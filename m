Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D754E4AF3
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 03:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241303AbiCWCgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 22:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiCWCgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 22:36:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E39670062;
        Tue, 22 Mar 2022 19:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30AF2B81DD9;
        Wed, 23 Mar 2022 02:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA68EC340F2;
        Wed, 23 Mar 2022 02:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648002893;
        bh=cORONT9KFjGjK1waRa5byQPgHZgQsfuIcAEnv79p6NE=;
        h=From:To:Cc:Subject:Date:From;
        b=d9VXbx220K9vFoNmWvuXW0JejxOyab0sfAIx3GmPRVZpTuEN7wOmZ0DvrH6fvCL9X
         RYzvv9WeeMkVHqFHyWXcUfCe6adsb1Xxi8ujVPP+dWM9teAoI2CHqzeC0IkwiW0GiX
         Ld5j7PtMuy7FE/Ry2Klamn4ATqiF9O0xms8XB2a14UKr6gCDd7xsR4QcnBN3pouNQl
         rPwKTzwcQrT2I/Z5voYFHPuCpv2hyobBJfS1z1snnu+kRYloeeDEWx6XyqrPZw2nia
         eqVPddE4l9RdKvtedulD2jLD4CEcjza7qacDzJZtXFM5pYr7/qFz+MebFCVqT7gtjE
         lgFztLflsHRtQ==
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v13 bpf-next 0/1] fprobe: Introduce fprobe function entry/exit probe 
Date:   Wed, 23 Mar 2022 11:34:46 +0900
Message-Id: <164800288611.1716332.7053663723617614668.stgit@devnote2>
X-Mailer: git-send-email 2.25.1
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Here is the 13th version of rethook x86 port. This is developed for a part
of fprobe series [1] for hooking function return. But since I forgot to send
it to arch maintainers, that caused conflict with IBT and SLS mitigation series.
Now I picked the x86 rethook part and send it to x86 maintainers to be
reviewed.

[1] https://lore.kernel.org/all/164735281449.1084943.12438881786173547153.stgit@devnote2/T/#u

Note that this patch is still for the bpf-next since the rethook itself
is on the bpf-next tree. But since this also uses the ANNOTATE_NOENDBR
macro which has been introduced by IBT/ENDBR patch, to build this series
you need to merge the tip/master branch with the bpf-next.
(hopefully, it is rebased soon)

The fprobe itself is for providing the function entry/exit probe
with multiple probe point. The rethook is a sub-feature to hook the
function return as same as kretprobe does. Eventually, I would like
to replace the kretprobe's trampoline with this rethook.

Thank you,

---

Masami Hiramatsu (1):
      rethook: x86: Add rethook x86 implementation


 arch/x86/Kconfig                 |    1 
 arch/x86/include/asm/unwind.h    |    8 ++-
 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/kprobes/common.h |    1 
 arch/x86/kernel/rethook.c        |  121 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 131 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/rethook.c

--
Masami Hiramatsu (Linaro) <mhiramat@kernel.org>
