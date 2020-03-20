Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB8F818D983
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbgCTUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:36:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61954 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727403AbgCTUgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:36:36 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KKNYJC021758
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=jBOZTxxyHXc9C3gt33ohnDX1FUpNLP+SITQ4TEpB8io=;
 b=EQxRSEUQGMLpGlM7osozrK+UzTsGpKf8eDJo0sH6d0oT+df7WBRwTU/e/xWZwKkCoqCt
 QPql3CGe1rv21kTNTkge+iPIKrw9vzoMhPO3PUQPs5+2kaVquVwp2qUaVCpXmSSP4mrc
 H2v5sjsdIfBALjkGAO9RHdIeEfUJYPJGNX4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yua0x7xma-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:35 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 13:36:33 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 445BA2EC2E57; Fri, 20 Mar 2020 13:36:28 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/6] bpf: implement bpf_prog replacement for an active bpf_cgroup_link
Date:   Fri, 20 Mar 2020 13:36:12 -0700
Message-ID: <20200320203615.1519013-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320203615.1519013-1-andriin@fb.com>
References: <20200320203615.1519013-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_07:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 spamscore=0 clxscore=1015
 suspectscore=8 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200081
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new operation (LINK_UPDATE), which allows to replace active bpf_prog from
under given bpf_link. Currently this is only supported for bpf_cgroup_link,
but will be extended to other kinds of bpf_links in follow-up patches.

For bpf_cgroup_link, implemented functionality matches existing semantics for
direct bpf_prog attachment (including BPF_F_REPLACE flag). User can either
unconditionally set new bpf_prog regardless of which bpf_prog is currently
active under given bpf_link, or, optionally, can specify expected active
bpf_prog. If active bpf_prog doesn't match expected one, operation is a noop
and returns a failure.

cgroup_bpf_replace() operation is resolving race between auto-detachment and
bpf_prog update in the same fashion as it's done for bpf_link detachment,
except in this case update has no way of succeeding because of target cgroup
marked as dying. So in this case error is returned.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf-cgroup.h |  4 ++
 include/uapi/linux/bpf.h   | 12 ++++++
 kernel/bpf/cgroup.c        | 77 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/syscall.c       | 60 +++++++++++++++++++++++++++++
 kernel/cgroup/cgroup.c     | 21 +++++++++++
 5 files changed, 174 insertions(+)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index ab95824a1d99..5735d8bfd69e 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -98,6 +98,8 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 			struct bpf_cgroup_link *link,
 			enum bpf_attach_type type);
+int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
+			 struct bpf_prog *new_prog);
 int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		       union bpf_attr __user *uattr);
 
@@ -108,6 +110,8 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
 		      u32 flags);
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		      enum bpf_attach_type type);
+int cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
+		       struct bpf_prog *old_prog, struct bpf_prog *new_prog);
 int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 		     union bpf_attr __user *uattr);
 
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index fad9f79bb8f1..fa944093f9fc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -112,6 +112,7 @@ enum bpf_cmd {
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
+	BPF_LINK_UPDATE,
 };
 
 enum bpf_map_type {
@@ -574,6 +575,17 @@ union bpf_attr {
 		__u32		target_fd;	/* object to attach to */
 		__u32		attach_type;	/* attach type */
 	} link_create;
+
+	struct { /* struct used by BPF_LINK_UPDATE command */
+		__u32		link_fd;	/* link fd */
+		/* new program fd to update link with */
+		__u32		new_prog_fd;
+		__u32		flags;		/* extra flags */
+		/* expected link's program fd; is specified only if
+		 * BPF_F_REPLACE flag is set in flags */
+		__u32		old_prog_fd;
+	} link_update;
+
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index b960e8633f23..b9f4971336f3 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -501,6 +501,83 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 	return err;
 }
 
