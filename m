Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8854B6C47
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 13:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiBOMmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 07:42:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237771AbiBOMlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 07:41:52 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0474C1400B;
        Tue, 15 Feb 2022 04:41:41 -0800 (PST)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jyggf2L8zz6803S;
        Tue, 15 Feb 2022 20:41:18 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 13:41:39 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <revest@chromium.org>
CC:     <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH v2 2/6] ima: Always return a file measurement in ima_file_hash()
Date:   Tue, 15 Feb 2022 13:40:38 +0100
Message-ID: <20220215124042.186506-3-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220215124042.186506-1-roberto.sassu@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__ima_inode_hash() checks if a digest has been already calculated by
looking for the integrity_iint_cache structure associated to the passed
inode.

Users of ima_file_hash() (e.g. eBPF) might be interested in obtaining the
information without having to setup an IMA policy so that the digest is
always available at the time they call this function.

Call ima_collect_measurement() in __ima_inode_hash(), if the file
descriptor is available (passed by ima_file_hash()), and store the file
measurement in a temporary integrity_iint_cache structure.

This change does not cause memory usage increase, due to using the
temporary integrity_iint_cache structure, and due to freeing the
ima_digest_data structure inside integrity_iint_cache before exiting from
__ima_inode_hash().

For compatibility reasons, the behavior of ima_inode_hash() remains
unchanged.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 security/integrity/ima/ima_main.c | 36 +++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 946ba8a12eab..3562a212a5ba 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -520,15 +520,27 @@ int ima_file_check(struct file *file, int mask)
 }
 EXPORT_SYMBOL_GPL(ima_file_check);
 
-static int __ima_inode_hash(struct inode *inode, char *buf, size_t buf_size)
+static int __ima_inode_hash(struct inode *inode, struct file *file, char *buf,
+			    size_t buf_size)
 {
-	struct integrity_iint_cache *iint;
-	int hash_algo;
+	struct integrity_iint_cache *iint = NULL, tmp_iint;
+	int rc, hash_algo;
 
-	if (!ima_policy_flag)
-		return -EOPNOTSUPP;
+	if (ima_policy_flag)
+		iint = integrity_iint_find(inode);
+
+	if (!iint && file) {
+		memset(&tmp_iint, 0, sizeof(tmp_iint));
+		tmp_iint.inode = inode;
+
+		rc = ima_collect_measurement(&tmp_iint, file, NULL, 0,
+					     ima_hash_algo, NULL);
+		if (rc < 0)
+			return -EOPNOTSUPP;
+
+		iint = &tmp_iint;
+	}
 
-	iint = integrity_iint_find(inode);
 	if (!iint)
 		return -EOPNOTSUPP;
 
@@ -552,12 +564,14 @@ static int __ima_inode_hash(struct inode *inode, char *buf, size_t buf_size)
 	hash_algo = iint->ima_hash->algo;
 	mutex_unlock(&iint->mutex);
 
+	if (iint == &tmp_iint)
+		kfree(iint->ima_hash);
+
 	return hash_algo;
 }
 
 /**
- * ima_file_hash - return the stored measurement if a file has been hashed and
- * is in the iint cache.
+ * ima_file_hash - return a measurement of the file
  * @file: pointer to the file
  * @buf: buffer in which to store the hash
  * @buf_size: length of the buffer
@@ -570,7 +584,7 @@ static int __ima_inode_hash(struct inode *inode, char *buf, size_t buf_size)
  * The file hash returned is based on the entire file, including the appended
  * signature.
  *
- * If IMA is disabled or if no measurement is available, return -EOPNOTSUPP.
+ * If the measurement cannot be performed, return -EOPNOTSUPP.
  * If the parameters are incorrect, return -EINVAL.
  */
 int ima_file_hash(struct file *file, char *buf, size_t buf_size)
@@ -578,7 +592,7 @@ int ima_file_hash(struct file *file, char *buf, size_t buf_size)
 	if (!file)
 		return -EINVAL;
 
-	return __ima_inode_hash(file_inode(file), buf, buf_size);
+	return __ima_inode_hash(file_inode(file), file, buf, buf_size);
 }
 EXPORT_SYMBOL_GPL(ima_file_hash);
 
@@ -605,7 +619,7 @@ int ima_inode_hash(struct inode *inode, char *buf, size_t buf_size)
 	if (!inode)
 		return -EINVAL;
 
-	return __ima_inode_hash(inode, buf, buf_size);
+	return __ima_inode_hash(inode, NULL, buf, buf_size);
 }
 EXPORT_SYMBOL_GPL(ima_inode_hash);
 
-- 
2.32.0

