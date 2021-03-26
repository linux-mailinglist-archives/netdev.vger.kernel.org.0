Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A9A34AC46
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 17:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhCZQGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 12:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbhCZQFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 12:05:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336BBC0613B1
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 09:05:43 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id x7so6128528wrw.10
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 09:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mqp/POwv3HiaquHlLQ1gTN1Ru0BA4oHIhK0qmfN5BCM=;
        b=GPk10D7QKyNGNK62WM1P0nDYs3pFdP5iH+CwIFUKtiMBMRx1SK1pXZZNcIr4r0dD6R
         0bCnup3k36XmYUmZjm26og9Sbue7e4UcKdrL8efhfnP3iKOuZX53/ZP3bn/IgPOrHuj4
         8vGc2v5RMQbhoJeWQp4cJ6L7ND6El5Ywpp7Fs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mqp/POwv3HiaquHlLQ1gTN1Ru0BA4oHIhK0qmfN5BCM=;
        b=duM1hHW4RaVh0A/+1TDk+3Jx13kOo0sb5qytQLgIvCvCY0CY9Ze7MxeBxMUAogoAo4
         ohaICNnqMWOtXVupiJJToxcc+krq2YPW9Oo4cM6dRPP4Wkz9xb83b54pAbngiQzPeIkt
         zxqBfZ+47gdkV/QigzQq4PajK2qkdEB1pLMdNXMbleKei5u9K6oUfUVosnpAn23euISG
         fGMWGBezd+Wj0bRMpPZgh7L4rC24GDCX/7KRzDDlUIJpZOzx6NP8GZbNe3/IQkVX2+wa
         PAXs796Nxj0sBdHvgR3yuypnrXYj1288zVrtreQ4Q3Gc9vgl3+Nk8V0Yg6s6Z0TOZoW4
         Ky0A==
X-Gm-Message-State: AOAM530Vie6S79YfhhbfsiNSUOub7xN8iP5fUebo0O5MJJmPLSiM8p06
        ePvkRQ/GiKus45RTFe/4SuRbFg==
X-Google-Smtp-Source: ABdhPJzeLafYdRr/2dkqUCk5gViv+7xxZjUwGkq7UgOvm5XI4BKlgmgK88QvJ/BSIm7Wbvm7U5grSA==
X-Received: by 2002:adf:e64d:: with SMTP id b13mr15395269wrn.204.1616774741842;
        Fri, 26 Mar 2021 09:05:41 -0700 (PDT)
Received: from localhost.localdomain (5.0.8.c.b.e.d.6.4.e.c.a.1.e.f.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4fe1:ace4:6deb:c805])
        by smtp.gmail.com with ESMTPSA id s20sm11692879wmj.36.2021.03.26.09.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 09:05:41 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kernel-team@cloudflare.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf v2 2/2] bpf: program: refuse non-O_RDWR flags in BPF_OBJ_GET
Date:   Fri, 26 Mar 2021 16:05:01 +0000
Message-Id: <20210326160501.46234-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210326160501.46234-1-lmb@cloudflare.com>
References: <20210326160501.46234-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As for bpf_link, refuse creating a non-O_RDWR fd. Since program fds
currently don't allow modifications this is a precaution, not a
straight up bug fix.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 kernel/bpf/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index dc56237d6960..d2de2abec35b 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -543,7 +543,7 @@ int bpf_obj_get_user(const char __user *pathname, int flags)
 		return PTR_ERR(raw);
 
 	if (type == BPF_TYPE_PROG)
-		ret = bpf_prog_new_fd(raw);
+		ret = (f_flags != O_RDWR) ? -EINVAL : bpf_prog_new_fd(raw);
 	else if (type == BPF_TYPE_MAP)
 		ret = bpf_map_new_fd(raw, f_flags);
 	else if (type == BPF_TYPE_LINK)
-- 
2.27.0

