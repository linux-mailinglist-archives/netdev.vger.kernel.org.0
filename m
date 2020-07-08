Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A2E219352
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgGHWZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHWZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:25:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23028C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 15:25:18 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E1141277EA75;
        Wed,  8 Jul 2020 15:25:17 -0700 (PDT)
Date:   Wed, 08 Jul 2020 15:25:16 -0700 (PDT)
Message-Id: <20200708.152516.848610490321452051.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jchapman@katalix.com, gnault@redhat.com
Subject: Re: [PATCH net] l2tp: remove skb_dst_set() from l2tp_xmit_skb()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <57ec206296ac8049d51755667b69aa0e978e3d6e.1594058552.git.lucien.xin@gmail.com>
References: <57ec206296ac8049d51755667b69aa0e978e3d6e.1594058552.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jul 2020 15:25:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue,  7 Jul 2020 02:02:32 +0800

> In the tx path of l2tp, l2tp_xmit_skb() calls skb_dst_set() to set
> skb's dst. However, it will eventually call inet6_csk_xmit() or
> ip_queue_xmit() where skb's dst will be overwritten by:
> 
>    skb_dst_set_noref(skb, dst);
> 
> without releasing the old dst in skb. Then it causes dst/dev refcnt leak:
> 
>   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
> 
> This can be reproduced by simply running:
> 
>   # modprobe l2tp_eth && modprobe l2tp_ip
>   # sh ./tools/testing/selftests/net/l2tp.sh
> 
> So before going to inet6_csk_xmit() or ip_queue_xmit(), skb's dst
> should be dropped. This patch is to fix it by removing skb_dst_set()
> from l2tp_xmit_skb() and moving skb_dst_drop() into l2tp_xmit_core().
> 
> Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
> Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for -stable, thank you.
