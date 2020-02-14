Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA2C15F368
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404281AbgBNSLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:11:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:32780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731267AbgBNPxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:53:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1852F24676;
        Fri, 14 Feb 2020 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695610;
        bh=AM/cxaMLSs+1tt+XbdmWhg83uD3mrehTan0F9wpp1Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nonzCETK6MpkL+LcSar/aVLQUg3zYVmesDa9mpX9cPeCIyO8PCAo7anf4PTT0gS9g
         VZxgm7D+y23LLpgzDWBU/z1+wLz71Z4jSiWEBWJaRBRx4W9dZBaZfnRCNaCBtFA/so
         Nk9vmVWDeZPyq0i0n41ONx8l6V7sH0W+O4wGDTbk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.5 212/542] samples/bpf: Set -fno-stack-protector when building BPF programs
Date:   Fri, 14 Feb 2020 10:43:24 -0500
Message-Id: <20200214154854.6746-212-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 450278977acbf494a20367c22fbb38729772d1fc ]

It seems Clang can in some cases turn on stack protection by default, which
doesn't work with BPF. This was reported once before[0], but it seems the
flag to explicitly turn off the stack protector wasn't added to the
Makefile, so do that now.

The symptom of this is compile errors like the following:

error: <unknown>:0:0: in function bpf_prog1 i32 (%struct.__sk_buff*): A call to built-in function '__stack_chk_fail' is not supported.

[0] https://www.spinics.net/lists/netdev/msg556400.html

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20191216103819.359535-1-toke@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index c0147a8cf1882..06ebe3104cc03 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -236,6 +236,7 @@ BTF_LLVM_PROBE := $(shell echo "int main() { return 0; }" | \
 			  readelf -S ./llvm_btf_verify.o | grep BTF; \
 			  /bin/rm -f ./llvm_btf_verify.o)
 
+BPF_EXTRA_CFLAGS += -fno-stack-protector
 ifneq ($(BTF_LLVM_PROBE),)
 	BPF_EXTRA_CFLAGS += -g
 else
-- 
2.20.1

