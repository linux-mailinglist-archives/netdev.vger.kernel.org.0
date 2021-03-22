Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03078344DAA
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhCVRp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCVRo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:44:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A15EC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 10:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Cr3tmBKDXooi1INVsOIrQCwG5pt7IILAMg5dRCZmqYI=; b=cuv6FqNf97wOCvQzkiMtbdZkaK
        4ZU4Gj1zWx1rTpzT3DsOWtL8s/dppUN/UcdNWVVx69yB/wcbUtGmrgX8ZKcL5kWoTo53yA8A0ad59
        CWVpIuq/Uo/mQe84Vz8t3SHRtaoegAL58c+CHCbNLBGM/y6CsOvXc6oFJ0aXJdbAsJ37KTiOpgv4O
        zyLqUAToaPjv59UCEANozqNfsUfV0McIHnt83tfI5EsVpNh6arW3G2SbZWh3fjg8Eez7EnbO9NYr3
        rIUsqjaTzgQlkIU+tvGoH+Dg8rZYlKhL+U70N0+1zIsIL4tuXF9bCBApZAn/NGAcAUHK7ThcxnulK
        yDUXny/Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lOObF-008rPU-1S; Mon, 22 Mar 2021 17:44:28 +0000
Date:   Mon, 22 Mar 2021 17:44:21 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH net-next] net-sysfs: remove possible sleep from an RCU
 read-side critical section
Message-ID: <20210322174421.GT1719932@casper.infradead.org>
References: <20210322154329.340048-1-atenart@kernel.org>
 <20210322165439.GR1719932@casper.infradead.org>
 <161643489069.6320.12260867980480523074@kwain.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161643489069.6320.12260867980480523074@kwain.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 06:41:30PM +0100, Antoine Tenart wrote:
> Quoting Matthew Wilcox (2021-03-22 17:54:39)
> > -       rcu_read_lock();
> > -       dev_maps = rcu_dereference(dev->xps_maps[type]);
> > +       dev_maps = READ_ONCE(dev->xps_maps[type]);
> 
> Couldn't dev_maps be freed between here and the read of dev_maps->nr_ids
> as we're not in an RCU read-side critical section?

Oh, good point.  Never mind, then.

> My feeling is there is not much value in having a tricky allocation
> logic for reads from xps_cpus and xps_rxqs. While we could come up with
> something, returning -ENOMEM on memory pressure should be fine.

That's fine.  It's your code, and this is probably a small allocation
anyway.

