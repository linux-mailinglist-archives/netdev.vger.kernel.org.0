Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03AAE61EB9
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730944AbfGHMqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:46:25 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:40887 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGHMqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:46:24 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MMoXC-1i3ErY1LKW-00Ikwr; Mon, 08 Jul 2019 14:45:48 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] Revert "bpf: Fix ORC unwinding in non-JIT BPF code"
Date:   Mon,  8 Jul 2019 14:45:23 +0200
Message-Id: <20190708124547.3515538-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dpxQFSIW823RM1QEm3jyJ5Ha9S1hG/XgAyEwAb3Bq2BvwHXqmM/
 IMvuMeO0a9ZBslErXc907kOvrpZhGClXPWQ0MV/6wEMhDCIPsSZvjkEVXkhWrGM0uB572cV
 I1EsBb6U3wlPhkXTdSAOzNmpNgkNIliOOeruG1o7av3v/bs0YBkmJ4LELIHhHO6CvrN1tNH
 yDwqfhVgZr6YvA0uE5VAw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eJXlBJYTykY=:SOrJNMR1+bV+vkq0dCEYi3
 9wdptLA35N9QnDbxnKJ8XlfW01u3+UZR71IYehoLlQGqlp6yxRvgKjfM0wRAX41aWiTk6vrI7
 jLnS5/Zsk5Omaxtg+ovyWkZadQs0oKJwQmuPzwiIFIAK2K30wQNgEs1Wy9NzXG2rijFKpUC8O
 xgVlz2c2bOcZbZPjrpEgZGgN8avGEen+RI0QoW1gngnkN8SQj6R2WflkAVtFti7tvATzospdj
 0APFlxxT0HCtClop/Fl2ug7gS0KnDNF5PCJL88+YLQD4NtuX2wTzMugnUbcs3vVHkcyOMUhmP
 SKStL8u5kyRJJelounUII8CjBLEST1q358hMnABRsJHPpzY+pj9on0bKJig+DWGzC7g3OV7wi
 5XfVnIX5M9V2Fw1UoFjrF2svlUSL/Ss/vYszc7WwLMM6BJMANY61OfRZpktc8Q/9F0QUAau3M
 OBBoRsZDZLkv13OgSyjwzTe0/apm3BT4gTmv79ddRHuRau3GJy6e3DJTc3dWMqXlt9o4cAuuD
 uFwWJBUXNsu5T+y2lNu6BcLRVVZtIvA0YcwvPTwgrE8tDYkgh+WZhJxvtfztzHOg5SThJGP7q
 4Piu6LAjQ0EQNidgovzkoKEfbpa5koKHhSFs5YSPLrgFnzpStx2AHdMCOfUS6FbWhmL8hUqi3
 6PKIJMkD4fZVS8lXYbU4wBoty9nYPvp8EhuBYHyT53Ab6LATBIAJnDIc4yGNS8o9bN2eGtOBd
 oZ+b4mrmMoSdLhr/iB2xH7uq8G0+s1WE96epGw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Apparently this was a bit premature, at least I still get this
warning with gcc-8.1:

kernel/bpf/core.o: warning: objtool: ___bpf_prog_run()+0x44d2: sibling call from callable instruction with modified stack frame

This reverts commit b22cf36c189f31883ad0238a69ccf82aa1f3b16b.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/bpf/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 7e98f36a14e2..16079550db6d 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1299,7 +1299,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 {
 #define BPF_INSN_2_LBL(x, y)    [BPF_##x | BPF_##y] = &&x##_##y
 #define BPF_INSN_3_LBL(x, y, z) [BPF_##x | BPF_##y | BPF_##z] = &&x##_##y##_##z
-	static const void * const jumptable[256] __annotate_jump_table = {
+	static const void *jumptable[256] = {
 		[0 ... 255] = &&default_label,
 		/* Now overwrite non-defaults ... */
 		BPF_INSN_MAP(BPF_INSN_2_LBL, BPF_INSN_3_LBL),
@@ -1558,6 +1558,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn, u64 *stack)
 		BUG_ON(1);
 		return 0;
 }
+STACK_FRAME_NON_STANDARD(___bpf_prog_run); /* jump table */
 
 #define PROG_NAME(stack_size) __bpf_prog_run##stack_size
 #define DEFINE_BPF_PROG_RUN(stack_size) \
-- 
2.20.0

