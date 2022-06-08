Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2139154305E
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbiFHMan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiFHMal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:30:41 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998E4259F41
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 05:30:37 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id m20so41087630ejj.10
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 05:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=25w7LxQy0AYKz+DVwKAzK720H7bugHWMS4uOX3aKjBA=;
        b=OXoTr/VP+YOIRo7R8LFjSF62Om1GHYgXwvqV5qtTUWErNsDprw/UI6eKoUot/VVBfC
         Hmm2m//zw7vHKsCixtUsLIU2I1/pUj2zw0C+Snt6X3Bts3usKp/zVCKUb/kmu6wlaDBe
         SWzny/NiXpTSdeStejoemCyw1f0KFdjKYrbeNlsoeKhVU/E1E8Hl3U1LDK/3ySHgIRdj
         Umb7vPl6DsMNZ3ZqU0FfJ1SAKTyCpM/laBC5XpBzKcHUXgT+vhHxlfkz8nLieyiEUrxi
         TqcEOs0T8e+GmRSjdP0loOzENVS5S2zez0rjls6K6jhMzuWY8ctXC950NK2QKj++Bbqm
         1IpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=25w7LxQy0AYKz+DVwKAzK720H7bugHWMS4uOX3aKjBA=;
        b=0oouALlWfh/WhsJx8q4A02agpj5fvtqIKwjmAcvv3AbCrY7CITOVO06hCgIg+DRhb+
         bX0IJMvkO84DpPOnlKy2NhAoYefQfzs9CyOQJ2uu7zK1WR3YWvCgp1w85f0cKFZOXnU1
         0McLwc9h29YCKnmSYJjZEQw5NxOdONWcYL9ZBST8/pkejSLp8cJHxR1+Xl3BImFxrwkk
         HhODSPdydtUGQeSF1aPqtJPW0l1wY0Hoa/xcIAng/uKkgZhqYz15HMSAQ7HTsByVOs9i
         Bt6lW7VfMi1hRHiodeoQ2r+yaB/YY0P6+XQsQC3PEZChV49DhVqIRYbn6RTwE9/zd8NP
         hFpw==
X-Gm-Message-State: AOAM531KwkAkUOhV0qpCQtDv1yvWuIKj9M8nOXjp3Ux15pAAoWUlqLSa
        /1GQHEeZ4WeFbIXnz+JvWZQhg769AFJK5EL/
X-Google-Smtp-Source: ABdhPJzIYW/cRQJ+3GMQpqzy8xorV8r4cA6UrqFT1jJPjqEcBmuF+h3clHgnFqD+n0kyKqZs9M2ROQ==
X-Received: by 2002:a17:906:3087:b0:6f4:2901:608a with SMTP id 7-20020a170906308700b006f42901608amr31983251ejv.646.1654691435497;
        Wed, 08 Jun 2022 05:30:35 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id o7-20020a50fd87000000b0042dc25fdf5bsm12161687edt.29.2022.06.08.05.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 05:30:35 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, roopa@nvidia.com,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH iproute2-next 01/10] bridge: fdb: add new flush command
Date:   Wed,  8 Jun 2022 15:29:12 +0300
Message-Id: <20220608122921.3962382-2-razor@blackwall.org>
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

Add support for fdb bulk delete (aka flush) command. Currently it only
supports the self and master flags with the same semantics as fdb
add/del. The device is a mandatory argument.

Example:
$ bridge fdb flush dev br0
This will delete *all* fdb entries in br0's fdb table.

$ bridge fdb flush dev swp1 master
This will delete all fdb entries pointing to swp1.

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 bridge/fdb.c      | 58 ++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/bridge.8 | 29 ++++++++++++++++++++++++
 2 files changed, 86 insertions(+), 1 deletion(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 8912f092ca15..ac9f7af64336 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -44,7 +44,8 @@ static void usage(void)
 		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ]\n"
 		"              [ state STATE ] [ dynamic ] ]\n"
 		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
