Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C933656795D
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 23:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiGEVcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 17:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiGEVc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 17:32:27 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E2A15A31
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 14:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657056745; x=1688592745;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a2vfLDIU1Y8R3v+h0jDohycCBGEae5albz97uSQfIr4=;
  b=dmGls7HaEaCbl+HjhXwv2FXDNKblQQw5Er8bhJ5F4c/N/PKegyYmwT0w
   0X6uaTSJSlBZNXB8T4a/d6liydnjOlH8Q6WAWasfUINtSdYI1lr2MzwKO
   eCFdOrOIMnTxHBKpspV1cN503+h4ra1nYlgeGmyiEJ0G8ckBIQU7eHQoN
   H8zZCAMx/RLBG+nauFRxSKOQ3D8rgCvADwyJsdUeVmPEJR/28oZG6hC1E
   ErwkTVp/uvUnzD1n5pjXbr7/XN20OOqqGMWL/qyZ+Zl7xuCn4AR4Zf+ao
   Wnn2RDpK4b1Lt8mNygDDpCympXBAUQarzT+IuHJKi/Evi81lDgy7begRu
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="284633935"
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="284633935"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:23 -0700
X-IronPort-AV: E=Sophos;i="5.92,247,1650956400"; 
   d="scan'208";a="590558751"
Received: from rcenter-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.17.169])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 14:32:22 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Kishen Maloor <kishen.maloor@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, geliang.tang@suse.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 5/7] selftests: mptcp: userspace PM support for MP_PRIO signals
Date:   Tue,  5 Jul 2022 14:32:15 -0700
Message-Id: <20220705213217.146898-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705213217.146898-1-mathew.j.martineau@linux.intel.com>
References: <20220705213217.146898-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kishen Maloor <kishen.maloor@intel.com>

This change updates the testing sample (pm_nl_ctl) to exercise
the updated MPTCP_PM_CMD_SET_FLAGS command for userspace PMs to
issue MP_PRIO signals over the selected subflow.

E.g. ./pm_nl_ctl set 10.0.1.2 port 47234 flags backup token 823274047 rip 10.0.1.1 rport 50003

userspace_pm.sh has a new selftest that invokes this command.

Fixes: 259a834fadda ("selftests: mptcp: functional tests for the userspace PM type")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 73 ++++++++++++++++++-
 .../selftests/net/mptcp/userspace_pm.sh       | 32 ++++++++
 2 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 6a2f4b981e1d..cb79f0719e3b 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -39,7 +39,7 @@ static void syntax(char *argv[])
 	fprintf(stderr, "\tdsf lip <local-ip> lport <local-port> rip <remote-ip> rport <remote-port> token <token>\n");
 	fprintf(stderr, "\tdel <id> [<ip>]\n");
 	fprintf(stderr, "\tget <id>\n");
-	fprintf(stderr, "\tset [<ip>] [id <nr>] flags [no]backup|[no]fullmesh [port <nr>]\n");
+	fprintf(stderr, "\tset [<ip>] [id <nr>] flags [no]backup|[no]fullmesh [port <nr>] [token <token>] [rip <ip>] [rport <port>]\n");
 	fprintf(stderr, "\tflush\n");
 	fprintf(stderr, "\tdump\n");
 	fprintf(stderr, "\tlimits [<rcv addr max> <subflow max>]\n");
@@ -1279,7 +1279,10 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 	struct rtattr *rta, *nest;
 	struct nlmsghdr *nh;
 	u_int32_t flags = 0;
+	u_int32_t token = 0;
+	u_int16_t rport = 0;
 	u_int16_t family;
+	void *rip = NULL;
 	int nest_start;
 	int use_id = 0;
 	u_int8_t id;
