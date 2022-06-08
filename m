Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F38543060
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239160AbiFHMa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239076AbiFHMap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:45 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182F325A088
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:43 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id m20so41087630ejj.10
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9K5G/9GMMxCCPUr3eiXhjwJ83u/CoHUJ1RwCnFRoxzY=;
        b=L0Rpvq1RnH7oaAuSGLwlmuEptcJB958RDtG1NEATtP1t2RwqaJpJoT8SvZACDe/nob
         ZrgckKmm5G3AAeqGyXLwydxRch5TbZQ+NVmZqAYeN+oCRi/QALO3HhEwU01pj3phMiyR
         3OuLn8yMOZEG2PWzyzonZUmVDv8gCDCi1hU0Ag+aokLc3NR+iSCRfetLa8bgcHD3b/V4
         bh2k+ciPTewA7X1t3lv/1m1z/oNncZFv9/IbYUCwumMLD1l3UvC0yGegPaNSFz0skaDx
         JWk43Lt2dK/pyUqpOGhGeqI1rJF8X/NWQX+0DKXL5tuosfx7CuWqHCR4sWm2/nVGisvP
         bysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9K5G/9GMMxCCPUr3eiXhjwJ83u/CoHUJ1RwCnFRoxzY=;
        b=KPMCioh+qxjvPYWU/lR26qpZYI7hQXgrWb2qt0vnWOS5yppiiQNhcK45/t8oPMuozK
         8NPeCkEa78zzEtKMjRphF8KNwYaqO8Ko9XWHXg9Swxm4RDNnCmWiel3cViQD2fbLYWDO
         KNBPT8edcjRUJ5QS5aU4eg4Cepc84/B9tFBK6OgVPHDJziEIbh5mR7RRzEichm5EMjkL
         YPqr2bTrmW12x2zBRVL/Brt+lAU6ik45jcu/3+1RGGijU1lfwXyheC9wD2u2RhfN1boi
         wVx8K47eMhOtiXgBmW7atVmjCDNwI4Rsb6Bx8l8ns1id/Vlcu07JyA1wPzU7fcfH0yRc
         Cp0g==
X-Gm-Message-State: AOAM5330zPxR8y3Tj0vzysZkos3/leika0rc5CxeIKB/UOjJWRjDQL8c
        P3T6B7ACBYU/bl1C1b/X5j/D4iABXicKv2TT
X-Google-Smtp-Source: ABdhPJxWoYkYZ/bK2BpjMbToRjwigIApzIFaGuY777YEGEe8+3+lSOB993XWyqrrGy8lYgc7y3lXbg==
X-Received: by 2002:a17:906:51c5:b0:711:f4ee:6574 with SMTP id v5-20020a17090651c500b00711f4ee6574mr2734606ejk.509.1654691442305;
        Wed, 08 Jun 2022 05:30:42 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:41 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 07/10] bridge: fdb: add flush [no]added_by_user entry matching
Date:   Wed,  8 Jun 2022 15:29:18 +0300
Message-Id: <20220608122921.3962382-8-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608122921.3962382-1-razor@blackwall.org>
References: <20220608122921.3962382-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flush support to match entries with or without (if "no" is
prepended) added_by_user flag. Note that NTF_USE is used internally
because there is no NTF_ flag that describes such entries.

Examples:
$ bridge fdb flush dev br0 added_by_user
This will delete all added_by_user entries in br0's fdb table.

$ bridge fdb flush dev br0 noadded_by_user
This will delete all entries except the ones with added_by_user flag in
br0's fdb table.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 13 ++++++++++++-
 man/man8/bridge.8 |  8 +++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 9c1899c167be..c57ad235b401 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -46,7 +46,8 @@ static void usage(void)
 		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
 		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
-		"              [ self ] [ master ] [ [no]permanent | [no]static | [no]dynamic ]\n");
+		"              [ self ] [ master ] [ [no]permanent | [no]static | [no]dynamic ]\n"
+		"              [ [no]added_by_user ]\n");
 	exit(-1);
 }
 
@@ -681,6 +682,7 @@ static int fdb_flush(int argc, char **argv)
 		.ndm.ndm_family = PF_BRIDGE,
 	};
 	unsigned short ndm_state_mask = 0;
+	unsigned short ndm_flags_mask = 0;
 	short vid = -1, port_ifidx = -1;
 	unsigned short ndm_flags = 0;
 	unsigned short ndm_state = 0;
@@ -712,6 +714,12 @@ static int fdb_flush(int argc, char **argv)
 		} else if (strcmp(*argv, "nodynamic") == 0) {
 			ndm_state |= NUD_NOARP;
 			ndm_state_mask |= NUD_NOARP;
+		} else if (strcmp(*argv, "added_by_user") == 0) {
+			ndm_flags |= NTF_USE;
+			ndm_flags_mask |= NTF_USE;
+		} else if (strcmp(*argv, "noadded_by_user") == 0) {
+			ndm_flags &= ~NTF_USE;
+			ndm_flags_mask |= NTF_USE;
 		} else if (strcmp(*argv, "brport") == 0) {
 			if (port)
 				duparg2("brport", *argv);
@@ -764,6 +772,9 @@ static int fdb_flush(int argc, char **argv)
 		addattr32(&req.n, sizeof(req), NDA_IFINDEX, port_ifidx);
 	if (vid > -1)
 		addattr16(&req.n, sizeof(req), NDA_VLAN, vid);
+	if (ndm_flags_mask)
+		addattr8(&req.n, sizeof(req), NDA_NDM_FLAGS_MASK,
+			 ndm_flags_mask);
 	if (ndm_state_mask)
 		addattr16(&req.n, sizeof(req), NDA_NDM_STATE_MASK,
 			  ndm_state_mask);
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index f4b3887a9144..b39c74823606 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -121,7 +121,8 @@ bridge \- show / manipulate bridge addresses and devices
 .B vlan
 .IR VID " ] [ "
 .BR self " ] [ " master " ] [ "
-.BR [no]permanent " | " [no]static " | " [no]dynamic " ]"
+.BR [no]permanent " | " [no]static " | " [no]dynamic " ] [ "
+.BR [no]added_by_user " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
@@ -843,6 +844,11 @@ is prepended then only non-static entries will be deleted.
 .B [no]dynamic
 if specified then only dynamic entries will be deleted or respectively if "no"
 is prepended then only non-dynamic (static or permanent) entries will be deleted.
+
+.TP
+.B [no]added_by_user
+if specified then only entries with added_by_user flag will be deleted or respectively
+if "no" is prepended then only entries without added_by_user flag will be deleted.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

