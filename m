Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A58924AC280
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441837AbiBGPFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442513AbiBGOwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:52:20 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E91C0401C3
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 06:52:19 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id e17so23188721uad.9
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 06:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rZtABFI5cNBm/eHiIyfTOBmMdnmCDUrTmiFxVvQRvIk=;
        b=AU/XUeRCfjrq2h50MvAAbLtXQMvXPnF1OQYbz+uYV66kfQpjJ5JZKWn040JZyprG5Y
         i2RHs+OuQWoF8n1LCs1tWi/sZHAEhStvkBlMPRSShBQgLFRvEEhYE8SnDIY8Vmm92lo8
         2cJ0/3dMDYTT5CMx3XH8KYzoySRkvALWLfBUA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rZtABFI5cNBm/eHiIyfTOBmMdnmCDUrTmiFxVvQRvIk=;
        b=0Vr3TjLIxTNfybjftmJBSnPhTZ2+aY3+2M8a0wd76asjg0X6zz3ZhB7iG8OwAJhilg
         wuCx+IzmoXdHg/iYmvi8052MCH78FZpCOkIX34FWnkcrWUHgGiQtSAR2jBM4/aJXWbwY
         VymKlcJat5lQf0alL7STRMXWRHHJylBRGBYz+fsCbhVavtwEGIAPSjeb3gv82IYvyDdd
         NpSjyxQBY359mc8X9Ze8JDAJIZ2g7+uWinrdbrT1a576wkKi5yNhpXc/QojwgjaJbvqT
         hY3111zyGFWcdPAOKznI/D60N87bg+qZq2MbN0OilbpVjoha91yw2T9H+rbLrkpBYtnb
         0JXg==
X-Gm-Message-State: AOAM531ULFPH75y+W27CswhEdzh8xB6wiu5RJjK4+hUBfnM7an+geRK8
        BBoNZqJSm3sN3ylskrBBl9ygokGMiJEdlRfBqXLQoPKZimmoBH9K2dEHVfc4AcPJUkzyConGNH5
        Hgiqkaut4vfvBrHRyNwJq7cRwzyxtwiWug0/c5IMjgp1TvFI2HojYW3jb3ew5ZOwzCOpwkw==
X-Google-Smtp-Source: ABdhPJxd7czwyrCJSKh5ynMPFWDnHcE4mDToDt0JOdBdGOMR5xzShdyJkrVpGkFsxOVJCGNHrzODAw==
X-Received: by 2002:a67:e146:: with SMTP id o6mr52916vsl.12.1644245537456;
        Mon, 07 Feb 2022 06:52:17 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id r14sm581347vke.20.2022.02.07.06.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 06:52:17 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next v2 1/3] libbpf: Remove mode check in libbpf_set_strict_mode()
Date:   Mon,  7 Feb 2022 09:50:50 -0500
Message-Id: <20220207145052.124421-2-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220207145052.124421-1-mauricio@kinvolk.io>
References: <20220207145052.124421-1-mauricio@kinvolk.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

libbpf_set_strict_mode() checks that the passed mode doesn't contain
extra bits for LIBBPF_STRICT_* flags that don't exist yet.

It makes it difficult for applications to disable some strict flags as
something like "LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS"
is rejected by this check and they have to use a rather complicated
formula to calculate it.[0]

One possibility is to change LIBBPF_STRICT_ALL to only contain the bits
of all existing LIBBPF_STRICT_* flags instead of 0xffffffff. However
it's not possible because the idea is that applications compiled against
older libbpf_legacy.h would still be opting into latest
LIBBPF_STRICT_ALL features.[1]

The other possibility is to remove that check so something like
"LIBBPF_STRICT_ALL & ~LIBBPF_STRICT_MAP_DEFINITIONS" is allowed. It's
what this commit does.

[0]: https://lore.kernel.org/bpf/20220204220435.301896-1-mauricio@kinvolk.io/
[1]: https://lore.kernel.org/bpf/CAEf4BzaTWa9fELJLh+bxnOb0P1EMQmaRbJVG0L+nXZdy0b8G3Q@mail.gmail.com/

Fixes: 93b8952d223a ("libbpf: deprecate legacy BPF map definitions")

Signed-off-by: Mauricio Vásquez <mauricio@kinvolk.io>
---
 tools/lib/bpf/libbpf.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 81605de8654e..d5bac4ed7023 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -156,14 +156,6 @@ enum libbpf_strict_mode libbpf_mode = LIBBPF_STRICT_NONE;
 
 int libbpf_set_strict_mode(enum libbpf_strict_mode mode)
 {
-	/* __LIBBPF_STRICT_LAST is the last power-of-2 value used + 1, so to
-	 * get all possible values we compensate last +1, and then (2*x - 1)
-	 * to get the bit mask
-	 */
-	if (mode != LIBBPF_STRICT_ALL
-	    && (mode & ~((__LIBBPF_STRICT_LAST - 1) * 2 - 1)))
-		return errno = EINVAL, -EINVAL;
-
 	libbpf_mode = mode;
 	return 0;
 }
-- 
2.25.1

