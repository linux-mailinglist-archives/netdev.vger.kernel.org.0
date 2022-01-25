Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB86D49AA48
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385073AbiAYDgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:36:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415548AbiAYBrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 20:47:32 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C5AC0617A3
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 16:38:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f12-20020a056902038c00b006116df1190aso38199275ybs.20
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 16:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AE42NXyGuF++OsviAYaBM/aTmpTPsKa7gHXSQEZykMk=;
        b=epqnPUKasiEtVVChbxwzoIKZvsEye6JpyuSU3+3TTjN6k+SwW/3ePaZzTsoMMIKl7a
         smbzhVEuKtL+O7FpT8UhKnSYwfd2IOxl5sQYEMIdtPqj7GR6EETLVOzJ+id/rbL5cfpX
         +0PWD4TSsL5dXEXsG2q/jLVwx6WbZ6UawAQzhFOekBDUfUEl93AexIEJPqkfeZi/a168
         tYGCif8PANqr6Tjf/cYay9ZjfFjeKDzh7mvGHozh6UEHXYGV5bvrZgj9FqXd2n+RvH48
         xqeiQzjWSnO0tD2GpNkb+bUYmxSBXLfZjJB/bu6GeeR/R6Jz69TU9+2Cn1xUj1BmTMnf
         XlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AE42NXyGuF++OsviAYaBM/aTmpTPsKa7gHXSQEZykMk=;
        b=x3CnZ48IBAQjVD9CBzI6LxuArwc/k87w3EPoKxQvug8NGdPR1P0xfQd/+bEOHrsQdw
         NW6HqVxJ2jCSgs4BvaB1q0ruq6T7ZBBCFbhq1I9sgOqJEmFk2pnle2BbmeP8iD6cDWhr
         1Kj+n5L10djb4qMzfAgliPCWcEVWRwLS4NAJVIs88MQ0snnfKHnjWoHvWALl80KeE9rB
         YPvUreIducnJ6DzEh4u2l2Us49S4iivLR6By77m/BDkxHdnsvDkb5aF24wEZHfl+gxnE
         KeXDwTMBNI4rprJBvsJ/ryqH7hiyfIpolzJMeoFl+m/47JRdHLHgcIBqxvtoNxtVZls5
         fvOQ==
X-Gm-Message-State: AOAM533D+g3tNa51OU/LjG1OMQ1B3rMadrIHu3+lnJDC/U3lcfr5ST8o
        qCaWO6XJsXbUwI1gv1+61dHmzUHd7YjzCO3X5bEtwe7e/nbroo/b71/ZTf8G/XGDGNejE3yLvlo
        pSyRj9rGWPST371PfyQWMkCt5YMtj4v55jQ2pIA2qmjbzvPd78to8aw==
X-Google-Smtp-Source: ABdhPJygJaFOA7hjd6Q/A1ZwXd9SVSFn5POPN1pc7ztOjwG/0r9GVBFJUKADFz0f7LuhzSjy+h+j+XA=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:2b4e:2e9:6635:b685])
 (user=sdf job=sendgmr) by 2002:a0d:d701:0:b0:2ca:287c:6bb4 with SMTP id
 00721157ae682-2ca287c6e03mr2441197b3.89.1643071128462; Mon, 24 Jan 2022
 16:38:48 -0800 (PST)
Date:   Mon, 24 Jan 2022 16:38:45 -0800
Message-Id: <20220125003845.2857801-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH bpf-next] bpf: fix register_btf_kfunc_id_set for !CONFIG_DEBUG_INFO_BTF
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
breaks loading of some modules when CONFIG_DEBUG_INFO_BTF is not set.
register_btf_kfunc_id_set returns -ENOENT to the callers when
there is no module btf. Let's return 0 (success) instead to let
those modules work in !CONFIG_DEBUG_INFO_BTF cases.

Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Fixes: dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 57f5fd5af2f9..24205c2d4f7e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6741,7 +6741,7 @@ int register_btf_kfunc_id_set(enum bpf_prog_type prog_type,
 
 	btf = btf_get_module_btf(kset->owner);
 	if (IS_ERR_OR_NULL(btf))
-		return btf ? PTR_ERR(btf) : -ENOENT;
+		return btf ? PTR_ERR(btf) : 0;
 
 	hook = bpf_prog_type_to_kfunc_hook(prog_type);
 	ret = btf_populate_kfunc_set(btf, hook, kset);
-- 
2.35.0.rc0.227.g00780c9af4-goog

