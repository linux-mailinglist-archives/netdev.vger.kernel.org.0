Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD82721E4A3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgGNAmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgGNAm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:42:29 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7836C061755;
        Mon, 13 Jul 2020 17:42:29 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h18so6734726qvl.3;
        Mon, 13 Jul 2020 17:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KdIW5He8ZiiCiJCefvMCxWAQ162LKqrQoM487o/uJO8=;
        b=kXA12gfh+GeMEU0kaSoQ15nqyvzVsppDR7KTdVpxyShQ4ztvA5r9mmzlEhnBgw6JM0
         M00ZaD5scYu/PTcWMxJ3kv0hZ/2XO78OrGxpYpb3jhWXgfQbUTnqRwqFOIsDr+j2pAqZ
         VG8Q0fRmq8eJULv43+qfCdY9Ktf/a/hY4BI5P71MaaS572T0+rvdfB0qNBtmNLuYm/Ps
         fuCIymU+DnYkvMCpTVRVPkiC8b+NoUSPslqs22xgK65g6NPfK6UT4PlPNzCmCNNIhJnr
         Dsdm00orgJnSJy5lAamHKdi/YTHjKQI2HhK+As546ROmFhNnfbcMSCixrsSHP5yttjHH
         ibmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KdIW5He8ZiiCiJCefvMCxWAQ162LKqrQoM487o/uJO8=;
        b=bRiLL9P9PFWTnEP07ZSpy/3be42C+/glXZP6vbUvwhf976JQEVo1VW6AH8alr9Z0oX
         F2r/jOKb9+w6CPG3j1Ll7gbCRTbiTtnPkKu64oFPXD6tOb+blLxIh0LoiE52dIY9kBaA
         Ws3CT7WVlx8RaNIwWTGZVvG6dertr/BDDQxqk0Fcu6550Ja3CGcR5bil4gZ7ZQOTq7RK
         yPooX9l87/P60uJjnDR3rqrGIBT/EDiCPQ+7l/WcL59OR0quceYs+ssn0xNWfPVESNCY
         Hus/9eutG/2f6O5RstxqLFtZWbA+BWrwzxMvRwPZ8SiFdVcAH239hgxerq2YMsl/tpc8
         rsNQ==
X-Gm-Message-State: AOAM532C1SQEOCE5BFaxUNPSeXM9wl4vkHYZK3g9NNjjMNLlvokjJPX9
        hNMwkuJQ3mErmdZdvJbyzQ==
X-Google-Smtp-Source: ABdhPJwVjnzLFeP+i8s/I6t5APn4aBiJ18PZlMr//czA/GeBiS5dylC/raDPG+E1JxJrEBSrZxyUCw==
X-Received: by 2002:a0c:8583:: with SMTP id o3mr2124679qva.108.1594687348930;
        Mon, 13 Jul 2020 17:42:28 -0700 (PDT)
Received: from localhost.localdomain ([209.94.141.207])
        by smtp.gmail.com with ESMTPSA id p36sm2849287qte.90.2020.07.13.17.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 17:42:28 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [Linux-kernel-mentees] [PATCH] bpf: Fix NULL pointer dereference in __btf_resolve_helper_id()
Date:   Mon, 13 Jul 2020 20:38:56 -0400
Message-Id: <20200714003856.194768-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
as NULL. This patch fixes the following syzbot bug:

    https://syzkaller.appspot.com/bug?id=5edd146856fd513747c1992442732e5a0e9ba355

Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 30721f2c2d10..3e981b183fa4 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4088,7 +4088,7 @@ static int __btf_resolve_helper_id(struct bpf_verifier_log *log, void *fn,
 	const char *tname, *sym;
 	u32 btf_id, i;
 
-	if (IS_ERR(btf_vmlinux)) {
+	if (IS_ERR_OR_NULL(btf_vmlinux)) {
 		bpf_log(log, "btf_vmlinux is malformed\n");
 		return -EINVAL;
 	}
-- 
2.25.1

