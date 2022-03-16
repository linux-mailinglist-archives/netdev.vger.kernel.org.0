Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF984DAD26
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 10:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354792AbiCPJE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 05:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354809AbiCPJEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 05:04:24 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9199E3BFAD
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:03:10 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q5so2172318ljb.11
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 02:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=xI7+6t1/Io4sQEZ6G4SCny5ogIKDyQOHp+SRw2woYDQ=;
        b=kDZbnrYzG9xUy/cDYOXhreEkpg0DqIBZ8Ven5AMAzV49BLJ2w/zI9xrNB0atwkQ/nF
         yHE3b/7IgA3FkgkfNt+EFA4fqaXb3M87vFgRumIC4EpcE2coeaNaZa8L71yBFRwwOtro
         QR/ogexhGsNKkeRxdzFWQPmm+lrtebqfS/gB5ULH30NMSyZFD4Caa9CNQP7o2Znb6Qz4
         +qb2vQkRob0DRzZrptk0u3Hdxw/G+FBRVAhwF1kRaHjkC7h/2vnIQZoaMn+gfhwzgKC1
         TOHuj2rGasynbvz/LEYU9tBQ2wLCpgs+qxL5eOD+QS36mD6ODVLGD5nX/5V63UdlQX13
         LNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=xI7+6t1/Io4sQEZ6G4SCny5ogIKDyQOHp+SRw2woYDQ=;
        b=tzezvTFkBzagpEdv6DvnJOk/mIdr4V7ffopg1WdvSC2gZMYwhnRlRpueFfPNTWPVF+
         lBLPN9cNwy8xxKlnjZ3zXOwgd02oueF5DGr7RfPMrfvg0k6xGyR9aULKtjbo43qKnB74
         IiZm8HwBbgz9FTI2wcasl4ecjeinkh1RRVFxwG8JUBa20PPBXDaSaJYbVt7axsH4PZIG
         yIaxWNX56pO6xLoKXGdv7XnV1W8IKQ1u4vMFYZ4Zy2WESf8hLqDXNbxFtPiFLu2Covew
         MCYxTY/G9ZoN9b/9aC/ikhXdk6vnExyC9RFoQeW17iE3CPS/BHAJZrJRyuqbvTLx3rYa
         GQ7A==
X-Gm-Message-State: AOAM530gA2YqjKQmyk8JlNMnioF4mOYrpYmnphstu4Ck1C5Js2Pbw2nW
        TCUTEQHorX+NyUq2FmYG4UuyecJfVEBz9w==
X-Google-Smtp-Source: ABdhPJygV2Ly2EYykkh9iJkHlM8RNQ2IgPdYOIlMinVh9zCawYYzmJuQKYzejZlg2crJ43P0L6b4VA==
X-Received: by 2002:a2e:a44b:0:b0:249:36ec:5bd3 with SMTP id v11-20020a2ea44b000000b0024936ec5bd3mr9163162ljn.504.1647421386884;
        Wed, 16 Mar 2022 02:03:06 -0700 (PDT)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id j17-20020a2e8511000000b00247ee6592cesm124111lji.104.2022.03.16.02.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 02:03:06 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next 1/2] bridge: support for controlling mcast_router per port
Date:   Wed, 16 Mar 2022 10:02:56 +0100
Message-Id: <20220316090257.3531111-2-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316090257.3531111-1-troglobit@gmail.com>
References: <20220316090257.3531111-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge vlan command supports setting mcast_router per-port and
per-vlan, what's however missing is the ability to set the per-port
mcast_router options, e.g. when VLAN filtering is disabled.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 bridge/link.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index 80b01f56..3810fa04 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -156,6 +156,9 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_BCAST_FLOOD])
 			print_on_off(PRINT_ANY, "bcast_flood", "bcast_flood %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_BCAST_FLOOD]));
+		if (prtb[IFLA_BRPORT_MULTICAST_ROUTER])
+			print_uint(PRINT_ANY, "mcast_router", "mcast_router %u ",
+				   rta_getattr_u8(prtb[IFLA_BRPORT_MULTICAST_ROUTER]));
 		if (prtb[IFLA_BRPORT_MCAST_TO_UCAST])
 			print_on_off(PRINT_ANY, "mcast_to_unicast", "mcast_to_unicast %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_MCAST_TO_UCAST]));
@@ -270,6 +273,7 @@ static void usage(void)
 		"                               [ learning {on | off} ]\n"
 		"                               [ learning_sync {on | off} ]\n"
 		"                               [ flood {on | off} ]\n"
+		"                               [ mcast_router MULTICAST_ROUTER ]\n"
 		"                               [ mcast_flood {on | off} ]\n"
 		"                               [ bcast_flood {on | off} ]\n"
 		"                               [ mcast_to_unicast {on | off} ]\n"
@@ -303,6 +307,7 @@ static int brlink_modify(int argc, char **argv)
 	__s8 learning_sync = -1;
 	__s8 flood = -1;
 	__s8 vlan_tunnel = -1;
+	__s8 mcast_router = -1;
 	__s8 mcast_flood = -1;
 	__s8 bcast_flood = -1;
 	__s8 mcast_to_unicast = -1;
@@ -359,6 +364,9 @@ static int brlink_modify(int argc, char **argv)
 			flood = parse_on_off("flood", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "mcast_router") == 0) {
+			NEXT_ARG();
+			mcast_router = atoi(*argv);
 		} else if (strcmp(*argv, "mcast_flood") == 0) {
 			NEXT_ARG();
 			mcast_flood = parse_on_off("mcast_flood", *argv, &ret);
@@ -473,6 +481,9 @@ static int brlink_modify(int argc, char **argv)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_PROTECT, root_block);
 	if (flood >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_UNICAST_FLOOD, flood);
+	if (mcast_router >= 0)
+		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MULTICAST_ROUTER,
+			 mcast_router);
 	if (mcast_flood >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MCAST_FLOOD,
 			 mcast_flood);
-- 
2.25.1

