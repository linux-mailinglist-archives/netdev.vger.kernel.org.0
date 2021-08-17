Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FB03EF09C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 19:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbhHQRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 13:09:18 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:56726
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229700AbhHQRJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 13:09:17 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id AD0933F0B9;
        Tue, 17 Aug 2021 17:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629220122;
        bh=WJBXkkU1tHc8E8eo8Usv6y0V0Z9Qgiu/DplUySoP91s=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=anFq0wsiYvXoedRMVYYKBJlaFe4IRTL41by7WARaDZFAfL9YofQcSVJTnYkSm7yPu
         jlqQvHRdJp5OUwIunUOfcSZP5MlZtoRxDpSBwdaMNg4/qgVYMj+ps6366ON/TLxRJf
         2foqSWHaPdYwCRpSkSULec1DOkdC3LSZWdtzsoI1oadmEpx1DiEkT1rMUff7G8GO7x
         RtyvDQrTA796S7rfHD5V1TVJrGDQcsYiUCC2zv5H9cOcRILXdvYpOAUaxxyZXTiQxq
         EQ0VEaVqXhX8x4ad2IXmkMBWh7zy1i0H0lSd1obaB9V0KQl8FcakBLAaUUU4ivQS6D
         z5wbV61JPViqg==
From:   Colin King <colin.king@canonical.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] bpf: remove redundant initialization of variable allow
Date:   Tue, 17 Aug 2021 18:08:42 +0100
Message-Id: <20210817170842.495440-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable allow is being initialized with a value that is never read, it
is being updated later on. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index a1dedba4c174..9f35928bab0a 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1133,11 +1133,11 @@ int __cgroup_bpf_check_dev_permission(short dev_type, u32 major, u32 minor,
 	struct bpf_cgroup_dev_ctx ctx = {
 		.access_type = (access << 16) | dev_type,
 		.major = major,
 		.minor = minor,
 	};
-	int allow = 1;
+	int allow;
 
 	rcu_read_lock();
 	cgrp = task_dfl_cgroup(current);
 	allow = BPF_PROG_RUN_ARRAY_CG(cgrp->bpf.effective[type], &ctx,
 				      bpf_prog_run);
-- 
2.32.0

