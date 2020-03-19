Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D88E18B854
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 14:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727240AbgCSNsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 09:48:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56101 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbgCSNsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 09:48:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 77B3E5C031B;
        Thu, 19 Mar 2020 09:48:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 19 Mar 2020 09:48:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=p8+ZzYgrymTxe088nYIoX2F704HdD6dNMR6DVrMYG2c=; b=nosxxjiI
        adznFfYyE94HTbVdxV1tBGrLTO9DbgJGQAv3agpIiyz00/zxmE8Gusdg4cuTfgBI
        0pf+QDAROwzZK1Hkuprgu1omdzuId3xdbGlfn9Ez1KJx30NHWoVimysoYOwKNuND
        nhtB6BhDEs1FdjgZEv8eeNY81QMhGMgLfEf5+aVoVLMV7s30PoF0CXbMLiYWYyNp
        ZNkUIrmE247A0wXFOHuGEFVtFm/oYFLqleynWdcB9vT80VM6t4zXGtwxE4fH+T60
        ns+VB7tSC1dB5eH8bOoYt6lOLLKdM7qlPGoLzJUtfviB1NNTUF1B8gbs26bCxF0u
        TNo5+aIA9doWVQ==
X-ME-Sender: <xms:GHhzXoscNISaTuX9e2Vnfvhy5SWam0jmsHjUsX-ExoMsWdek6eTbIw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefledgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppedutdelrdeiiedrudeftddrheenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:GHhzXpv-HZcwvgoqZsj4tP4DCamvNLrOJf7yKM1LB7nmdA7To_dhjA>
    <xmx:GHhzXuyWEy3WiQ__5zjDb3g6iu6z6Bp1HpY94xNSIywwCJvLwfxCOw>
    <xmx:GHhzXvhTfqNtE5FTRGGjsp2pdnnKE7lzCAtNiG0regxuNlGpd1iTHg>
    <xmx:GHhzXu_49e6gN7qfSCCF0ff0pkGjG1B8J_ZGAfxJ2HGKnZOMO2hiig>
Received: from splinter.mtl.com (bzq-109-66-130-5.red.bezeqint.net [109.66.130.5])
        by mail.messagingengine.com (Postfix) with ESMTPA id AEDB130618B7;
        Thu, 19 Mar 2020 09:48:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, petrm@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/5] net: tc_skbedit: Factor a helper out of is_tcf_skbedit_{mark, ptype}()
Date:   Thu, 19 Mar 2020 15:47:20 +0200
Message-Id: <20200319134724.1036942-2-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319134724.1036942-1-idosch@idosch.org>
References: <20200319134724.1036942-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

The two functions is_tcf_skbedit_mark() and is_tcf_skbedit_ptype() have a
very similar structure. A follow-up patch will add one more such function.
Instead of more cut'n'pasting, extract a helper function that checks
whether a TC action is an skbedit with the required flag. Convert the two
existing functions into thin wrappers around the helper.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 include/net/tc_act/tc_skbedit.h | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/net/tc_act/tc_skbedit.h b/include/net/tc_act/tc_skbedit.h
index b22a1f641f02..ac8ff60143fe 100644
--- a/include/net/tc_act/tc_skbedit.h
+++ b/include/net/tc_act/tc_skbedit.h
@@ -27,8 +27,8 @@ struct tcf_skbedit {
 };
 #define to_skbedit(a) ((struct tcf_skbedit *)a)
 
-/* Return true iff action is mark */
-static inline bool is_tcf_skbedit_mark(const struct tc_action *a)
+/* Return true iff action is the one identified by FLAG. */
+static inline bool is_tcf_skbedit_with_flag(const struct tc_action *a, u32 flag)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	u32 flags;
@@ -37,12 +37,18 @@ static inline bool is_tcf_skbedit_mark(const struct tc_action *a)
 		rcu_read_lock();
 		flags = rcu_dereference(to_skbedit(a)->params)->flags;
 		rcu_read_unlock();
-		return flags == SKBEDIT_F_MARK;
+		return flags == flag;
 	}
 #endif
 	return false;
 }
 
+/* Return true iff action is mark */
+static inline bool is_tcf_skbedit_mark(const struct tc_action *a)
+{
+	return is_tcf_skbedit_with_flag(a, SKBEDIT_F_MARK);
+}
+
 static inline u32 tcf_skbedit_mark(const struct tc_action *a)
 {
 	u32 mark;
@@ -57,17 +63,7 @@ static inline u32 tcf_skbedit_mark(const struct tc_action *a)
 /* Return true iff action is ptype */
 static inline bool is_tcf_skbedit_ptype(const struct tc_action *a)
 {
-#ifdef CONFIG_NET_CLS_ACT
-	u32 flags;
-
-	if (a->ops && a->ops->id == TCA_ID_SKBEDIT) {
-		rcu_read_lock();
-		flags = rcu_dereference(to_skbedit(a)->params)->flags;
-		rcu_read_unlock();
-		return flags == SKBEDIT_F_PTYPE;
-	}
-#endif
-	return false;
+	return is_tcf_skbedit_with_flag(a, SKBEDIT_F_PTYPE);
 }
 
 static inline u32 tcf_skbedit_ptype(const struct tc_action *a)
-- 
2.24.1

