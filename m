Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9764A7D34
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348735AbiBCBD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:03:56 -0500
Received: from mga06.intel.com ([134.134.136.31]:6288 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235383AbiBCBDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 20:03:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643850230; x=1675386230;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fiZ8lVR6tJKIp1bjE+ooOoXrIV+2sSrB3mNK93hMjhE=;
  b=LFLD6w2sDxeiiGJW21q96Q+TxJbdoKRuD259D1/TwWyl+PUVc40KBr3w
   0era9KSYk7UI50zlFKCWWtc6Rh80N/rNndB1DoZj5/zvME3nyHy90/GCV
   L7FoK/Uc4umwMTMaSmiSBQRReVakrWUEfCNG4vWtnZwcPthqiaJjdzlwu
   v8LXHkhKLXTAwDPPWeiQqAWyh4l/XL0But0nBWv03Yzjd0xvzcjKdAD/X
   WLUtvHa6QUC1xaW22BJ0KUYNhdL+jW9zHSf/pBiZMjk5QlgI/lB/4s7e8
   D8I/0iWmFsZQxkGkJPihG+ZvxpI9ISXIaxsScNdtPK2OaOZRl2NgimKTB
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="308782834"
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="308782834"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
X-IronPort-AV: E=Sophos;i="5.88,338,1635231600"; 
   d="scan'208";a="483070834"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.1.6])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:03:49 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Geliang Tang <geliang.tang@suse.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/7] selftests: mptcp: set fullmesh flag in pm_nl_ctl
Date:   Wed,  2 Feb 2022 17:03:42 -0800
Message-Id: <20220203010343.113421-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
References: <20220203010343.113421-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch added the fullmesh flag setting and clearing support in
pm_nl_ctl:

 # pm_nl_ctl set ip flags fullmesh
 # pm_nl_ctl set ip flags nofullmesh

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/pm_nl_ctl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
index 354784512748..152b84e44d69 100644
--- a/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
+++ b/tools/testing/selftests/net/mptcp/pm_nl_ctl.c
@@ -28,7 +28,7 @@ static void syntax(char *argv[])
 	fprintf(stderr, "\tadd [flags signal|subflow|backup|fullmesh] [id <nr>] [dev <name>] <ip>\n");
 	fprintf(stderr, "\tdel <id> [<ip>]\n");
 	fprintf(stderr, "\tget <id>\n");
-	fprintf(stderr, "\tset <ip> [flags backup|nobackup]\n");
+	fprintf(stderr, "\tset <ip> [flags backup|nobackup|fullmesh|nofullmesh]\n");
 	fprintf(stderr, "\tflush\n");
 	fprintf(stderr, "\tdump\n");
 	fprintf(stderr, "\tlimits [<rcv addr max> <subflow max>]\n");
@@ -704,12 +704,14 @@ int set_flags(int fd, int pm_family, int argc, char *argv[])
 			if (++arg >= argc)
 				error(1, 0, " missing flags value");
 
-			/* do not support flag list yet */
 			for (str = argv[arg]; (tok = strtok(str, ","));
 			     str = NULL) {
 				if (!strcmp(tok, "backup"))
 					flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-				else if (strcmp(tok, "nobackup"))
+				else if (!strcmp(tok, "fullmesh"))
+					flags |= MPTCP_PM_ADDR_FLAG_FULLMESH;
+				else if (strcmp(tok, "nobackup") &&
+					 strcmp(tok, "nofullmesh"))
 					error(1, errno,
 					      "unknown flag %s", argv[arg]);
 			}
-- 
2.35.1

