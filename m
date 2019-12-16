Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C7B11FE8A
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 07:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfLPGoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 01:44:17 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33544 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfLPGoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 01:44:15 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so2551525pjb.0
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 22:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XCQTIt0joOQx73lO5XCJevpGn2uDiJooqPAsQPzZtmw=;
        b=ACkQySEtytuZJgJThpIk+BaLueLLDgsOVz63UdIZg9bZmtTH5v+oc33QwzZhCW0EGp
         wCZX8nATgW9yWnJxgngZel+z8iRKeeJBELiIwzM+TfSeTY8bpsVYyP56vR6fU0Mf4p4z
         kC+0joWpkIdukU306MoZeDrabc4E2rVuaudW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XCQTIt0joOQx73lO5XCJevpGn2uDiJooqPAsQPzZtmw=;
        b=mc+ZuOJHoDcOU+saIQCE0AgvGTDDuN/KAmAgJM4qUbsFmMvWVtPQ7zeqB8QAhzT6E7
         pQZAxHV579d4CtyMTUHIhrqzPfC4D/Tr0RJrf7tbrj1jxE9syy3W9f+YH/Gy1jkcTxqj
         PsGkalTibVRHbBcfsrXYthGvBhqsK+lRPUMOAbjbxR0u/gmj+XJmKdyD8w1wxxG/LSOu
         QghRjxaHqyWAUPYEQS895Dr1EalrExo7AcJzbz47c4HecX11yFRVk8vQQOqxz8rp47Hv
         9gtseXHUZnebXpnvuRS3zHHCmeL5wjYgCD8It127iyrR7MKMslBxu7tuboXZrDXgOFcv
         krkQ==
X-Gm-Message-State: APjAAAXCnnvlwo8Aj7Q9AFVrcyO7YmGoE4TKAOlad/KQFzga05m8v8Zn
        DgTIFbpo5J4vNvy4GIGVrzU5ptz4QLo=
X-Google-Smtp-Source: APXvYqzYsqt3yFwD4OF6cK1t8pqKUf4kvuqFyvxC0EAG359Le57MethRM0gnFhqOPbdeQ+gb6Wihxw==
X-Received: by 2002:a17:90a:9bc6:: with SMTP id b6mr16123153pjw.77.1576478654981;
        Sun, 15 Dec 2019 22:44:14 -0800 (PST)
Received: from f3.synalogic.ca (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id y62sm21881502pfg.45.2019.12.15.22.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 22:44:14 -0800 (PST)
From:   Benjamin Poirier <bpoirier@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [PATCH iproute2 6/8] bridge: Fix vni printing
Date:   Mon, 16 Dec 2019 15:43:42 +0900
Message-Id: <20191216064344.1470824-7-bpoirier@cumulusnetworks.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
References: <20191216064344.1470824-1-bpoirier@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit c7c1a1ef51ae ("bridge: colorize output and use JSON print
library"), print_range() is used for vid (16bits) and vni. However, the
latter are 32bits so they get truncated. They got truncated even before
that commit though.

Fixes: 8652eeb3ab12 ("bridge: vlan: support for per vlan tunnel info")
Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
---
 bridge/vlan.c                            |  6 +++---
 testsuite/Makefile                       |  3 ++-
 testsuite/lib/generic.sh                 |  6 +++++-
 testsuite/tests/bridge/vlan/tunnelshow.t | 24 ++++++++++++++++++++++++
 4 files changed, 34 insertions(+), 5 deletions(-)
 create mode 100755 testsuite/tests/bridge/vlan/tunnelshow.t

diff --git a/bridge/vlan.c b/bridge/vlan.c
index c0294aa6..428eeee3 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -266,15 +266,15 @@ static void close_vlan_port(void)
 	close_json_object();
 }
 
-static void print_range(const char *name, __u16 start, __u16 id)
+static void print_range(const char *name, __u32 start, __u32 id)
 {
 	char end[64];
 
 	snprintf(end, sizeof(end), "%sEnd", name);
 
-	print_hu(PRINT_ANY, name, "\t %hu", start);
+	print_uint(PRINT_ANY, name, "\t %u", start);
 	if (start != id)
-		print_hu(PRINT_ANY, end, "-%hu", id);
+		print_uint(PRINT_ANY, end, "-%u", id);
 
 }
 
diff --git a/testsuite/Makefile b/testsuite/Makefile
index 4451f316..fb50f618 100644
--- a/testsuite/Makefile
+++ b/testsuite/Makefile
@@ -82,7 +82,8 @@ endif
 		TMP_OUT=`mktemp /tmp/tc_testsuite.XXXXXX`; \
 		. $(KENVFN); \
 		STD_ERR="$$TMP_ERR" STD_OUT="$$TMP_OUT" \
-		TC="$$i/tc/tc" IP="$$i/ip/ip" SS=$$i/misc/ss DEV="$(DEV)" IPVER="$@" SNAME="$$i" \
+		TC="$$i/tc/tc" IP="$$i/ip/ip" SS=$$i/misc/ss BRIDGE="$$i/bridge/bridge" \
+		DEV="$(DEV)" IPVER="$@" SNAME="$$i" \
 		ERRF="$(RESULTS_DIR)/$@.$$o.err" $(PREFIX) tests/$@ > $(RESULTS_DIR)/$@.$$o.out; \
 		if [ "$$?" = "127" ]; then \
 			printf "\033[1;35mSKIPPED\033[0m\n"; \
diff --git a/testsuite/lib/generic.sh b/testsuite/lib/generic.sh
index e909008a..8b339ec1 100644
--- a/testsuite/lib/generic.sh
+++ b/testsuite/lib/generic.sh
@@ -1,4 +1,3 @@
-
 export DEST="127.0.0.1"
 
 ts_log()
@@ -66,6 +65,11 @@ ts_ss()
 	__ts_cmd "$SS" "$@"
 }
 
+ts_bridge()
+{
+	__ts_cmd "$BRIDGE" "$@"
+}
+
 ts_qdisc_available()
 {
 	HELPOUT=`$TC qdisc add $1 help 2>&1`
diff --git a/testsuite/tests/bridge/vlan/tunnelshow.t b/testsuite/tests/bridge/vlan/tunnelshow.t
new file mode 100755
index 00000000..1583abb9
--- /dev/null
+++ b/testsuite/tests/bridge/vlan/tunnelshow.t
@@ -0,0 +1,24 @@
+#!/bin/sh
+
+. lib/generic.sh
+
+ts_log "[Testing tunnelshow]"
+
+BR_DEV="$(rand_dev)"
+VX_DEV="$(rand_dev)"
+
+ts_ip "$0" "Add $BR_DEV bridge interface" link add $BR_DEV type bridge
+
+ts_ip "$0" "Add $VX_DEV vxlan interface" \
+	link add $VX_DEV type vxlan dstport 4789 external
+ts_ip "$0" "Enslave $VX_DEV under $BR_DEV" \
+	link set dev $VX_DEV master $BR_DEV
+ts_ip "$0" "Set vlan_tunnel on $VX_DEV" \
+	link set dev $VX_DEV type bridge_slave vlan_tunnel on
+
+ts_bridge "$0" "Add single vlan" vlan add dev $VX_DEV vid 1030
+ts_bridge "$0" "Add tunnel with vni > 16k" \
+	vlan add dev $VX_DEV vid 1030 tunnel_info id 65556
+
+ts_bridge "$0" "Show tunnel info" vlan tunnelshow dev $VX_DEV
+test_on "1030\s+65556"
-- 
2.24.0

