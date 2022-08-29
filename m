Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7CE5A52A9
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbiH2RF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbiH2REw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:04:52 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B009C52C;
        Mon, 29 Aug 2022 10:04:26 -0700 (PDT)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MGcC10k08z67DRW;
        Tue, 30 Aug 2022 01:00:45 +0800 (CST)
Received: from lhrpeml500004.china.huawei.com (7.191.163.9) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 19:04:24 +0200
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 29 Aug 2022 18:04:23 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <hukeping@huawei.com>, <anton.sirazetdinov@huawei.com>
Subject: [PATCH v7 10/18] seltests/landlock: move helper function
Date:   Tue, 30 Aug 2022 01:03:53 +0800
Message-ID: <20220829170401.834298-11-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
References: <20220829170401.834298-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml100002.china.huawei.com (7.188.26.75) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit moves enforce_ruleset() helper function to common.h so that
to be used both by filesystem tests and network ones.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v6:
* None.

Changes since v5:
* Splits commit.
* Moves enforce_ruleset helper into common.h
* Formats code with clang-format-14.

---
 tools/testing/selftests/landlock/common.h  | 10 ++++++++++
 tools/testing/selftests/landlock/fs_test.c | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
index 7ba18eb23783..48870afb054b 100644
--- a/tools/testing/selftests/landlock/common.h
+++ b/tools/testing/selftests/landlock/common.h
@@ -187,3 +187,13 @@ clear_cap(struct __test_metadata *const _metadata, const cap_value_t caps)
 {
 	_effective_cap(_metadata, caps, CAP_CLEAR);
 }
+
+__attribute__((__unused__)) static void
+enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
+{
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
+	{
+		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
+	}
+}
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index debe2d9ea6cf..25a655891754 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -556,16 +556,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
 	return ruleset_fd;
 }

-static void enforce_ruleset(struct __test_metadata *const _metadata,
-			    const int ruleset_fd)
-{
-	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
-	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
-	{
-		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
-	}
-}
-
 TEST_F_FORK(layout1, proc_nsfs)
 {
 	const struct rule rules[] = {
--
2.25.1

