Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC6F53BC0D
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236725AbiFBQCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiFBQCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:02:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05571DB1C6;
        Thu,  2 Jun 2022 09:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 775F0614BA;
        Thu,  2 Jun 2022 16:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AFACC385A5;
        Thu,  2 Jun 2022 16:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654185749;
        bh=PQ/ALFmc2rHdOMOvBYplDDZYqrr95PM1qDGM+8q0FAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mAsxZWaNR/QCVzI/KMLuaYYMq4HjEk6FQW7TVSJz/CmyQczSXlcNOoMHmO2EpmcOe
         UzN+KPjNABEB9ArOPggjKcyF1kE6TGlosSCEYrJaiFPh5R3BOe1K1vCakgbtyqR5YI
         TjvpMudqRkrgVPHe1ka9HbAqRNT7we7zqQoQnUN/79Zhuezezg6EXGPmoQ2t/zBcew
         Y73oAnL0mSb+6ylxyysFYQAKIsO7QCEmmzWiJmK5czWxKvy8YVO4M7zv1tD5C3qkb4
         KEbo5+Cva8b62qeHZ8jnTOCoJbhG0F4KY6OFbv83+dtd3VwucxLvZPFWultDTAcmlT
         a3fdTQGzl0sUg==
Date:   Thu, 2 Jun 2022 09:02:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Wang Yufen <wangyufen@huawei.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4] ipv6: Fix signed integer overflow in
 __ip6_append_data
Message-ID: <20220602090228.1e493e47@kernel.org>
In-Reply-To: <4c9e3cf5122f4c2f8a2473c493891362e0a13b4a.camel@redhat.com>
References: <20220601084803.1833344-1-wangyufen@huawei.com>
        <4c9e3cf5122f4c2f8a2473c493891362e0a13b4a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 02 Jun 2022 12:38:10 +0200 Paolo Abeni wrote:
> I'm sorry for the multiple incremental feedback on this patch. It's
> somewhat tricky.
> 
> AFAICS Jakub mentioned only udpv6_sendmsg(). In l2tp_ip6_sendmsg() we
> can have an overflow:
> 
>         int transhdrlen = 4; /* zero session-id */
>         int ulen = len + transhdrlen;
> 
> when len >= INT_MAX - 4. That will be harmless, but I guess it could
> still trigger a noisy UBSAN splat. 

Good point, I wonder if that's a separate issue. Should we
follow what UDP does and subtract the transhdr from the max?
My gut feeling is that stricter checks are cleaner than just 
bumping variable sizes.

diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index c6ff8bf9b55f..9dbd801ddb98 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -504,14 +504,15 @@ static int l2tp_ip6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
        struct ipcm6_cookie ipc6;
        int addr_len = msg->msg_namelen;
        int transhdrlen = 4; /* zero session-id */
-       int ulen = len + transhdrlen;
+       int ulen;
        int err;
 
        /* Rough check on arithmetic overflow,
         * better check is made in ip6_append_data().
         */
-       if (len > INT_MAX)
+       if (len > INT_MAX - transhdrlen)
                return -EMSGSIZE;
+       ulen = len + transhdrlen;
 
        /* Mirror BSD error message compatibility */
        if (msg->msg_flags & MSG_OOB)
