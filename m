Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C782CC877
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbgLBU5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:57:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731124AbgLBU5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 15:57:22 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96E6C061A49
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 12:55:52 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 23so5512675wrc.8
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 12:55:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t4beLIa3KJ8+MUkP/0+ZlqhuHQAr4Y2kV+lpaUplNzE=;
        b=e+PPU1x0oI1ydxbhlMsNEEWpMzZy+NBUCct8cTNT47jwZfmkBcR00W2FIeVEZC/t4Q
         EBOXpVe13FBkxnKrGaQvlGYPcT6fMO5Cz6Cd09yWDt/L/1dpXHQG/ZWKJ2Feovzb1uWr
         uJQs+7TcBo9I0GNsyVBnn0fC38wB2/uL2JR+8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t4beLIa3KJ8+MUkP/0+ZlqhuHQAr4Y2kV+lpaUplNzE=;
        b=MlLCfsMTsu2zWtRQonN2sfJopLsC+ahUQ+HkXgMA+ZUJeXW8CWRPfWQ1KL8mOB9Mb7
         5vuOq5NAlF3VpqcSEtc/Wh9CUr1o8ALeGaeB6YfKYCJj0Meqta8gjghOU3s2Wjrrktu1
         m+N/PiMeuZvUI9Ip97cusf24o0ltwvarRILISb31CaKbkiB8hKbU3TwswvRVBTfBEGPJ
         E1n8fgiPKKjpbRFTBLBizn6J2bSOnQE9wowCNoURE5kP8OLMCt50iXwtn85/2jtLBttt
         f0CCzhTnw7BPFhHaUzCZawuU9d5Gmbk9qVcR3w/GCkRiyRssDdWkyls8OqX4LkDea1zF
         QwDg==
X-Gm-Message-State: AOAM5336q6nV+TSGphc3EC0pXucW5wHjY9VWTJJKN/T1yXphFzpsD+tU
        scx6cXmi3IzPVmVFTVE9djBY4g==
X-Google-Smtp-Source: ABdhPJw2S8DkFi9xJHuGpcygik9qGwFOKDt2nDTyCfPY0UXodM1/fRNXpZLIP6cLRjuyPFRnt6AxPw==
X-Received: by 2002:a5d:4d92:: with SMTP id b18mr5848300wru.260.1606942551727;
        Wed, 02 Dec 2020 12:55:51 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id d2sm3438486wrn.43.2020.12.02.12.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 12:55:51 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
X-Google-Original-From: Florent Revest <revest@google.com>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        KP Singh <kpsingh@google.com>
Subject: [PATCH bpf-next v4 3/6] bpf: Expose bpf_sk_storage_* to iterator programs
Date:   Wed,  2 Dec 2020 21:55:24 +0100
Message-Id: <20201202205527.984965-3-revest@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
In-Reply-To: <20201202205527.984965-1-revest@google.com>
References: <20201202205527.984965-1-revest@google.com>
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
2.29.2.454.gaff20da3a2-goog

