Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBA76C2882
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 04:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCUDSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 23:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCUDSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 23:18:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABA01554D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 20:18:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D71FA61944
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020F4C4339B;
        Tue, 21 Mar 2023 03:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679368689;
        bh=GKOQFBNBxuHG/gpeQ/xEfZrFJOjIBvpLqpQUg1Z/YrM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SW4mt8gQMJRI702ONiZiL7Vu5lIq6aYMaWlGPwphJXBrXhjyHbpjH9KYcaRTUIHnV
         B9NtHwyjRcStP5HmJW1HTQwEM+TNaON7NQiaWFPt6AAzzr37rsz8tv5JOHjisaxR5w
         3BL1zngM7xF46GC2UYvPXyXEzheyHqNK5Y3Vav54Var6OVeh5ZmnQLpWktOR1IIyaG
         qvA3E03bqvMe74vzi8EoSl3L/TwAlrOtFkzKBtoGS5cAvgMCQ7nuJvQ/zJLOysmYIs
         oL8AcC1qXCMGKw+KvjPrdnAL8L+gvVcAJn9rzgLR68xBr6V9zroshoPqTWb0zevW7u
         llgG2S34FataA==
Date:   Mon, 20 Mar 2023 20:18:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v1] rtnetlink: Return error when message too
 short
Message-ID: <20230320201808.6cc362b2@kernel.org>
In-Reply-To: <20230320231834.66273-1-donald.hunter@gmail.com>
References: <20230320231834.66273-1-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Mar 2023 23:18:34 +0000 Donald Hunter wrote:
> rtnetlink_rcv_msg currently returns 0 when the message length is too
> short. This leads to either no response at all, or an ack response
> if NLM_F_ACK was set in the request.
> 
> Change rtnetlink_rcv_msg to return -EINVAL which tells af_netlink to
> generate a proper error response.

It's a touch risky to start returning an error now.
Some application could possibly have been passing an empty netlink
message just because.

We should give the user a heads up (pr_warn_once() with the name+pid
of current process). Or continue returning a 0 but add a warning via 
the extack. The latter is cleaner but will not help old / sloppy apps,
your call.

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

We can't put a Fixes tag on it. It could break uAPI, we don't want 
it backported for sure.

> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>  net/core/rtnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 5d8eb57867a9..04b7f184f32e 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -6086,7 +6086,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	/* All the messages must have at least 1 byte length */
>  	if (nlmsg_len(nlh) < sizeof(struct rtgenmsg))
> -		return 0;
> +		return -EINVAL;
>  
>  	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
>  	kind = rtnl_msgtype_kind(type);

