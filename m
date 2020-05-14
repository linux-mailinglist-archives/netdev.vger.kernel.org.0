Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50011D3641
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgENQSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:18:11 -0400
Received: from www62.your-server.de ([213.133.104.62]:36478 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgENQSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:18:11 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jZGYg-00017m-GJ; Thu, 14 May 2020 18:18:06 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, mhiramat@kernel.org,
        brendan.d.gregg@gmail.com, hch@lst.de, john.fastabend@gmail.com,
        yhs@fb.com, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf 2/3] bpf: add bpf_probe_read_{user, kernel}_str() to do_refine_retval_range
Date:   Thu, 14 May 2020 18:16:06 +0200
Message-Id: <20200514161607.9212-3-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200514161607.9212-1-daniel@iogearbox.net>
References: <20200514161607.9212-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25812/Thu May 14 14:13:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given bpf_probe_read{,str}() BPF helpers are now only available under
CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE, we need to add the drop-in
replacements of bpf_probe_read_{kernel,user}_str() to do_refine_retval_range()
as well to avoid hitting the same issue as in 849fa50662fbc ("bpf/verifier:
refine retval R0 state for bpf_get_stack helper").

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/verifier.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fa1d8245b925..ac922b0d3b00 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4340,7 +4340,9 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
 
 	if (ret_type != RET_INTEGER ||
 	    (func_id != BPF_FUNC_get_stack &&
-	     func_id != BPF_FUNC_probe_read_str))
+	     func_id != BPF_FUNC_probe_read_str &&
+	     func_id != BPF_FUNC_probe_read_kernel_str &&
+	     func_id != BPF_FUNC_probe_read_user_str))
 		return;
 
 	ret_reg->smax_value = meta->msize_max_value;
-- 
2.21.0