-		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n");
+		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n"
+		"       bridge fdb flush dev DEV [ self ] [ master ]\n");
 	exit(-1);
 }
 
@@ -666,6 +667,59 @@ static int fdb_get(int argc, char **argv)
 	return 0;
 }
 
+static int fdb_flush(int argc, char **argv)
+{
+	struct {
+		struct nlmsghdr	n;
+		struct ndmsg		ndm;
+		char			buf[256];
+	} req = {
+		.n.nlmsg_len = NLMSG_LENGTH(sizeof(struct ndmsg)),
+		.n.nlmsg_flags = NLM_F_REQUEST | NLM_F_BULK,
+		.n.nlmsg_type = RTM_DELNEIGH,
+		.ndm.ndm_family = PF_BRIDGE,
+	};
+	unsigned short ndm_flags = 0;
+	char *d = NULL;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "dev") == 0) {
+			NEXT_ARG();
+			d = *argv;
+		} else if (strcmp(*argv, "master") == 0) {
+			ndm_flags |= NTF_MASTER;
+		} else if (strcmp(*argv, "self") == 0) {
+			ndm_flags |= NTF_SELF;
+		} else {
+			if (strcmp(*argv, "help") == 0)
+				NEXT_ARG();
+		}
+		argc--; argv++;
+	}
+
+	if (d == NULL) {
+		fprintf(stderr, "Device is a required argument.\n");
+		return -1;
+	}
+
+	req.ndm.ndm_ifindex = ll_name_to_index(d);
+	if (req.ndm.ndm_ifindex == 0) {
+		fprintf(stderr, "Cannot find bridge device \"%s\"\n", d);
+		return -1;
+	}
+
+	/* if self and master were not specified assume self */
+	if (!(ndm_flags & (NTF_SELF | NTF_MASTER)))
+		ndm_flags |= NTF_SELF;
+
+	req.ndm.ndm_flags = ndm_flags;
+
+	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+		return -1;
+
+	return 0;
+}
+
 int do_fdb(int argc, char **argv)
 {
 	ll_init_map(&rth);
@@ -685,6 +739,8 @@ int do_fdb(int argc, char **argv)
 		    matches(*argv, "lst") == 0 ||
 		    matches(*argv, "list") == 0)
 			return fdb_show(argc-1, argv+1);
+		if (strcmp(*argv, "flush") == 0)
+			return fdb_flush(argc-1, argv+1);
 		if (matches(*argv, "help") == 0)
 			usage();
 	} else
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index d8923d2eb076..bfda9f7ecd7b 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -112,6 +112,12 @@ bridge \- show / manipulate bridge addresses and devices
 .IR VNI " ] ["
 .BR self " ] [ " master " ] [ " dynamic " ]"
 
+.ti -8
+.BR "bridge fdb flush"
+.B dev
+.IR DEV " [ "
+.BR self " ] [ " master " ]"
+
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
 .B dev
@@ -782,6 +788,29 @@ the bridge to which this address is associated.
 .TP
 .B master
 - the address is associated with master devices fdb. Usually software (default).
+
+.SS bridge fdb flush - flush bridge forwarding table entries.
+
+flush the matching bridge forwarding table entries.
+
+.TP
+.BI dev " DEV"
+the target device for the operation. If the device is a bridge port and "master"
+is set then the operation will be fulfilled by its master device's driver and
+all entries pointing to that port will be deleted.
+
+.TP
+.B self
+the operation is fulfilled directly by the driver for the specified network
+device. If the network device belongs to a master like a bridge, then the
+bridge is bypassed and not notified of this operation. The "bridge fdb flush"
+command can also be used on the bridge device itself. The flag is set by default if
+"master" is not specified.
+
+.TP
+.B master
+if the specified network device is a port that belongs to a master device
+such as a bridge, the operation is fulfilled by the master device's driver.
 .sp
 
 .SH bridge mdb - multicast group database management
-- 
2.35.1

