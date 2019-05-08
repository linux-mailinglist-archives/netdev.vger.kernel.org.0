Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F51717F2D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbfEHRgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:36:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728735AbfEHRgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:36:17 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 805AE142C00B7;
        Wed,  8 May 2019 10:36:16 -0700 (PDT)
Date:   Wed, 08 May 2019 10:36:13 -0700 (PDT)
Message-Id: <20190508.103613.1782548019381525988.davem@davemloft.net>
To:     jasowang@redhat.com
Cc:     netdev@vger.kernel.org, mst@redhat.com, yuehaibing@huawei.com,
        xiyou.wangcong@gmail.com, weiyongjun1@huawei.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array
 instead of tun->numqueues
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 May 2019 10:36:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Tue,  7 May 2019 00:03:36 -0400

> @@ -1313,6 +1315,10 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
>  
>  	tfile = rcu_dereference(tun->tfiles[smp_processor_id() %
>  					    numqueues]);
> +	if (!tfile) {
> +		rcu_read_unlock();
> +		return -ENXIO; /* Caller will free/return all frames */
> +	}
>  
>  	spin_lock(&tfile->tx_ring.producer_lock);
>  	for (i = 0; i < n; i++) {

The only way we can see a NULL here is if a detach happened in parallel,
and if that happens we should retry the tfile[] indexing after resampling
numqueues rather than dropping the packet.
