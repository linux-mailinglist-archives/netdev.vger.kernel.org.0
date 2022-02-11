Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB334B2547
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349870AbiBKML4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:11:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiBKMLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:11:55 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483E8E56;
        Fri, 11 Feb 2022 04:11:54 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id a11-20020a17090a740b00b001b8b506c42fso11806321pjg.0;
        Fri, 11 Feb 2022 04:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m2skchjtqqaz0vHh+/kBDEndAfD/M3DESiF5Hc+r0Mg=;
        b=lR6ipYfxxb8rieq4SGfq8IX+R9/HsIzcwvra9pZsCqVQF1ZGjDRzoefkKr/7aYvlxq
         OP+qIPS17STIx0jaCzqoWaiDbK8cDQVdi4KlH+AfFtoqi/zUBhnodvrULNCKXvmWK5zg
         VOAtgFRZtL1yw2610Zwu2HTdT3soSnk8dbXG2OQ2N/N3XKfHJpR+580nONwsMfiOgcJo
         MSQPbML0ZvePdjsEqE+ldH4orGGjt9J1qyGM3hCBZzhi9SQVNhwOxNmIuiLLOovRcQav
         3bK0s2UwB1d5OhpIZCQTsfiuA6yyhIsHbNLNN0rxYd4JD4dePgv1Ouz5WBQmcqg5p8T3
         v0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m2skchjtqqaz0vHh+/kBDEndAfD/M3DESiF5Hc+r0Mg=;
        b=0EATR3/Q04OUM9t5/xNkmfS56lqtbJjW+IFtSw3ji/8+Pk9RBKjm5A34MXQoRAAEW9
         h9uJUDK5SIBCSV/iBUVc5ZXkXBSwItanePxuPN/PipeGbaYPzxhUwRRV+gXGw9ho4bch
         q1A02FlsGIaoMkjt945RScTBx1kKvwAhQ2vq9DIQl5BFGk9h7CMhAMnp3MvVVzSiaz3v
         dUB3gDAnWhsfhWc0e4aLjX4jjV9ouaO6J9X7mbgpr7qbfRXuBM6EQah6CGGsiVetdPUb
         SXNpift7NpQMPcndIbLILoLi60pDLUk+MpXttedtUyiTS9wvkqkZuHkNWA092waIsWoh
         JVkw==
X-Gm-Message-State: AOAM531XustaKQrg0n1AkjhryvFOf2gZFbnZei4G7wKPWO0XGPyWHIBE
        EFKGnqoSBMjIGNLIjQyNz14=
X-Google-Smtp-Source: ABdhPJw0XHPTjCT2TgTZLb3gwlG6kkiB4tfe4vm/HFxDLr7Xe9yJb28vX+rAqI6kmig55R9Y1xCquw==
X-Received: by 2002:a17:902:d88f:: with SMTP id b15mr1337446plz.44.1644581513878;
        Fri, 11 Feb 2022 04:11:53 -0800 (PST)
Received: from vultr.guest ([149.248.7.47])
        by smtp.gmail.com with ESMTPSA id il18sm5558913pjb.27.2022.02.11.04.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:11:53 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 1/4] bpf: Add pin_name into struct bpf_prog_aux
Date:   Fri, 11 Feb 2022 12:11:42 +0000
Message-Id: <20220211121145.35237-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220211121145.35237-1-laoar.shao@gmail.com>
References: <20220211121145.35237-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A new member pin_name is added into struct bpf_prog_aux, which will be
set when the prog is set and cleared when the pinned file is removed.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/bpf.h      |  2 ++
 include/uapi/linux/bpf.h |  1 +
 kernel/bpf/inode.c       | 20 +++++++++++++++++++-
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0ceb25b..9cf8055 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -933,6 +933,8 @@ struct bpf_prog_aux {
 		struct work_struct work;
 		struct rcu_head	rcu;
 	};
+
+	char pin_name[BPF_PIN_NAME_LEN];
 };
 
 struct bpf_array_aux {
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index c14fed8..bada5cc 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1217,6 +1217,7 @@ struct bpf_stack_build_id {
 };
 
 #define BPF_OBJ_NAME_LEN 16U
+#define BPF_PIN_NAME_LEN 64U
 
 union bpf_attr {
 	struct { /* anonymous struct used by BPF_MAP_CREATE command */
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4477ca8..f1a8811 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -437,6 +437,8 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
 static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 			  enum bpf_type type)
 {
+	struct bpf_prog_aux *aux;
+	struct bpf_prog *prog;
 	struct dentry *dentry;
 	struct inode *dir;
 	struct path path;
@@ -461,6 +463,10 @@ static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 
 	switch (type) {
 	case BPF_TYPE_PROG:
+		prog = raw;
+		aux = prog->aux;
+		(void) strncpy_from_user(aux->pin_name, pathname, BPF_PIN_NAME_LEN);
+		aux->pin_name[BPF_PIN_NAME_LEN - 1] = '\0';
 		ret = vfs_mkobj(dentry, mode, bpf_mkprog, raw);
 		break;
 	case BPF_TYPE_MAP:
@@ -611,12 +617,24 @@ static int bpf_show_options(struct seq_file *m, struct dentry *root)
 
 static void bpf_free_inode(struct inode *inode)
 {
+	struct bpf_prog_aux *aux;
+	struct bpf_prog *prog;
 	enum bpf_type type;
 
 	if (S_ISLNK(inode->i_mode))
 		kfree(inode->i_link);
-	if (!bpf_inode_type(inode, &type))
+	if (!bpf_inode_type(inode, &type)) {
+		switch (type) {
+		case BPF_TYPE_PROG:
+			prog = inode->i_private;
+			aux = prog->aux;
+			aux->pin_name[0] = '\0';
+			break;
+		default:
+			break;
+		}
 		bpf_any_put(inode->i_private, type);
+	}
 	free_inode_nonrcu(inode);
 }
 
-- 
1.8.3.1

