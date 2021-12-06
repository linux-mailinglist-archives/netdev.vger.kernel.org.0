Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5A746A8A4
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 21:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349735AbhLFUnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344890AbhLFUnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:43:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16F2C061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 12:40:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1702FCE1808
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 20:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD811C341C1;
        Mon,  6 Dec 2021 20:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638823202;
        bh=3kXCQua+cAdvOiY3i2Ud+VQdQd5K0/6HLqgHsmQRmpE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QfzTBiRu2edt1ycUVxwDPwGT/NMwNDe/trBkVfdPKYoLzV/z4ct2G46cJ4o9tnDRo
         nXLmKsKaisZeNbpAX5Ujv/QoEsIWoMDlw89dV43HfCZ4ShQzvSeaJIyFx7F5SrG4zG
         JosG1QNgDA/2+Rh3zIJ4cTpNZpvYjZJcDaBylp4a/KhXIaviah8cLL+u0+9l+gA2QX
         2hO9aLpmGG4brIahpiaPbJa60mK9VAn0G+OwGCehBcRHQT7siecs93NZh/w2XgSUaD
         H/tWxhQEUSCQ2Gd0vJ4wXXSJtlGQX2xgdduZKilwxWZNgQbKtgSNCgjMvUcypUD7Xm
         pQLoeRw9oDk4w==
Date:   Mon, 6 Dec 2021 12:40:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        alexander.duyck@gmail.com
Subject: Re: [net-next v1 1/2] net: sched: use queue_mapping to pick tx
 queue
Message-ID: <20211206124001.5a264583@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211206080512.36610-2-xiangxia.m.yue@gmail.com>
References: <20211206080512.36610-1-xiangxia.m.yue@gmail.com>
        <20211206080512.36610-2-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Dec 2021 16:05:11 +0800 xiangxia.m.yue@gmail.com wrote:
>   +----+      +----+      +----+
>   | P1 |      | P2 |      | Pn |
>   +----+      +----+      +----+
>     |           |           |
>     +-----------+-----------+
>                 |
>                 | clsact/skbedit
>                 |    MQ
>                 v
>     +-----------+-----------+
>     | q0        | q1        | qn
>     v           v           v
>    HTB         HTB   ...   FIFO

The usual suggestion these days is to try to use FQ + EDT to
implement efficient policies. You don't need dedicated qdiscs, 
just modulate transmission time appropriately on egress of the
container.

In general recording the decision in the skb seems a little heavy
handed. We just need to carry the information from the egress hook
to the queue selection a few lines below. Or in fact maybe egress
hook shouldn't be used for this in the first place, and we need 
a more appropriate root qdisc than simple mq?

Not sure. What I am sure of is that you need to fix these warnings:

include/linux/skbuff.h:937: warning: Function parameter or member 'tc_skip_txqueue' not described in 'sk_buff'

ERROR: spaces required around that '=' (ctx:VxW)
#103: FILE: net/sched/act_skbedit.c:42:
+	queue_mapping= (queue_mapping & 0xff) + hash % mapping_mod;
 	             ^

;)
