Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53C104EE5C2
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 03:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbiDABkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 21:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241841AbiDABkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 21:40:09 -0400
X-Greylist: delayed 245 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 31 Mar 2022 18:38:18 PDT
Received: from 189.cn (ptr.189.cn [183.61.185.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9F48BC11;
        Thu, 31 Mar 2022 18:38:17 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.43:55786.717889391
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-123.150.8.43 (unknown [10.64.8.43])
        by 189.cn (HERMES) with SMTP id 3FC9110023C;
        Fri,  1 Apr 2022 09:34:09 +0800 (CST)
Received: from  ([123.150.8.43])
        by gateway-153622-dep-749df8664c-nmrf6 with ESMTP id dd0746ef3fd74dcf991a4b4269762705 for ast@kernel.org;
        Fri, 01 Apr 2022 09:34:11 CST
X-Transaction-ID: dd0746ef3fd74dcf991a4b4269762705
X-Real-From: chensong_2000@189.cn
X-Receive-IP: 123.150.8.43
X-MEDUSA-Status: 0
Sender: chensong_2000@189.cn
From:   Song Chen <chensong_2000@189.cn>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Song Chen <chensong_2000@189.cn>
Subject: [PATCH] sample: bpf: syscall_tp_kern: add dfd before filename
Date:   Fri,  1 Apr 2022 09:40:46 +0800
Message-Id: <1648777246-21352-1-git-send-email-chensong_2000@189.cn>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When i was writing my eBPF program, i copied some pieces of code from
syscall_tp, syscall_tp_kern only records how many files are opened, but
mine needs to print file name.I reused struct syscalls_enter_open_args,
which is defined as:

struct syscalls_enter_open_args {
	unsigned long long unused;
	long syscall_nr;
	long filename_ptr;
        long flags;
        long mode;
};

I tried to use filename_ptr, but it's not the pointer of filename, flags
turns out to be the pointer I'm looking for, there might be something
missed in the struct.

I read the ftrace log, found the missed one is dfd, which is supposed to be
placed in between syscall_nr and filename_ptr.

Actually syscall_tp has nothing to do with dfd, it can run anyway without
it, but it's better to have it to make it a better eBPF sample, especially
to new eBPF programmers, then i fixed it.

Signed-off-by: Song Chen <chensong_2000@189.cn>
---
 samples/bpf/syscall_tp_kern.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/syscall_tp_kern.c b/samples/bpf/syscall_tp_kern.c
index 50231c2eff9c..e4ac818aee57 100644
--- a/samples/bpf/syscall_tp_kern.c
+++ b/samples/bpf/syscall_tp_kern.c
@@ -7,6 +7,7 @@
 struct syscalls_enter_open_args {
 	unsigned long long unused;
 	long syscall_nr;
+	long dfd_ptr;
 	long filename_ptr;
 	long flags;
 	long mode;
-- 
2.25.1

