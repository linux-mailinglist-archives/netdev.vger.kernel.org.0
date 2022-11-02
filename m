Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D522616FF3
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiKBVkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKBVkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1338463D0;
        Wed,  2 Nov 2022 14:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32179B82525;
        Wed,  2 Nov 2022 21:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7FDC433D6;
        Wed,  2 Nov 2022 21:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667425194;
        bh=PmiXzhOEefQJy7eB8akCP/s7HA4Sro+JpQ84GNIMYP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t9hQ5YIJDF4ecTpDvEt0KvC+XB1Hyk/ciVuLGAiJ0DaGLa8dUVqV5T1UBNa5ULgA/
         gszs4XrhL1e8t0ZAtqmofo7FJwegfhhCsKkAIjofulxdu+ANZK+BX8bTJ5SoWSvFI1
         nuP2U8E6MR9JQjX25/i1UG+aUCBOwuj1lej9ha75EdjISemDyxhsj2JC8pmSdTYM/Z
         5k6hyHF6S5jQPFJQe2qnAJLBoeBVnwd3hb2B6FMQMvFIKagfC3uLS1hdxPe3EeSQN0
         CqOSGnp7jth9S9zKWMRC83qV9Q621guhB0WYDXE5jww2gRTA9NSVsYvg1DEjU9bgul
         OMiyvFpD5bPIw==
Date:   Wed, 2 Nov 2022 14:39:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tao Chen <chentao.kernel@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Petr Machata <petrm@nvidia.com>,
        Kees Cook <keescook@chromium.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netlink: Fix potential skb memleak in
 netlink_ack
Message-ID: <20221102143953.001f1247@kernel.org>
In-Reply-To: <7a382b9503d10d235238ca55938bc933d92a1de7.1667389213.git.chentao.kernel@linux.alibaba.com>
References: <7a382b9503d10d235238ca55938bc933d92a1de7.1667389213.git.chentao.kernel@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Nov 2022 20:08:20 +0800 Tao Chen wrote:
> We should clean the skb resource if nlmsg_put/append failed
> , so fix it.

The comma should be at the end of the previous line.
But really the entire ", so fix it." is redundant.

> Fiexs: commit 738136a0e375 ("netlink: split up copies in the
> ack construction")

Please look around to see how to correctly format a Fixes tag
(including not line wrapping it).

How did you find this bug? An automated tool? Syzbot?

One more note below on the code itself.

> Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
> ---
>  net/netlink/af_netlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index c6b8207e..9d73dae 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2500,7 +2500,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>  
>  	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
>  	if (!skb)
> -		goto err_bad_put;
> +		goto err_skb;
>  
>  	rep = nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
>  			NLMSG_ERROR, sizeof(*errmsg), flags);
> @@ -2528,6 +2528,8 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
>  	return;
>  
>  err_bad_put:
> +	kfree_skb(skb);

Please use nlmsg_free() since we allocated with nlmsg_new().

> +err_skb:
>  	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
>  	sk_error_report(NETLINK_CB(in_skb).sk);
>  }

