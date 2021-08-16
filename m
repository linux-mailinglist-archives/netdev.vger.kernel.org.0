Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077CD3EDAAF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 18:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhHPQST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 12:18:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:19482 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhHPQSO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 12:18:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="215889356"
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="215889356"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 09:17:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,326,1620716400"; 
   d="scan'208";a="487523947"
Received: from amlin-018-053.igk.intel.com ([10.102.18.53])
  by fmsmga008.fm.intel.com with ESMTP; 16 Aug 2021 09:17:39 -0700
From:   Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
To:     linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, richardcochran@gmail.com,
        shuah@kernel.org, arkadiusz.kubalewski@intel.com, arnd@arndb.de,
        nikolay@nvidia.com, cong.wang@bytedance.com,
        colin.king@canonical.com, gustavoars@kernel.org
Subject: [RFC net-next 2/7] selftests/ptp: Add usage of PTP_DPLL_GETSTATE ioctl in testptp
Date:   Mon, 16 Aug 2021 18:07:12 +0200
Message-Id: <20210816160717.31285-3-arkadiusz.kubalewski@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow get Digital Phase Locked Loop state of ptp enabled device
through ptp related ioctl PTP_DPLL_GETSTATE.

Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
---
 tools/testing/selftests/ptp/testptp.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index f7911aaeb007..67de96cf0962 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -141,6 +141,7 @@ static void usage(char *progname)
 		" -S         set the system time from the ptp clock time\n"
 		" -t val     shift the ptp clock time by 'val' seconds\n"
 		" -T val     set the ptp clock time to 'val' seconds\n"
+		" -u         get list of available DPLLs and their state values"
 		" -z         test combinations of rising/falling external time stamp flags\n",
 		progname);
 }
@@ -156,6 +157,7 @@ int main(int argc, char *argv[])
 	struct timex tx;
 	struct ptp_clock_time *pct;
 	struct ptp_sys_offset *sysoff;
+	struct ptp_dpll_state *ds;
 
 	char *progname;
 	unsigned int i;
@@ -177,6 +179,7 @@ int main(int argc, char *argv[])
 	int pps = -1;
 	int seconds = 0;
 	int settime = 0;
+	int dpll_state = 0;
 
 	int64_t t1, t2, tp;
 	int64_t interval, offset;
@@ -186,7 +189,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:p:P:sSt:T:w:z"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:p:P:sSt:T:uw:z"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -242,6 +245,9 @@ int main(int argc, char *argv[])
 			settime = 3;
 			seconds = atoi(optarg);
 			break;
+		case 'u':
+			dpll_state = 1;
+			break;
 		case 'w':
 			pulsewidth = atoi(optarg);
 			break;
@@ -506,6 +512,25 @@ int main(int argc, char *argv[])
 		free(sysoff);
 	}
 
+	if (dpll_state) {
+		ds = calloc(1, sizeof(*ds));
+		if (!ds) {
+			perror("calloc");
+			return -1;
+		}
+
+		if (ioctl(fd, PTP_DPLL_GETSTATE, ds))
+			perror("PTP_DPLL_GETSTATE");
+		else
+			puts("get dpll state request okay");
+
+		printf("dpll state:\n");
+		for (i = 0; i < ds->dpll_num; i++)
+			printf("dpll id:%i state:%u\n", i, ds->state[i]);
+
+		free(ds);
+	}
+
 	close(fd);
 	return 0;
 }
-- 
2.24.0

