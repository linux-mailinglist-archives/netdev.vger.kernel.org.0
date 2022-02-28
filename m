Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F40F4C6E58
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:37:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbiB1Nhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:37:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235604AbiB1Nhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:37:47 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BF67A9A4;
        Mon, 28 Feb 2022 05:37:08 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id l12so5538875ljh.12;
        Mon, 28 Feb 2022 05:37:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=xXj2/f+qvoC8XO/wzynFMId5J1aWTkWLoQHGmpvRGhE=;
        b=RmDwxl2xzi0WHVsau0s4wrcEkmbPNa1mYJcPoUHdwKRSP0LTWAGpzIVQLRI/d8uDqv
         u6WpTVZSUZqLr26sD+PySzmOY4/NTZ8yY/2B/6wGJt3Xb/EV7C2VIaeLhTrN1fEz/wGz
         JvBvoEl01jxmHS/jWpo3VSvtcTEmIl3xzXTfnP8L+zU170gkknkEKfbdDV8/sZ/J16uC
         2YSn1VE2DfrejqTCHGImRRGV9fbaCO/uXip3VcGYn40qN8G6igvh1VuV5oL4OnS6WJlB
         1fRfqPXzWarM0XJWLG919lMgGwiNsj8EzBKP3nYB4/sCkOCt/OFg0HbCEabuV3gWtK8S
         /uMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=xXj2/f+qvoC8XO/wzynFMId5J1aWTkWLoQHGmpvRGhE=;
        b=fMUdBqKUWXzOXQsdjbeKgeyG1ZotsYAbb2ypYCJA/n0+Z/mIi+Io1xMUN1pCLhp9Ub
         iEtfzqAtFQ+gJIHAHgqU57yVny8c2tEPIhitsweUSR6dY1HzjEjEuXxT3wH9M8bVH+83
         htKujoAKgy/oLlsDqDHO6O6wI/z41iv19VrPJDeoWA5k0we6XFA1pRTpf8yHugkVlj8A
         93Ewg9WIf/Nh/prnZDN/Hap6/p8yX/SWOFb5JgVopuK/kag5uhg7AR/z/LSBDmrmO25u
         bCUCPtWb1wbq4e6Y1aUB/C0BmLGhl1dEEuac/tJXOGgZgGYSGVj0VbxF1do+JQ3C7Rrw
         +Ywg==
X-Gm-Message-State: AOAM530brsyJO15fTLCTP6bwndrUkCTEkiLN3LLGTaGM7pTBO/QIiowf
        d9blq/1uNPIcvmRrvZ+HEBM=
X-Google-Smtp-Source: ABdhPJyqnrFPptURF8sqTAcicGqTOv80lDSCynEfiZ/iFNOCU0F5rafKKgTdzvGFJwaBgCe7y73PdA==
X-Received: by 2002:a2e:9247:0:b0:244:d4bf:58fc with SMTP id v7-20020a2e9247000000b00244d4bf58fcmr14429906ljg.309.1646055426963;
        Mon, 28 Feb 2022 05:37:06 -0800 (PST)
Received: from wse-c0127.beijerelectronics.com ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i16-20020a2e5410000000b0024647722a4asm1326640ljb.29.2022.02.28.05.37.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 05:37:06 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH iproute2-next V2 1/4] bridge: link: add command to set port in locked mode
Date:   Mon, 28 Feb 2022 14:36:47 +0100
Message-Id: <20220228133650.31358-2-schultz.hans+netdev@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
References: <20220228133650.31358-1-schultz.hans+netdev@gmail.com>
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

Add support for setting a bridge port in locked mode to use with 802.1X,
so that only authorized clients are allowed access through the port.

Syntax: bridge link set dev DEV locked {on, off}

Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
---
 bridge/link.c                | 13 +++++++++++++
 include/uapi/linux/if_link.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index 205a2fe7..bb4f0b2d 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -175,6 +175,9 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_ISOLATED])
 			print_on_off(PRINT_ANY, "isolated", "isolated %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_ISOLATED]));
+		if (prtb[IFLA_BRPORT_LOCKED])
+			print_on_off(PRINT_ANY, "locked", "locked %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_LOCKED]));
 	} else
 		print_stp_state(rta_getattr_u8(attr));
 }
@@ -275,6 +278,7 @@ static void usage(void)
 		"                               [ neigh_suppress {on | off} ]\n"
 		"                               [ vlan_tunnel {on | off} ]\n"
 		"                               [ isolated {on | off} ]\n"
+		"                               [ locked {on | off} ]\n"
 		"                               [ hwmode {vepa | veb} ]\n"
 		"                               [ backup_port DEVICE ] [ nobackup_port ]\n"
 		"                               [ self ] [ master ]\n"
@@ -303,6 +307,7 @@ static int brlink_modify(int argc, char **argv)
 	__s8 vlan_tunnel = -1;
 	__s8 mcast_flood = -1;
 	__s8 mcast_to_unicast = -1;
+	__s8 locked = -1;
 	__s8 isolated = -1;
 	__s8 hairpin = -1;
 	__s8 bpdu_guard = -1;
@@ -415,6 +420,11 @@ static int brlink_modify(int argc, char **argv)
 			isolated = parse_on_off("isolated", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "locked") == 0) {
+			NEXT_ARG();
+			locked = parse_on_off("locked", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "backup_port") == 0) {
 			NEXT_ARG();
 			backup_port_idx = ll_name_to_index(*argv);
@@ -489,6 +499,9 @@ static int brlink_modify(int argc, char **argv)
 	if (isolated != -1)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_ISOLATED, isolated);
 
+	if (locked >= 0)
+		addattr8(&req.n, sizeof(req), IFLA_BRPORT_LOCKED, locked);
+
 	if (backup_port_idx != -1)
 		addattr32(&req.n, sizeof(req), IFLA_BRPORT_BACKUP_PORT,
 			  backup_port_idx);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1d4ed60b..637623bb 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -534,6 +534,7 @@ enum {
 	IFLA_BRPORT_MRP_IN_OPEN,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
+	IFLA_BRPORT_LOCKED,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
-- 
2.30.2

