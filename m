Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206EE3D9CEE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 06:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233759AbhG2Eza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 00:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbhG2Ez3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 00:55:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C21AC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:55:26 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso7403387pjf.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 21:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BM39hhWl0HJGtmPlP5LBjxCBAkj9TXrWHYaMU1vbaY4=;
        b=z7QfRH85PJKQEAXDcclpDn7J0dV1Bt2eYXFDh16htmdPd37fwKGRGnQBNSxH4se5JF
         h4vWKbvsdIhzTudw45HbsWzs6ZM8fA2iUrM+jpF9IkQQdDAaCkX1GrefwrqmS3TwSJvX
         K3DViPdOO1EKXXznp33tocgYL0jMK1z0qoneqLTfkHtLs84QSyWpKYH5IfGMpuszo0Fs
         PkowNk9EakyniSFl0K4wTrZYvYiBO4IY/QTudxmG2Es1UGDx1NdVNqBz4gqOYjk7BlUz
         7PRbb2p/HBued7fGMGM5dvKJ+PwZTd6G0oumn6moXzZohvadnwJMG7XhW3q2TBJZb2iT
         GO+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BM39hhWl0HJGtmPlP5LBjxCBAkj9TXrWHYaMU1vbaY4=;
        b=Ox47k0x0RW9UXm7l/SdzNi+HUIRSzdH/Y2zXPMY9myBvFAJvR9G1CYg1LVc4fSuax5
         LlPtzmC8+Bhwr++YEOVAoNJZZQuoxAxImIQ9NJ7997OBXKOEOld0YR09fhAcvZ8qBhmA
         sSzTwtisDWyL1xygHBfTi9KBeXZwAjDQ/YYwa4+skOg/tLp4eJfI8EszhYLy+F9ntZAT
         wg+mcth83NIbYCPz7+lq700ESHA0IpGNu29mBkHIYbEQjtdTUBJq9OT8Px32K9JQd7ft
         cwt44nnfq44Ec0x476SOftVZBTk/E01XcT9boyxl0Ielpt9JRSyHiebJYMyHQ42nqxtf
         PoHg==
X-Gm-Message-State: AOAM531hAB1F7N7e7t5W9HAOAOmIc6r3SJDrRmYdb/As535iXK0QqVPF
        Fj9Gf3mZcIeO4qjGT0fIMouGGW0N90RTCA==
X-Google-Smtp-Source: ABdhPJzCJ0OBJowHEj7xpjHf+8B2pgw13I4Kw5xyN3lgUOuaY8HbMh2nwmbrX+kzulwT8Xl73AhfEw==
X-Received: by 2002:a65:60c5:: with SMTP id r5mr2249257pgv.442.1627534525286;
        Wed, 28 Jul 2021 21:55:25 -0700 (PDT)
Received: from FVFX41FWHV2J.bytedance.net ([139.177.225.247])
        by smtp.gmail.com with ESMTPSA id m21sm1672805pfo.159.2021.07.28.21.55.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 21:55:24 -0700 (PDT)
From:   Feng zhou <zhoufeng.zf@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, kuznet@ms2.inr.ac.ru,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        chenzhuowen.simon@bytedance.com, zhoufeng.zf@bytedance.com
Subject: [PATCH] lib/bpf: Fix btf_load error lead to enable debug log
Date:   Thu, 29 Jul 2021 12:55:16 +0800
Message-Id: <20210729045516.7373-1-zhoufeng.zf@bytedance.com>
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

