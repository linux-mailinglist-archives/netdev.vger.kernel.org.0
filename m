Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7194B961A5
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 15:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfHTNx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 09:53:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35370 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729812AbfHTNx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 09:53:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id k2so12510066wrq.2
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 06:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=bm263GMWeKPUI5wuV6Udltpey7traBFFYHIuzV+qSTc=;
        b=jzoC16fwWZQlep1XQrlZ0OvgarFBOjo2tNoXXGTtGjwGvTi0M94aXOIfTpw1F1usI7
         l8NV3J0K0RHwN3vSbpENrpEa6I1VK9iYe+7cuMtEp5zUXHftwz+OjeE1CbhDauSWI3t3
         TI94J1+ntokgm5jht6OkVi9sN3fGCWoryhsD8YjrzBoIlOoq+J9A92frr1wUY7PI4xM9
         A8f1t/uNwb4i/H1cLogQDqgi3nX6FCfFenanvi4Pmtcujd475T4MmsS11pKL3fhFFb8i
         /8npLUtIfKqXlSuAXSVx5IDHGlRVo8268w1wRpgOOSqTs3bFDzJw9DorUD+xeRq0SMY+
         CUvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bm263GMWeKPUI5wuV6Udltpey7traBFFYHIuzV+qSTc=;
        b=NaTn1KjwBsHfzXvYeBrqWnMiDsnFs/xk6i6vzDlpNHrmOkMTRB4s99+9CaO8kVF2aU
         tmPXJ7caN0gdZLS9hMon1AIztGBPgIt+rE5JkcioTk2PIMT4fCMSCoPygfjSwFnymVuZ
         UIbtwBKLDoawA1scHqcA/fRh9/10DAm1PSWDO34gecOwnKAlVrhX2o6A/oYuTu4BzCzM
         YBwjIvCzVIXA7eaKxN+40VxQVX4C+DEtqBc3UhlmAaqIfEPhOpw9CivceiC52gSK3iP3
         e9aCg91uwEb4y0E4aW6HoWgrzKTxymoNCfjChx+o6cf16XpGVUqO/ZycBB+5vXKKrwty
         FVfg==
X-Gm-Message-State: APjAAAWZqFfnGLUEcDdB4/RlmCz2f1bEpvv/13ImDk8TrtThVV+CHvvk
        ENcSjHA7urV/cmtY+JXrWC9L0rEMFrY=
X-Google-Smtp-Source: APXvYqyz3HKtXQok062DzHDWKPtayPWakbhiAmNsdprn5WW7GG4zo5XvnC2cnQ/Gey1Ng+DO+LGYqQ==
X-Received: by 2002:adf:ec4f:: with SMTP id w15mr18720296wrn.311.1566309235151;
        Tue, 20 Aug 2019 06:53:55 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id r18sm107943wmh.6.2019.08.20.06.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 06:53:54 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next v2] bpf: add BTF ids in procfs for file descriptors to BTF objects
Date:   Tue, 20 Aug 2019 14:53:46 +0100
Message-Id: <20190820135346.7593-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the show_fdinfo hook for BTF FDs file operations, and make it
print the id of the BTF object. This allows for a quick retrieval of the
BTF id from its FD; or it can help understanding what type of object
(BTF) the file descriptor points to.

v2:
- Do not expose data_size, only btf_id, in FD info.

Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 kernel/bpf/btf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5fcc7a17eb5a..6b403dc18486 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3376,6 +3376,15 @@ void btf_type_seq_show(const struct btf *btf, u32 type_id, void *obj,
 	btf_type_ops(t)->seq_show(btf, t, type_id, obj, 0, m);
 }
 
+#ifdef CONFIG_PROC_FS
+static void bpf_btf_show_fdinfo(struct seq_file *m, struct file *filp)
+{
+	const struct btf *btf = filp->private_data;
+
+	seq_printf(m, "btf_id:\t%u\n", btf->id);
+}
+#endif
+
 static int btf_release(struct inode *inode, struct file *filp)
 {
 	btf_put(filp->private_data);
@@ -3383,6 +3392,9 @@ static int btf_release(struct inode *inode, struct file *filp)
 }
 
 const struct file_operations btf_fops = {
+#ifdef CONFIG_PROC_FS
+	.show_fdinfo	= bpf_btf_show_fdinfo,
+#endif
 	.release	= btf_release,
 };
 
-- 
2.17.1

