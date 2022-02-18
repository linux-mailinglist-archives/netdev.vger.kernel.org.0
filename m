Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A450E4BAFF2
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 04:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbiBRDDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 22:03:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbiBRDDg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 22:03:36 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9237F59A61
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 19:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645153401; x=1676689401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A4UCyKVS+ECivE7dWa84k+oB0wXq0H5Wl3tdPlE5ETM=;
  b=Hpf265KoG3jg1fRRmsZUjt23RB6QAKW5XiaFv25uvcFbVSZtH3QnHuxy
   7pwfMAXZB5S1Cr/brWKAZB+j1NQStId0bTi2/0/tXTWqSY+9G1fpvABnZ
   lJAbrx2lVPc/j/bVsJP615b32GYqUYbC6bTY0vxBPegiBkhTbXxxBFA4W
   5DM2Anjh6lWZbfuSAarhlT+kfZOqad3tsZOHMg7Z4cZiBb+O+f0XLZ0Uk
   MGYBAEH6Is/VhQKzmrEerqCBw+0II/m0e0FdMUGDBhW84CnWMJBknLiUW
   tsAnjXUHHkGVcr7Awt9v4Q9OKSzQNjqIuZoiHMQGO2zEkGKV7FN/Ft/Cw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="250794598"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="250794598"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:19 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="635431937"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.101.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:03:19 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 5/7] selftests: mptcp: join: create tmp files only if needed
Date:   Thu, 17 Feb 2022 19:03:09 -0800
Message-Id: <20220218030311.367536-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
References: <20220218030311.367536-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

These tmp files will only be created when a test will be launched.

This avoid 'dd' output when '-h' is used for example.

While at it, also avoid creating netns that will be removed when
starting the first test.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 37 ++++++++++++-------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index c6379093f38a..63340bb76920 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -17,6 +17,7 @@ capture=0
 checksum=0
 ip_mptcp=0
 do_all_tests=1
+init=0
 
 TEST_COUNT=0
 
@@ -38,7 +39,7 @@ CBPF_MPTCP_SUBOPTION_ADD_ADDR="14,
 			       6 0 0 65535,
 			       6 0 0 0"
 
-init()
+init_partial()
 {
 	capout=$(mktemp)
 
@@ -98,6 +99,21 @@ cleanup_partial()
 	done
 }
 
+init() {
+	init=1
+
+	sin=$(mktemp)
+	sout=$(mktemp)
+	cin=$(mktemp)
+	cinsent=$(mktemp)
+	cout=$(mktemp)
+
+	trap cleanup EXIT
+
+	make_file "$cin" "client" 1
+	make_file "$sin" "server" 1
+}
+
 cleanup()
 {
 	rm -f "$cin" "$cout" "$sinfail"
@@ -107,8 +123,13 @@ cleanup()
 
 reset()
 {
-	cleanup_partial
-	init
+	if [ "${init}" != "1" ]; then
+		init
+	else
+		cleanup_partial
+	fi
+
+	init_partial
 }
 
 reset_with_cookies()
@@ -2106,16 +2127,6 @@ usage()
 	exit ${ret}
 }
 
-sin=$(mktemp)
-sout=$(mktemp)
-cin=$(mktemp)
-cinsent=$(mktemp)
-cout=$(mktemp)
-init
-make_file "$cin" "client" 1
-make_file "$sin" "server" 1
-trap cleanup EXIT
-
 for arg in "$@"; do
 	# check for "capture/checksum" args before launching tests
 	if [[ "${arg}" =~ ^"-"[0-9a-zA-Z]*"c"[0-9a-zA-Z]*$ ]]; then
-- 
2.35.1

