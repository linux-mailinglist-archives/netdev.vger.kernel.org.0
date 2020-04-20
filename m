Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5BE1B08EC
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 14:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgDTMLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 08:11:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:37360 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726262AbgDTMLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 08:11:00 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id A93B0B3CD1E906072D21;
        Mon, 20 Apr 2020 20:10:51 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Apr 2020
 20:10:45 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <udknight@gmail.com>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
        <x86@kernel.org>, <hpa@zytor.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <andriin@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@chromium.org>, <lukenels@cs.washington.edu>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] bpf, x32: remove unneeded conversion to bool
Date:   Mon, 20 Apr 2020 20:37:27 +0800
Message-ID: <20200420123727.3616-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '==' expression itself is bool, no need to convert it to bool again.
This fixes the following coccicheck warning:

arch/x86/net/bpf_jit_comp32.c:1478:50-55: WARNING: conversion to bool
not needed here
arch/x86/net/bpf_jit_comp32.c:1479:50-55: WARNING: conversion to bool
not needed here

Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 arch/x86/net/bpf_jit_comp32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp32.c b/arch/x86/net/bpf_jit_comp32.c
index 4d2a7a764602..b41ba3517819 100644
--- a/arch/x86/net/bpf_jit_comp32.c
+++ b/arch/x86/net/bpf_jit_comp32.c
@@ -1475,8 +1475,8 @@ static int do_jit(struct bpf_prog *bpf_prog, int *addrs, u8 *image,
 	for (i = 0; i < insn_cnt; i++, insn++) {
 		const s32 imm32 = insn->imm;
 		const bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
-		const bool dstk = insn->dst_reg == BPF_REG_AX ? false : true;
-		const bool sstk = insn->src_reg == BPF_REG_AX ? false : true;
+		const bool dstk = insn->dst_reg != BPF_REG_AX;
+		const bool sstk = insn->src_reg != BPF_REG_AX;
 		const u8 code = insn->code;
 		const u8 *dst = bpf2ia32[insn->dst_reg];
 		const u8 *src = bpf2ia32[insn->src_reg];
-- 
2.21.1

