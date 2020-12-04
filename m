Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7D62CED2F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388063AbgLDLhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgLDLhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:37:46 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B97E2C061A56
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 03:36:21 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id a3so6712880wmb.5
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 03:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vXUt9QR6W/2xypB9zqeID7fSJysj66ekgYEFFzk0u3s=;
        b=M8VVpn2j0Mamn/J9XrTVaYx67YMPiKTCcqkORGZkkY2bPk4iBr7PVQQW13pMhqSEfb
         A+3S8KjGCgOOKa/vbCMYBmO/jGdGQBjK502cJ5zsmmjnbLPUUSHZjdBbXfA+/rxhKBkg
         AEtLmeyaz25uSLlhre7xQqu8pFIefO1fNpmQ4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vXUt9QR6W/2xypB9zqeID7fSJysj66ekgYEFFzk0u3s=;
        b=pCD0mAwDfxQzOlhiJbaY+yQFJBpKgE0MBnXezrL+AeEMhy8MyFC5vMO1iJGsXubags
         FqnJNeelYPI0SF/af/PA2Hq+XtfcIiaR/egaSPaSw/DSz8fjY/E4CN6FEIYN2F+7JybR
         MVj9K3By3aG+R5jnp+ivJwzVZDkZTzZETdCBkm7/lu60KmHUElh3/WK6JB9VTrtZCEhO
         vNIxDEGHwh4muLD9CGmWMi15fbP5ekDAQPNuZkI+f0MqZUL1DWrXnmtoEhhb/1mWuI9v
         G50s2RUxosRU8I5zdpF+McGXbCA4Z1CLQuBUsnYnQ1onlXzBll1Gr/8g25RpvNX0fik8
         YoTQ==
X-Gm-Message-State: AOAM533tsorjMjfoPpuCYKPKGWsXCX8UlEN12dOmb2b05I303AR72gMj
        3IiM2I1QYJ2o+dVccfYANJ/NvA==
X-Google-Smtp-Source: ABdhPJye4B8dDFbmGY6ImaaUYrrR2Sy5uuk2eixv15LJmLNAfKjKJZizosdgZvxiAMQfc6I5y0CtnQ==
X-Received: by 2002:a1c:3d86:: with SMTP id k128mr3629454wma.66.1607081780439;
        Fri, 04 Dec 2020 03:36:20 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id j6sm3202750wrq.38.2020.12.04.03.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 03:36:19 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
X-Google-Original-From: Florent Revest <revest@google.com>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        KP Singh <kpsingh@google.com>
Subject: [PATCH bpf-next v5 3/6] bpf: Expose bpf_sk_storage_* to iterator programs
Date:   Fri,  4 Dec 2020 12:36:06 +0100
Message-Id: <20201204113609.1850150-3-revest@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
In-Reply-To: <20201204113609.1850150-1-revest@google.com>
References: <20201204113609.1850150-1-revest@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Iterators are currently used to expose kernel information to userspace
over fast procfs-like files but iterators could also be used to
manipulate local storage. For example, the task_file iterator could be
used to initialize a socket local storage with associations between
processes and sockets or to selectively delete local storage values.

Signed-off-by: Florent Revest <revest@google.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Acked-by: KP Singh <kpsingh@google.com>
---
 net/core/bpf_sk_storage.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index a32037daa933..4edd033e899c 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -394,6 +394,7 @@ static bool bpf_sk_storage_tracing_allowed(const struct bpf_prog *prog)
 	 * use the bpf_sk_storage_(get|delete) helper.
 	 */
 	switch (prog->expected_attach_type) {
+	case BPF_TRACE_ITER:
 	case BPF_TRACE_RAW_TP:
 		/* bpf_sk_storage has no trace point */
 		return true;
-- 
2.29.2.576.ga3fc446d84-goog

