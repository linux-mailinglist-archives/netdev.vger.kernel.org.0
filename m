Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A020A62EA3F
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235044AbiKRA2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbiKRA23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:28:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 702192645;
        Thu, 17 Nov 2022 16:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73C49B8223F;
        Fri, 18 Nov 2022 00:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5168C433D7;
        Fri, 18 Nov 2022 00:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668731303;
        bh=GI/8ybj1mt/ovkNkUNJsiHgZkXH0Lv2Qqhh2GuHkb4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tKtLbh3kyroef+REH8JwFS0aznhy4sBymVMB8IQUOUGHQeuLbb1QRlKAJH/ocwBI4
         h1qKstjmLz1Q8LZN4x/Avc6ifvRhF+REOuHNtqwmp8YUjpPypQZroQyll2T07QoWo6
         CAmGlffCW3GalEtpB5IQvgefvWN6PFAlg5Y5e62ldjPntnUs+eysYeWiddhFy21xek
         QFC9G8quuvLwZp+T634PJZh/lVisY9vwR5+QlMyINJH5Tg/R34YzIMZM7sV6aVvMia
         sF0AlDizBBgwuHl4alLjboWhl+dgS3iTrzbIEglElKroYmQ0TQCZ9V5AGnxQ3f/vpg
         h4Fdj2HCS3WNw==
Date:   Thu, 17 Nov 2022 16:28:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <20221117162822.5cb04021@kernel.org>
In-Reply-To: <202211171431.6C8675E2@keescook>
References: <20221114090614.2bfeb81c@kernel.org>
        <202211161444.04F3EDEB@keescook>
        <202211161454.D5FA4ED44@keescook>
        <202211161502.142D146@keescook>
        <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
        <20221116170526.752c304b@kernel.org>
        <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
        <20221116221306.5a4bd5f8@kernel.org>
        <20221117082556.37b8028f@hermes.local>
        <20221117123615.41d9c71a@kernel.org>
        <202211171431.6C8675E2@keescook>
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

On Thu, 17 Nov 2022 14:35:32 -0800 Kees Cook wrote:
> As for testing, I can do that if you want -- the goal was to make sure
> the final result doesn't trip FORTIFY when built with -fstrict-flex-arrays
> (not yet in a released compiler version, but present in both GCC and Clang
> truck builds) and with __builtin_dynamic_object_size() enabled (which
> is not yet in -next, as it is waiting on the last of ksize() clean-ups).

I got distracted, sorry. Does this work?

-->8--------------

From: Jakub Kicinski <kuba@kernel.org>
Subject: netlink: remove the flex array from struct nlmsghdr

I've added a flex array to struct nlmsghdr to allow accessing
the data easily. But it leads to warnings with clang, when user
space wraps this structure into another struct and the flex
array is not at the end of the container.

Link: https://lore.kernel.org/all/20221114023927.GA685@u2004-local/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/netlink.h | 2 --
 net/netlink/af_netlink.c     | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
index 5da0da59bf01..e2ae82e3f9f7 100644
--- a/include/uapi/linux/netlink.h
+++ b/include/uapi/linux/netlink.h
@@ -48,7 +48,6 @@ struct sockaddr_nl {
  * @nlmsg_flags: Additional flags
  * @nlmsg_seq:   Sequence number
  * @nlmsg_pid:   Sending process port ID
- * @nlmsg_data:  Message payload
  */
 struct nlmsghdr {
 	__u32		nlmsg_len;
@@ -56,7 +55,6 @@ struct nlmsghdr {
 	__u16		nlmsg_flags;
 	__u32		nlmsg_seq;
 	__u32		nlmsg_pid;
-	__u8		nlmsg_data[];
 };
 
 /* Flags values */
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 9ebdf3262015..d73091f6bb0f 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2514,7 +2514,7 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 		if (!nlmsg_append(skb, nlmsg_len(nlh)))
 			goto err_bad_put;
 
-		memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
+		memcpy(nlmsg_data(&errmsg->msg), nlmsg_data(nlh),
 		       nlmsg_len(nlh));
 	}
 
-- 
2.38.1

