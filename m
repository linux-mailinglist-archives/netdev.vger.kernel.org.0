Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46C72C5977
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 17:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391546AbgKZQpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 11:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403791AbgKZQpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 11:45:42 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57177C061A49
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 08:45:42 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id 1so3019582wme.3
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 08:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=satiAp7q7vxp1zQmeNmE59ZD3HlYoTJcGcwpTzuEPC0=;
        b=fgliAF2Sz+QGPKBp4FiAzSvtfZOF7X/v9rcdOtzOseupTGyRIbwNAS4OUUle3/h8+l
         rk7N6gZ4JrwfofolDrrcTiS52Hrx8X6IEIM4b1cpxPNZafVYRM1E1LxRvOUN4y6/skLV
         yvw76LTXAJ3qK4WEUPs1J/Ff67cswZgDrv7z0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=satiAp7q7vxp1zQmeNmE59ZD3HlYoTJcGcwpTzuEPC0=;
        b=h8nnVHcXaTaArdINk5jTUlxBg1QjjTLP4rcXqwDwihZks8YWm99IGqU3ZdxZiXLinO
         zdDibG4+yJw7l9RzJGCImX6SROZwUxfKm0SXrGH7oeG5D4S3cvyYI6KKL/N0rcRxn7Sy
         7cRfSpJJK57CMB2e+5bytLzVxYoVYHNZEve8ahzf12zeu1twT0ourJHH4SlyAofj0/ga
         ad/d1OL2cvHh9GpwuWuR/gI7+VJ2fsILsLET3UrH5tMu60XjskPGyJ4oQSXzug9ktf6Q
         RplK5KTYK64h0hUZkkM4LCuoEyi98Nkz0zq5HNVK71hF1csEJyX40NIU5OiVq6GTf0w5
         qYZA==
X-Gm-Message-State: AOAM532eRBn013S8RJi5AtcFTGqkZBFDlktFRGaPc7y39x8XCOnUNgw2
        /Rm7GM4OZVLHktUBTREC4b/Rhg==
X-Google-Smtp-Source: ABdhPJxro2BM0uV+9MCG3jYYWVG89Rgp+wglSySpeJeHg6JxH5CR3TLj4hTfoXxWpnJZJSyuO0BkBg==
X-Received: by 2002:a1c:e3c1:: with SMTP id a184mr4437025wmh.88.1606409141127;
        Thu, 26 Nov 2020 08:45:41 -0800 (PST)
Received: from revest.zrh.corp.google.com ([2a00:79e0:42:204:f693:9fff:fef4:a569])
        by smtp.gmail.com with ESMTPSA id f17sm8805824wmh.10.2020.11.26.08.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 08:45:40 -0800 (PST)
From:   Florent Revest <revest@chromium.org>
X-Google-Original-From: Florent Revest <revest@google.com>
To:     bpf@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andrii@kernel.org, kpsingh@chromium.org, revest@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 3/6] bpf: Expose bpf_sk_storage_* to iterator programs
Date:   Thu, 26 Nov 2020 17:44:46 +0100
Message-Id: <20201126164449.1745292-3-revest@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
In-Reply-To: <20201126164449.1745292-1-revest@google.com>
References: <20201126164449.1745292-1-revest@google.com>
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

