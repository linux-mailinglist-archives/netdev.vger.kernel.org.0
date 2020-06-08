Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A431F2DD0
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgFHXNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729551AbgFHXNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADBF7214D8;
        Mon,  8 Jun 2020 23:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658022;
        bh=O4sIm0dMTHqRZCNxs3PMb5hcgRJULMMM54RSsYvmZzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F1yw1wz+uI9OEFQsyy85GOQZGHGC3KoGlB+D/SIm0JmdbSTAmmD1l3wts9O9c//c6
         ic/0LubGEJyDE4eQxEaPXgyJbTzL7zLwOZb0IVHgz4KJJTij391/f4h86OZSLw2S8F
         MGGaJuS01F2kLvG7WOQmjW/T54rB3TZcAW3IkKb8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 075/606] bpf: Enforce returning 0 for fentry/fexit progs
Date:   Mon,  8 Jun 2020 19:03:20 -0400
Message-Id: <20200608231211.3363633-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

commit e92888c72fbdc6f9d07b3b0604c012e81d7c0da7 upstream.

Currently, tracing/fentry and tracing/fexit prog
return values are not enforced. In trampoline codes,
the fentry/fexit prog return values are ignored.
Let us enforce it to be 0 to avoid confusion and
allows potential future extension.

This patch also explicitly added return value
checking for tracing/raw_tp, tracing/fmod_ret,
and freplace programs such that these program
return values can be anything. The purpose are
two folds:
 1. to make it explicit about return value expectations
    for these programs in verifier.
 2. for tracing prog_type, if a future attach type
    is added, the default is -ENOTSUPP which will
    enforce to specify return value ranges explicitly.

Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200514053206.1298415-1-yhs@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1c53ccbd5b5d..c1bb5be530e9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6498,6 +6498,22 @@ static int check_return_code(struct bpf_verifier_env *env)
 			return 0;
 		range = tnum_const(0);
 		break;
+	case BPF_PROG_TYPE_TRACING:
+		switch (env->prog->expected_attach_type) {
+		case BPF_TRACE_FENTRY:
+		case BPF_TRACE_FEXIT:
+			range = tnum_const(0);
+			break;
+		case BPF_TRACE_RAW_TP:
+			return 0;
+		default:
+			return -ENOTSUPP;
+		}
+		break;
+	case BPF_PROG_TYPE_EXT:
+		/* freplace program can return anything as its return value
+		 * depends on the to-be-replaced kernel func or bpf program.
+		 */
 	default:
 		return 0;
 	}
-- 
2.25.1

