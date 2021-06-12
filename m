Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620D63A4C3F
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 04:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhFLCig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 22:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFLCif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 22:38:35 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F65C061574;
        Fri, 11 Jun 2021 19:36:25 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id i34so3901258pgl.9;
        Fri, 11 Jun 2021 19:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6oXG9vdCurXKmOdJS+c0Sh8RTbrP7GR5GJEYzeBms5A=;
        b=d/mr0GV+HvbS44NUwfeq2VHLzjZXryTIEE8CarYc4VjvzL+MNOGULMnitC2YAK5TcV
         RFTxmQElpkpyrFBKTYuabNWFC+bSTrd6l8FDgun39/18OHTU0Kx6Tl0xCRc8nD50ma2X
         1cZxU3UO2Wx+K4SlEpXvWa/O1AgrpzRemGS2I2fCG6eV3Q7HqYD6LVR44Z8Qh0K9ggCA
         s0yNaQIJ1Z5KEVZ1bEYeUjiKh+yxjMXUQhakCqnC9g05GjDXGB70ggLH1xzmagklZcSD
         LRw/6PYYm42sBQbW5U6tRonZXYro0HQ395f0VdZATJlngZW2P4WOPvwduuDvHsatyeQU
         XLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6oXG9vdCurXKmOdJS+c0Sh8RTbrP7GR5GJEYzeBms5A=;
        b=nYkqJi2MeOX+g7E7HKbgsHRNLteDIO068+jCauK0z0AtNTnfBnbeNWdOFqrGeilbW+
         wysAQCPzqvqFpTzGu8nDvn4z+1qdB5L0nD0NOAFlRmtVSV71c0FV53DkLz8OQVT6JdH2
         IMgvn+1UVLVoXhqElvyuj7jA7s/gIrM0iW0EogETTIdXLhNtaRdE6mFOWmLx4NGzO5pH
         BQrXYgp0no2C2wsVZUh/0whC11r6UojWajVvMjR1ih+mc7PaVRNxdW3YvIqEPW5RGokj
         cM7tQHQaOrCXIa2W5I2Hbv+70EVUQ0ZBmtVTMEf7SmD/brXP0wvwR3DAvsaTsgiHO+dg
         plAw==
X-Gm-Message-State: AOAM5301i0GloHHQsy0zNOWywKGMJTmCEt9gqbU1O9MAGnwL5UzJhvmt
        QH1riitZj/b11TZ6C909RftTAUdEfFo=
X-Google-Smtp-Source: ABdhPJw0dx3xNUbywwe6e21p1hM96NjZxI7FVbEdpFTeqL6/+mo4vrEB/y1fx3aAD9T6Gq50S3yAeQ==
X-Received: by 2002:a65:438d:: with SMTP id m13mr6333212pgp.87.1623465384857;
        Fri, 11 Jun 2021 19:36:24 -0700 (PDT)
Received: from localhost ([2409:4063:4d05:9fb3:bc63:2dba:460a:d70e])
        by smtp.gmail.com with ESMTPSA id t39sm5857834pfg.147.2021.06.11.19.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 19:36:24 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next 1/3] libbpf: remove unneeded check for flags during detach
Date:   Sat, 12 Jun 2021 08:05:00 +0530
Message-Id: <20210612023502.1283837-2-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210612023502.1283837-1-memxor@gmail.com>
References: <20210612023502.1283837-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity complained about this being unreachable code. It is right
because we already enforce flags to be unset, so a check validating the
flag value is redundant.

CID: 322808
Fixes: 715c5ce454a6 ("libbpf: Add low level TC-BPF management API")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/netlink.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/lib/bpf/netlink.c b/tools/lib/bpf/netlink.c
index d743c8721aa7..efbb50ad59d8 100644
--- a/tools/lib/bpf/netlink.c
+++ b/tools/lib/bpf/netlink.c
@@ -675,8 +675,6 @@ static int __bpf_tc_detach(const struct bpf_tc_hook *hook,
 		return -EINVAL;
 	if (priority > UINT16_MAX)
 		return -EINVAL;
-	if (flags & ~BPF_TC_F_REPLACE)
-		return -EINVAL;
 	if (!flush) {
 		if (!handle || !priority)
 			return -EINVAL;
-- 
2.31.1

