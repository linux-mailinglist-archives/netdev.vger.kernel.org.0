Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E09C2FE04D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 05:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733220AbhAUD4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 22:56:03 -0500
Received: from mail-m972.mail.163.com ([123.126.97.2]:57830 "EHLO
        mail-m972.mail.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729636AbhAUDAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:00:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=dqcHSmHAfDMQIlJJSN
        4wpg35l5Qu7xOOGot1v9uNrfM=; b=UgmHeHyANBrnjbaK385ZOUqyGsjLPTuKDn
        eWRvRXkJEfe8xSkV4O64KNYx2gH67NXhxRI3li7uZBRiRbySOG+9Hl0BQcQIg/yi
        35JhfhxgaCg6fiQ34Eehrp3bd5qKTffj+uX5udyRhnNkbwTLGZNhmTdUqgq1zg0y
        gWvY3oUYQ=
Received: from localhost.localdomain (unknown [119.3.119.20])
        by smtp2 (Coremail) with SMTP id GtxpCgCnEcw+4ghgGLEmJw--.3551S4;
        Thu, 21 Jan 2021 10:09:06 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH] bpf: put file handler if no storage found
Date:   Wed, 20 Jan 2021 18:08:56 -0800
Message-Id: <20210121020856.25507-1-bianpan2016@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: GtxpCgCnEcw+4ghgGLEmJw--.3551S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jry8KryxArWkKry5Cw4rXwb_yoWfZrb_XF
        WUX3yxKr4q9rZ7Xws8CaySq3s2yF4rKr1kC347KF4UG3Z8Z3s8JFnrAwnxZFyrtw4rKFZx
        JrZ3Zr95Gr15ZjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1BbytUUUUU==
X-Originating-IP: [119.3.119.20]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBUQIhclaD9tYxSgAAsO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Put file f if inode_storage_ptr() returns NULL.

Fixes: 8ea636848aca ("bpf: Implement bpf_local_storage for inodes")
Acked-by: KP Singh <kpsingh@kernel.org>
Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 kernel/bpf/bpf_inode_storage.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_inode_storage.c b/kernel/bpf/bpf_inode_storage.c
index 6edff97ad594..089d5071d4fc 100644
--- a/kernel/bpf/bpf_inode_storage.c
+++ b/kernel/bpf/bpf_inode_storage.c
@@ -125,8 +125,12 @@ static int bpf_fd_inode_storage_update_elem(struct bpf_map *map, void *key,
 
 	fd = *(int *)key;
 	f = fget_raw(fd);
-	if (!f || !inode_storage_ptr(f->f_inode))
+	if (!f)
+		return -EBADF;
+	if (!inode_storage_ptr(f->f_inode)) {
+		fput(f);
 		return -EBADF;
+	}
 
 	sdata = bpf_local_storage_update(f->f_inode,
 					 (struct bpf_local_storage_map *)map,
-- 
2.17.1

