Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9FB862D351
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 07:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234606AbiKQGNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 01:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiKQGNJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 01:13:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D30C22F3BB;
        Wed, 16 Nov 2022 22:13:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA9362098;
        Thu, 17 Nov 2022 06:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69696C433D6;
        Thu, 17 Nov 2022 06:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668665587;
        bh=gLckPaA2RbWy+qeW1Y4mm8k80EgIFB5RtSqjqWtke/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G36v79fw4yxJ8qCDYlRX7RBZnRQJWWBmKf1QLizuJVpIqAVQvBAxSDJvtj7kH+xqh
         2Au3NXirMSfsHSsNku6OuwgbvinSs7Oq64lnHptYILRCzYLGYRRzpDh+rtXppIPnwU
         M8AySb3vmnGbW+V15GONVGmfmMqoHd0JYH220l38G8YfozM70LdzvsgYwAA69/PMWI
         pa274aV5NMLbsMQXf/tEk5r0SRBND0il1CmkXmUg7P2LH2G/GXA582Z9hNjyfifSGs
         VikO5h0SXPh90YtEbpny/QyaP25rIJ+mQZ2KQw99m2aN6KIEVhV4yqvrAx8N1VJYFg
         5StUDY8ih0MVQ==
Date:   Wed, 16 Nov 2022 22:13:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Kees Cook <keescook@chromium.org>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <20221116221306.5a4bd5f8@kernel.org>
In-Reply-To: <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
References: <20221027212553.2640042-1-kuba@kernel.org>
        <20221114023927.GA685@u2004-local>
        <20221114090614.2bfeb81c@kernel.org>
        <202211161444.04F3EDEB@keescook>
        <202211161454.D5FA4ED44@keescook>
        <202211161502.142D146@keescook>
        <1e97660d-32ff-c0cc-951b-5beda6283571@embeddedor.com>
        <20221116170526.752c304b@kernel.org>
        <1b373b08-988d-b870-d363-814f8083157c@embeddedor.com>
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

On Wed, 16 Nov 2022 19:20:51 -0600 Gustavo A. R. Silva wrote:
> On 11/16/22 19:05, Jakub Kicinski wrote:
> >> This seems to be a sensible change. In general, it's not a good idea
> >> to have variable length objects (flex-array members) in structures used
> >> as headers, and that we know will ultimately be followed by more objects
> >> when embedded inside other structures.  
> > 
> > Meaning we should go back to zero-length arrays instead?  
> 
> No.

I was asking based on your own commit 1e6e9d0f4859 ("uapi: revert
flexible-array conversions"). This is uAPI as well.

Since we can't prevent user space from wrapping structures seems
like adding a flex member to an existing struct should never be
permitted in uAPI headers? We can just wrap things locally, I guess:

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 9ebdf3262015..2af2f8de4043 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2479,7 +2479,10 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 {
        struct sk_buff *skb;
        struct nlmsghdr *rep;
-       struct nlmsgerr *errmsg;
+       struct hashtag_silly {
+               struct nlmsgerr err;
+               u8 data[];
+       } *errmsg;
        size_t payload = sizeof(*errmsg);
        struct netlink_sock *nlk = nlk_sk(NETLINK_CB(in_skb).sk);
        unsigned int flags = 0;
@@ -2507,15 +2510,14 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
        if (!rep)
                goto err_bad_put;
        errmsg = nlmsg_data(rep);
-       errmsg->error = err;
-       errmsg->msg = *nlh;
+       errmsg->err.error = err;
+       errmsg->err.msg = *nlh;
 
        if (!(flags & NLM_F_CAPPED)) {
                if (!nlmsg_append(skb, nlmsg_len(nlh)))
                        goto err_bad_put;
 
-               memcpy(errmsg->msg.nlmsg_data, nlh->nlmsg_data,
-                      nlmsg_len(nlh));
+               memcpy(errmsg->data, nlmsg_data(nlh), nlmsg_len(nlh));
        }
 
        if (tlvlen)

In this particular case, tho, we're probably better off giving up 
on the flex array and doing nlmsg_data() on both src and dst.

> > Is there something in the standard that makes flexible array
> > at the end of an embedded struct a problem?  
> 
> I haven't seen any problems ss long as the flex-array appears last:
> 
> struct foo {
> 	... members
> 	struct boo {
> 		... members
> 		char flex[];
> 	};
> };
> 
> struct complex {
> 	... members
> 	struct foo embedded;
> };
> 
> However, the GCC docs[1] mention this:
> 
> "A structure containing a flexible array member [..] may not be a
> member of a structure [..] (However, these uses are permitted by GCC
> as extensions.)"
> 
> And in this case it seems that's the reason why GCC doesn't complain?

Seems so, clang's warning is called -Wgnu-variable-sized-type-not-at-end
