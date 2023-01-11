Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2476665D2
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbjAKVre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbjAKVrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:47:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72FB113F69;
        Wed, 11 Jan 2023 13:47:32 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net] uapi: linux: restore IPPROTO_MAX to 256
Date:   Wed, 11 Jan 2023 22:47:19 +0100
Message-Id: <20230111214719.194027-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPPROTO_MAX used to be 256, but with the introduction of IPPROTO_MPTCP
definition, IPPROTO_MAX was bumped to 263.

IPPROTO_MPTCP definition is used for the socket interface from
userspace. It is never used in the layer 4 protocol field of
IP headers.

IPPROTO_* definitions are used anywhere in the kernel as well as in
userspace to set the layer 4 protocol field in IP headers.

At least in Netfilter, there is code in userspace that relies on
IPPROTO_MAX (not inclusive) to check for the maximum layer 4 protocol.

This patch restores IPPROTO_MAX to 256.

Fixes: faf391c3826c ("tcp: Define IPPROTO_MPTCP")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Alternatively, I can also define an internal __IPPROTO_MAX to 256 in
userspace.  I understand an update on uapi at this stage might be
complicated. Another possibility is to add a new definition
IPPROTO_FIELD_MAX to uapi and set it to 256 that userspace could start
using.

 include/uapi/linux/in.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
index 07a4cb149305..0600b03b49ee 100644
--- a/include/uapi/linux/in.h
+++ b/include/uapi/linux/in.h
@@ -80,10 +80,10 @@ enum {
   IPPROTO_ETHERNET = 143,	/* Ethernet-within-IPv6 Encapsulation	*/
 #define IPPROTO_ETHERNET	IPPROTO_ETHERNET
   IPPROTO_RAW = 255,		/* Raw IP packets			*/
+  IPPROTO_MAX = 256,
 #define IPPROTO_RAW		IPPROTO_RAW
   IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
 #define IPPROTO_MPTCP		IPPROTO_MPTCP
-  IPPROTO_MAX
 };
 #endif
 
-- 
2.30.2

