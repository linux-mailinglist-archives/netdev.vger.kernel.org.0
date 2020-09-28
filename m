Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849CA27AA25
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 11:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgI1JBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 05:01:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:56448 "EHLO
        mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1JBs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 05:01:48 -0400
Received: from ALA-HCB.corp.ad.wrs.com (ala-hcb.corp.ad.wrs.com [147.11.189.41])
        by mail1.windriver.com (8.15.2/8.15.2) with ESMTPS id 08S91MsO013707
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Mon, 28 Sep 2020 02:01:22 -0700 (PDT)
Received: from pek-lpg-core2.corp.ad.wrs.com (128.224.153.41) by
 ALA-HCB.corp.ad.wrs.com (147.11.189.41) with Microsoft SMTP Server id
 14.3.487.0; Mon, 28 Sep 2020 02:01:15 -0700
From:   <zhe.he@windriver.com>
To:     <gustavo@embeddedor.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <zhe.he@windriver.com>
Subject: [PATCH] powerpc: net: bpf_jit_comp: Fix misuse of fallthrough
Date:   Mon, 28 Sep 2020 17:00:23 +0800
Message-ID: <20200928090023.38117-1-zhe.he@windriver.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: He Zhe <zhe.he@windriver.com>

The user defined label following "fallthrough" is not considered by GCC
and causes build failure.

kernel-source/include/linux/compiler_attributes.h:208:41: error: attribute
'fallthrough' not preceding a case label or default label [-Werror]
 208   define fallthrough _attribute((fallthrough_))
                          ^~~~~~~~~~~~~

Signed-off-by: He Zhe <zhe.he@windriver.com>
---
 arch/powerpc/net/bpf_jit_comp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/net/bpf_jit_comp.c b/arch/powerpc/net/bpf_jit_comp.c
index 78d61f97371e..e809cb5a1631 100644
--- a/arch/powerpc/net/bpf_jit_comp.c
+++ b/arch/powerpc/net/bpf_jit_comp.c
@@ -475,7 +475,6 @@ static int bpf_jit_build_body(struct bpf_prog *fp, u32 *image,
 		case BPF_JMP | BPF_JSET | BPF_K:
 		case BPF_JMP | BPF_JSET | BPF_X:
 			true_cond = COND_NE;
-			fallthrough;
 		cond_branch:
 			/* same targets, can avoid doing the test :) */
 			if (filter[i].jt == filter[i].jf) {
-- 
2.26.2

