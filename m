Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C478141FD3
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 20:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbgASTk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 14:40:58 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:35453 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728682AbgASTk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 14:40:58 -0500
Received: by mail-pj1-f73.google.com with SMTP id l8so9149123pje.0
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 11:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=GYu7/zxMNd86d8ZFJUTXCcQyLaKeKY/49TH/Y+j6Gqg=;
        b=QlOdTQSL0z+vkc6smWiyAQv9TSrlVmSbT/+AQt+zaKA98cZi+qyrt0DbZ0Xs7MFC20
         5aamMs9qMUFIv4nItetzHFmLGTOon1t7k/NHKm/1WDKitaeMEIBoRwXp/gbkCHU/iqrr
         GQRhGd+/iL+Rj4LFLSMeHGRb6GINCcrUFdWgfK2CJgIZk8C2B8kWld7dCCpbzHjeJRD5
         +Z/Hz23oeNBgx79zWK2FGFUjAj4Jue7OPGOw8u7g4AHGoHZxvk+YO2X9LQAbGhqtOK+F
         Wv4BH83ZnfubP878cLqqML9UPDyyFiXnac8MW1chjhuLxiIgB4Y+BWtjdr798IKXSmGq
         vppQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=GYu7/zxMNd86d8ZFJUTXCcQyLaKeKY/49TH/Y+j6Gqg=;
        b=MMJVDz6fsEMCplV2OHOR9os0OwmKsVa+Hrgu/V6uQd4oMZCKBwULDpiQs9tym5DL/z
         9tApA8XI90JJTPXkUjbkjeMMHQki90YYNzPleREZoS5wW3V0AElXWRlGvdaXT/5keNcG
         XqAH77yr/9McYaWxQktPRc8Eoqav1Ud6FjuB9Hzb4Ckzx3GppmtQWHK+eNDyaRULRV7k
         2EnpDw6Cand4EykhmIfLXBCK0lycIIJxkwtEUdnU0sLZfWdd3lS7svkbr3KpAv4Jtfvh
         mrndw/QHW5U/j2pJmNzyOnA+tdyxbRdP/x1R9FkkSidiAO6O3c7xmVsMwUnjaN4ZX7fl
         h85g==
X-Gm-Message-State: APjAAAU/E7Uf6GQjQuqBsO7QTFwscHkIhNeQoKcRgnw2rKKOjTnEIPC7
        Yhh14eGxI3dp/QPdsJSUM2kAVIRZ/N+h
X-Google-Smtp-Source: APXvYqxuXDpCo3mn2kxa6NMICU35MJWDGVxXH9/az/hajnPP/dt1PwbFij25BEGseYexTQgSbHlar3gYhHgz
X-Received: by 2002:a63:7311:: with SMTP id o17mr53720220pgc.29.1579462857433;
 Sun, 19 Jan 2020 11:40:57 -0800 (PST)
Date:   Sun, 19 Jan 2020 11:40:40 -0800
Message-Id: <20200119194040.128369-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v2 bpf-next] bpf: Fix memory leaks in generic update/delete
 batch ops
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

generic update/delete batch ops functions were using __bpf_copy_key
without properly freeing the memory. Handle the memory allocation and
copy_from_user separately.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: aa2e93b8e58e ("bpf: Add generic support for update and delete batch ops")
Signed-off-by: Brian Vazquez <brianvv@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
v1->v2:
 - Put Fixes subject in a single line (Yonghong Song)
---
 kernel/bpf/syscall.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index c26a71460f02f..9a840c57f6df7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1239,12 +1239,15 @@ int generic_map_delete_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	key = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	if (!key)
+		return -ENOMEM;
+
 	for (cp = 0; cp < max_count; cp++) {
-		key = __bpf_copy_key(keys + cp * map->key_size, map->key_size);
-		if (IS_ERR(key)) {
-			err = PTR_ERR(key);
+		err = -EFAULT;
+		if (copy_from_user(key, keys + cp * map->key_size,
+				   map->key_size))
 			break;
-		}
 
 		if (bpf_map_is_dev_bound(map)) {
 			err = bpf_map_offload_delete_elem(map, key);
@@ -1264,6 +1267,8 @@ int generic_map_delete_batch(struct bpf_map *map,
 	}
 	if (copy_to_user(&uattr->batch.count, &cp, sizeof(cp)))
 		err = -EFAULT;
+
+	kfree(key);
 	return err;
 }
 
@@ -1294,18 +1299,21 @@ int generic_map_update_batch(struct bpf_map *map,
 	if (!max_count)
 		return 0;
 
+	key = kmalloc(map->key_size, GFP_USER | __GFP_NOWARN);
+	if (!key)
+		return -ENOMEM;
+
 	value = kmalloc(value_size, GFP_USER | __GFP_NOWARN);
-	if (!value)
+	if (!value) {
+		kfree(key);
 		return -ENOMEM;
+	}
 
 	for (cp = 0; cp < max_count; cp++) {
-		key = __bpf_copy_key(keys + cp * map->key_size, map->key_size);
-		if (IS_ERR(key)) {
-			err = PTR_ERR(key);
-			break;
-		}
 		err = -EFAULT;
-		if (copy_from_user(value, values + cp * value_size, value_size))
+		if (copy_from_user(key, keys + cp * map->key_size,
+		    map->key_size) ||
+		    copy_from_user(value, values + cp * value_size, value_size))
 			break;
 
 		err = bpf_map_update_value(map, f, key, value,
-- 
2.25.0.341.g760bfbb309-goog

