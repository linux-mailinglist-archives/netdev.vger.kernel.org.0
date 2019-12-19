Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87DEC126E8A
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfLSUQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:16:29 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:36158 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfLSUQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:16:29 -0500
Received: by mail-ot1-f66.google.com with SMTP id w1so8696649otg.3
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 12:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j06D1vVCaLQ7Gidlh9Y8GoXvESd5SgrJMCcKoVEnNkE=;
        b=IRDf8V5059BgFq0OvHUN+tYR5ScIHW30d0J6hcVOyE1mZcBUZ2higPK22wxdrA6TZC
         vYHUnKYnjcS9QBzuT6jmYTv0xO7LkW2bWf98rSj4DDsuSAPmVsHaRPCDoVqilfACL2k7
         r9HRfRZJfPEV9kWKJwsD1m3iy5V899/fHW5DE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j06D1vVCaLQ7Gidlh9Y8GoXvESd5SgrJMCcKoVEnNkE=;
        b=LuwILaAshwM38OtcjTI7BnShWHiDWmD0YOgFskSSWvf7DwLDzlLMpgQUkJQUZMvALI
         eEQq5NEcWGllWblN2OXtGsY4k2MgFWLL6gK6cBsAYQK+V0s/kRwFsJUdsqC5s+ZuyN1t
         /CSiglZyyNU6ietyznsMZNmukooh3eJT4W7o561+ohyb6ISJ/kDeUZyVP5FDgZ70rs8/
         XL2Y3RDjffcpki0aDqQ0J8G0gJVEgt7b1PxILy1zn5MJYAv7SAzrxGxujU2H2wBvbbdC
         tW++DkwDR4J4QwxlAaQIMYAp2gwZieWx+p0xYKkajkpLdf0r06v9doXiiZh8XSh7i9sj
         5Y2g==
X-Gm-Message-State: APjAAAXvXclrv5u48mooa/mIuLjvUW95kOw8AM7EpjSioBNA/3qSieIX
        jsvdNkwpVwFoSXqcZ1XlQ7rOrwfpQANYDA==
X-Google-Smtp-Source: APXvYqxqktalCXTHDJZqDJ6u4XMvyejBheoyFOMli7k8odpXoDaEnOOM42F0FVbxFcT6z/4zuTKetA==
X-Received: by 2002:a9d:39a5:: with SMTP id y34mr10087733otb.146.1576786588066;
        Thu, 19 Dec 2019 12:16:28 -0800 (PST)
Received: from C02VM0LMHTDD.cfops.it ([198.41.128.1])
        by smtp.gmail.com with ESMTPSA id g19sm2473561otj.81.2019.12.19.12.16.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 19 Dec 2019 12:16:27 -0800 (PST)
From:   Alex Forster <aforster@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     Alex Forster <aforster@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH bpf-next] libbpf: fix AF_XDP helper program to support kernels without the JMP32 eBPF instruction class
Date:   Thu, 19 Dec 2019 14:16:01 -0600
Message-Id: <20191219201601.7378-1-aforster@cloudflare.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel 5.1 introduced support for the JMP32 eBPF instruction class, and commit d7d962a modified the libbpf AF_XDP helper program to use the BPF_JMP32_IMM instruction. For those on earlier kernels, attempting to load the helper program now results in the verifier failing with "unknown opcode 66". This change replaces the usage of BPF_JMP32_IMM with BPF_JMP_IMM for compatibility with pre-5.1 kernels.

Signed-off-by: Alex Forster <aforster@cloudflare.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Björn Töpel <bjorn.topel@intel.com>
---
 tools/lib/bpf/xsk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 8e0ffa800a71..761f8485b80e 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -366,7 +366,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 		/* call bpf_redirect_map */
 		BPF_EMIT_CALL(BPF_FUNC_redirect_map),
 		/* if w0 != 0 goto pc+13 */
-		BPF_JMP32_IMM(BPF_JSGT, BPF_REG_0, 0, 13),
+		BPF_JMP_IMM(BPF_JSGT, BPF_REG_0, 0, 13),
 		/* r2 = r10 */
 		BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
 		/* r2 += -4 */
-- 
2.23.0

