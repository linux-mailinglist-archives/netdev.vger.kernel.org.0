Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956EC62EC66
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 04:39:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiKRDjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 22:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiKRDjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 22:39:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DFC5131E
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 19:39:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 36868CE1FCE
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5972C433C1;
        Fri, 18 Nov 2022 03:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668742747;
        bh=b5Ciezt8/hFEbDXdb8acMLPYQDDy/7lEA3tkZKMdX6w=;
        h=From:To:Cc:Subject:Date:From;
        b=FpA9tixOUEdwKECfANNO1oO5psY3Tvy5RB3aGnSKSSlUp/n/Jb53jmCQMYIFidDN8
         MRIz7aw7DD5AyDU1VMDRMTleOsi3zOGjtw4jDFayfrnjN94QEdZmjlTtClACm1Y9Nc
         d68qWdWmCGMvdZ6XPBaMitLNoPQUpE1gXaWwSJumrVLkiSi3sQAmCbpRrsm/kflT+M
         2cK9h9djnhwss8Ow7heQRCzLM4TEvHJQq2F4MTCE4XZs49jBuA7pa9nWdGMfqbApXV
         +cxXD3PhNR/4weFJDOFBYra7s+Udlw6E0HVaReAUIkxvIW3TptWT7hKvRyRPiPgPw0
         Z5GlG8Prs1uqw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>, nathan@kernel.org,
        ndesaulniers@google.com, trix@redhat.com, llvm@lists.linux.dev
Subject: [PATCH net-next] netlink: remove the flex array from struct nlmsghdr
Date:   Thu, 17 Nov 2022 19:39:03 -0800
Message-Id: <20221118033903.1651026-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've added a flex array to struct nlmsghdr in
commit 738136a0e375 ("netlink: split up copies in the ack construction")
to allow accessing the data easily. It leads to warnings with clang,
if user space wraps this structure into another struct and the flex
array is not at the end of the container.

Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/all/20221114023927.GA685@u2004-local/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: nathan@kernel.org
CC: ndesaulniers@google.com
CC: trix@redhat.com
CC: llvm@lists.linux.dev
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

