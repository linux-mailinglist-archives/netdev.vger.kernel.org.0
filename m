Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362E52CF45C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgLDSw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:52:26 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55930 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgLDSw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:52:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4Ie35p085149;
        Fri, 4 Dec 2020 18:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=qKvf4lzEo5tNiBSD+ta9N0URRH+/apH1S2WO9655a9k=;
 b=mhrID1qX18m6dww1exE6wPNTGZ74zSHcGO0t/+YT+rn9U/dRLYsOsXsJhtC53PztlUk1
 YPM3WZVMFIHWGMRzLgb77YnvtF1uaViSucME3JudNON5lvgd850Kb4rReWCAdilSjm4h
 es/SygkHshlhUkGLMSgL2JAM5VA0z5U7PTBEoFfANPSVK/Op/+gqa8DQbb1hEDQucidG
 +hTNRe2QTy5Hkd31LEkrKGg+UND/cy+VHEjtkWtCPiSMUUaZK2SB3Ce9Bx0p1udD/tmY
 Jwdd7WmTiGSdqIN5eNg+eO4K9laOSEmTTrykweFq4sqQrRy70J/lNBovmuhqM1xzyk4o ug== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 353dyr4pry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 04 Dec 2020 18:50:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B4IaIgY044683;
        Fri, 4 Dec 2020 18:48:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540f3pntt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Dec 2020 18:48:56 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B4ImtZC006809;
        Fri, 4 Dec 2020 18:48:55 GMT
Received: from localhost.uk.oracle.com (/10.175.205.186)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Dec 2020 10:48:55 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, yhs@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        rostedt@goodmis.org, mingo@redhat.com, haoluo@google.com,
        jolsa@kernel.org, quentin@isovalent.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, shuah@kernel.org, lmb@cloudflare.com,
        linux-kselftest@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 1/3] bpf: eliminate btf_module_mutex as RCU synchronization can be used
Date:   Fri,  4 Dec 2020 18:48:34 +0000
Message-Id: <1607107716-14135-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
References: <1607107716-14135-1-git-send-email-alan.maguire@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=2 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9825 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=2 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012040106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_module_mutex is used when manipulating the BTF module list.
However we will wish to look up this list from BPF program context,
and such contexts can include interrupt state where we cannot sleep
due to a mutex_lock().  RCU usage here conforms quite closely
to the example in the system call auditing example in
Documentation/RCU/listRCU.rst ; and as such we can eliminate
the lock and use list_del_rcu()/call_rcu() on module removal,
and list_add_rcu() for module addition.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 kernel/bpf/btf.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 8d6bdb4..333f41c 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5758,13 +5758,13 @@ bool btf_id_set_contains(const struct btf_id_set *set, u32 id)
 #ifdef CONFIG_DEBUG_INFO_BTF_MODULES
 struct btf_module {
 	struct list_head list;
+	struct rcu_head	rcu;
 	struct module *module;
 	struct btf *btf;
 	struct bin_attribute *sysfs_attr;
 };
 
 static LIST_HEAD(btf_modules);
-static DEFINE_MUTEX(btf_module_mutex);
 
 static ssize_t
 btf_module_read(struct file *file, struct kobject *kobj,
@@ -5777,10 +5777,21 @@ struct btf_module {
 	return len;
 }
 
+static void btf_module_free(struct rcu_head *rcu)
+{
+	struct btf_module *btf_mod = container_of(rcu, struct btf_module, rcu);
+
+	if (btf_mod->sysfs_attr)
+		sysfs_remove_bin_file(btf_kobj, btf_mod->sysfs_attr);
+	btf_put(btf_mod->btf);
+	kfree(btf_mod->sysfs_attr);
+	kfree(btf_mod);
+}
+
 static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 			     void *module)
 {
-	struct btf_module *btf_mod, *tmp;
+	struct btf_module *btf_mod;
 	struct module *mod = module;
 	struct btf *btf;
 	int err = 0;
@@ -5811,11 +5822,9 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 			goto out;
 		}
 
-		mutex_lock(&btf_module_mutex);
 		btf_mod->module = module;
 		btf_mod->btf = btf;
-		list_add(&btf_mod->list, &btf_modules);
-		mutex_unlock(&btf_module_mutex);
+		list_add_rcu(&btf_mod->list, &btf_modules);
 
 		if (IS_ENABLED(CONFIG_SYSFS)) {
 			struct bin_attribute *attr;
@@ -5845,20 +5854,14 @@ static int btf_module_notify(struct notifier_block *nb, unsigned long op,
 
 		break;
 	case MODULE_STATE_GOING:
-		mutex_lock(&btf_module_mutex);
-		list_for_each_entry_safe(btf_mod, tmp, &btf_modules, list) {
+		list_for_each_entry(btf_mod, &btf_modules, list) {
 			if (btf_mod->module != module)
 				continue;
 
-			list_del(&btf_mod->list);
-			if (btf_mod->sysfs_attr)
-				sysfs_remove_bin_file(btf_kobj, btf_mod->sysfs_attr);
-			btf_put(btf_mod->btf);
-			kfree(btf_mod->sysfs_attr);
-			kfree(btf_mod);
+			list_del_rcu(&btf_mod->list);
+			call_rcu(&btf_mod->rcu, btf_module_free);
 			break;
 		}
-		mutex_unlock(&btf_module_mutex);
 		break;
 	}
 out:
-- 
1.8.3.1

