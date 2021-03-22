Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E28BC344C66
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCVQzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbhCVQzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:55:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05A92C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 09:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kzxqchfPmu/8lYrfp2zKgORyBaujjx8P/Vw5bDn6fBo=; b=ME/6dWtOH2m+rpfhWa5qfP98RK
        YXfI9TJ2znmUor/ucQ6NAFp5l9SaMBsAkEHsp/2XmErAwXrdmcvzi4gZvDsO8H+t8bqKKO5XnycyO
        tRRUEqP4zVlFcNHwRQH1R5DERdhYjvDW0TBOwhMGx/HX6uNmQsgOPA0gyM43KvYfc8evjQkQzh6vU
        gGFTOw1hyMCfEFtyLCl2uv3+mhvtbQL3w+vmIfohv9VTYyRYg9+Gu1VWGAOQ2MFoemAI5M9UAiu0f
        KSlJKB6y9ZL9l6MFT813hkEUjleKf7GlVovHMYTXAvgKx/KbgGwbZ7eaWHPbYQrfEP8ugPunvrdVz
        71O0zeCg==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lONp9-008oEE-4v; Mon, 22 Mar 2021 16:54:43 +0000
Date:   Mon, 22 Mar 2021 16:54:39 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH net-next] net-sysfs: remove possible sleep from an RCU
 read-side critical section
Message-ID: <20210322165439.GR1719932@casper.infradead.org>
References: <20210322154329.340048-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322154329.340048-1-atenart@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 04:43:29PM +0100, Antoine Tenart wrote:
> xps_queue_show is mostly made of an RCU read-side critical section and
> calls bitmap_zalloc with GFP_KERNEL in the middle of it. That is not
> allowed as this call may sleep and such behaviours aren't allowed in RCU
> read-side critical sections. Fix this by using GFP_NOWAIT instead.

This would be another way of fixing the problem that is slightly less
complex than my initial proposal, but does allow for using GFP_KERNEL
for fewer failures:

@@ -1366,11 +1366,10 @@ static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
 {
        struct xps_dev_maps *dev_maps;
        unsigned long *mask;
-       unsigned int nr_ids;
+       unsigned int nr_ids, new_nr_ids;
        int j, len;
 
-       rcu_read_lock();
-       dev_maps = rcu_dereference(dev->xps_maps[type]);
+       dev_maps = READ_ONCE(dev->xps_maps[type]);
 
        /* Default to nr_cpu_ids/dev->num_rx_queues and do not just return 0
         * when dev_maps hasn't been allocated yet, to be backward compatible.
@@ -1379,10 +1378,18 @@ static ssize_t xps_queue_show(struct net_device *dev, unsigned int index,
                 (type == XPS_CPUS ? nr_cpu_ids : dev->num_rx_queues);
 
        mask = bitmap_zalloc(nr_ids, GFP_KERNEL);
-       if (!mask) {
-               rcu_read_unlock();
+       if (!mask)
                return -ENOMEM;
-       }
+
+       rcu_read_lock();
+       dev_maps = rcu_dereference(dev->xps_maps[type]);
+       /* if nr_ids shrank in the meantime, do not overrun array.
+        * if it increased, we just won't show the new ones
+        */
+       new_nr_ids = dev_maps ? dev_maps->nr_ids :
+                       (type == XPS_CPUS ? nr_cpu_ids : dev->num_rx_queues);
+       if (new_nr_ids < nr_ids)
+               nr_ids = new_nr_ids;
 
        if (!dev_maps || tc >= dev_maps->num_tc)
                goto out_no_maps;

(or do we need the rcu read lock to read dev->num_rcx_queues? i'm assuming
we only need it to read the xps_maps array)
