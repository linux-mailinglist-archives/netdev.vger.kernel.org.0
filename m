Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C53322ED3B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgG0N01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0N00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 09:26:26 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDB9C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:26:25 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id v4so7535596ljd.0
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 06:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uw/RH0celvphSjJGmfO8R+FZlpx9mMKK+rAAVor0RbU=;
        b=ZiuSGn+8glPgs4h0sYiE0Hp/q0X3RBUYgydrbvTfSVcNAZWvmAGm375HsRCklwGNc1
         KeAylHYARqyM5Sf1s3za4pfO2JMqyqvg0xLl/qzhsmwRiMzWM45aMP6neqwsSjIz/wRM
         z52MwtLBRmxKFvsiQ7Rl3zowhFAABATtkMLlIWBPQnVuCmGrDNNKaL+3yck29r2Tintp
         KEdayt1ZI5LJcKxVfjHHMCOW9NV9qaoHJaXefdA7vmvsgaUQ/RT/HZEGH3HoXctYPD/g
         HadwYJbrBB8lEN8sr43UvDLdwn01TMdZrxCrY8J/0U3F5p6j8ZAjaiQwqjIwumxAdE3T
         2PdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uw/RH0celvphSjJGmfO8R+FZlpx9mMKK+rAAVor0RbU=;
        b=MfrI14DY9Smu1susYXr+L4T+RgoyP4kOkXKlcGuSBjih7xIb35uW+lEr3TKe63J7ts
         btmwWiaRXHhRXNzAsyPpiaUg6CO7bnMwOeV1asbo6gz2v7+gCZKxGH7uoWSWm66J9geg
         7eRJj1HaNTWrJoE+oYeKVe/unO9+bwVFOS8Xip78oFn3xY9FkrjuNUruOfMPyG0bi/vC
         /dgP4yzrLLNqf2BZCbJyVxgiEjYfeTVMrfDq9BdJwVrSoMCO0nb2FCq//bXup6maVTaM
         9Q8u+bE9+6qAAueBVyl503UdakU4/8EeshgcEFuw83sbYbKGwz0ewvztE6sO4MSereIi
         Molg==
X-Gm-Message-State: AOAM5302iHYHZ9HZPrJfLbQv+nDHAzZzKiFy9ntLRtWaBYcfit0hg7XN
        SpINTR6yb4p4XNx3SADk6ClfABJ1
X-Google-Smtp-Source: ABdhPJwZQaMpWvR+FcYh5D6e9b8XAyHGxcJmtjor+5vf0biCpHhNmnEiWKPxMY4E3wJOnAcXvJLMZQ==
X-Received: by 2002:a2e:999a:: with SMTP id w26mr9697577lji.371.1595856384250;
        Mon, 27 Jul 2020 06:26:24 -0700 (PDT)
Received: from dau-pc-work.sunlink.ru ([87.244.6.228])
        by smtp.googlemail.com with ESMTPSA id 16sm2351103lju.100.2020.07.27.06.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 06:26:23 -0700 (PDT)
From:   Anton Danilov <littlesmilingcloud@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org,
        Anton Danilov <littlesmilingcloud@gmail.com>
Subject: [PATCH iproute2] bridge: fdb: the 'dynamic' option in the show/get commands
Date:   Mon, 27 Jul 2020 16:26:07 +0300
Message-Id: <20200727132606.251041-1-littlesmilingcloud@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In most of cases a user wants to see only the dynamic mac addresses
in the fdb output. But currently the 'fdb show' displays tons of
various self entries, those only waste the output without any useful
goal.

New option 'dynamic' for 'show' and 'get' commands forces display
only relevant records.

Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
---
 bridge/fdb.c      | 17 +++++++++++++----
 man/man8/bridge.8 | 30 ++++++++++++++++++------------
 2 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 710dfc99..78aaaa5a 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -30,7 +30,8 @@
 #include "rt_names.h"
 #include "utils.h"
 
-static unsigned int filter_index, filter_vlan, filter_state, filter_master;
+static unsigned int filter_index, filter_dynamic, filter_master,
+	filter_state, filter_vlan;
 
 static void usage(void)
 {
@@ -40,9 +41,10 @@ static void usage(void)
 		"              [ sticky ] [ local | static | dynamic ] [ dst IPADDR ]\n"
 		"              [ vlan VID ] [ port PORT] [ vni VNI ] [ via DEV ]\n"
 		"              [ src_vni VNI ]\n"
-		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ] [ state STATE ] ]\n"
-		"       bridge fdb get ADDR [ br BRDEV ] { brport |dev }  DEV [ vlan VID ]\n"
-		"              [ vni VNI ]\n");
+		"       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ]\n"
+		"              [ state STATE ] [ dynamic ] ]\n"
+		"       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV\n"
+		"              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]\n");
 	exit(-1);
 }
 
@@ -167,6 +169,9 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 	if (filter_vlan && filter_vlan != vid)
 		return 0;
 
+	if (filter_dynamic && (r->ndm_state & NUD_PERMANENT))
+		return 0;
+
 	open_json_object(NULL);
 	if (n->nlmsg_type == RTM_DELNEIGH)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
@@ -322,6 +327,8 @@ static int fdb_show(int argc, char **argv)
 			if (state_a2n(&state, *argv))
 				invarg("invalid state", *argv);
 			filter_state |= state;
+		} else if (strcmp(*argv, "dynamic") == 0) {
+			filter_dynamic = 1;
 		} else {
 			if (matches(*argv, "help") == 0)
 				usage();
@@ -566,6 +573,8 @@ static int fdb_get(int argc, char **argv)
 				duparg2("vlan", *argv);
 			NEXT_ARG();
 			vlan = atoi(*argv);
+		} else if (matches(*argv, "dynamic") == 0) {
+			filter_dynamic = 1;
 		} else {
 			if (strcmp(*argv, "to") == 0)
 				NEXT_ARG();
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 71f2e890..5aa83e15 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -77,12 +77,12 @@ bridge \- show / manipulate bridge addresses and devices
 .B port
 .IR PORT " ] ["
 .B via
-.IR DEVICE " ]"
+.IR DEVICE " ] ["
+.B src_vni
+.IR VNI " ]"
 
 .ti -8
-.BR "bridge fdb" " [ " show " ] [ "
-.B dev
-.IR DEV " ] [ "
+.BR "bridge fdb" " [ [ " show " ] [ "
 .B br
 .IR BRDEV " ] [ "
 .B brport
@@ -90,18 +90,24 @@ bridge \- show / manipulate bridge addresses and devices
 .B vlan
 .IR VID " ] [ "
 .B state
-.IR STATE " ]"
+.IR STATE " ] ["
+.B dynamic
+.IR "] ]"
 
 .ti -8
-.B bridge fdb get
-.I LLADDR " [ "
-.B dev
-.IR DEV " ] [ "
+.BR "bridge fdb get" " ["
+.B to
+.IR "]"
+.I LLADDR "[ "
 .B br
-.IR BRDEV " ] [ "
+.IR BRDEV " ]"
+.B { brport | dev }
+.IR DEV " [ "
 .B vlan
-.IR VID  " ] ["
-.BR self " ] [ " master " ]"
+.IR VID  " ] [ "
+.B vni
+.IR VNI " ] ["
+.BR self " ] [ " master " ] [ " dynamic " ]"
 
 .ti -8
 .BR "bridge mdb" " { " add " | " del " } "
-- 
2.27.0

