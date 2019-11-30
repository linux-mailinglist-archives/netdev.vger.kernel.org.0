Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB14110DE89
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 19:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfK3SeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 13:34:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbfK3SeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 13:34:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3:a597:786a:2aef:1599])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0F68C133FF02D;
        Sat, 30 Nov 2019 10:34:14 -0800 (PST)
Date:   Sat, 30 Nov 2019 10:34:11 -0800 (PST)
Message-Id: <20191130.103411.2158582570201430879.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        treeze.taeung@gmail.com
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in
 hsr_dev_xmit()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191130142400.3930-1-ap420073@gmail.com>
References: <20191130142400.3930-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 Nov 2019 10:34:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Sat, 30 Nov 2019 14:24:00 +0000

> @@ -226,9 +226,16 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct hsr_priv *hsr = netdev_priv(dev);
>  	struct hsr_port *master;
>  
> +	rcu_read_lock();
>  	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);

I don't want to distract from your bug fix but I had to audit and learn
how this hsr->ports stuff works while reading your patch.

hsr->ports has supposedly RCU protection...

But add and delete opertions to the port list only occur by newlink
netlink operations (the device isn't even visible yet at this point)
and network device teardown (all packet processing paths will quiesce
beforehand).

Therefore, the port list never changes from it's effectively static
configuration made at hsr_dev_finalize() time.

The whole driver very inconsistently accesses the hsr->port list,
and it all works only because of the above invariant.

So let's not try to fix the RCU protection issues here ok?  That
should be handled separately, and there are no real problems caused by
the lack of RCU protection here right now.

Thank you.
