Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D15D54305F
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbiFHMav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbiFHMan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:43 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACDB254449
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:40 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id h23so30084626ejj.12
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQW3yJvWjyhGF3vYcK5DUCFClEZxPALp4KGWMqOk/9M=;
        b=Rl8IpHNvpwYCaXLvvcGzCZi2qYvPPpJEBKYC+wyqfGgnp/Bi7UyEVNj8imlZ1AZLbI
         05/DpWb9Db59cEGmuXT5vaoReFSB76L/3rGr3FRvj2+kdaWhvb/ehqPFnUn6e+zfCHbn
         dgqa4AiRhdRBDT6UgmP8RxrItY7LZW0anoxfPY6UMxtm8ygULfIUAVbIldkOqNPjirg7
         Le5Y+EdOKDArWmeY5zjtnaf35oxuxrNkMEg94Q5exMMNwS1+nJssxBo6SiyJf0d5kSNU
         FwgzgvPK6aIvaE7MBVjq0UrPNyrzzqlpkEyN8SeGeZr1j5z5fcj/h53qoyoPx3IAv2ig
         P4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQW3yJvWjyhGF3vYcK5DUCFClEZxPALp4KGWMqOk/9M=;
        b=amZCyYEwJ3Y4if1vR2iVqrSCs7hHUYf13hGnCKsp6tOkWG7sriygVwNu74HJ9vKtoZ
         SzQ362rS8iQu9itWpi6A6CJpngqs2rY1yAPEMJd4BixfCXpX+s7Q3cLqWKV+5m8nvEHd
         WLmU4yh2ludcdFbf9FUfvX27/UMMaVuwoiAIG0BeIyycqhqZ2/vrXZ/TRoz+rgLr7Ydt
         6OxlpHukJrmIjYhkrvwk+Fyo31U0bOCGGXYAalg1cIQ9LFO8bSFa6pWImBWfdsKwvsb8
         /NJ0FJLrWx8NpKqH1Ggy2ysnt54quBis0Kahg0bzEIiSDXDM6q1zNCjcuGyXQbHQ48IH
         JAgA==
X-Gm-Message-State: AOAM532IKDma5II5GuCJ2II5WRB74ArmTHpp/kCgph5TBlfQt3Sjs3Wm
        rUIyXaIEitPD/A1fOB2eY3obWZL0R2fYVaFp
X-Google-Smtp-Source: ABdhPJyI5py/YL20utdfuR7ob/pfrLf9rVaYEgmk2cA9krUxsI4R7P2aXfw3x8JJ3oLhWSbpuZRCPA==
X-Received: by 2002:a17:907:7ea9:b0:6fe:d412:ec2c with SMTP id qb41-20020a1709077ea900b006fed412ec2cmr31227363ejc.613.1654691438998;
        Wed, 08 Jun 2022 05:30:38 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:38 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 04/10] bridge: fdb: add flush [no]permanent entry matching
Date:   Wed,  8 Jun 2022 15:29:15 +0300
Message-Id: <20220608122921.3962382-5-razor@blackwall.org>
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

Add flush support to match permanent or non-permanent entries if "no" is
prepended respectively.

Examples:
$ bridge fdb flush dev br0 permanent
This will delete all permanent entries in br0's fdb table.

$ bridge fdb flush dev br0 nopermanent
This will delete all entries except the permanent ones in br0's fdb
table.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 14 +++++++++++++-
 man/man8/bridge.8 | 11 +++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 4af13eb20dc5..b1c516141750 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -46,7 +46,7 @@ static void usage(void)
 		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
 		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
 		"       bridge fdb flush dev DEV [ brport DEV ] [ vlan VID ]\n"
-		"              [ self ] [ master ]\n");
+		"              [ self ] [ master ] [ [no]permanent ]\n");
 	exit(-1);
 }
 
@@ -680,8 +680,10 @@ static int fdb_flush(int argc, char **argv)
 		.n.nlmsg_type = RTM_DELNEIGH,
 		.ndm.ndm_family = PF_BRIDGE,
 	};
+	unsigned short ndm_state_mask = 0;
 	short vid = -1, port_ifidx = -1;
 	unsigned short ndm_flags = 0;
+	unsigned short ndm_state = 0;
 	char *d = NULL, *port = NULL;
 
 	while (argc > 0) {
@@ -692,6 +694,12 @@ static int fdb_flush(int argc, char **argv)
 			ndm_flags |= NTF_MASTER;
 		} else if (strcmp(*argv, "self") == 0) {
 			ndm_flags |= NTF_SELF;
+		} else if (strcmp(*argv, "permanent") == 0) {
+			ndm_state |= NUD_PERMANENT;
+			ndm_state_mask |= NUD_PERMANENT;
+		} else if (strcmp(*argv, "nopermanent") == 0) {
+			ndm_state &= ~NUD_PERMANENT;
+			ndm_state_mask |= NUD_PERMANENT;
 		} else if (strcmp(*argv, "brport") == 0) {
 			if (port)
 				duparg2("brport", *argv);
@@ -739,10 +747,14 @@ static int fdb_flush(int argc, char **argv)
 		ndm_flags |= NTF_SELF;
 
 	req.ndm.ndm_flags = ndm_flags;
+	req.ndm.ndm_state = ndm_state;
 	if (port_ifidx > -1)
 		addattr32(&req.n, sizeof(req), NDA_IFINDEX, port_ifidx);
 	if (vid > -1)
 		addattr16(&req.n, sizeof(req), NDA_VLAN, vid);
+	if (ndm_state_mask)
+		addattr16(&req.n, sizeof(req), NDA_NDM_STATE_MASK,
+			  ndm_state_mask);
 
 	if (rtnl_talk(&rth, &req.n, NULL) < 0)
 		return -1;
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 32b81b4bd4fe..9dcd1f0a613f 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -120,7 +120,8 @@ bridge \- show / manipulate bridge addresses and devices
 .IR DEV " ] [ "
 .B vlan
 .IR VID " ] [ "
-.BR self " ] [ " master " ]"
+.BR self " ] [ " master " ] [ "
+.BR [no]permanent " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
@@ -795,7 +796,8 @@ the bridge to which this address is associated.
 
 .SS bridge fdb flush - flush bridge forwarding table entries.
 
-flush the matching bridge forwarding table entries.
+flush the matching bridge forwarding table entries. Some options below have a negated
+form when "no" is prepended to them (e.g. permanent and nopermanent).
 
 .TP
 .BI dev " DEV"
@@ -826,6 +828,11 @@ command can also be used on the bridge device itself. The flag is set by default
 .B master
 if the specified network device is a port that belongs to a master device
 such as a bridge, the operation is fulfilled by the master device's driver.
+
+.TP
+.B [no]permanent
+if specified then only permanent entries will be deleted or respectively if "no"
+is prepended then only non-permanent entries will be deleted.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

