Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECD16A1C60
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjBXMqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:46:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBXMqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:46:00 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7415B42BED;
        Fri, 24 Feb 2023 04:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Z1svfh4p8q2jZu1lBbyg+kHr3WJV+oeeQaEoeKU2KdU=;
        t=1677242759; x=1678452359; b=LIm1Aojy7V3UsMlXc3xTCJOZ7Ge0a2/0r2zjKofKsIfy4dV
        a8zqXBfdossww6j2WJivVn2JiTpxOfhN4+CtaR9RBF60BPj8uVAbWAx2FcrKUE/a48H4U5fAkCrjh
        czdhM8vs53vjBcJ3CA6vDg5wh6uALMrY+Ft9QR1+DpOKXM1dWmkB6GAn38JE2y813MVddG0mQ03YZ
        tPXet1CDe9H5XXIARGaX9gaTsK5jYz+UGJ+oC2P/v0YBSGPM6KvpQbkLFPA272jX9OdIuZQi7oFwm
        JVajjkOUdNup0fQitt8wV433iKXE5b8zLOvDT2WQfH98ItyJ1vlB2pOJy1EVCIYQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pVXSX-004CAe-16;
        Fri, 24 Feb 2023 13:45:57 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [RFC PATCH 1/2] net: netlink: make full range policy macros nicer
Date:   Fri, 24 Feb 2023 13:45:52 +0100
Message-Id: <20230224134441.791ae90f2939.Ic85e4e5fac77de8dedfa97ee1ad749b8ff8eb7a3@changeid>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230224124553.94730-1-johannes@sipsolutions.net>
References: <20230224124553.94730-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Since these macros are used for variable initializers
there's really no way to have a non-constant pointer,
so move the required & into the macros.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h     | 4 ++--
 net/ipv6/ioam6_iptunnel.c | 4 ++--
 net/wireless/nl80211.c    | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index b12cd957abb4..52dedc8bfedd 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -415,13 +415,13 @@ struct nla_policy {
 #define NLA_POLICY_FULL_RANGE(tp, _range) {		\
 	.type = NLA_ENSURE_UINT_OR_BINARY_TYPE(tp),	\
 	.validation_type = NLA_VALIDATE_RANGE_PTR,	\
-	.range = _range,				\
+	.range = &(_range),				\
 }
 
 #define NLA_POLICY_FULL_RANGE_SIGNED(tp, _range) {	\
 	.type = NLA_ENSURE_SINT_TYPE(tp),		\
 	.validation_type = NLA_VALIDATE_RANGE_PTR,	\
-	.range_signed = _range,				\
+	.range_signed = &(_range),			\
 }
 
 #define NLA_POLICY_MIN(tp, _min) {			\
diff --git a/net/ipv6/ioam6_iptunnel.c b/net/ipv6/ioam6_iptunnel.c
index f6f5b83dd954..790a40e2497d 100644
--- a/net/ipv6/ioam6_iptunnel.c
+++ b/net/ipv6/ioam6_iptunnel.c
@@ -67,8 +67,8 @@ static struct ioam6_trace_hdr *ioam6_lwt_trace(struct lwtunnel_state *lwt)
 }
 
 static const struct nla_policy ioam6_iptunnel_policy[IOAM6_IPTUNNEL_MAX + 1] = {
-	[IOAM6_IPTUNNEL_FREQ_K] = NLA_POLICY_FULL_RANGE(NLA_U32, &freq_range),
-	[IOAM6_IPTUNNEL_FREQ_N] = NLA_POLICY_FULL_RANGE(NLA_U32, &freq_range),
+	[IOAM6_IPTUNNEL_FREQ_K] = NLA_POLICY_FULL_RANGE(NLA_U32, freq_range),
+	[IOAM6_IPTUNNEL_FREQ_N] = NLA_POLICY_FULL_RANGE(NLA_U32, freq_range),
 	[IOAM6_IPTUNNEL_MODE]	= NLA_POLICY_RANGE(NLA_U8,
 						   IOAM6_IPTUNNEL_MODE_MIN,
 						   IOAM6_IPTUNNEL_MODE_MAX),
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1c3b9a305f42..fbea0e786b21 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -811,7 +811,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MLO_SUPPORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_MAX_NUM_AKM_SUITES] = { .type = NLA_REJECT },
 	[NL80211_ATTR_PUNCT_BITMAP] =
-		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
+		NLA_POLICY_FULL_RANGE(NLA_U32, nl80211_punct_bitmap_range),
 };
 
 /* policy for the key attributes */
-- 
2.39.2

