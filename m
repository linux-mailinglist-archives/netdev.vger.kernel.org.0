Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E25B52CEAE
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfE1S3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:29:54 -0400
Received: from mail-oi1-f202.google.com ([209.85.167.202]:52608 "EHLO
        mail-oi1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728151AbfE1S3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:29:52 -0400
Received: by mail-oi1-f202.google.com with SMTP id j9so6702219oih.19
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 11:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lfVPYgVsrgTm5HSRXwm4saqwmib2k5XfcIamVFoAWPg=;
        b=bsnCWvydPDTWyFLpW3/zbC88qkCf051v0n/sK15ngfL7uZDNj2iVe7fCJM7B6ewdaP
         z50mWaIWAUekPnO4QKlJ2I+G3LHSKdqBB0oiIb4MLGeyFKiG3NAYIgJsejRcuwAbspdK
         9L3wEP7/9s0/rUVT13ACQaB/se2/phN+8HhdDccfnCNc8XNWf69kZDHu7Ou+9pVdGJrW
         oFNacl/jFcAJbMveDbJnxCJYQBO+EQUAQx3XwcYiJ+6ces6fhD93X2/wDwqCviyzaFQr
         YCayewCEXA96LjxdECJIhUsKgWVCsMeu9ervpqlWNJh+TuAg8X9b05NlJE1/LsY4jtIC
         vjaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lfVPYgVsrgTm5HSRXwm4saqwmib2k5XfcIamVFoAWPg=;
        b=plQHT3xtCDkSNr1e2PKOXuMwZRqp89YaNhjebW5WSignQOCI7+op+dc+2KdCdFbZ8/
         hjQ6xjbuLG39fNswDeVDXl51NTeH3qm6hKMjUpiYtxoh3SsD9kSqwajm4C7ejpVKjgxa
         cSXecKr/P+Ol6IlrpCzzBzqv3Joq6Hn+H5GpmSKO+ZWITq9Wx6N/sMZF8ICaP051TXO7
         ZY9cS1NCaKhZoj3QsthBxbLTU9mj/UBGgwpTDdQVwtnuooat8i4JdFUzaxnURVpnIgCW
         jyI/76LZJHj6BUXP2sqOPaXvCNK/6+SmKrPaBEsT1Lq5DDxdWPbzXoFacUhko98T6yx7
         sm+g==
X-Gm-Message-State: APjAAAW9nS0p1cULUzap6cAnkzMoWxQj09643+b3IqXf7ADEk0xIi1of
        USClF7GlpXRP2qEZcCt/XVFqmUJQXB597f8ETZ3nNbf5AfUuG61U9Wy/yPZkR0HO3oK2ZoFApzq
        4C/rgnWd7Yp6htrkR1/4BDkGxHcaaYU/SJltysurg9k6/2HurEIWlQw==
X-Google-Smtp-Source: APXvYqybmb7CtYZcZ7uZMCRDD2BKcgJ5fu7zv/g35JgmErtJ6JzPhNaPtkZd+sUPQbGgHy/Z5hBPC1k=
X-Received: by 2002:a9d:661:: with SMTP id 88mr35748119otn.214.1559068191802;
 Tue, 28 May 2019 11:29:51 -0700 (PDT)
Date:   Tue, 28 May 2019 11:29:44 -0700
In-Reply-To: <20190528182946.3633-1-sdf@google.com>
Message-Id: <20190528182946.3633-2-sdf@google.com>
Mime-Version: 1.0
References: <20190528182946.3633-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH bpf-next v3 2/4] bpf: media: properly use bpf_prog_array api
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

