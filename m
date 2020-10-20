Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04F293278
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 02:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389647AbgJTA6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 20:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389638AbgJTA6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 20:58:54 -0400
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C97C0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 17:58:54 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CFZy43KgrzKmWG;
        Tue, 20 Oct 2020 02:58:52 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1603155530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9f9aCZQS8yOVAUIclO4a5rskVp3eWW6QhR7x12ODyY8=;
        b=q5q8tMX8QwDssSbKJYJ5vuysBdhvbli8RtHTO8pXSQz6OL01B1m2b0AB8SQ7D+ahPzhjqE
        gcqFEBAU6O03DkrXJTFyvg2x/kTjNZLop0X47Y2m7ZdMuCicuQFqAuqs82dWWe33kiyIrt
        0VkeCPBIRiq38kfvDXd1L9XhvjRPtR7c6l1MtUTs1eGfjos4kUF4/GyredUtCvmpkzhFeC
        vDTWE3Bx5fE6f92nJaLX29t8xnLzCrnwo4kON6ZTNn5Lg7UjqsoCYI50/8msc5JfBV/B6O
        PXXUCkrLXU0esBqONXrKQunJcXERpnNurVMBsR40qrLAGAuadXWfTmp3gdReLg==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id YwkF6--CmHBj; Tue, 20 Oct 2020 02:58:49 +0200 (CEST)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 06/15] ip: iplink_vlan: Port over to parse_flag_on_off()
Date:   Tue, 20 Oct 2020 02:58:14 +0200
Message-Id: <24ac69937eff13dce8d6360599b39ab4e9ddcc86.1603154867.git.me@pmachata.org>
In-Reply-To: <cover.1603154867.git.me@pmachata.org>
References: <cover.1603154867.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: **
X-Rspamd-Score: 1.52 / 15.00 / 15.00
X-Rspamd-Queue-Id: 75B5717DB
X-Rspamd-UID: 5bd9bd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert bridge/link.c from a hand-rolled on_off parsing to the new global
one.

Signed-off-by: Petr Machata <me@pmachata.org>
---
 ip/iplink_vlan.c | 55 +++++++++++++++++-------------------------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index 1e6817f5de3d..66c4c0fb57f1 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -43,12 +43,6 @@ static void explain(void)
 	print_explain(stderr);
 }
 
-static int on_off(const char *msg, const char *arg)
-{
-	fprintf(stderr, "Error: argument of \"%s\" must be \"on\" or \"off\", not \"%s\"\n", msg, arg);
-	return -1;
-}
-
 static int vlan_parse_qos_map(int *argcp, char ***argvp, struct nlmsghdr *n,
 			      int attrtype)
 {
@@ -87,6 +81,7 @@ static int vlan_parse_opt(struct link_util *lu, int argc, char **argv,
 {
 	struct ifla_vlan_flags flags = { 0 };
 	__u16 id, proto;
+	int ret;
 
 	while (argc > 0) {
 		if (matches(*argv, "protocol") == 0) {
@@ -102,48 +97,36 @@ static int vlan_parse_opt(struct link_util *lu, int argc, char **argv,
 		} else if (matches(*argv, "reorder_hdr") == 0) {
 			NEXT_ARG();
 			flags.mask |= VLAN_FLAG_REORDER_HDR;
-			if (strcmp(*argv, "on") == 0)
-				flags.flags |= VLAN_FLAG_REORDER_HDR;
-			else if (strcmp(*argv, "off") == 0)
-				flags.flags &= ~VLAN_FLAG_REORDER_HDR;
-			else
-				return on_off("reorder_hdr", *argv);
+			parse_flag_on_off("reorder_hdr", *argv, &flags.flags, VLAN_FLAG_REORDER_HDR,
+					  &ret);
+			if (ret)
+				return ret;
 		} else if (matches(*argv, "gvrp") == 0) {
 			NEXT_ARG();
 			flags.mask |= VLAN_FLAG_GVRP;
-			if (strcmp(*argv, "on") == 0)
-				flags.flags |= VLAN_FLAG_GVRP;
-			else if (strcmp(*argv, "off") == 0)
-				flags.flags &= ~VLAN_FLAG_GVRP;
-			else
-				return on_off("gvrp", *argv);
+			parse_flag_on_off("gvrp", *argv, &flags.flags, VLAN_FLAG_GVRP, &ret);
+			if (ret)
+				return ret;
 		} else if (matches(*argv, "mvrp") == 0) {
 			NEXT_ARG();
 			flags.mask |= VLAN_FLAG_MVRP;
-			if (strcmp(*argv, "on") == 0)
-				flags.flags |= VLAN_FLAG_MVRP;
-			else if (strcmp(*argv, "off") == 0)
-				flags.flags &= ~VLAN_FLAG_MVRP;
-			else
-				return on_off("mvrp", *argv);
+			parse_flag_on_off("mvrp", *argv, &flags.flags, VLAN_FLAG_MVRP, &ret);
+			if (ret)
+				return ret;
 		} else if (matches(*argv, "loose_binding") == 0) {
 			NEXT_ARG();
 			flags.mask |= VLAN_FLAG_LOOSE_BINDING;
-			if (strcmp(*argv, "on") == 0)
-				flags.flags |= VLAN_FLAG_LOOSE_BINDING;
-			else if (strcmp(*argv, "off") == 0)
-				flags.flags &= ~VLAN_FLAG_LOOSE_BINDING;
-			else
-				return on_off("loose_binding", *argv);
+			parse_flag_on_off("loose_binding", *argv, &flags.flags,
+					  VLAN_FLAG_LOOSE_BINDING, &ret);
+			if (ret)
+				return ret;
 		} else if (matches(*argv, "bridge_binding") == 0) {
 			NEXT_ARG();
 			flags.mask |= VLAN_FLAG_BRIDGE_BINDING;
-			if (strcmp(*argv, "on") == 0)
-				flags.flags |= VLAN_FLAG_BRIDGE_BINDING;
-			else if (strcmp(*argv, "off") == 0)
-				flags.flags &= ~VLAN_FLAG_BRIDGE_BINDING;
-			else
-				return on_off("bridge_binding", *argv);
+			parse_flag_on_off("bridge_binding", *argv, &flags.flags,
+					  VLAN_FLAG_BRIDGE_BINDING, &ret);
+			if (ret)
+				return ret;
 		} else if (matches(*argv, "ingress-qos-map") == 0) {
 			NEXT_ARG();
 			if (vlan_parse_qos_map(&argc, &argv, n,
-- 
2.25.1

