Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1EB33DCA43
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 08:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhHAGH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 02:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhHAGH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 02:07:27 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F89C06175F
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 23:07:20 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id u16so7472307ple.2
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 23:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BM39hhWl0HJGtmPlP5LBjxCBAkj9TXrWHYaMU1vbaY4=;
        b=r72RipyogEz+7C/7uKvUFZ4/Tz5jcbvYHbsFcc4VT97LTzxk/8cO11RNdFsvWEO5qQ
         p3vDJN3eo0wpV/Sauz3OGlqr0+uPGZuWbe3gA7DlA1ErNJD6pzuvYyshazkb6o1Qa1vS
         fCaIy9COhBrQQPAnKUcoMYb/XsS+PRY6xvt4yINRXWiz0Olfo437jjqTmFG23MZjMRPC
         RT76kopntnkkXonYm2z9FZXtZgu3IVSja7U0ZPiYgPmsGihBUvexP6lNQWZyVWlMGh+Z
         jkww5oKo+ruzJEZE0kYqYd6ktFPEfriZn0rQo3QrK8GEyav+eh3vpBtH1oFfo8StDZB3
         YrNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BM39hhWl0HJGtmPlP5LBjxCBAkj9TXrWHYaMU1vbaY4=;
        b=hXdp7jiyiOnLBndYErJWs3/in4ZO95DSgMOoCfCq/7XjvoV0Rbrr+Tsk1kdzUtQqxa
         eGtXjzGhAjUdbfyDOtycypTwhZhsPDML2eqiJeaVHIfNuVdJrBGA1qvb3pIOV64vNkZ2
         EBhhyS9LS5uik0d9WFoAKZ41V57KmaYhqFU5ShORQwfyPgJfH9WYmoAmFArmLVBK7ImG
         bNnRHSx1e+dFPQne8T9PYwMHMPPN0kSG17bao0hnsOyB6GBRzxz811a/6q4MwZFmFv64
         2q5pcNfoRBOG0ywZ+u4ZsDXtfF1DnqCs9KTCS6CCukEQj+rFUhcioYl9EtKPYB8SwFxZ
         jUaA==
X-Gm-Message-State: AOAM5328WD0vTB1KDFjtvnvoOzHbSN/PXfuxGzj6m9iWX9sfdxgQk3tg
        CX/CWIJ0yDdr0jq5wWbesYGuZcypuFf3yQ==
X-Google-Smtp-Source: ABdhPJy1Fzu8sjEi6oYSODmuOnKIZgu8n6NoJYMA0jKZqD9+mrxPP+0LKTkse/gnUPfhoYNSb51tTw==
X-Received: by 2002:aa7:9a08:0:b029:331:ea96:691d with SMTP id w8-20020aa79a080000b0290331ea96691dmr10773976pfj.75.1627798039271;
        Sat, 31 Jul 2021 23:07:19 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id u62sm7611330pfb.19.2021.07.31.23.07.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 31 Jul 2021 23:07:18 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     netdev@vger.kernel.org, andrii.nakryiko@gmail.com
Cc:     stephen@networkplumber.org, kuznet@ms2.inr.ac.ru,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        chenzhuowen.simon@bytedance.com, zhoufeng.zf@bytedance.com,
        cong.wang@bytedance.com
Subject: [PATCH iproute2] lib/bpf: Fix btf_load error lead to enable debug log
Date:   Sun,  1 Aug 2021 14:07:09 +0800
Message-Id: <20210801060709.4148-1-zhoufeng.zf@bytedance.com>
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
 lib/bpf_legacy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/bpf_legacy.c b/lib/bpf_legacy.c
index 8a03b9c2..d824388c 100644
--- a/lib/bpf_legacy.c
+++ b/lib/bpf_legacy.c
@@ -1531,7 +1531,7 @@ retry:
 		 * into our buffer. Still, try to give a debuggable error
 		 * log for the user, so enlarge it and re-fail.
 		 */
-		if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
+		if (fd < 0 && errno == ENOSPC) {
 			if (tries++ < 10 && !bpf_log_realloc(ctx))
 				goto retry;
 
@@ -2069,7 +2069,7 @@ retry:
 	fd = bpf_btf_load(ctx->btf_data->d_buf, ctx->btf_data->d_size,
 			  ctx->log, ctx->log_size);
 	if (fd < 0 || ctx->verbose) {
-		if (fd < 0 && (errno == ENOSPC || !ctx->log_size)) {
+		if (fd < 0 && errno == ENOSPC) {
 			if (tries++ < 10 && !bpf_log_realloc(ctx))
 				goto retry;
 
-- 
2.11.0