@@ -1339,7 +1342,13 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 		error(1, 0, " missing flags keyword");
 
 	for (; arg < argc; arg++) {
-		if (!strcmp(argv[arg], "flags")) {
+		if (!strcmp(argv[arg], "token")) {
+			if (++arg >= argc)
+				error(1, 0, " missing token value");
+
+			/* token */
+			token = atoi(argv[arg]);
+		} else if (!strcmp(argv[arg], "flags")) {
 			char *tok, *str;
 
 			/* flags */
@@ -1378,12 +1387,72 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 			rta->rta_len = RTA_LENGTH(2);
 			memcpy(RTA_DATA(rta), &port, 2);
 			off += NLMSG_ALIGN(rta->rta_len);
+		} else if (!strcmp(argv[arg], "rport")) {
+			if (++arg >= argc)
+				error(1, 0, " missing remote port");
+
+			rport = atoi(argv[arg]);
+		} else if (!strcmp(argv[arg], "rip")) {
+			if (++arg >= argc)
+				error(1, 0, " missing remote ip");
+
+			rip = argv[arg];
 		} else {
 			error(1, 0, "unknown keyword %s", argv[arg]);
 		}
 	}
 	nest->rta_len = off - nest_start;
 
+	/* token */
+	if (token) {
+		rta = (void *)(data + off);
+		rta->rta_type = MPTCP_PM_ATTR_TOKEN;
+		rta->rta_len = RTA_LENGTH(4);
+		memcpy(RTA_DATA(rta), &token, 4);
+		off += NLMSG_ALIGN(rta->rta_len);
+	}
+
+	/* remote addr/port */
+	if (rip) {
+		nest_start = off;
+		nest = (void *)(data + off);
+		nest->rta_type = NLA_F_NESTED | MPTCP_PM_ATTR_ADDR_REMOTE;
+		nest->rta_len = RTA_LENGTH(0);
+		off += NLMSG_ALIGN(nest->rta_len);
+
+		/* addr data */
+		rta = (void *)(data + off);
+		if (inet_pton(AF_INET, rip, RTA_DATA(rta))) {
+			family = AF_INET;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR4;
+			rta->rta_len = RTA_LENGTH(4);
+		} else if (inet_pton(AF_INET6, rip, RTA_DATA(rta))) {
+			family = AF_INET6;
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_ADDR6;
+			rta->rta_len = RTA_LENGTH(16);
+		} else {
+			error(1, errno, "can't parse ip %s", (char *)rip);
+		}
+		off += NLMSG_ALIGN(rta->rta_len);
+
+		/* family */
+		rta = (void *)(data + off);
+		rta->rta_type = MPTCP_PM_ADDR_ATTR_FAMILY;
+		rta->rta_len = RTA_LENGTH(2);
+		memcpy(RTA_DATA(rta), &family, 2);
+		off += NLMSG_ALIGN(rta->rta_len);
+
+		if (rport) {
+			rta = (void *)(data + off);
+			rta->rta_type = MPTCP_PM_ADDR_ATTR_PORT;
+			rta->rta_len = RTA_LENGTH(2);
+			memcpy(RTA_DATA(rta), &rport, 2);
+			off += NLMSG_ALIGN(rta->rta_len);
+		}
+
+		nest->rta_len = off - nest_start;
+	}
+
 	do_nl_req(fd, nh, off, 0);
 	return 0;
 }
diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 78d0bb640b11..abe3d4ebe554 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -770,10 +770,42 @@ test_subflows()
 	rm -f "$evts"
 }
 
+test_prio()
+{
+	local count
+
+	# Send MP_PRIO signal from client to server machine
+	ip netns exec "$ns2" ./pm_nl_ctl set 10.0.1.2 port "$client4_port" flags backup token "$client4_token" rip 10.0.1.1 rport "$server4_port"
+	sleep 0.5
+
+	# Check TX
+	stdbuf -o0 -e0 printf "MP_PRIO TX                                                 \t"
+	count=$(ip netns exec "$ns2" nstat -as | grep MPTcpExtMPPrioTx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ $count != 1 ]; then
+		stdbuf -o0 -e0 printf "[FAIL]\n"
+		exit 1
+	else
+		stdbuf -o0 -e0 printf "[OK]\n"
+	fi
+
+	# Check RX
+	stdbuf -o0 -e0 printf "MP_PRIO RX                                                 \t"
+	count=$(ip netns exec "$ns1" nstat -as | grep MPTcpExtMPPrioRx | awk '{print $2}')
+	[ -z "$count" ] && count=0
+	if [ $count != 1 ]; then
+		stdbuf -o0 -e0 printf "[FAIL]\n"
+		exit 1
+	else
+		stdbuf -o0 -e0 printf "[OK]\n"
+	fi
+}
+
 make_connection
 make_connection "v6"
 test_announce
 test_remove
 test_subflows
+test_prio
 
 exit 0
-- 
2.37.0