+/* Swap updated BPF program for given link in effective program arrays across
+ * all descendant cgroups. This function is guaranteed to succeed.
+ */
+static void replace_effective_prog(struct cgroup *cgrp,
+				   enum bpf_attach_type type,
+				   struct bpf_cgroup_link *link)
+{
+	struct bpf_prog_array_item *item;
+	struct cgroup_subsys_state *css;
+	struct bpf_prog_array *progs;
+	struct bpf_prog_list *pl;
+	struct list_head *head;
+	struct cgroup *cg;
+	int pos;
+
+	css_for_each_descendant_pre(css, &cgrp->self) {
+		struct cgroup *desc = container_of(css, struct cgroup, self);
+
+		if (percpu_ref_is_zero(&desc->bpf.refcnt))
+			continue;
+
+		/* found position of link in effective progs array */
+		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
+			if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_MULTI))
+				continue;
+
+			head = &cg->bpf.progs[type];
+			list_for_each_entry(pl, head, node) {
+				if (!prog_list_prog(pl))
+					continue;
+				if (pl->link == link)
+					goto found;
+				pos++;
+			}
+		}
+found:
+		BUG_ON(!cg);
+		progs = rcu_dereference_protected(
+				desc->bpf.effective[type],
+				lockdep_is_held(&cgroup_mutex));
+		item = &progs->items[pos];
+		WRITE_ONCE(item->prog, link->link.prog);
+	}
+}
+
+/**
+ * __cgroup_bpf_replace() - Replace link's program and propagate the change
+ *                          to descendants
+ * @cgrp: The cgroup which descendants to traverse
+ * @link: A link for which to replace BPF program
+ * @type: Type of attach operation
+ *
+ * Must be called with cgroup_mutex held.
+ */
+int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
+			 struct bpf_prog *new_prog)
+{
+	struct list_head *progs = &cgrp->bpf.progs[link->type];
+	struct bpf_prog *old_prog;
+	struct bpf_prog_list *pl;
+	bool found = false;
+
+	list_for_each_entry(pl, progs, node) {
+		if (pl->link == link) {
+			found = true;
+			break;
+		}
+	}
+	if (!found)
+		return -ENOENT;
+
+	old_prog = xchg(&link->link.prog, new_prog);
+	replace_effective_prog(cgrp, link->type, link);
+	bpf_prog_put(old_prog);
+	return 0;
+}
+
 static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
 					       struct bpf_prog *prog,
 					       struct bpf_cgroup_link *link,
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index f6e7d32a2632..1ff7aaa2c727 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3572,6 +3572,63 @@ static int link_create(union bpf_attr *attr)
 	return ret;
 }
 
+#define BPF_LINK_UPDATE_LAST_FIELD link_update.old_prog_fd
+
+static int link_update(union bpf_attr *attr)
+{
+	struct bpf_prog *old_prog = NULL, *new_prog;
+	enum bpf_prog_type ptype;
+	struct bpf_link *link;
+	u32 flags;
+	int ret;
+
+	if (CHECK_ATTR(BPF_LINK_UPDATE))
+		return -EINVAL;
+
+	flags = attr->link_update.flags;
+	if (flags & ~BPF_F_REPLACE)
+		return -EINVAL;
+
+	link = bpf_link_get_from_fd(attr->link_update.link_fd);
+	if (IS_ERR(link))
+		return PTR_ERR(link);
+
+	new_prog = bpf_prog_get(attr->link_update.new_prog_fd);
+	if (IS_ERR(new_prog))
+		return PTR_ERR(new_prog);
+
+	if (flags & BPF_F_REPLACE) {
+		old_prog = bpf_prog_get(attr->link_update.old_prog_fd);
+		if (IS_ERR(old_prog)) {
+			ret = PTR_ERR(old_prog);
+			old_prog = NULL;
+			goto out_put_progs;
+		}
+	}
+
+	if (link->ops == &bpf_cgroup_link_lops) {
+		struct bpf_cgroup_link *cg_link;
+
+		cg_link = container_of(link, struct bpf_cgroup_link, link);
+		ptype = attach_type_to_prog_type(cg_link->type);
+		if (ptype != new_prog->type) {
+			ret = -EINVAL;
+			goto out_put_progs;
+		}
+		ret = cgroup_bpf_replace(cg_link->cgroup, cg_link,
+					 old_prog, new_prog);
+	} else {
+		ret = -EINVAL;
+	}
+
+out_put_progs:
+	if (old_prog)
+		bpf_prog_put(old_prog);
+	if (ret)
+		bpf_prog_put(new_prog);
+	return ret;
+}
+
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
 	union bpf_attr attr = {};
@@ -3685,6 +3742,9 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
 	case BPF_LINK_CREATE:
 		err = link_create(&attr);
 		break;
+	case BPF_LINK_UPDATE:
+		err = link_update(&attr);
+		break;
 	default:
 		err = -EINVAL;
 		break;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 219624fba9ba..d4787fccf183 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6317,6 +6317,27 @@ int cgroup_bpf_attach(struct cgroup *cgrp,
 	return ret;
 }
 
+int cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
+		       struct bpf_prog *old_prog, struct bpf_prog *new_prog)
+{
+	int ret;
+
+	mutex_lock(&cgroup_mutex);
+	/* link might have been auto-released by dying cgroup, so fail */
+	if (!link->cgroup) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+	if (old_prog && link->link.prog != old_prog) {
+		ret = -EPERM;
+		goto out_unlock;
+	}
+	ret = __cgroup_bpf_replace(cgrp, link, new_prog);
+out_unlock:
+	mutex_unlock(&cgroup_mutex);
+	return ret;
+}
+
 int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 		      enum bpf_attach_type type)
 {
-- 
2.17.1

