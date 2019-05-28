Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919D92D0DF
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfE1VOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:14:50 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:45118 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727678AbfE1VOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:14:49 -0400
Received: by mail-yb1-f201.google.com with SMTP id y3so274069ybg.12
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 14:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lfVPYgVsrgTm5HSRXwm4saqwmib2k5XfcIamVFoAWPg=;
        b=C8j/uC562YqCi55VHT59ByRZkAxSo5IR6Z3rzVQVPtX4BC7HUn9UU0W5qpolUH5fbJ
         OkqvLu3P8utOWglvEPNJu6ZGeAoJRSluU1Q0FFge7NK3zs/kiWhSr+KfDCplXn/fiY3D
         xBzWWUhW9vTUKhxLdhzIjw2gSblPV/X/h/H9UgnW3iKeyXUlkRW5kabICW+ZuGEi9efU
         8O5gC4orU4q5wHfnKwqFZuGXQv8ygkLZSSUoCyNvBZDSQnqNmDkU/Gf/Zqb2cFf4HtHy
         /Rnmcu4sBsH1yfAHxh99+jfrmaWIDQBNUnoLdrjcKXgsDaA4vwNG76cpvUrBpKl/4ua1
         mhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lfVPYgVsrgTm5HSRXwm4saqwmib2k5XfcIamVFoAWPg=;
        b=Y9AmjBeX7fMbOq+OeZ9+xOxx4fUm667xT4dXZCNXrrqtqL+LWy4h5KOyH1Xh57sYVW
         ew1FSv36hzbBbe21HhekTb13CMIoA4/nfzr7rBh9/lj0aDzAzP/+LaAsBR7mYU+vMVgf
         VKgP/z40tW3JfJRmJFrqXjJtlW6PGP0M4V9qoRMo79Q/lm3eAoBE7ak1AGeMVJW2zus6
         QDZSMv3ADuXtnPWzl48adaNKBwwpeBpgeglTQlNX5ypiHRrU1GtemZbrevhi9LoYyGuE
         YVS5n0AkHGWKWiz1RDmSgkahq7GA3eI0pmbRuuk7mzRqzflXvoV9JQPQlpqk40DBzQH/
         n0/g==
X-Gm-Message-State: APjAAAXuaumYp3NZBxSLByk2tMIae9u9zA3jRhPofUgL2PYi+4fC5947
        m88UYK5O+nMrNxLxus5objRSodt66ny/T38dQx0MWZ4VsV+jMZIlx/XjoaMa5dgoQscXhyszplh
        +qwuYFNAAwlzIwNU0b7RnopN8bTa3TFOx9E7f5gMx4kBpMK9P8ZubTw==
X-Google-Smtp-Source: APXvYqxzYdLFOZwIy1nN8tZleymEzL+WmQw2RJTanZsJ+NNYdTUzAf2ZriGWw868VLx53XZC7OKKa4Q=
X-Received: by 2002:a81:4f8c:: with SMTP id d134mr59860912ywb.387.1559078089134;
 Tue, 28 May 2019 14:14:49 -0700 (PDT)
Date:   Tue, 28 May 2019 14:14:42 -0700
In-Reply-To: <20190528211444.166437-1-sdf@google.com>
Message-Id: <20190528211444.166437-2-sdf@google.com>
Mime-Version: 1.0
References: <20190528211444.166437-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH bpf-next v4 2/4] bpf: media: properly use bpf_prog_array api
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sean Young <sean@mess.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we don't have __rcu markers on the bpf_prog_array helpers,
let's use proper rcu_dereference_protected to obtain array pointer
under mutex.

Cc: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Sean Young <sean@mess.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/media/rc/bpf-lirc.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index ee657003c1a1..0a0ce620e4a2 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -8,6 +8,9 @@
 #include <linux/bpf_lirc.h>
 #include "rc-core-priv.h"
 
+#define lirc_rcu_dereference(p)						\
+	rcu_dereference_protected(p, lockdep_is_held(&ir_raw_handler_lock))
+
 /*
  * BPF interface for raw IR
  */
@@ -136,7 +139,7 @@ const struct bpf_verifier_ops lirc_mode2_verifier_ops = {
 
 static int lirc_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	struct ir_raw_event_ctrl *raw;
 	int ret;
@@ -154,12 +157,12 @@ static int lirc_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
 		goto unlock;
 	}
 
-	if (raw->progs && bpf_prog_array_length(raw->progs) >= BPF_MAX_PROGS) {
+	old_array = lirc_rcu_dereference(raw->progs);
+	if (old_array && bpf_prog_array_length(old_array) >= BPF_MAX_PROGS) {
 		ret = -E2BIG;
 		goto unlock;
 	}
 
-	old_array = raw->progs;
 	ret = bpf_prog_array_copy(old_array, NULL, prog, &new_array);
 	if (ret < 0)
 		goto unlock;
@@ -174,7 +177,7 @@ static int lirc_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
 
 static int lirc_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	struct ir_raw_event_ctrl *raw;
 	int ret;
@@ -192,7 +195,7 @@ static int lirc_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
 		goto unlock;
 	}
 
-	old_array = raw->progs;
+	old_array = lirc_rcu_dereference(raw->progs);
 	ret = bpf_prog_array_copy(old_array, prog, NULL, &new_array);
 	/*
 	 * Do not use bpf_prog_array_delete_safe() as we would end up
@@ -223,21 +226,22 @@ void lirc_bpf_run(struct rc_dev *rcdev, u32 sample)
 /*
  * This should be called once the rc thread has been stopped, so there can be
  * no concurrent bpf execution.
+ *
+ * Should be called with the ir_raw_handler_lock held.
  */
 void lirc_bpf_free(struct rc_dev *rcdev)
 {
 	struct bpf_prog_array_item *item;
+	struct bpf_prog_array *array;
 
-	if (!rcdev->raw->progs)
+	array = lirc_rcu_dereference(rcdev->raw->progs);
+	if (!array)
 		return;
 
-	item = rcu_dereference(rcdev->raw->progs)->items;
-	while (item->prog) {
+	for (item = array->items; item->prog; item++)
 		bpf_prog_put(item->prog);
-		item++;
-	}
 
-	bpf_prog_array_free(rcdev->raw->progs);
+	bpf_prog_array_free(array);
 }
 
 int lirc_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
@@ -290,7 +294,7 @@ int lirc_prog_detach(const union bpf_attr *attr)
 int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 {
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
-	struct bpf_prog_array __rcu *progs;
+	struct bpf_prog_array *progs;
 	struct rc_dev *rcdev;
 	u32 cnt, flags = 0;
 	int ret;
@@ -311,7 +315,7 @@ int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (ret)
 		goto put;
 
-	progs = rcdev->raw->progs;
+	progs = lirc_rcu_dereference(rcdev->raw->progs);
 	cnt = progs ? bpf_prog_array_length(progs) : 0;
 
 	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt))) {
-- 
2.22.0.rc1.257.g3120a18244-goog

