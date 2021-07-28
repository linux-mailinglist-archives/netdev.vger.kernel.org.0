Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A05E3D8AAE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 11:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhG1Jdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 05:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhG1Jdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 05:33:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1648C061764
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 02:33:36 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k4-20020a17090a5144b02901731c776526so9041938pjm.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 02:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LdueI+7ntEuRiTezbvN0MNwX4sEm9fMdcHdRVOiDSS4=;
        b=F/XXjM9sRo1vqlffNWywbBL3IbvmOuLIxqtvooeUmgw3ksZnlyX3SPWLYu7L+4L8ay
         5Zn9trWsCgtBimsDleIA+i58N7l05n/9Y0pM9kbkQ2k7bzgOV2EJaUzKVTTLiljCd9ma
         kKyG9Z2u6j8GsLKCltmujqRh6eaNmylZCw6MZDzA9HQ35Wzj5cDe3i0hLqEXWA7HnTeQ
         WeDrMsxIHAAmnN60uSGSRT+tZPkV7/m86bb8s0LcLeT/5E4LZJ+vX0IJosdOOO9zYb30
         vFubL5j5IvLlEAop0eW30yCyz/W1rhDcsLVRFc58KHc9RqY/A75FVkJbZgAKiIxRi1+J
         CKPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LdueI+7ntEuRiTezbvN0MNwX4sEm9fMdcHdRVOiDSS4=;
        b=fasF480g2hBxVDVfplnYLz1wplPZ2Znk/JOL7e1zAWoN5zvtagw5MRYW1yAwpCWCpQ
         /BzGLgskBIOLrJkuNPqDY19lVQBJi4MbeCBvHIcSknKRoavX5l+MN6RjmGDW07r0TRt7
         +PRdrY85X7jKjLzTG+/T2muOztyDKS1mBgN4knV6TKNJrxO+W2+HDjteYkq+XZXpisCD
         YG7fzZQn42cstw1ZfxbzpwpahPHphvCZvfPCplzIzIYCpPbjRE0Z9nj8cEtv7m0jJIvJ
         7hfXRwpxrIp40K8fKXgY2bC9QUEZi73QCVdJxk+05WUpG0jlOOR2BuiVjy2X321pLp0f
         G/Kg==
X-Gm-Message-State: AOAM5322QLY4L/uP2GZXg5B0qKzEAlouGntRTuqpyfIEYb68zDNyxO7c
        Oa4JNtIl/wslqgIIWcnIHjouLoWwY5IhCw==
X-Google-Smtp-Source: ABdhPJyc4AZQSxMiQhQQqm0tZw0RaXdR3qgHDSVBuzTZdbwz8pG+owsLpo5IE+nvnuQLH7bK8o8WJg==
X-Received: by 2002:a63:ff22:: with SMTP id k34mr28013560pgi.336.1627464815946;
        Wed, 28 Jul 2021 02:33:35 -0700 (PDT)
Received: from FVFX41FWHV2J.bytedance.net ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id j3sm6759636pfc.10.2021.07.28.02.33.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 02:33:35 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, kuznet@ms2.inr.ac.ru,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        chenzhuowen.simon@bytedance.com, zhoufeng.zf@bytedance.com
Subject: [PATCH] lib/bpf: Fix btf_load error lead to enable debug log
Date:   Wed, 28 Jul 2021 17:33:21 +0800
Message-Id: <20210728093321.16500-1-zhoufeng.zf@bytedance.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Feng Zhou <zhoufeng.zf@bytedance.com>

Use tc with no verbose, when bpf_btf_attach fail,
the conditions:
"if (fd < 0 && (errno == ENOSPC || !ctx->log_size))"
will make ctx->log_size != 0. And then, bpf_prog_attach,
ctx->log_size != 0. so enable debug log.
The verifier log sometimes is so chatty on larger programs.
bpf_prog_attach is failed.
"Log buffer too small to dump verifier log 16777215 bytes (9 tries)!"

BTF load failure does not affect prog load. prog still work.
So when BTF/PROG load fail, enlarge log_size and re-fail with
having verbose.

Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
---
 lib/bpf_legacy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 8a03b9c2..80c49f08 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -1525,13 +1525,13 @@ retry:
 	fd = bpf_prog_load_dev(prog->type, prog->insns, prog->size,
 			       prog->license, ctx->ifindex,
 			       ctx->log, ctx->log_size);
-	if (fd < 0 || ctx->verbose) {
+	if (fd < 0 && ctx->verbose) {
 		/* The verifier log is pretty chatty, sometimes so chatty
 		 * on larger programs, that we could fail to dump everything
 		 * into our buffer. Still, try to give a debuggable error
 		 * log for the user, so enlarge it and re-fail.
 		 */
-		if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
+		if (errno == ENOSPC) {
 			if (tries++ < 10 && !bpf_log_realloc(ctx))
 				goto retry;
 
@@ -2068,8 +2068,8 @@ retry:
 	errno = 0;
 	fd = bpf_btf_load(ctx->btf_data->d_buf, ctx->btf_data->d_size,
 			  ctx->log, ctx->log_size);
-	if (fd < 0 || ctx->verbose) {
-		if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
+	if (fd < 0 && ctx->verbose) {
+		if (errno == ENOSPC) {
 			if (tries++ < 10 && !bpf_log_realloc(ctx))
 				goto retry;
 
-- 
2.11.0

