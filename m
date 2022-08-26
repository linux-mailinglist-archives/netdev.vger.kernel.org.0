Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7485A1D85
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 02:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244314AbiHZAGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 20:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244259AbiHZAG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 20:06:27 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8B8C7BA5;
        Thu, 25 Aug 2022 17:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661472382; x=1693008382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R5NdENqqVqvIQgv37zKNDKl+4KZdem8oyqI/ZyiO/bs=;
  b=vCKARESB8H5iPtQnVpyMUtNfuG10EWJgSolPip84o3nyahRyfjVVLalH
   y2cCnsv3Xa7U0nOdxuMVbzPSQ11+LgbDuf+OIUrtGICDLVfPl309WHmQo
   6m+pkkk3T7UM1fjSWEQpGjU7N4YbfCebtzMxPQLq736ezC9d+kpN2LmXU
   g=;
X-IronPort-AV: E=Sophos;i="5.93,264,1654560000"; 
   d="scan'208";a="234194079"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 00:06:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-02ee77e7.us-west-2.amazon.com (Postfix) with ESMTPS id A1CB044E48;
        Fri, 26 Aug 2022 00:06:07 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Fri, 26 Aug 2022 00:06:07 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.140) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Fri, 26 Aug 2022 00:06:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Layton <jlayton@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: [PATCH v1 net-next 02/13] sysctl: Support LOCK_MAND for read/write.
Date:   Thu, 25 Aug 2022 17:04:34 -0700
Message-ID: <20220826000445.46552-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220826000445.46552-1-kuniyu@amazon.com>
References: <20220826000445.46552-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D10UWB001.ant.amazon.com (10.43.161.111) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The preceding patch added LOCK_MAND support for flock(), and this patch
adds read/write protection on sysctl knobs.  The read/write operations
will return -EPERM if the file is mandatory-locked.

The following patches introduce sysctl knobs which are read in clone() or
unshare() to control a per-netns hash table size for TCP/UDP.  In such a
case, we can use write protection to guarantee the hash table's size for
the child netns.

The difference between BPF_PROG_TYPE_CGROUP_SYSCTL is that the BPF prog
requires processes to be in the same cgroup to allow/deny read/write to
sysctl knobs.

Note that the read protection might be useless, especially for some
sysctl knobs whose value we can know in another way.  For example, we
can know fs.nr_open by opening too many files and checking the error,
and net.ipv4.tcp_syn_retries by dropping SYN and dumping packets.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 fs/locks.c            | 26 ++++++++++++++++++++++++++
 fs/proc/proc_sysctl.c | 25 ++++++++++++++++++++++++-
 include/linux/fs.h    |  1 +
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 03ff10a3165e..c858c6c61920 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -890,6 +890,32 @@ static bool flock_locks_conflict(struct file_lock *caller_fl,
 	return locks_conflict(caller_fl, sys_fl);
 }
 
+int flock_mandatory_locked(struct file *filp)
+{
+	struct file_lock_context *ctx;
+	struct file_lock *fl;
+	int flags = 0;
+
+	ctx = smp_load_acquire(&file_inode(filp)->i_flctx);
+	if (!ctx)
+		goto out;
+
+	spin_lock(&ctx->flc_lock);
+	list_for_each_entry(fl, &ctx->flc_flock, fl_list) {
+		if (!(fl->fl_type & LOCK_MAND))
+			continue;
+
+		if (fl->fl_file != filp)
+			flags = fl->fl_type & (LOCK_MAND | LOCK_RW);
+
+		break;
+	}
+	spin_unlock(&ctx->flc_lock);
+out:
+	return flags;
+}
+EXPORT_SYMBOL(flock_mandatory_locked);
+
 void
 posix_test_lock(struct file *filp, struct file_lock *fl)
 {
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 021e83fe831f..ce2755670970 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -561,10 +561,30 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 	return err;
 }
 
+static bool proc_mandatory_locked(struct file *filp, int write)
+{
+	int flags = flock_mandatory_locked(filp);
+
+	if (flags & LOCK_MAND) {
+		if (write) {
+			if (flags & LOCK_WRITE)
+				return false;
+		} else {
+			if (flags & LOCK_READ)
+				return false;
+		}
+
+		return true;
+	}
+
+	return false;
+}
+
 static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
 		int write)
 {
-	struct inode *inode = file_inode(iocb->ki_filp);
+	struct file *filp = iocb->ki_filp;
+	struct inode *inode = file_inode(filp);
 	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
 	size_t count = iov_iter_count(iter);
@@ -582,6 +602,9 @@ static ssize_t proc_sys_call_handler(struct kiocb *iocb, struct iov_iter *iter,
 	if (sysctl_perm(head, table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
+	if (proc_mandatory_locked(filp, write))
+		goto out;
+
 	/* if that can happen at all, it should be -EINVAL, not -EISDIR */
 	error = -EINVAL;
 	if (!table->proc_handler)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9eced4cc286e..5d1d4b10a868 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1164,6 +1164,7 @@ extern void locks_copy_conflock(struct file_lock *, struct file_lock *);
 extern void locks_remove_posix(struct file *, fl_owner_t);
 extern void locks_remove_file(struct file *);
 extern void locks_release_private(struct file_lock *);
+int flock_mandatory_locked(struct file *filp);
 extern void posix_test_lock(struct file *, struct file_lock *);
 extern int posix_lock_file(struct file *, struct file_lock *, struct file_lock *);
 extern int locks_delete_block(struct file_lock *);
-- 
2.30.2

