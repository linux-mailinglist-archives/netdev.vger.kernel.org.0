Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB3817F106
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgCJHcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:32:42 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42214 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgCJHcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 03:32:42 -0400
Received: by mail-pf1-f194.google.com with SMTP id f5so6076935pfk.9;
        Tue, 10 Mar 2020 00:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MJwg8iSfmsfomv5k6r5ohZ+xPIbEpaoDC7tA7oRqZ/M=;
        b=kLAnE58YjRDod5y2i2IGRAETVIJ4f8HUj61lM09pIurs2dU+CfbkAF9gsolWl7F3Fs
         bjDuD47zYl/EDEFO4fFgHg+DavRV8CuoQ1Awx1D5CNzhonu3lD1UrXiwjSkWYwgUhRee
         4MYWXxS0sQ6aAngxCsWAPIFTlXCuNRenLaghlfkRgIEP9eBYe3uMxP0BgGKsarGrDUET
         k20Sdl6X0u6qO5YlI7P/FQ8Hd2ztrlWkvvX+AIMpr8H7LxL8c6tFaYC21Zf7xMfYmkQJ
         8B2RXbeyTnplymzYEZ8e3oWcUDBQ+sM9nergOVt7UqpngTgA6JitNTusJT1zzUIf7c+p
         6Omw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MJwg8iSfmsfomv5k6r5ohZ+xPIbEpaoDC7tA7oRqZ/M=;
        b=ujqdY8V6I+f4H/If2QYdRZ5QmtKNMQ/u0lo5kgHE2ZgznYm9DYATWMACFq7Q89l1LZ
         BAexSSkoJWwM1CnsXzQefLJAfEAEDAzTf78EryQYIB69pPHEW3Mx5KNyuLABKhWAR2zm
         r+tiqSJbeiExcmB9E8rL4m8QjTd6R/A6hF/TLDW3GWMoVD2RWFGZZz9EMnvgjoMpILAj
         uTnPv5fDjzsTSvCnEO8FCQYgw3y2FKJEiGh0nlt/9YyDWvjrRU1Xsz3+98iqsyeJUFzw
         OqDAHyDPCBrUAeKibo6b+67mJk8SU7fKmD/5K0RqQE4yKgMs7es9+04CrMY6C8T0cM08
         WwBA==
X-Gm-Message-State: ANhLgQ0F7qNsNrCrV8yfShk2+lXRRs9BYYvKBa7+enbyWpDBg7ilJ26S
        Vo0NFBk3O5AyEFx5hfhpwUM=
X-Google-Smtp-Source: ADFU+vuOyhEKtlEnwciCNGzmRJyLvT7Bpi6puVDKDuCjQKm7BI8GGpl4k+b731XAdwvASUG/j6p0BQ==
X-Received: by 2002:a63:67c5:: with SMTP id b188mr19736305pgc.111.1583825561728;
        Tue, 10 Mar 2020 00:32:41 -0700 (PDT)
Received: from dali.ht.sfc.keio.ac.jp (dali.ht.sfc.keio.ac.jp. [133.27.170.2])
        by smtp.gmail.com with ESMTPSA id t8sm1075109pjy.11.2020.03.10.00.32.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Mar 2020 00:32:41 -0700 (PDT)
From:   Yoshiki Komachi <komachi.yoshiki@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf 1/2] bpf/btf: Fix BTF verification of enum members in struct/union
Date:   Tue, 10 Mar 2020 16:32:29 +0900
Message-Id: <1583825550-18606-2-git-send-email-komachi.yoshiki@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
References: <1583825550-18606-1-git-send-email-komachi.yoshiki@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_enum_check_member() was currently sure to recognize the size of
"enum" type members in struct/union as the size of "int" even if
its size was packed.

This patch fixes BTF enum verification to use the correct size
of member in BPF programs.

Fixes: 179cde8cef7e ("bpf: btf: Check members of struct/union")
Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 7871400..32ab922 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2418,7 +2418,7 @@ static int btf_enum_check_member(struct btf_verifier_env *env,
 
 	struct_size = struct_type->size;
 	bytes_offset = BITS_ROUNDDOWN_BYTES(struct_bits_off);
-	if (struct_size - bytes_offset < sizeof(int)) {
+	if (struct_size - bytes_offset < member_type->size) {
 		btf_verifier_log_member(env, struct_type, member,
 					"Member exceeds struct_size");
 		return -EINVAL;
-- 
1.8.3.1

