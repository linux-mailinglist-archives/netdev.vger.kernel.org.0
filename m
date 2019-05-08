Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA7BF17EF9
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 19:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728919AbfEHRSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 13:18:55 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:35527 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbfEHRSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 13:18:54 -0400
Received: by mail-qt1-f202.google.com with SMTP id u21so23922766qtk.2
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 10:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dBVF9tqLXphyriby2Sali7IJHS+SaCg6nJ2FY2lFxPo=;
        b=pANr7Ap0bi82ywW+IsBk6pG6XmeRA3aCL68H2DnzN+AKtyjvd7LsrJs7hy8JdHGnhU
         Bl8NMnwZoWlVOigv4u3XWznJ1JmeWFf39CuMEVJQbMhL94Gfh8nXH3B3pZB8b9wCd5u3
         m8MdHX9C0varGlzBwzKIRstmEz6nr1XrWnkzd8D275SKuhQiGwRZur1kq6BLlluG/Egf
         Uxvwd9tS0JTuKxpNAiPg9CE/tf//Pwjegj2zI+QWlwu/jtnTVGByoqOgGL6RQ28DV9pl
         LDRmQKLs6GUcVSaWcmv1Ia39qEq4Lrbj92sqFZ+5euvQ0q3Qa+jh8NggfKFfdVa0diTs
         MwRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dBVF9tqLXphyriby2Sali7IJHS+SaCg6nJ2FY2lFxPo=;
        b=fFNv5BSvq7nF0zG+KAFejrRP0z0wKZ+mztTk6z29HoYDQ1sA8niZa5UCA9TregU5/d
         K/preNofzFPW9NusNmr+cEwau99OR0TQ2WywCMGdWK1DlkC78Yc4sbixcmoxTruYW9VP
         AxTG/U9VhnsJCaC8XI5BhMdiGq5BaoyoWdKLQA9kdV6LF+yu8/zczQA4KMnqgNDXriGy
         cRd86LXEyf+dd7KkDM/VrM/mJh2Xj09K8NZqD5yD/zw2Ynu1Qd6YZU0ZD6yWejAQuVzt
         EMnvEsbRAnHXVRxwzEMJ3PgFY9woU7jyrid0hR0WD831Es1lSqocS7LAn3GIjsXqFhiY
         DMlw==
X-Gm-Message-State: APjAAAVF34A56XDth2jW1HO9m6xTZwGzLUYhNfpSLSrA76SLGFPH1qqe
        HNLnQ90m4I7bot/36d48Nn3PE3TboeaQacergT1P2GuHRrCXnaIijwWcdlz3ziSD8xUJKuum87N
        puM/csaVLsV3isIUmu0b5XVVESCEs9qCOm55+dAjMlAYuFRzI5gFk/g==
X-Google-Smtp-Source: APXvYqxR4fl9jIla2OhmLIzaZ6+WE2iEANBaN6rxOlayRJlxxKof7suMNC0Z0moEAiBEdZucFt7h+zI=
X-Received: by 2002:a37:884:: with SMTP id 126mr1997936qki.67.1557335933118;
 Wed, 08 May 2019 10:18:53 -0700 (PDT)
Date:   Wed,  8 May 2019 10:18:43 -0700
In-Reply-To: <20190508171845.201303-1-sdf@google.com>
Message-Id: <20190508171845.201303-3-sdf@google.com>
Mime-Version: 1.0
References: <20190508171845.201303-1-sdf@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH bpf 2/4] bpf: media: properly use bpf_prog_array api
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        linux-media@vger.kernel.org, Sean Young <sean@mess.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we don't have __rcu markers on the bpf_prog_array helpers,
let's use proper rcu_dereference_protected to obtain array pointer
under mutex.

Cc: linux-media@vger.kernel.org
Cc: Sean Young <sean@mess.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/media/rc/bpf-lirc.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/media/rc/bpf-lirc.c b/drivers/media/rc/bpf-lirc.c
index 390a722e6211..38d4c01174fc 100644
--- a/drivers/media/rc/bpf-lirc.c
+++ b/drivers/media/rc/bpf-lirc.c
@@ -8,6 +8,9 @@
 #include <linux/bpf_lirc.h>
 #include "rc-core-priv.h"
 
+#define lirc_dereference(p)						\
+	rcu_dereference_protected(p, lockdep_is_held(&ir_raw_handler_lock))
+
 /*
  * BPF interface for raw IR
  */
@@ -130,7 +133,7 @@ const struct bpf_verifier_ops lirc_mode2_verifier_ops = {
 
 static int lirc_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	struct ir_raw_event_ctrl *raw;
 	int ret;
@@ -148,12 +151,12 @@ static int lirc_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
 		goto unlock;
 	}
 
-	if (raw->progs && bpf_prog_array_length(raw->progs) >= BPF_MAX_PROGS) {
+	old_array = lirc_dereference(raw->progs);
+	if (old_array && bpf_prog_array_length(old_array) >= BPF_MAX_PROGS) {
 		ret = -E2BIG;
 		goto unlock;
 	}
 
-	old_array = raw->progs;
 	ret = bpf_prog_array_copy(old_array, NULL, prog, &new_array);
 	if (ret < 0)
 		goto unlock;
@@ -168,7 +171,7 @@ static int lirc_bpf_attach(struct rc_dev *rcdev, struct bpf_prog *prog)
 
 static int lirc_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
 {
-	struct bpf_prog_array __rcu *old_array;
+	struct bpf_prog_array *old_array;
 	struct bpf_prog_array *new_array;
 	struct ir_raw_event_ctrl *raw;
 	int ret;
@@ -186,7 +189,7 @@ static int lirc_bpf_detach(struct rc_dev *rcdev, struct bpf_prog *prog)
 		goto unlock;
 	}
 
-	old_array = raw->progs;
+	old_array = lirc_dereference(raw->progs);
 	ret = bpf_prog_array_copy(old_array, prog, NULL, &new_array);
 	/*
 	 * Do not use bpf_prog_array_delete_safe() as we would end up
@@ -217,21 +220,25 @@ void lirc_bpf_run(struct rc_dev *rcdev, u32 sample)
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
+	array = lirc_dereference(rcdev->raw->progs);
+	if (!array)
 		return;
 
-	item = rcu_dereference(rcdev->raw->progs)->items;
+	item = array->items;
 	while (item->prog) {
 		bpf_prog_put(item->prog);
 		item++;
 	}
 
-	bpf_prog_array_free(rcdev->raw->progs);
+	bpf_prog_array_free(array);
 }
 
 int lirc_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
@@ -284,7 +291,7 @@ int lirc_prog_detach(const union bpf_attr *attr)
 int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 {
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
-	struct bpf_prog_array __rcu *progs;
+	struct bpf_prog_array *progs;
 	struct rc_dev *rcdev;
 	u32 cnt, flags = 0;
 	int ret;
@@ -305,7 +312,7 @@ int lirc_prog_query(const union bpf_attr *attr, union bpf_attr __user *uattr)
 	if (ret)
 		goto put;
 
-	progs = rcdev->raw->progs;
+	progs = lirc_dereference(rcdev->raw->progs);
 	cnt = progs ? bpf_prog_array_length(progs) : 0;
 
 	if (copy_to_user(&uattr->query.prog_cnt, &cnt, sizeof(cnt))) {
-- 
2.21.0.1020.gf2820cf01a-goog

