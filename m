Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127262DBE76
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 11:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgLPKRo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 05:17:44 -0500
Received: from pegase1.c-s.fr ([93.17.236.30]:42635 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgLPKRo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 05:17:44 -0500
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4CwrQp4HxPz9tyst;
        Wed, 16 Dec 2020 11:07:30 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id t0R5zxo6-F_R; Wed, 16 Dec 2020 11:07:30 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4CwrQp2splz9tysr;
        Wed, 16 Dec 2020 11:07:30 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 88DF78B7CA;
        Wed, 16 Dec 2020 11:07:31 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id xewPYISckelT; Wed, 16 Dec 2020 11:07:31 +0100 (CET)
Received: from localhost.localdomain (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5DFA48B7BA;
        Wed, 16 Dec 2020 11:07:30 +0100 (CET)
Received: by localhost.localdomain (Postfix, from userid 0)
        id 039556681D; Wed, 16 Dec 2020 10:07:29 +0000 (UTC)
Message-Id: <cover.1608112796.git.christophe.leroy@csgroup.eu>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: [RFC PATCH v1 0/7] Implement EBPF on powerpc32
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 16 Dec 2020 10:07:29 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series implements extended BPF on powerpc32. For the implementation
details, see the last patch.

Below are the results on a powerpc 885 at 132 MHz:
- with the patch, with and without bpf_jit_enable
- without the patch, with bpf_jit_enable (ie with CBPF)

With the patch, with bpf_jit_enable = 1 :

[   44.221346] test_bpf: #0 TAX jited:1 961 959 959 PASS
[   44.226287] test_bpf: #1 TXA jited:1 353 351 351 PASS
[   44.230722] test_bpf: #2 ADD_SUB_MUL_K jited:1 398 PASS
[   44.232591] test_bpf: #3 DIV_MOD_KX jited:1 914 PASS
[   44.235080] test_bpf: #4 AND_OR_LSH_K jited:1 3838 411 PASS
[   44.240892] test_bpf: #5 LD_IMM_0 jited:1 376 PASS
[   44.242773] test_bpf: #6 LD_IND jited:1 1075 1071 3584 PASS
[   44.250251] test_bpf: #7 LD_ABS jited:1 1114 1110 1110 PASS
[   44.255316] test_bpf: #8 LD_ABS_LL jited:1 4166 1686 PASS
[   44.262888] test_bpf: #9 LD_IND_LL jited:1 1128 1125 2599 PASS
[   44.269519] test_bpf: #10 LD_ABS_NET jited:1 1682 1641 PASS
[   44.274515] test_bpf: #11 LD_IND_NET jited:1 3729 1102 1102 PASS
[   44.282221] test_bpf: #12 LD_PKTTYPE jited:1 558 555 PASS
[   44.284998] test_bpf: #13 LD_MARK jited:1 323 2721 PASS
[   44.289640] test_bpf: #14 LD_RXHASH jited:1 322 320 PASS
[   44.291845] test_bpf: #15 LD_QUEUE jited:1 323 321 PASS
[   44.294053] test_bpf: #16 LD_PROTOCOL jited:1 801 4107 PASS
[   44.300752] test_bpf: #17 LD_VLAN_TAG jited:1 323 321 PASS
[   44.302964] test_bpf: #18 LD_VLAN_TAG_PRESENT jited:1 338 336 PASS
[   44.305199] test_bpf: #19 LD_IFINDEX jited:1 3689 374 PASS
[   44.310877] test_bpf: #20 LD_HATYPE jited:1 376 374 PASS
[   44.313204] test_bpf: #21 LD_CPU jited:1 710 708 PASS
[   44.316235] test_bpf: #22 LD_NLATTR jited:1 687 1058 PASS
[   44.322924] test_bpf: #23 LD_NLATTR_NEST jited:1 4327 6120 PASS
[   44.335178] test_bpf: #24 LD_PAYLOAD_OFF jited:1 12677 14527 PASS
[   44.364105] test_bpf: #25 LD_ANC_XOR jited:1 353 351 PASS
[   44.366398] test_bpf: #26 SPILL_FILL jited:1 520 517 517 PASS
[   44.372132] test_bpf: #27 JEQ jited:1 1121 646 631 PASS
[   44.376289] test_bpf: #28 JGT jited:1 1121 647 632 PASS
[   44.382895] test_bpf: #29 JGE (jt 0), test 1 jited:1 1121 647 2118 PASS
[   44.388579] test_bpf: #30 JGE (jt 0), test 2 jited:1 649 646 631 PASS
[   44.392265] test_bpf: #31 JGE jited:1 946 1020 3417 PASS
[   44.399473] test_bpf: #32 JSET jited:1 976 1042 1232 PASS
[   44.404637] test_bpf: #33 tcpdump port 22 jited:1 3662 1772 2022 PASS
[   44.414350] test_bpf: #34 tcpdump complex jited:1 2617 1757 3071 PASS
[   44.424143] test_bpf: #35 RET_A jited:1 322 321 PASS
[   44.426350] test_bpf: #36 INT: ADD trivial jited:1 345 PASS
[   44.430558] test_bpf: #37 INT: MUL_X jited:1 383 PASS
[   44.432380] test_bpf: #38 INT: MUL_X2 jited:1 406 PASS
[   44.434232] test_bpf: #39 INT: MUL32_X jited:1 360 PASS
[   44.436037] test_bpf: #40 INT: ADD 64-bit jited:1 2794 PASS
[   44.444862] test_bpf: #41 INT: ADD 32-bit jited:1 4093 PASS
[   44.450735] test_bpf: #42 INT: SUB jited:1 2276 PASS
[   44.454694] test_bpf: #43 INT: XOR jited:1 3705 PASS
[   44.459986] test_bpf: #44 INT: MUL jited:1 2420 PASS
[   44.463988] test_bpf: #45 MOV REG64 jited:1 854 PASS
[   44.466341] test_bpf: #46 MOV REG32 jited:1 855 PASS
[   44.472037] test_bpf: #47 LD IMM64 jited:1 855 PASS
[   44.474396] test_bpf: #48 INT: ALU MIX jited:0 5480 PASS
[   44.480792] test_bpf: #49 INT: shifts by register jited:1 924 PASS
[   44.483214] test_bpf: #50 check: missing ret PASS
[   44.483871] test_bpf: #51 check: div_k_0 PASS
[   44.484544] test_bpf: #52 check: unknown insn PASS
[   44.485212] test_bpf: #53 check: out of range spill/fill PASS
[   44.485880] test_bpf: #54 JUMPS + HOLES jited:1 908 PASS
[   44.496498] test_bpf: #55 check: RET X PASS
[   44.498658] test_bpf: #56 check: LDX + RET X PASS
[   44.499329] test_bpf: #57 M[]: alt STX + LDX jited:1 1455 PASS
[   44.502833] test_bpf: #58 M[]: full STX + full LDX jited:1 1318 PASS
[   44.506072] test_bpf: #59 check: SKF_AD_MAX PASS
[   44.510956] test_bpf: #60 LD [SKF_AD_OFF-1] jited:1 1091 PASS
[   44.513593] test_bpf: #61 load 64-bit immediate jited:1 413 PASS
[   44.515475] test_bpf: #62 ALU_MOV_X: dst = 2 jited:1 3535 PASS
[   44.520461] test_bpf: #63 ALU_MOV_X: dst = 4294967295 jited:1 231 PASS
[   44.522115] test_bpf: #64 ALU64_MOV_X: dst = 2 jited:1 231 PASS
[   44.523783] test_bpf: #65 ALU64_MOV_X: dst = 4294967295 jited:1 231 PASS
[   44.525431] test_bpf: #66 ALU_MOV_K: dst = 2 jited:1 4444 PASS
[   44.531319] test_bpf: #67 ALU_MOV_K: dst = 4294967295 jited:1 216 PASS
[   44.532955] test_bpf: #68 ALU_MOV_K: 0x0000ffffffff0000 = 0x00000000ffffffff jited:1 307 PASS
[   44.534697] test_bpf: #69 ALU64_MOV_K: dst = 2 jited:1 216 PASS
[   44.536327] test_bpf: #70 ALU64_MOV_K: dst = 2147483647 jited:1 224 PASS
[   44.542389] test_bpf: #71 ALU64_OR_K: dst = 0x0 jited:1 307 PASS
[   44.544136] test_bpf: #72 ALU64_MOV_K: dst = -1 jited:1 307 PASS
[   44.545880] test_bpf: #73 ALU_ADD_X: 1 + 2 = 3 jited:1 246 PASS
[   44.550913] test_bpf: #74 ALU_ADD_X: 1 + 4294967294 = 4294967295 jited:1 246 PASS
[   44.552581] test_bpf: #75 ALU_ADD_X: 2 + 4294967294 = 0 jited:1 300 PASS
[   44.554322] test_bpf: #76 ALU64_ADD_X: 1 + 2 = 3 jited:1 246 PASS
[   44.555990] test_bpf: #77 ALU64_ADD_X: 1 + 4294967294 = 4294967295 jited:1 246 PASS
[   44.561933] test_bpf: #78 ALU64_ADD_X: 2 + 4294967294 = 4294967296 jited:1 315 PASS
[   44.563688] test_bpf: #79 ALU_ADD_K: 1 + 2 = 3 jited:1 231 PASS
[   44.565338] test_bpf: #80 ALU_ADD_K: 3 + 0 = 3 jited:1 3554 PASS
[   44.570362] test_bpf: #81 ALU_ADD_K: 1 + 4294967294 = 4294967295 jited:1 231 PASS
[   44.572018] test_bpf: #82 ALU_ADD_K: 4294967294 + 2 = 0 jited:1 284 PASS
[   44.573740] test_bpf: #83 ALU_ADD_K: 0 + (-1) = 0x00000000ffffffff jited:1 300 PASS
[   44.575478] test_bpf: #84 ALU_ADD_K: 0 + 0xffff = 0xffff jited:1 4558 PASS
[   44.581505] test_bpf: #85 ALU_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:1 315 PASS
[   44.583266] test_bpf: #86 ALU_ADD_K: 0 + 0x80000000 = 0x80000000 jited:1 300 PASS
[   44.585006] test_bpf: #87 ALU_ADD_K: 0 + 0x80008000 = 0x80008000 jited:1 315 PASS
[   44.590076] test_bpf: #88 ALU64_ADD_K: 1 + 2 = 3 jited:1 231 PASS
[   44.591735] test_bpf: #89 ALU64_ADD_K: 3 + 0 = 3 jited:1 216 PASS
[   44.593377] test_bpf: #90 ALU64_ADD_K: 1 + 2147483646 = 2147483647 jited:1 247 PASS
[   44.595047] test_bpf: #91 ALU64_ADD_K: 4294967294 + 2 = 4294967296 jited:1 299 PASS
[   44.601011] test_bpf: #92 ALU64_ADD_K: 2147483646 + -2147483647 = -1 jited:1 254 PASS
[   44.602688] test_bpf: #93 ALU64_ADD_K: 1 + 0 = 1 jited:1 284 PASS
[   44.604411] test_bpf: #94 ALU64_ADD_K: 0 + (-1) = 0xffffffffffffffff jited:1 299 PASS
[   44.606146] test_bpf: #95 ALU64_ADD_K: 0 + 0xffff = 0xffff jited:1 322 PASS
[   44.612194] test_bpf: #96 ALU64_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:1 322 PASS
[   44.613980] test_bpf: #97 ALU64_ADD_K: 0 + 0x80000000 = 0xffffffff80000000 jited:1 307 PASS
[   44.615732] test_bpf: #98 ALU_ADD_K: 0 + 0x80008000 = 0xffffffff80008000 jited:1 322 PASS
[   44.620859] test_bpf: #99 ALU_SUB_X: 3 - 1 = 2 jited:1 246 PASS
[   44.622532] test_bpf: #100 ALU_SUB_X: 4294967295 - 4294967294 = 1 jited:1 246 PASS
[   44.624197] test_bpf: #101 ALU64_SUB_X: 3 - 1 = 2 jited:1 246 PASS
[   44.625867] test_bpf: #102 ALU64_SUB_X: 4294967295 - 4294967294 = 1 jited:1 246 PASS
[   44.631809] test_bpf: #103 ALU_SUB_K: 3 - 1 = 2 jited:1 231 PASS
[   44.633461] test_bpf: #104 ALU_SUB_K: 3 - 0 = 3 jited:1 224 PASS
[   44.635102] test_bpf: #105 ALU_SUB_K: 4294967295 - 4294967294 = 1 jited:1 231 PASS
[   44.640067] test_bpf: #106 ALU64_SUB_K: 3 - 1 = 2 jited:1 231 PASS
[   44.641722] test_bpf: #107 ALU64_SUB_K: 3 - 0 = 3 jited:1 216 PASS
[   44.643358] test_bpf: #108 ALU64_SUB_K: 4294967294 - 4294967295 = -1 jited:1 231 PASS
[   44.645009] test_bpf: #109 ALU64_ADD_K: 2147483646 - 2147483647 = -1 jited:1 254 PASS
[   44.651198] test_bpf: #110 ALU_MUL_X: 2 * 3 = 6 jited:1 246 PASS
[   44.652877] test_bpf: #111 ALU_MUL_X: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:1 254 PASS
[   44.654558] test_bpf: #112 ALU_MUL_X: -1 * -1 = 1 jited:1 246 PASS
[   44.656250] test_bpf: #113 ALU64_MUL_X: 2 * 3 = 6 jited:1 292 PASS
[   44.662255] test_bpf: #114 ALU64_MUL_X: 1 * 2147483647 = 2147483647 jited:1 299 PASS
[   44.663980] test_bpf: #115 ALU_MUL_K: 2 * 3 = 6 jited:1 231 PASS
[   44.665632] test_bpf: #116 ALU_MUL_K: 3 * 1 = 3 jited:1 231 PASS
[   44.670759] test_bpf: #117 ALU_MUL_K: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:1 246 PASS
[   44.672437] test_bpf: #118 ALU_MUL_K: 1 * (-1) = 0x00000000ffffffff jited:1 300 PASS
[   44.674177] test_bpf: #119 ALU64_MUL_K: 2 * 3 = 6 jited:1 269 PASS
[   44.675872] test_bpf: #120 ALU64_MUL_K: 3 * 1 = 3 jited:1 216 PASS
[   44.681782] test_bpf: #121 ALU64_MUL_K: 1 * 2147483647 = 2147483647 jited:1 277 PASS
[   44.683486] test_bpf: #122 ALU64_MUL_K: 1 * -2147483647 = -2147483647 jited:1 284 PASS
[   44.685195] test_bpf: #123 ALU64_MUL_K: 1 * (-1) = 0xffffffffffffffff jited:1 3624 PASS
[   44.690294] test_bpf: #124 ALU_DIV_X: 6 / 2 = 3 jited:1 277 PASS
[   44.691995] test_bpf: #125 ALU_DIV_X: 4294967295 / 4294967295 = 1 jited:1 246 PASS
[   44.693666] test_bpf: #126 ALU64_DIV_X: 6 / 2 = 3 jited:0 1508 PASS
[   44.696074] test_bpf: #127 ALU64_DIV_X: 2147483647 / 2147483647 = 1 jited:0 1455 PASS
[   44.702724] test_bpf: #128 ALU64_DIV_X: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:0 2230 PASS
[   44.705856] test_bpf: #129 ALU_DIV_K: 6 / 2 = 3 jited:1 269 PASS
[   44.710003] test_bpf: #130 ALU_DIV_K: 3 / 1 = 3 jited:1 223 PASS
[   44.711645] test_bpf: #131 ALU_DIV_K: 4294967295 / 4294967295 = 1 jited:1 239 PASS
[   44.713332] test_bpf: #132 ALU_DIV_K: 0xffffffffffffffff / (-1) = 0x1 jited:1 307 PASS
[   44.715079] test_bpf: #133 ALU64_DIV_K: 6 / 2 = 3 jited:1 239 PASS
[   44.720968] test_bpf: #134 ALU64_DIV_K: 3 / 1 = 3 jited:1 216 PASS
[   44.722607] test_bpf: #135 ALU64_DIV_K: 2147483647 / 2147483647 = 1 jited:0 1318 PASS
[   44.724841] test_bpf: #136 ALU64_DIV_K: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:1 300 PASS
[   44.730859] test_bpf: #137 ALU_MOD_X: 3 % 2 = 1 jited:1 322 PASS
[   44.732614] test_bpf: #138 ALU_MOD_X: 4294967295 % 4294967293 = 2 jited:1 261 PASS
[   44.734304] test_bpf: #139 ALU64_MOD_X: 3 % 2 = 1 jited:0 1599 PASS
[   44.739214] test_bpf: #140 ALU64_MOD_X: 2147483647 % 2147483645 = 2 jited:0 1546 PASS
[   44.741661] test_bpf: #141 ALU_MOD_K: 3 % 2 = 1 jited:1 231 PASS
[   44.743311] test_bpf: #142 ALU_MOD_K: 3 % 1 = 0 jited:1 PASS
[   44.744634] test_bpf: #143 ALU_MOD_K: 4294967295 % 4294967293 = 2 jited:1 269 PASS
[   44.746326] test_bpf: #144 ALU64_MOD_K: 3 % 2 = 1 jited:1 231 PASS
[   44.753171] test_bpf: #145 ALU64_MOD_K: 3 % 1 = 0 jited:1 PASS
[   44.754497] test_bpf: #146 ALU64_MOD_K: 2147483647 % 2147483645 = 2 jited:0 1409 PASS
[   44.759247] test_bpf: #147 ALU_AND_X: 3 & 2 = 2 jited:1 246 PASS
[   44.760916] test_bpf: #148 ALU_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:1 246 PASS
[   44.762582] test_bpf: #149 ALU64_AND_X: 3 & 2 = 2 jited:1 246 PASS
[   44.764256] test_bpf: #150 ALU64_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:1 246 PASS
[   44.765923] test_bpf: #151 ALU_AND_K: 3 & 2 = 2 jited:1 231 PASS
[   44.772799] test_bpf: #152 ALU_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:1 239 PASS
[   44.774459] test_bpf: #153 ALU64_AND_K: 3 & 2 = 2 jited:1 231 PASS
[   44.776113] test_bpf: #154 ALU64_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:1 231 PASS
[   44.781135] test_bpf: #155 ALU64_AND_K: 0x0000ffffffff0000 & 0x0 = 0x0000ffff00000000 jited:1 307 PASS
[   44.782891] test_bpf: #156 ALU64_AND_K: 0x0000ffffffff0000 & -1 = 0x0000ffffffffffff jited:1 315 PASS
[   44.784653] test_bpf: #157 ALU64_AND_K: 0xffffffffffffffff & -1 = 0xffffffffffffffff jited:1 300 PASS
[   44.786397] test_bpf: #158 ALU_OR_X: 1 | 2 = 3 jited:1 246 PASS
[   44.792370] test_bpf: #159 ALU_OR_X: 0x0 | 0xffffffff = 0xffffffff jited:1 246 PASS
[   44.794043] test_bpf: #160 ALU64_OR_X: 1 | 2 = 3 jited:1 246 PASS
[   44.795713] test_bpf: #161 ALU64_OR_X: 0 | 0xffffffff = 0xffffffff jited:1 246 PASS
[   44.800861] test_bpf: #162 ALU_OR_K: 1 | 2 = 3 jited:1 231 PASS
[   44.802515] test_bpf: #163 ALU_OR_K: 0 & 0xffffffff = 0xffffffff jited:1 239 PASS
[   44.804180] test_bpf: #164 ALU64_OR_K: 1 | 2 = 3 jited:1 223 PASS
[   44.805821] test_bpf: #165 ALU64_OR_K: 0 & 0xffffffff = 0xffffffff jited:1 239 PASS
[   44.811753] test_bpf: #166 ALU64_OR_K: 0x0000ffffffff0000 | 0x0 = 0x0000ffff00000000 jited:1 299 PASS
[   44.813494] test_bpf: #167 ALU64_OR_K: 0x0000ffffffff0000 | -1 = 0xffffffffffffffff jited:1 315 PASS
[   44.815282] test_bpf: #168 ALU64_OR_K: 0x000000000000000 | -1 = 0xffffffffffffffff jited:1 3654 PASS
[   44.820407] test_bpf: #169 ALU_XOR_X: 5 ^ 6 = 3 jited:1 246 PASS
[   44.822084] test_bpf: #170 ALU_XOR_X: 0x1 ^ 0xffffffff = 0xfffffffe jited:1 246 PASS
[   44.823755] test_bpf: #171 ALU64_XOR_X: 5 ^ 6 = 3 jited:1 246 PASS
[   44.825431] test_bpf: #172 ALU64_XOR_X: 1 ^ 0xffffffff = 0xfffffffe jited:1 4496 PASS
[   44.831380] test_bpf: #173 ALU_XOR_K: 5 ^ 6 = 3 jited:1 231 PASS
[   44.833038] test_bpf: #174 ALU_XOR_K: 1 ^ 0xffffffff = 0xfffffffe jited:1 239 PASS
[   44.834697] test_bpf: #175 ALU64_XOR_K: 5 ^ 6 = 3 jited:1 224 PASS
[   44.836344] test_bpf: #176 ALU64_XOR_K: 1 & 0xffffffff = 0xfffffffe jited:1 239 PASS
[   44.842268] test_bpf: #177 ALU64_XOR_K: 0x0000ffffffff0000 ^ 0x0 = 0x0000ffffffff0000 jited:1 300 PASS
[   44.844013] test_bpf: #178 ALU64_XOR_K: 0x0000ffffffff0000 ^ -1 = 0xffff00000000ffff jited:1 322 PASS
[   44.845778] test_bpf: #179 ALU64_XOR_K: 0x000000000000000 ^ -1 = 0xffffffffffffffff jited:1 307 PASS
[   44.850896] test_bpf: #180 ALU_LSH_X: 1 << 1 = 2 jited:1 246 PASS
[   44.852567] test_bpf: #181 ALU_LSH_X: 1 << 31 = 0x80000000 jited:1 246 PASS
[   44.854238] test_bpf: #182 ALU64_LSH_X: 1 << 1 = 2 jited:1 292 PASS
[   44.855957] test_bpf: #183 ALU64_LSH_X: 1 << 31 = 0x80000000 jited:1 292 PASS
[   44.861974] test_bpf: #184 ALU_LSH_K: 1 << 1 = 2 jited:1 231 PASS
[   44.863624] test_bpf: #185 ALU_LSH_K: 1 << 31 = 0x80000000 jited:1 231 PASS
[   44.865275] test_bpf: #186 ALU64_LSH_K: 1 << 1 = 2 jited:1 3664 PASS
[   44.870387] test_bpf: #187 ALU64_LSH_K: 1 << 31 = 0x80000000 jited:1 239 PASS
[   44.872046] test_bpf: #188 ALU_RSH_X: 2 >> 1 = 1 jited:1 246 PASS
[   44.873712] test_bpf: #189 ALU_RSH_X: 0x80000000 >> 31 = 1 jited:1 246 PASS
[   44.875382] test_bpf: #190 ALU64_RSH_X: 2 >> 1 = 1 jited:1 4522 PASS
[   44.881359] test_bpf: #191 ALU64_RSH_X: 0x80000000 >> 31 = 1 jited:1 292 PASS
[   44.883080] test_bpf: #192 ALU_RSH_K: 2 >> 1 = 1 jited:1 231 PASS
[   44.884727] test_bpf: #193 ALU_RSH_K: 0x80000000 >> 31 = 1 jited:1 231 PASS
[   44.886378] test_bpf: #194 ALU64_RSH_K: 2 >> 1 = 1 jited:1 239 PASS
[   44.892302] test_bpf: #195 ALU64_RSH_K: 0x80000000 >> 31 = 1 jited:1 239 PASS
[   44.893964] test_bpf: #196 ALU_ARSH_X: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:1 284 PASS
[   44.895678] test_bpf: #197 ALU_ARSH_K: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:1 238 PASS
[   44.900683] test_bpf: #198 ALU_NEG: -(3) = -3 jited:1 231 PASS
[   44.902331] test_bpf: #199 ALU_NEG: -(-3) = 3 jited:1 231 PASS
[   44.904002] test_bpf: #200 ALU64_NEG: -(3) = -3 jited:1 231 PASS
[   44.905646] test_bpf: #201 ALU64_NEG: -(-3) = 3 jited:1 231 PASS
[   44.911548] test_bpf: #202 ALU_END_FROM_BE 16: 0x0123456789abcdef -> 0xcdef jited:1 246 PASS
[   44.913218] test_bpf: #203 ALU_END_FROM_BE 32: 0x0123456789abcdef -> 0x89abcdef jited:1 284 PASS
[   44.914937] test_bpf: #204 ALU_END_FROM_BE 64: 0x0123456789abcdef -> 0x89abcdef jited:1 239 PASS
[   44.920873] test_bpf: #205 ALU_END_FROM_LE 16: 0x0123456789abcdef -> 0xefcd jited:1 261 PASS
[   44.922567] test_bpf: #206 ALU_END_FROM_LE 32: 0x0123456789abcdef -> 0xefcdab89 jited:1 315 PASS
[   44.924314] test_bpf: #207 ALU_END_FROM_LE 64: 0x0123456789abcdef -> 0x67452301 jited:1 315 PASS
[   44.926057] test_bpf: #208 ST_MEM_B: Store/Load byte: max negative jited:1 284 PASS
[   44.931304] test_bpf: #209 ST_MEM_B: Store/Load byte: max positive jited:1 284 PASS
[   44.933020] test_bpf: #210 STX_MEM_B: Store/Load byte: max negative jited:1 292 PASS
[   44.934739] test_bpf: #211 ST_MEM_H: Store/Load half word: max negative jited:1 292 PASS
[   44.936465] test_bpf: #212 ST_MEM_H: Store/Load half word: max positive jited:1 284 PASS
[   44.942440] test_bpf: #213 STX_MEM_H: Store/Load half word: max negative jited:1 300 PASS
[   44.944172] test_bpf: #214 ST_MEM_W: Store/Load word: max negative jited:1 284 PASS
[   44.945884] test_bpf: #215 ST_MEM_W: Store/Load word: max positive jited:1 292 PASS
[   44.951010] test_bpf: #216 STX_MEM_W: Store/Load word: max negative jited:1 292 PASS
[   44.952728] test_bpf: #217 ST_MEM_DW: Store/Load double word: max negative jited:1 300 PASS
[   44.954460] test_bpf: #218 ST_MEM_DW: Store/Load double word: max negative 2 jited:1 376 PASS
[   44.956285] test_bpf: #219 ST_MEM_DW: Store/Load double word: max positive jited:1 307 PASS
[   44.962325] test_bpf: #220 STX_MEM_DW: Store/Load double word: max negative jited:1 292 PASS
[   44.964043] test_bpf: #221 STX_XADD_W: Test: 0x12 + 0x10 = 0x22 jited:1 398 PASS
[   44.965876] test_bpf: #222 STX_XADD_W: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:1 PASS
[   44.970597] test_bpf: #223 STX_XADD_W: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:1 383 PASS
[   44.972412] test_bpf: #224 STX_XADD_W: X + 1 + 1 + 1 + ... jited:1 733404 PASS
[   45.722965] test_bpf: #225 STX_XADD_DW: Test: 0x12 + 0x10 = 0x22 jited:0 1523 PASS
[   45.725407] test_bpf: #226 STX_XADD_DW: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:0 PASS
[   45.726219] test_bpf: #227 STX_XADD_DW: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:0 1356 PASS
[   45.732066] test_bpf: #228 STX_XADD_DW: X + 1 + 1 + 1 + ... jited:0 1900755 PASS
[   47.634973] test_bpf: #229 JMP_EXIT jited:1 231 PASS
[   47.638312] test_bpf: #230 JMP_JA: Unconditional jump: if (true) return 1 jited:1 246 PASS
[   47.639994] test_bpf: #231 JMP_JSLT_K: Signed jump: if (-2 < -1) return 1 jited:1 292 PASS
[   47.641727] test_bpf: #232 JMP_JSLT_K: Signed jump: if (-1 < -1) return 0 jited:1 292 PASS
[   47.643453] test_bpf: #233 JMP_JSGT_K: Signed jump: if (-1 > -2) return 1 jited:1 292 PASS
[   47.645182] test_bpf: #234 JMP_JSGT_K: Signed jump: if (-1 > -1) return 0 jited:1 292 PASS
[   47.652218] test_bpf: #235 JMP_JSLE_K: Signed jump: if (-2 <= -1) return 1 jited:1 292 PASS
[   47.653971] test_bpf: #236 JMP_JSLE_K: Signed jump: if (-1 <= -1) return 1 jited:1 292 PASS
[   47.655697] test_bpf: #237 JMP_JSLE_K: Signed jump: value walk 1 jited:1 444 PASS
[   47.661481] test_bpf: #238 JMP_JSLE_K: Signed jump: value walk 2 jited:1 391 PASS
[   47.663320] test_bpf: #239 JMP_JSGE_K: Signed jump: if (-1 >= -2) return 1 jited:1 292 PASS
[   47.665050] test_bpf: #240 JMP_JSGE_K: Signed jump: if (-1 >= -1) return 1 jited:1 292 PASS
[   47.670131] test_bpf: #241 JMP_JSGE_K: Signed jump: value walk 1 jited:1 444 PASS
[   47.672032] test_bpf: #242 JMP_JSGE_K: Signed jump: value walk 2 jited:1 391 PASS
[   47.673863] test_bpf: #243 JMP_JGT_K: if (3 > 2) return 1 jited:1 284 PASS
[   47.675583] test_bpf: #244 JMP_JGT_K: Unsigned jump: if (-1 > 1) return 1 jited:1 284 PASS
[   47.681560] test_bpf: #245 JMP_JLT_K: if (2 < 3) return 1 jited:1 284 PASS
[   47.683282] test_bpf: #246 JMP_JGT_K: Unsigned jump: if (1 < -1) return 1 jited:1 300 PASS
[   47.685013] test_bpf: #247 JMP_JGE_K: if (3 >= 2) return 1 jited:1 284 PASS
[   47.690053] test_bpf: #248 JMP_JLE_K: if (2 <= 3) return 1 jited:1 284 PASS
[   47.691777] test_bpf: #249 JMP_JGT_K: if (3 > 2) return 1 (jump backwards) jited:1 315 PASS
[   47.693531] test_bpf: #250 JMP_JGE_K: if (3 >= 3) return 1 jited:1 284 PASS
[   47.695250] test_bpf: #251 JMP_JGT_K: if (2 < 3) return 1 (jump backwards) jited:1 4563 PASS
[   47.701308] test_bpf: #252 JMP_JLE_K: if (3 <= 3) return 1 jited:1 284 PASS
[   47.703028] test_bpf: #253 JMP_JNE_K: if (3 != 2) return 1 jited:1 284 PASS
[   47.704749] test_bpf: #254 JMP_JEQ_K: if (3 == 3) return 1 jited:1 284 PASS
[   47.706464] test_bpf: #255 JMP_JSET_K: if (0x3 & 0x2) return 1 jited:1 269 PASS
[   47.712431] test_bpf: #256 JMP_JSET_K: if (0x3 & 0xffffffff) return 1 jited:1 292 PASS
[   47.714157] test_bpf: #257 JMP_JSGT_X: Signed jump: if (-1 > -2) return 1 jited:1 300 PASS
[   47.715896] test_bpf: #258 JMP_JSGT_X: Signed jump: if (-1 > -1) return 0 jited:1 299 PASS
[   47.721009] test_bpf: #259 JMP_JSLT_X: Signed jump: if (-2 < -1) return 1 jited:1 300 PASS
[   47.722748] test_bpf: #260 JMP_JSLT_X: Signed jump: if (-1 < -1) return 0 jited:1 299 PASS
[   47.724484] test_bpf: #261 JMP_JSGE_X: Signed jump: if (-1 >= -2) return 1 jited:1 300 PASS
[   47.726221] test_bpf: #262 JMP_JSGE_X: Signed jump: if (-1 >= -1) return 1 jited:1 300 PASS
[   47.732255] test_bpf: #263 JMP_JSLE_X: Signed jump: if (-2 <= -1) return 1 jited:1 299 PASS
[   47.733995] test_bpf: #264 JMP_JSLE_X: Signed jump: if (-1 <= -1) return 1 jited:1 299 PASS
[   47.735730] test_bpf: #265 JMP_JGT_X: if (3 > 2) return 1 jited:1 299 PASS
[   47.740840] test_bpf: #266 JMP_JGT_X: Unsigned jump: if (-1 > 1) return 1 jited:1 300 PASS
[   47.742579] test_bpf: #267 JMP_JLT_X: if (2 < 3) return 1 jited:1 300 PASS
[   47.744342] test_bpf: #268 JMP_JLT_X: Unsigned jump: if (1 < -1) return 1 jited:1 300 PASS
[   47.746076] test_bpf: #269 JMP_JGE_X: if (3 >= 2) return 1 jited:1 299 PASS
[   47.752108] test_bpf: #270 JMP_JGE_X: if (3 >= 3) return 1 jited:1 300 PASS
[   47.753844] test_bpf: #271 JMP_JLE_X: if (2 <= 3) return 1 jited:1 299 PASS
[   47.755586] test_bpf: #272 JMP_JLE_X: if (3 <= 3) return 1 jited:1 300 PASS
[   47.760660] test_bpf: #273 JMP_JGE_X: ldimm64 test 1 jited:1 315 PASS
[   47.762419] test_bpf: #274 JMP_JGE_X: ldimm64 test 2 jited:1 299 PASS
[   47.764152] test_bpf: #275 JMP_JGE_X: ldimm64 test 3 jited:1 284 PASS
[   47.765877] test_bpf: #276 JMP_JLE_X: ldimm64 test 1 jited:1 315 PASS
[   47.771903] test_bpf: #277 JMP_JLE_X: ldimm64 test 2 jited:1 300 PASS
[   47.773640] test_bpf: #278 JMP_JLE_X: ldimm64 test 3 jited:1 284 PASS
[   47.775362] test_bpf: #279 JMP_JNE_X: if (3 != 2) return 1 jited:1 3621 PASS
[   47.780454] test_bpf: #280 JMP_JEQ_X: if (3 == 3) return 1 jited:1 299 PASS
[   47.782192] test_bpf: #281 JMP_JSET_X: if (0x3 & 0x2) return 1 jited:1 300 PASS
[   47.783929] test_bpf: #282 JMP_JSET_X: if (0x3 & 0xffffffff) return 1 jited:1 300 PASS
[   47.785664] test_bpf: #283 JMP_JA: Jump, gap, jump, ... jited:1 360 PASS
[   47.791922] test_bpf: #284 BPF_MAXINSNS: Maximum possible literals jited:1 345 PASS
[   47.839363] test_bpf: #285 BPF_MAXINSNS: Single literal jited:1 352 PASS
[   47.888467] test_bpf: #286 BPF_MAXINSNS: Run/add until end jited:1 432654 PASS
[   48.361618] test_bpf: #287 BPF_MAXINSNS: Too many instructions PASS
[   48.361718] test_bpf: #288 BPF_MAXINSNS: Very long jump jited:1 352 PASS
[   48.414403] test_bpf: #289 BPF_MAXINSNS: Ctx heavy transformations jited:1 576541 575917 PASS
[   49.618003] test_bpf: #290 BPF_MAXINSNS: Call heavy transformations jited:1 1913162 1913711 PASS
[   53.529851] test_bpf: #291 BPF_MAXINSNS: Jump heavy test jited:1 1006696 PASS
[   54.597995] test_bpf: #292 BPF_MAXINSNS: Very long jump backwards jited:1 292 PASS
[   54.614763] test_bpf: #293 BPF_MAXINSNS: Edge hopping nuthouse jited:1 182195 PASS
[   54.808894] test_bpf: #294 BPF_MAXINSNS: Jump, gap, jump, ... jited:1 1616 PASS
[   54.845845] test_bpf: #295 BPF_MAXINSNS: jump over MSH PASS
[   54.885253] test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:1 3431744 PASS
[   58.578051] test_bpf: #297 BPF_MAXINSNS: ld_abs+get_processor_id jited:1 1818785 PASS
[   60.538451] test_bpf: #298 LD_IND byte frag jited:1 2017 PASS
[   60.542080] test_bpf: #299 LD_IND halfword frag jited:1 2070 PASS
[   60.545746] test_bpf: #300 LD_IND word frag jited:1 2024 PASS
[   60.552944] test_bpf: #301 LD_IND halfword mixed head/frag jited:1 2366 PASS
[   60.558548] test_bpf: #302 LD_IND word mixed head/frag jited:1 2427 PASS
[   60.562580] test_bpf: #303 LD_ABS byte frag jited:1 2071 PASS
[   60.566258] test_bpf: #304 LD_ABS halfword frag jited:1 2108 PASS
[   60.573455] test_bpf: #305 LD_ABS word frag jited:1 3593 PASS
[   60.578678] test_bpf: #306 LD_ABS halfword mixed head/frag jited:1 2404 PASS
[   60.582697] test_bpf: #307 LD_ABS word mixed head/frag jited:1 2465 PASS
[   60.589163] test_bpf: #308 LD_IND byte default X jited:1 824 PASS
[   60.591533] test_bpf: #309 LD_IND byte positive offset jited:1 839 PASS
[   60.593918] test_bpf: #310 LD_IND byte negative offset jited:1 839 PASS
[   60.596306] test_bpf: #311 LD_IND byte positive offset, all ff jited:1 839 PASS
[   60.602973] test_bpf: #312 LD_IND byte positive offset, out of bounds jited:1 1067 PASS
[   60.605595] test_bpf: #313 LD_IND byte negative offset, out of bounds jited:1 1120 PASS
[   60.610699] test_bpf: #314 LD_IND byte negative offset, multiple calls jited:1 2971 PASS
[   60.615315] test_bpf: #315 LD_IND halfword positive offset jited:1 3272 PASS
[   60.620160] test_bpf: #316 LD_IND halfword negative offset jited:1 847 PASS
[   60.622560] test_bpf: #317 LD_IND halfword unaligned jited:1 847 PASS
[   60.624979] test_bpf: #318 LD_IND halfword positive offset, all ff jited:1 4182 PASS
[   60.630740] test_bpf: #319 LD_IND halfword positive offset, out of bounds jited:1 1075 PASS
[   60.633368] test_bpf: #320 LD_IND halfword negative offset, out of bounds jited:1 1121 PASS
[   60.636041] test_bpf: #321 LD_IND word positive offset jited:1 847 PASS
[   60.641822] test_bpf: #322 LD_IND word negative offset jited:1 847 PASS
[   60.644221] test_bpf: #323 LD_IND word unaligned (addr & 3 == 2) jited:1 847 PASS
[   60.649036] test_bpf: #324 LD_IND word unaligned (addr & 3 == 1) jited:1 847 PASS
[   60.651443] test_bpf: #325 LD_IND word unaligned (addr & 3 == 3) jited:1 3513 PASS
[   60.659765] test_bpf: #326 LD_IND word positive offset, all ff jited:1 847 PASS
[   60.662168] test_bpf: #327 LD_IND word positive offset, out of bounds jited:1 1075 PASS
[   60.664793] test_bpf: #328 LD_IND word negative offset, out of bounds jited:1 4580 PASS
[   60.670955] test_bpf: #329 LD_ABS byte jited:1 566 PASS
[   60.673083] test_bpf: #330 LD_ABS byte positive offset, all ff jited:1 566 PASS
[   60.675211] test_bpf: #331 LD_ABS byte positive offset, out of bounds jited:1 4583 PASS
[   60.681383] test_bpf: #332 LD_ABS byte negative offset, out of bounds load PASS
[   60.682057] test_bpf: #333 LD_ABS byte negative offset, in bounds jited:1 1068 PASS
[   60.684679] test_bpf: #334 LD_ABS byte negative offset, out of bounds jited:1 4466 PASS
[   60.690753] test_bpf: #335 LD_ABS byte negative offset, multiple calls jited:1 2865 PASS
[   60.695252] test_bpf: #336 LD_ABS halfword jited:1 3005 PASS
[   60.699852] test_bpf: #337 LD_ABS halfword unaligned jited:1 581 PASS
[   60.701997] test_bpf: #338 LD_ABS halfword positive offset, all ff jited:1 581 PASS
[   60.704139] test_bpf: #339 LD_ABS halfword positive offset, out of bounds jited:1 1113 PASS
[   60.710119] test_bpf: #340 LD_ABS halfword negative offset, out of bounds load PASS
[   60.710794] test_bpf: #341 LD_ABS halfword negative offset, in bounds jited:1 1068 PASS
[   60.713415] test_bpf: #342 LD_ABS halfword negative offset, out of bounds jited:1 1121 PASS
[   60.716085] test_bpf: #343 LD_ABS word jited:1 573 PASS
[   60.722529] test_bpf: #344 LD_ABS word unaligned (addr & 3 == 2) jited:1 573 PASS
[   60.724663] test_bpf: #345 LD_ABS word unaligned (addr & 3 == 1) jited:1 573 PASS
[   60.729186] test_bpf: #346 LD_ABS word unaligned (addr & 3 == 3) jited:1 573 PASS
[   60.731324] test_bpf: #347 LD_ABS word positive offset, all ff jited:1 573 PASS
[   60.733456] test_bpf: #348 LD_ABS word positive offset, out of bounds jited:1 1113 PASS
[   60.736129] test_bpf: #349 LD_ABS word negative offset, out of bounds load PASS
[   60.741054] test_bpf: #350 LD_ABS word negative offset, in bounds jited:1 1068 PASS
[   60.743668] test_bpf: #351 LD_ABS word negative offset, out of bounds jited:1 1121 PASS
[   60.746342] test_bpf: #352 LDX_MSH standalone, preserved A jited:1 680 PASS
[   60.751992] test_bpf: #353 LDX_MSH standalone, preserved A 2 jited:1 1250 PASS
[   60.754981] test_bpf: #354 LDX_MSH standalone, test result 1 jited:1 3111 PASS
[   60.759713] test_bpf: #355 LDX_MSH standalone, test result 2 jited:1 695 PASS
[   60.762003] test_bpf: #356 LDX_MSH standalone, negative offset jited:1 1128 PASS
[   60.764704] test_bpf: #357 LDX_MSH standalone, negative offset 2 jited:1 4539 PASS
[   60.770850] test_bpf: #358 LDX_MSH standalone, out of bounds jited:1 1144 PASS
[   60.773585] test_bpf: #359 ADD default X jited:1 337 PASS
[   60.775367] test_bpf: #360 ADD default A jited:1 3649 PASS
[   60.780484] test_bpf: #361 SUB default X jited:1 338 PASS
[   60.782267] test_bpf: #362 SUB default A jited:1 323 PASS
[   60.784018] test_bpf: #363 MUL default X jited:1 337 PASS
[   60.785796] test_bpf: #364 MUL default A jited:1 322 PASS
[   60.791944] test_bpf: #365 DIV default X jited:1 398 PASS
[   60.793807] test_bpf: #366 DIV default A jited:1 315 PASS
[   60.795550] test_bpf: #367 MOD default X jited:1 399 PASS
[   60.800981] test_bpf: #368 MOD default A jited:1 322 PASS
[   60.802765] test_bpf: #369 JMP EQ default A jited:1 376 PASS
[   60.804597] test_bpf: #370 JMP EQ default X jited:1 391 PASS
[   60.806450] test_bpf: #371 JNE signed compare, test 1 jited:1 338 PASS
[   60.812472] test_bpf: #372 JNE signed compare, test 2 jited:1 337 PASS
[   60.814252] test_bpf: #373 JNE signed compare, test 3 jited:1 353 PASS
[   60.816044] test_bpf: #374 JNE signed compare, test 4 jited:1 299 PASS
[   60.821134] test_bpf: #375 JNE signed compare, test 5 jited:1 284 PASS
[   60.822852] test_bpf: #376 JNE signed compare, test 6 jited:1 300 PASS
[   60.824582] test_bpf: #377 JNE signed compare, test 7 jited:1 444 PASS
[   60.826529] test_bpf: Summary: 378 PASSED, 0 FAILED, [354/366 JIT'ed]
[   60.831963] test_bpf: #0 gso_with_rx_frags PASS
[   60.832226] test_bpf: #1 gso_linear_no_head_frag PASS
[   60.832505] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

With the patch, with bpf_jit_enable = 0 :

[   44.813310] test_bpf: #0 TAX jited:0 4631 4356 4587 PASS
[   44.828345] test_bpf: #1 TXA jited:0 1591 1588 1588 PASS
[   44.834218] test_bpf: #2 ADD_SUB_MUL_K jited:0 4600 PASS
[   44.839746] test_bpf: #3 DIV_MOD_KX jited:0 4496 PASS
[   44.845193] test_bpf: #4 AND_OR_LSH_K jited:0 4648 2088 PASS
[   44.852914] test_bpf: #5 LD_IMM_0 jited:0 1583 PASS
[   44.855428] test_bpf: #6 LD_IND jited:0 6079 3522 3903 PASS
[   44.870086] test_bpf: #7 LD_ABS jited:0 5183 6692 5434 PASS
[   44.888547] test_bpf: #8 LD_ABS_LL jited:0 4815 6372 PASS
[   44.900795] test_bpf: #9 LD_IND_LL jited:0 3747 5257 3743 PASS
[   44.914693] test_bpf: #10 LD_ABS_NET jited:0 6283 4812 PASS
[   44.927217] test_bpf: #11 LD_IND_NET jited:0 3861 3720 5234 PASS
[   44.941183] test_bpf: #12 LD_PKTTYPE jited:0 3024 4533 PASS
[   44.949818] test_bpf: #13 LD_MARK jited:0 1287 1285 PASS
[   44.953396] test_bpf: #14 LD_RXHASH jited:0 1287 3718 PASS
[   44.959434] test_bpf: #15 LD_QUEUE jited:0 1287 1284 PASS
[   44.963011] test_bpf: #16 LD_PROTOCOL jited:0 6675 4235 PASS
[   44.975030] test_bpf: #17 LD_VLAN_TAG jited:0 2796 1284 PASS
[   44.980140] test_bpf: #18 LD_VLAN_TAG_PRESENT jited:0 1424 1421 PASS
[   44.983989] test_bpf: #19 LD_IFINDEX jited:0 1636 4074 PASS
[   44.990734] test_bpf: #20 LD_HATYPE jited:0 1637 1634 PASS
[   44.995012] test_bpf: #21 LD_CPU jited:0 5267 2831 PASS
[   45.004168] test_bpf: #22 LD_NLATTR jited:0 4447 3944 PASS
[   45.013609] test_bpf: #23 LD_NLATTR_NEST jited:0 10344 12479 PASS
[   45.037579] test_bpf: #24 LD_PAYLOAD_OFF jited:0 16006 18158 PASS
[   45.072822] test_bpf: #25 LD_ANC_XOR jited:0 1537 3047 PASS
[   45.078450] test_bpf: #26 SPILL_FILL jited:0 3047 3044 4555 PASS
[   45.090276] test_bpf: #27 JEQ jited:0 5309 4458 2970 PASS
[   45.104171] test_bpf: #28 JGT jited:0 6861 2956 3241 PASS
[   45.118401] test_bpf: #29 JGE (jt 0), test 1 jited:0 5345 5182 3455 PASS
[   45.133545] test_bpf: #30 JGE (jt 0), test 2 jited:0 5102 3455 3483 PASS
[   45.147079] test_bpf: #31 JGE jited:0 4666 6660 5133 PASS
[   45.164725] test_bpf: #32 JSET jited:0 5652 4540 5820 PASS
[   45.182011] test_bpf: #33 tcpdump port 22 jited:0 6867 9883 11338 PASS
[   45.211451] test_bpf: #34 tcpdump complex jited:0 6697 9653 20164 PASS
[   45.249369] test_bpf: #35 RET_A jited:0 1279 1276 PASS
[   45.252931] test_bpf: #36 INT: ADD trivial jited:0 1758 PASS
[   45.255562] test_bpf: #37 INT: MUL_X jited:0 4951 PASS
[   45.261403] test_bpf: #38 INT: MUL_X2 jited:0 1796 PASS
[   45.264067] test_bpf: #39 INT: MUL32_X jited:0 1759 PASS
[   45.269101] test_bpf: #40 INT: ADD 64-bit jited:0 26213 PASS
[   45.296219] test_bpf: #41 INT: ADD 32-bit jited:0 21607 PASS
[   45.320207] test_bpf: #42 INT: SUB jited:0 23141 PASS
[   45.344244] test_bpf: #43 INT: XOR jited:0 9981 PASS
[   45.355115] test_bpf: #44 INT: MUL jited:0 11675 PASS
[   45.367683] test_bpf: #45 MOV REG64 jited:0 5288 PASS
[   45.373843] test_bpf: #46 MOV REG32 jited:0 7760 PASS
[   45.382494] test_bpf: #47 LD IMM64 jited:0 6801 PASS
[   45.390180] test_bpf: #48 INT: ALU MIX jited:0 3035 PASS
[   45.394084] test_bpf: #49 INT: shifts by register jited:0 7049 PASS
[   45.402024] test_bpf: #50 check: missing ret PASS
[   45.402686] test_bpf: #51 check: div_k_0 PASS
[   45.403358] test_bpf: #52 check: unknown insn PASS
[   45.404027] test_bpf: #53 check: out of range spill/fill PASS
[   45.404697] test_bpf: #54 JUMPS + HOLES jited:0 10350 PASS
[   45.418033] test_bpf: #55 check: RET X PASS
[   45.418708] test_bpf: #56 check: LDX + RET X PASS
[   45.419378] test_bpf: #57 M[]: alt STX + LDX jited:0 15206 PASS
[   45.435895] test_bpf: #58 M[]: full STX + full LDX jited:0 10723 PASS
[   45.449362] test_bpf: #59 check: SKF_AD_MAX PASS
[   45.450026] test_bpf: #60 LD [SKF_AD_OFF-1] jited:0 3247 PASS
[   45.454212] test_bpf: #61 load 64-bit immediate jited:0 5747 PASS
[   45.460848] test_bpf: #62 ALU_MOV_X: dst = 2 jited:0 930 PASS
[   45.462648] test_bpf: #63 ALU_MOV_X: dst = 4294967295 jited:0 930 PASS
[   45.464452] test_bpf: #64 ALU64_MOV_X: dst = 2 jited:0 938 PASS
[   45.466264] test_bpf: #65 ALU64_MOV_X: dst = 4294967295 jited:0 937 PASS
[   45.472333] test_bpf: #66 ALU_MOV_K: dst = 2 jited:0 793 PASS
[   45.473997] test_bpf: #67 ALU_MOV_K: dst = 4294967295 jited:0 793 PASS
[   45.475667] test_bpf: #68 ALU_MOV_K: 0x0000ffffffff0000 = 0x00000000ffffffff jited:0 4753 PASS
[   45.481313] test_bpf: #69 ALU64_MOV_K: dst = 2 jited:0 800 PASS
[   45.482983] test_bpf: #70 ALU64_MOV_K: dst = 2147483647 jited:0 801 PASS
[   45.484660] test_bpf: #71 ALU64_OR_K: dst = 0x0 jited:0 4773 PASS
[   45.490325] test_bpf: #72 ALU64_MOV_K: dst = -1 jited:0 1401 PASS
[   45.492598] test_bpf: #73 ALU_ADD_X: 1 + 2 = 3 jited:0 1082 PASS
[   45.494557] test_bpf: #74 ALU_ADD_X: 1 + 4294967294 = 4294967295 jited:0 1082 PASS
[   45.496517] test_bpf: #75 ALU_ADD_X: 2 + 4294967294 = 0 jited:0 1417 PASS
[   45.503079] test_bpf: #76 ALU64_ADD_X: 1 + 2 = 3 jited:0 1098 PASS
[   45.505053] test_bpf: #77 ALU64_ADD_X: 1 + 4294967294 = 4294967295 jited:0 3544 PASS
[   45.509491] test_bpf: #78 ALU64_ADD_X: 2 + 4294967294 = 4294967296 jited:0 1576 PASS
[   45.511938] test_bpf: #79 ALU_ADD_K: 1 + 2 = 3 jited:0 938 PASS
[   45.513751] test_bpf: #80 ALU_ADD_K: 3 + 0 = 3 jited:0 938 PASS
[   45.515565] test_bpf: #81 ALU_ADD_K: 1 + 4294967294 = 4294967295 jited:0 5214 PASS
[   45.521672] test_bpf: #82 ALU_ADD_K: 4294967294 + 2 = 0 jited:0 1265 PASS
[   45.523813] test_bpf: #83 ALU_ADD_K: 0 + (-1) = 0x00000000ffffffff jited:0 1409 PASS
[   45.526100] test_bpf: #84 ALU_ADD_K: 0 + 0xffff = 0xffff jited:0 1410 PASS
[   45.531753] test_bpf: #85 ALU_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:0 1409 PASS
[   45.534035] test_bpf: #86 ALU_ADD_K: 0 + 0x80000000 = 0x80000000 jited:0 1409 PASS
[   45.536323] test_bpf: #87 ALU_ADD_K: 0 + 0x80008000 = 0x80008000 jited:0 1409 PASS
[   45.541973] test_bpf: #88 ALU64_ADD_K: 1 + 2 = 3 jited:0 960 PASS
[   45.543806] test_bpf: #89 ALU64_ADD_K: 3 + 0 = 3 jited:0 960 PASS
[   45.545645] test_bpf: #90 ALU64_ADD_K: 1 + 2147483646 = 2147483647 jited:0 4318 PASS
[   45.550857] test_bpf: #91 ALU64_ADD_K: 4294967294 + 2 = 4294967296 jited:0 1432 PASS
[   45.553164] test_bpf: #92 ALU64_ADD_K: 2147483646 + -2147483647 = -1 jited:0 960 PASS
[   45.555001] test_bpf: #93 ALU64_ADD_K: 1 + 0 = 1 jited:0 4812 PASS
[   45.560705] test_bpf: #94 ALU64_ADD_K: 0 + (-1) = 0xffffffffffffffff jited:0 1432 PASS
[   45.563008] test_bpf: #95 ALU64_ADD_K: 0 + 0xffff = 0xffff jited:0 1432 PASS
[   45.565318] test_bpf: #96 ALU64_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:0 4796 PASS
[   45.571010] test_bpf: #97 ALU64_ADD_K: 0 + 0x80000000 = 0xffffffff80000000 jited:0 1432 PASS
[   45.573316] test_bpf: #98 ALU_ADD_K: 0 + 0x80008000 = 0xffffffff80008000 jited:0 1432 PASS
[   45.575626] test_bpf: #99 ALU_SUB_X: 3 - 1 = 2 jited:0 4607 PASS
[   45.581128] test_bpf: #100 ALU_SUB_X: 4294967295 - 4294967294 = 1 jited:0 1082 PASS
[   45.583081] test_bpf: #101 ALU64_SUB_X: 3 - 1 = 2 jited:0 1098 PASS
[   45.585057] test_bpf: #102 ALU64_SUB_X: 4294967295 - 4294967294 = 1 jited:0 4462 PASS
[   45.590411] test_bpf: #103 ALU_SUB_K: 3 - 1 = 2 jited:0 938 PASS
[   45.592220] test_bpf: #104 ALU_SUB_K: 3 - 0 = 3 jited:0 938 PASS
[   45.594034] test_bpf: #105 ALU_SUB_K: 4294967295 - 4294967294 = 1 jited:0 938 PASS
[   45.595847] test_bpf: #106 ALU64_SUB_K: 3 - 1 = 2 jited:0 5239 PASS
[   45.601979] test_bpf: #107 ALU64_SUB_K: 3 - 0 = 3 jited:0 960 PASS
[   45.603811] test_bpf: #108 ALU64_SUB_K: 4294967294 - 4294967295 = -1 jited:0 960 PASS
[   45.605651] test_bpf: #109 ALU64_ADD_K: 2147483646 - 2147483647 = -1 jited:0 4590 PASS
[   45.611137] test_bpf: #110 ALU_MUL_X: 2 * 3 = 6 jited:0 1090 PASS
[   45.613099] test_bpf: #111 ALU_MUL_X: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:0 1090 PASS
[   45.615067] test_bpf: #112 ALU_MUL_X: -1 * -1 = 1 jited:0 4462 PASS
[   45.620421] test_bpf: #113 ALU64_MUL_X: 2 * 3 = 6 jited:0 1136 PASS
[   45.622428] test_bpf: #114 ALU64_MUL_X: 1 * 2147483647 = 2147483647 jited:0 1136 PASS
[   45.624439] test_bpf: #115 ALU_MUL_K: 2 * 3 = 6 jited:0 945 PASS
[   45.626260] test_bpf: #116 ALU_MUL_K: 3 * 1 = 3 jited:0 945 PASS
[   45.632350] test_bpf: #117 ALU_MUL_K: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:0 945 PASS
[   45.634171] test_bpf: #118 ALU_MUL_K: 1 * (-1) = 0x00000000ffffffff jited:0 1417 PASS
[   45.636464] test_bpf: #119 ALU64_MUL_K: 2 * 3 = 6 jited:0 991 PASS
[   45.641688] test_bpf: #120 ALU64_MUL_K: 3 * 1 = 3 jited:0 991 PASS
[   45.643557] test_bpf: #121 ALU64_MUL_K: 1 * 2147483647 = 2147483647 jited:0 991 PASS
[   45.645427] test_bpf: #122 ALU64_MUL_K: 1 * -2147483647 = -2147483647 jited:0 4348 PASS
[   45.650669] test_bpf: #123 ALU64_MUL_K: 1 * (-1) = 0xffffffffffffffff jited:0 1462 PASS
[   45.653004] test_bpf: #124 ALU_DIV_X: 6 / 2 = 3 jited:0 1234 PASS
[   45.655114] test_bpf: #125 ALU_DIV_X: 4294967295 / 4294967295 = 1 jited:0 4547 PASS
[   45.660554] test_bpf: #126 ALU64_DIV_X: 6 / 2 = 3 jited:0 1508 PASS
[   45.662936] test_bpf: #127 ALU64_DIV_X: 2147483647 / 2147483647 = 1 jited:0 1455 PASS
[   45.665273] test_bpf: #128 ALU64_DIV_X: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:0 5603 PASS
[   45.671769] test_bpf: #129 ALU_DIV_K: 6 / 2 = 3 jited:0 1081 PASS
[   45.673722] test_bpf: #130 ALU_DIV_K: 3 / 1 = 3 jited:0 1082 PASS
[   45.675682] test_bpf: #131 ALU_DIV_K: 4294967295 / 4294967295 = 1 jited:0 4387 PASS
[   45.680964] test_bpf: #132 ALU_DIV_K: 0xffffffffffffffff / (-1) = 0x1 jited:0 1492 PASS
[   45.683329] test_bpf: #133 ALU64_DIV_K: 6 / 2 = 3 jited:0 1371 PASS
[   45.685577] test_bpf: #134 ALU64_DIV_K: 3 / 1 = 3 jited:0 4740 PASS
[   45.691212] test_bpf: #135 ALU64_DIV_K: 2147483647 / 2147483647 = 1 jited:0 1318 PASS
[   45.693404] test_bpf: #136 ALU64_DIV_K: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:0 2086 PASS
[   45.696368] test_bpf: #137 ALU_MOD_X: 3 % 2 = 1 jited:0 1242 PASS
[   45.701849] test_bpf: #138 ALU_MOD_X: 4294967295 % 4294967293 = 2 jited:0 1181 PASS
[   45.703908] test_bpf: #139 ALU64_MOD_X: 3 % 2 = 1 jited:0 1599 PASS
[   45.706388] test_bpf: #140 ALU64_MOD_X: 2147483647 % 2147483645 = 2 jited:0 1546 PASS
[   45.712311] test_bpf: #141 ALU_MOD_K: 3 % 2 = 1 jited:0 1089 PASS
[   45.714276] test_bpf: #142 ALU_MOD_K: 3 % 1 = 0 jited:0 PASS
[   45.715055] test_bpf: #143 ALU_MOD_K: 4294967295 % 4294967293 = 2 jited:0 4388 PASS
[   45.720336] test_bpf: #144 ALU64_MOD_K: 3 % 2 = 1 jited:0 1462 PASS
[   45.722670] test_bpf: #145 ALU64_MOD_K: 3 % 1 = 0 jited:0 PASS
[   45.723448] test_bpf: #146 ALU64_MOD_K: 2147483647 % 2147483645 = 2 jited:0 1409 PASS
[   45.725733] test_bpf: #147 ALU_AND_X: 3 & 2 = 2 jited:0 5360 PASS
[   45.731988] test_bpf: #148 ALU_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:0 1082 PASS
[   45.733942] test_bpf: #149 ALU64_AND_X: 3 & 2 = 2 jited:0 1098 PASS
[   45.735918] test_bpf: #150 ALU64_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:0 4460 PASS
[   45.741272] test_bpf: #151 ALU_AND_K: 3 & 2 = 2 jited:0 938 PASS
[   45.743083] test_bpf: #152 ALU_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:0 938 PASS
[   45.744898] test_bpf: #153 ALU64_AND_K: 3 & 2 = 2 jited:0 960 PASS
[   45.750078] test_bpf: #154 ALU64_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:0 961 PASS
[   45.751917] test_bpf: #155 ALU64_AND_K: 0x0000ffffffff0000 & 0x0 = 0x0000ffff00000000 jited:0 1432 PASS
[   45.754231] test_bpf: #156 ALU64_AND_K: 0x0000ffffffff0000 & -1 = 0x0000ffffffffffff jited:0 1432 PASS
[   45.760835] test_bpf: #157 ALU64_AND_K: 0xffffffffffffffff & -1 = 0xffffffffffffffff jited:0 1433 PASS
[   45.763157] test_bpf: #158 ALU_OR_X: 1 | 2 = 3 jited:0 1083 PASS
[   45.765118] test_bpf: #159 ALU_OR_X: 0x0 | 0xffffffff = 0xffffffff jited:0 3537 PASS
[   45.769549] test_bpf: #160 ALU64_OR_X: 1 | 2 = 3 jited:0 1098 PASS
[   45.771523] test_bpf: #161 ALU64_OR_X: 0 | 0xffffffff = 0xffffffff jited:0 1098 PASS
[   45.773500] test_bpf: #162 ALU_OR_K: 1 | 2 = 3 jited:0 938 PASS
[   45.775316] test_bpf: #163 ALU_OR_K: 0 & 0xffffffff = 0xffffffff jited:0 5215 PASS
[   45.781426] test_bpf: #164 ALU64_OR_K: 1 | 2 = 3 jited:0 961 PASS
[   45.783261] test_bpf: #165 ALU64_OR_K: 0 & 0xffffffff = 0xffffffff jited:0 961 PASS
[   45.785104] test_bpf: #166 ALU64_OR_K: 0x0000ffffffff0000 | 0x0 = 0x0000ffff00000000 jited:0 4801 PASS
[   45.790804] test_bpf: #167 ALU64_OR_K: 0x0000ffffffff0000 | -1 = 0xffffffffffffffff jited:0 1432 PASS
[   45.793114] test_bpf: #168 ALU64_OR_K: 0x000000000000000 | -1 = 0xffffffffffffffff jited:0 1432 PASS
[   45.795423] test_bpf: #169 ALU_XOR_X: 5 ^ 6 = 3 jited:0 4516 PASS
[   45.800833] test_bpf: #170 ALU_XOR_X: 0x1 ^ 0xffffffff = 0xfffffffe jited:0 1083 PASS
[   45.802787] test_bpf: #171 ALU64_XOR_X: 5 ^ 6 = 3 jited:0 1098 PASS
[   45.804765] test_bpf: #172 ALU64_XOR_X: 1 ^ 0xffffffff = 0xfffffffe jited:0 1098 PASS
[   45.810069] test_bpf: #173 ALU_XOR_K: 5 ^ 6 = 3 jited:0 938 PASS
[   45.811883] test_bpf: #174 ALU_XOR_K: 1 ^ 0xffffffff = 0xfffffffe jited:0 938 PASS
[   45.813698] test_bpf: #175 ALU64_XOR_K: 5 ^ 6 = 3 jited:0 961 PASS
[   45.815537] test_bpf: #176 ALU64_XOR_K: 1 & 0xffffffff = 0xfffffffe jited:0 5236 PASS
[   45.821668] test_bpf: #177 ALU64_XOR_K: 0x0000ffffffff0000 ^ 0x0 = 0x0000ffffffff0000 jited:0 1432 PASS
[   45.823975] test_bpf: #178 ALU64_XOR_K: 0x0000ffffffff0000 ^ -1 = 0xffff00000000ffff jited:0 1432 PASS
[   45.826287] test_bpf: #179 ALU64_XOR_K: 0x000000000000000 ^ -1 = 0xffffffffffffffff jited:0 1432 PASS
[   45.831978] test_bpf: #180 ALU_LSH_X: 1 << 1 = 2 jited:0 1082 PASS
[   45.833935] test_bpf: #181 ALU_LSH_X: 1 << 31 = 0x80000000 jited:0 1082 PASS
[   45.835893] test_bpf: #182 ALU64_LSH_X: 1 << 1 = 2 jited:0 4679 PASS
[   45.841468] test_bpf: #183 ALU64_LSH_X: 1 << 31 = 0x80000000 jited:0 1159 PASS
[   45.843498] test_bpf: #184 ALU_LSH_K: 1 << 1 = 2 jited:0 938 PASS
[   45.845315] test_bpf: #185 ALU_LSH_K: 1 << 31 = 0x80000000 jited:0 4295 PASS
[   45.850504] test_bpf: #186 ALU64_LSH_K: 1 << 1 = 2 jited:0 1021 PASS
[   45.852398] test_bpf: #187 ALU64_LSH_K: 1 << 31 = 0x80000000 jited:0 1021 PASS
[   45.854296] test_bpf: #188 ALU_RSH_X: 2 >> 1 = 1 jited:0 1082 PASS
[   45.856254] test_bpf: #189 ALU_RSH_X: 0x80000000 >> 31 = 1 jited:0 1082 PASS
[   45.862480] test_bpf: #190 ALU64_RSH_X: 2 >> 1 = 1 jited:0 1159 PASS
[   45.864512] test_bpf: #191 ALU64_RSH_X: 0x80000000 >> 31 = 1 jited:0 1159 PASS
[   45.869900] test_bpf: #192 ALU_RSH_K: 2 >> 1 = 1 jited:0 938 PASS
[   45.871721] test_bpf: #193 ALU_RSH_K: 0x80000000 >> 31 = 1 jited:0 938 PASS
[   45.873536] test_bpf: #194 ALU64_RSH_K: 2 >> 1 = 1 jited:0 1021 PASS
[   45.875434] test_bpf: #195 ALU64_RSH_K: 0x80000000 >> 31 = 1 jited:0 4383 PASS
[   45.880713] test_bpf: #196 ALU_ARSH_X: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:0 1105 PASS
[   45.882694] test_bpf: #197 ALU_ARSH_K: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:0 968 PASS
[   45.884540] test_bpf: #198 ALU_NEG: -(3) = -3 jited:0 930 PASS
[   45.886345] test_bpf: #199 ALU_NEG: -(-3) = 3 jited:0 930 PASS
[   45.892536] test_bpf: #200 ALU64_NEG: -(3) = -3 jited:0 945 PASS
[   45.894355] test_bpf: #201 ALU64_NEG: -(-3) = 3 jited:0 945 PASS
[   45.896179] test_bpf: #202 ALU_END_FROM_BE 16: 0x0123456789abcdef -> 0xcdef jited:0 968 PASS
[   45.901376] test_bpf: #203 ALU_END_FROM_BE 32: 0x0123456789abcdef -> 0x89abcdef jited:0 1417 PASS
[   45.903670] test_bpf: #204 ALU_END_FROM_BE 64: 0x0123456789abcdef -> 0x89abcdef jited:0 930 PASS
[   45.905477] test_bpf: #205 ALU_END_FROM_LE 16: 0x0123456789abcdef -> 0xefcd jited:0 4390 PASS
[   45.910763] test_bpf: #206 ALU_END_FROM_LE 32: 0x0123456789abcdef -> 0xefcdab89 jited:0 1440 PASS
[   45.913076] test_bpf: #207 ALU_END_FROM_LE 64: 0x0123456789abcdef -> 0x67452301 jited:0 991 PASS
[   45.914944] test_bpf: #208 ST_MEM_B: Store/Load byte: max negative jited:0 1075 PASS
[   45.920290] test_bpf: #209 ST_MEM_B: Store/Load byte: max positive jited:0 1075 PASS
[   45.922237] test_bpf: #210 STX_MEM_B: Store/Load byte: max negative jited:0 1226 PASS
[   45.924343] test_bpf: #211 ST_MEM_H: Store/Load half word: max negative jited:0 1075 PASS
[   45.926295] test_bpf: #212 ST_MEM_H: Store/Load half word: max positive jited:0 1074 PASS
[   45.932539] test_bpf: #213 STX_MEM_H: Store/Load half word: max negative jited:0 1226 PASS
[   45.934640] test_bpf: #214 ST_MEM_W: Store/Load word: max negative jited:0 1075 PASS
[   45.939964] test_bpf: #215 ST_MEM_W: Store/Load word: max positive jited:0 1075 PASS
[   45.941916] test_bpf: #216 STX_MEM_W: Store/Load word: max negative jited:0 1226 PASS
[   45.944022] test_bpf: #217 ST_MEM_DW: Store/Load double word: max negative jited:0 1113 PASS
[   45.946013] test_bpf: #218 ST_MEM_DW: Store/Load double word: max negative 2 jited:0 4970 PASS
[   45.951878] test_bpf: #219 ST_MEM_DW: Store/Load double word: max positive jited:0 1113 PASS
[   45.953867] test_bpf: #220 STX_MEM_DW: Store/Load double word: max negative jited:0 1226 PASS
[   45.955972] test_bpf: #221 STX_XADD_W: Test: 0x12 + 0x10 = 0x22 jited:0 4680 PASS
[   45.961549] test_bpf: #222 STX_XADD_W: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:0 PASS
[   45.962325] test_bpf: #223 STX_XADD_W: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:0 1143 PASS
[   45.964346] test_bpf: #224 STX_XADD_W: X + 1 + 1 + 1 + ... jited:0 1109065 PASS
[   47.075277] test_bpf: #225 STX_XADD_DW: Test: 0x12 + 0x10 = 0x22 jited:0 3248 PASS
[   47.079414] test_bpf: #226 STX_XADD_DW: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:0 PASS
[   47.080191] test_bpf: #227 STX_XADD_DW: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:0 1356 PASS
[   47.082427] test_bpf: #228 STX_XADD_DW: X + 1 + 1 + 1 + ... jited:0 1902624 PASS
[   48.987037] test_bpf: #229 JMP_EXIT jited:0 793 PASS
[   48.988701] test_bpf: #230 JMP_JA: Unconditional jump: if (true) return 1 jited:0 1021 PASS
[   48.990602] test_bpf: #231 JMP_JSLT_K: Signed jump: if (-2 < -1) return 1 jited:0 1250 PASS
[   48.992732] test_bpf: #232 JMP_JSLT_K: Signed jump: if (-1 < -1) return 0 jited:0 1098 PASS
[   48.994708] test_bpf: #233 JMP_JSGT_K: Signed jump: if (-1 > -2) return 1 jited:0 1250 PASS
[   49.002245] test_bpf: #234 JMP_JSGT_K: Signed jump: if (-1 > -1) return 0 jited:0 1098 PASS
[   49.004219] test_bpf: #235 JMP_JSLE_K: Signed jump: if (-2 <= -1) return 1 jited:0 1249 PASS
[   49.006350] test_bpf: #236 JMP_JSLE_K: Signed jump: if (-1 <= -1) return 1 jited:0 1249 PASS
[   49.012244] test_bpf: #237 JMP_JSLE_K: Signed jump: value walk 1 jited:0 2250 PASS
[   49.015376] test_bpf: #238 JMP_JSLE_K: Signed jump: value walk 2 jited:0 4471 PASS
[   49.020743] test_bpf: #239 JMP_JSGE_K: Signed jump: if (-1 >= -2) return 1 jited:0 1249 PASS
[   49.022869] test_bpf: #240 JMP_JSGE_K: Signed jump: if (-1 >= -1) return 1 jited:0 1249 PASS
[   49.024996] test_bpf: #241 JMP_JSGE_K: Signed jump: value walk 1 jited:0 5558 PASS
[   49.031449] test_bpf: #242 JMP_JSGE_K: Signed jump: value walk 2 jited:0 1841 PASS
[   49.034165] test_bpf: #243 JMP_JGT_K: if (3 > 2) return 1 jited:0 1257 PASS
[   49.036302] test_bpf: #244 JMP_JGT_K: Unsigned jump: if (-1 > 1) return 1 jited:0 1219 PASS
[   49.041770] test_bpf: #245 JMP_JLT_K: if (2 < 3) return 1 jited:0 1257 PASS
[   49.043902] test_bpf: #246 JMP_JGT_K: Unsigned jump: if (1 < -1) return 1 jited:0 1219 PASS
[   49.046000] test_bpf: #247 JMP_JGE_K: if (3 >= 2) return 1 jited:0 5289 PASS
[   49.052181] test_bpf: #248 JMP_JLE_K: if (2 <= 3) return 1 jited:0 1256 PASS
[   49.054311] test_bpf: #249 JMP_JGT_K: if (3 > 2) return 1 (jump backwards) jited:0 1363 PASS
[   49.059912] test_bpf: #250 JMP_JGE_K: if (3 >= 3) return 1 jited:0 1914 PASS
[   49.062712] test_bpf: #251 JMP_JGT_K: if (2 < 3) return 1 (jump backwards) jited:0 1363 PASS
[   49.064956] test_bpf: #252 JMP_JLE_K: if (3 <= 3) return 1 jited:0 3715 PASS
[   49.069565] test_bpf: #253 JMP_JNE_K: if (3 != 2) return 1 jited:0 1242 PASS
[   49.071680] test_bpf: #254 JMP_JEQ_K: if (3 == 3) return 1 jited:0 1249 PASS
[   49.073807] test_bpf: #255 JMP_JSET_K: if (0x3 & 0x2) return 1 jited:0 1234 PASS
[   49.075920] test_bpf: #256 JMP_JSET_K: if (0x3 & 0xffffffff) return 1 jited:0 5515 PASS
[   49.082331] test_bpf: #257 JMP_JSGT_X: Signed jump: if (-1 > -2) return 1 jited:0 1393 PASS
[   49.084597] test_bpf: #258 JMP_JSGT_X: Signed jump: if (-1 > -1) return 0 jited:0 1242 PASS
[   49.089223] test_bpf: #259 JMP_JSLT_X: Signed jump: if (-2 < -1) return 1 jited:0 1394 PASS
[   49.091499] test_bpf: #260 JMP_JSLT_X: Signed jump: if (-1 < -1) return 0 jited:0 1242 PASS
[   49.093621] test_bpf: #261 JMP_JSGE_X: Signed jump: if (-1 >= -2) return 1 jited:0 1394 PASS
[   49.095895] test_bpf: #262 JMP_JSGE_X: Signed jump: if (-1 >= -1) return 1 jited:0 5697 PASS
[   49.102489] test_bpf: #263 JMP_JSLE_X: Signed jump: if (-2 <= -1) return 1 jited:0 1394 PASS
[   49.104759] test_bpf: #264 JMP_JSLE_X: Signed jump: if (-1 <= -1) return 1 jited:0 4127 PASS
[   49.109783] test_bpf: #265 JMP_JGT_X: if (3 > 2) return 1 jited:0 1401 PASS
[   49.112060] test_bpf: #266 JMP_JGT_X: Unsigned jump: if (-1 > 1) return 1 jited:0 1356 PASS
[   49.114297] test_bpf: #267 JMP_JLT_X: if (2 < 3) return 1 jited:0 1401 PASS
[   49.121198] test_bpf: #268 JMP_JLT_X: Unsigned jump: if (1 < -1) return 1 jited:0 1355 PASS
[   49.123433] test_bpf: #269 JMP_JGE_X: if (3 >= 2) return 1 jited:0 1401 PASS
[   49.125712] test_bpf: #270 JMP_JGE_X: if (3 >= 3) return 1 jited:0 4022 PASS
[   49.130629] test_bpf: #271 JMP_JLE_X: if (2 <= 3) return 1 jited:0 1401 PASS
[   49.132904] test_bpf: #272 JMP_JLE_X: if (3 <= 3) return 1 jited:0 1401 PASS
[   49.135182] test_bpf: #273 JMP_JGE_X: ldimm64 test 1 jited:0 4925 PASS
[   49.141001] test_bpf: #274 JMP_JGE_X: ldimm64 test 2 jited:0 1408 PASS
[   49.143281] test_bpf: #275 JMP_JGE_X: ldimm64 test 3 jited:0 1280 PASS
[   49.145439] test_bpf: #276 JMP_JLE_X: ldimm64 test 1 jited:0 4820 PASS
[   49.151152] test_bpf: #277 JMP_JLE_X: ldimm64 test 2 jited:0 1408 PASS
[   49.153433] test_bpf: #278 JMP_JLE_X: ldimm64 test 3 jited:0 1280 PASS
[   49.155592] test_bpf: #279 JMP_JNE_X: if (3 != 2) return 1 jited:0 4747 PASS
[   49.161232] test_bpf: #280 JMP_JEQ_X: if (3 == 3) return 1 jited:0 1393 PASS
[   49.163498] test_bpf: #281 JMP_JSET_X: if (0x3 & 0x2) return 1 jited:0 1386 PASS
[   49.165762] test_bpf: #282 JMP_JSET_X: if (0x3 & 0xffffffff) return 1 jited:0 4760 PASS
[   49.171418] test_bpf: #283 JMP_JA: Jump, gap, jump, ... jited:0 1469 PASS
[   49.173761] test_bpf: #284 BPF_MAXINSNS: Maximum possible literals jited:0 1255 PASS
[   49.203261] test_bpf: #285 BPF_MAXINSNS: Single literal jited:0 1255 PASS
[   49.232027] test_bpf: #286 BPF_MAXINSNS: Run/add until end jited:0 758702 PASS
[   50.017459] test_bpf: #287 BPF_MAXINSNS: Too many instructions PASS
[   50.017558] test_bpf: #288 BPF_MAXINSNS: Very long jump jited:0 1362 PASS
[   50.048852] test_bpf: #289 BPF_MAXINSNS: Ctx heavy transformations jited:0 1579447 1578838 PASS
[   53.238245] test_bpf: #290 BPF_MAXINSNS: Call heavy transformations jited:0 3664502 3664981 PASS
[   60.598875] test_bpf: #291 BPF_MAXINSNS: Jump heavy test jited:0 1712737 PASS
[   62.345259] test_bpf: #292 BPF_MAXINSNS: Very long jump backwards jited:0 1006 PASS
[   62.349909] test_bpf: #293 BPF_MAXINSNS: Edge hopping nuthouse jited:0 636554 PASS
[   62.988278] test_bpf: #294 BPF_MAXINSNS: Jump, gap, jump, ... jited:0 7992 PASS
[   63.023230] test_bpf: #295 BPF_MAXINSNS: jump over MSH PASS
[   63.062642] test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:0 8172905 PASS
[   71.291022] test_bpf: #297 BPF_MAXINSNS: ld_abs+get_processor_id jited:0 3405900 PASS
[   74.739534] test_bpf: #298 LD_IND byte frag jited:0 8161 PASS
[   74.748697] test_bpf: #299 LD_IND halfword frag jited:0 6608 PASS
[   74.756294] test_bpf: #300 LD_IND word frag jited:0 6577 PASS
[   74.766431] test_bpf: #301 LD_IND halfword mixed head/frag jited:0 6910 PASS
[   74.775939] test_bpf: #302 LD_IND word mixed head/frag jited:0 6998 PASS
[   74.785486] test_bpf: #303 LD_ABS byte frag jited:0 8780 PASS
[   74.795266] test_bpf: #304 LD_ABS halfword frag jited:0 8774 PASS
[   74.805036] test_bpf: #305 LD_ABS word frag jited:0 8737 PASS
[   74.814773] test_bpf: #306 LD_ABS halfword mixed head/frag jited:0 9120 PASS
[   74.824892] test_bpf: #307 LD_ABS word mixed head/frag jited:0 9346 PASS
[   74.835237] test_bpf: #308 LD_IND byte default X jited:0 4600 PASS
[   74.840784] test_bpf: #309 LD_IND byte positive offset jited:0 3201 PASS
[   74.844923] test_bpf: #310 LD_IND byte negative offset jited:0 5652 PASS
[   74.851536] test_bpf: #311 LD_IND byte positive offset, all ff jited:0 3201 PASS
[   74.855677] test_bpf: #312 LD_IND byte positive offset, out of bounds jited:0 5946 PASS
[   74.862583] test_bpf: #313 LD_IND byte negative offset, out of bounds jited:0 5068 PASS
[   74.868608] test_bpf: #314 LD_IND byte negative offset, multiple calls jited:0 9707 PASS
[   74.879294] test_bpf: #315 LD_IND halfword positive offset jited:0 3209 PASS
[   74.883442] test_bpf: #316 LD_IND halfword negative offset jited:0 5669 PASS
[   74.890068] test_bpf: #317 LD_IND halfword unaligned jited:0 3209 PASS
[   74.894216] test_bpf: #318 LD_IND halfword positive offset, all ff jited:0 5665 PASS
[   74.900842] test_bpf: #319 LD_IND halfword positive offset, out of bounds jited:0 3498 PASS
[   74.905282] test_bpf: #320 LD_IND halfword negative offset, out of bounds jited:0 6007 PASS
[   74.912249] test_bpf: #321 LD_IND word positive offset jited:0 3209 PASS
[   74.916397] test_bpf: #322 LD_IND word negative offset jited:0 3209 PASS
[   74.922989] test_bpf: #323 LD_IND word unaligned (addr & 3 == 2) jited:0 4728 PASS
[   74.928678] test_bpf: #324 LD_IND word unaligned (addr & 3 == 1) jited:0 3208 PASS
[   74.932827] test_bpf: #325 LD_IND word unaligned (addr & 3 == 3) jited:0 5671 PASS
[   74.939459] test_bpf: #326 LD_IND word positive offset, all ff jited:0 3209 PASS
[   74.943607] test_bpf: #327 LD_IND word positive offset, out of bounds jited:0 5957 PASS
[   74.950527] test_bpf: #328 LD_IND word negative offset, out of bounds jited:0 3543 PASS
[   74.955006] test_bpf: #329 LD_ABS byte jited:0 5169 PASS
[   74.961135] test_bpf: #330 LD_ABS byte positive offset, all ff jited:0 2488 PASS
[   74.964561] test_bpf: #331 LD_ABS byte positive offset, out of bounds jited:0 7633 PASS
[   74.973155] test_bpf: #332 LD_ABS byte negative offset, out of bounds load PASS
[   74.973820] test_bpf: #333 LD_ABS byte negative offset, in bounds jited:0 5619 PASS
[   74.980403] test_bpf: #334 LD_ABS byte negative offset, out of bounds jited:0 3269 PASS
[   74.984608] test_bpf: #335 LD_ABS byte negative offset, multiple calls jited:0 9824 PASS
[   74.995415] test_bpf: #336 LD_ABS halfword jited:0 4177 PASS
[   75.000545] test_bpf: #337 LD_ABS halfword unaligned jited:0 2663 PASS
[   75.004146] test_bpf: #338 LD_ABS halfword positive offset, all ff jited:0 5103 PASS
[   75.010210] test_bpf: #339 LD_ABS halfword positive offset, out of bounds jited:0 5185 PASS
[   75.016336] test_bpf: #340 LD_ABS halfword negative offset, out of bounds load PASS
[   75.019466] test_bpf: #341 LD_ABS halfword negative offset, in bounds jited:0 3156 PASS
[   75.023562] test_bpf: #342 LD_ABS halfword negative offset, out of bounds jited:0 5730 PASS
[   75.030246] test_bpf: #343 LD_ABS word jited:0 2639 PASS
[   75.033822] test_bpf: #344 LD_ABS word unaligned (addr & 3 == 2) jited:0 5101 PASS
[   75.039883] test_bpf: #345 LD_ABS word unaligned (addr & 3 == 1) jited:0 2654 PASS
[   75.043475] test_bpf: #346 LD_ABS word unaligned (addr & 3 == 3) jited:0 5108 PASS
[   75.049543] test_bpf: #347 LD_ABS word positive offset, all ff jited:0 2639 PASS
[   75.053123] test_bpf: #348 LD_ABS word positive offset, out of bounds jited:0 7646 PASS
[   75.061728] test_bpf: #349 LD_ABS word negative offset, out of bounds load PASS
[   75.062395] test_bpf: #350 LD_ABS word negative offset, in bounds jited:0 3156 PASS
[   75.066497] test_bpf: #351 LD_ABS word negative offset, out of bounds jited:0 3270 PASS
[   75.074070] test_bpf: #352 LDX_MSH standalone, preserved A jited:0 5032 PASS
[   75.080070] test_bpf: #353 LDX_MSH standalone, preserved A 2 jited:0 9880 PASS
[   75.090946] test_bpf: #354 LDX_MSH standalone, test result 1 jited:0 3604 PASS
[   75.095501] test_bpf: #355 LDX_MSH standalone, test result 2 jited:0 6058 PASS
[   75.102532] test_bpf: #356 LDX_MSH standalone, negative offset jited:0 5033 PASS
[   75.108530] test_bpf: #357 LDX_MSH standalone, negative offset 2 jited:0 4272 PASS
[   75.113753] test_bpf: #358 LDX_MSH standalone, out of bounds jited:0 8124 PASS
[   75.122848] test_bpf: #359 ADD default X jited:0 1416 PASS
[   75.125147] test_bpf: #360 ADD default A jited:0 3848 PASS
[   75.129897] test_bpf: #361 SUB default X jited:0 1416 PASS
[   75.132197] test_bpf: #362 SUB default A jited:0 1272 PASS
[   75.134347] test_bpf: #363 MUL default X jited:0 1424 PASS
[   75.140087] test_bpf: #364 MUL default A jited:0 1280 PASS
[   75.142245] test_bpf: #365 DIV default X jited:0 1720 PASS
[   75.144854] test_bpf: #366 DIV default A jited:0 5072 PASS
[   75.150831] test_bpf: #367 MOD default X jited:0 1720 PASS
[   75.153436] test_bpf: #368 MOD default A jited:0 1423 PASS
[   75.155738] test_bpf: #369 JMP EQ default A jited:0 4777 PASS
[   75.161429] test_bpf: #370 JMP EQ default X jited:0 1561 PASS
[   75.163881] test_bpf: #371 JNE signed compare, test 1 jited:0 1531 PASS
[   75.166288] test_bpf: #372 JNE signed compare, test 2 jited:0 1530 PASS
[   75.172059] test_bpf: #373 JNE signed compare, test 3 jited:0 1780 PASS
[   75.174712] test_bpf: #374 JNE signed compare, test 4 jited:0 1211 PASS
[   75.179211] test_bpf: #375 JNE signed compare, test 5 jited:0 1098 PASS
[   75.181185] test_bpf: #376 JNE signed compare, test 6 jited:0 1211 PASS
[   75.183271] test_bpf: #377 JNE signed compare, test 7 jited:0 2145 PASS
[   75.186337] test_bpf: Summary: 378 PASSED, 0 FAILED, [0/366 JIT'ed]
[   75.191771] test_bpf: #0 gso_with_rx_frags PASS
[   75.192044] test_bpf: #1 gso_linear_no_head_frag PASS
[   75.192325] test_bpf: test_skb_segment: Summary: 2 PASSED, 0 FAILED

Without the patch, with bpf_jit_enable = 1 :

[  177.374113] test_bpf: #0 TAX jited:1 475 472 472 PASS
[  177.377021] test_bpf: #1 TXA jited:1 177 176 176 PASS
[  177.380436] test_bpf: #2 ADD_SUB_MUL_K jited:1 208 PASS
[  177.381602] test_bpf: #3 DIV_MOD_KX jited:1 602 PASS
[  177.383194] test_bpf: #4 AND_OR_LSH_K jited:1 208 207 PASS
[  177.384617] test_bpf: #5 LD_IMM_0 jited:1 178 PASS
[  177.385802] test_bpf: #6 LD_IND jited:1 672 5927 671 PASS
[  177.394286] test_bpf: #7 LD_ABS jited:1 634 632 632 PASS
[  177.398970] test_bpf: #8 LD_ABS_LL jited:1 1173 1178 PASS
[  177.402423] test_bpf: #9 LD_IND_LL jited:1 809 807 807 PASS
[  177.406038] test_bpf: #10 LD_ABS_NET jited:1 4499 1133 PASS
[  177.412806] test_bpf: #11 LD_IND_NET jited:1 809 784 784 PASS
[  177.416376] test_bpf: #12 LD_PKTTYPE jited:1 2721 298 PASS
[  177.420537] test_bpf: #13 LD_MARK jited:1 147 146 PASS
[  177.421909] test_bpf: #14 LD_RXHASH jited:1 147 146 PASS
[  177.423284] test_bpf: #15 LD_QUEUE jited:1 147 146 PASS
[  177.424662] test_bpf: #16 LD_PROTOCOL jited:1 565 564 PASS
[  177.426923] test_bpf: #17 LD_VLAN_TAG jited:1 147 146 PASS
[  177.433453] test_bpf: #18 LD_VLAN_TAG_PRESENT jited:1 155 153 PASS
[  177.434844] test_bpf: #19 LD_IFINDEX jited:1 185 184 PASS
[  177.436304] test_bpf: #20 LD_HATYPE jited:1 185 3516 PASS
[  177.441119] test_bpf: #21 LD_CPU jited:1 178 176 PASS
[  177.442565] test_bpf: #22 LD_NLATTR 
[  177.443010] BPF filter opcode 0020 (@3) unsupported
[  177.452107] jited:0 2349 2982 PASS
[  177.458009] test_bpf: #23 LD_NLATTR_NEST 
[  177.458457] BPF filter opcode 0020 (@2) unsupported
[  177.463226] jited:0 12501 13874 PASS
[  177.490190] test_bpf: #24 LD_PAYLOAD_OFF 
[  177.490629] BPF filter opcode 0020 (@0) unsupported
[  177.495353] jited:0 18010 18020 PASS
[  177.531980] test_bpf: #25 LD_ANC_XOR jited:1 178 176 PASS
[  177.533418] test_bpf: #26 SPILL_FILL jited:1 315 313 313 PASS
[  177.535572] test_bpf: #27 JEQ jited:1 649 3755 412 PASS
[  177.541625] test_bpf: #28 JGT jited:1 649 427 412 PASS
[  177.544305] test_bpf: #29 JGE (jt 0), test 1 jited:1 649 427 427 PASS
[  177.547011] test_bpf: #30 JGE (jt 0), test 2 jited:1 428 427 412 PASS
[  177.552817] test_bpf: #31 JGE jited:1 467 511 495 PASS
[  177.555499] test_bpf: #32 JSET jited:1 489 2939 693 PASS
[  177.560906] test_bpf: #33 tcpdump port 22 jited:1 642 1263 1209 PASS
[  177.565296] test_bpf: #34 tcpdump complex jited:1 672 16140901240593209 1877 PASS
[  177.572891] test_bpf: #35 RET_A jited:1 163 161 PASS
[  177.574298] test_bpf: #36 INT: ADD trivial jited:0 1758 PASS
[  177.576937] test_bpf: #37 INT: MUL_X jited:0 1605 PASS
[  177.582771] test_bpf: #38 INT: MUL_X2 jited:0 1796 PASS
[  177.585444] test_bpf: #39 INT: MUL32_X jited:0 4188 PASS
[  177.590528] test_bpf: #40 INT: ADD 64-bit jited:0 26526 PASS
[  177.617952] test_bpf: #41 INT: ADD 32-bit jited:0 22706 PASS
[  177.641561] test_bpf: #42 INT: SUB jited:0 23144 PASS
[  177.665607] test_bpf: #43 INT: XOR jited:0 9982 PASS
[  177.676484] test_bpf: #44 INT: MUL jited:0 11680 PASS
[  177.689060] test_bpf: #45 MOV REG64 jited:0 5288 PASS
[  177.695225] test_bpf: #46 MOV REG32 jited:0 7645 PASS
[  177.703766] test_bpf: #47 LD IMM64 jited:0 6802 PASS
[  177.711456] test_bpf: #48 INT: ALU MIX jited:0 3035 PASS
[  177.715367] test_bpf: #49 INT: shifts by register jited:0 7048 PASS
[  177.723315] test_bpf: #50 check: missing ret PASS
[  177.723982] test_bpf: #51 check: div_k_0 PASS
[  177.724659] test_bpf: #52 check: unknown insn PASS
[  177.725335] test_bpf: #53 check: out of range spill/fill PASS
[  177.726011] test_bpf: #54 JUMPS + HOLES jited:1 5734 PASS
[  177.733008] test_bpf: #55 check: RET X PASS
[  177.733678] test_bpf: #56 check: LDX + RET X PASS
[  177.734355] test_bpf: #57 M[]: alt STX + LDX jited:1 1029 PASS
[  177.736551] test_bpf: #58 M[]: full STX + full LDX jited:1 1021 PASS
[  177.743073] test_bpf: #59 check: SKF_AD_MAX PASS
[  177.743745] test_bpf: #60 LD [SKF_AD_OFF-1] jited:1 680 PASS
[  177.745449] test_bpf: #61 load 64-bit immediate jited:0 5738 PASS
[  177.752095] test_bpf: #62 ALU_MOV_X: dst = 2 jited:0 930 PASS
[  177.753904] test_bpf: #63 ALU_MOV_X: dst = 4294967295 jited:0 930 PASS
[  177.755718] test_bpf: #64 ALU64_MOV_X: dst = 2 jited:0 938 PASS
[  177.760875] test_bpf: #65 ALU64_MOV_X: dst = 4294967295 jited:0 938 PASS
[  177.762691] test_bpf: #66 ALU_MOV_K: dst = 2 jited:0 793 PASS
[  177.764369] test_bpf: #67 ALU_MOV_K: dst = 4294967295 jited:0 793 PASS
[  177.766048] test_bpf: #68 ALU_MOV_K: 0x0000ffffffff0000 = 0x00000000ffffffff jited:0 5659 PASS
[  177.772607] test_bpf: #69 ALU64_MOV_K: dst = 2 jited:0 801 PASS
[  177.774285] test_bpf: #70 ALU64_MOV_K: dst = 2147483647 jited:0 801 PASS
[  177.775970] test_bpf: #71 ALU64_OR_K: dst = 0x0 jited:0 4766 PASS
[  177.781637] test_bpf: #72 ALU64_MOV_K: dst = -1 jited:0 1401 PASS
[  177.783917] test_bpf: #73 ALU_ADD_X: 1 + 2 = 3 jited:0 1083 PASS
[  177.785887] test_bpf: #74 ALU_ADD_X: 1 + 4294967294 = 4294967295 jited:0 4429 PASS
[  177.791216] test_bpf: #75 ALU_ADD_X: 2 + 4294967294 = 0 jited:0 1417 PASS
[  177.793512] test_bpf: #76 ALU64_ADD_X: 1 + 2 = 3 jited:0 1098 PASS
[  177.795495] test_bpf: #77 ALU64_ADD_X: 1 + 4294967294 = 4294967295 jited:0 1098 PASS
[  177.800801] test_bpf: #78 ALU64_ADD_X: 2 + 4294967294 = 4294967296 jited:0 1576 PASS
[  177.803258] test_bpf: #79 ALU_ADD_K: 1 + 2 = 3 jited:0 938 PASS
[  177.805076] test_bpf: #80 ALU_ADD_K: 3 + 0 = 3 jited:0 938 PASS
[  177.806898] test_bpf: #81 ALU_ADD_K: 1 + 4294967294 = 4294967295 jited:0 937 PASS
[  177.812989] test_bpf: #82 ALU_ADD_K: 4294967294 + 2 = 0 jited:0 1265 PASS
[  177.815136] test_bpf: #83 ALU_ADD_K: 0 + (-1) = 0x00000000ffffffff jited:0 1409 PASS
[  177.819844] test_bpf: #84 ALU_ADD_K: 0 + 0xffff = 0xffff jited:0 1409 PASS
[  177.822141] test_bpf: #85 ALU_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:0 1409 PASS
[  177.824439] test_bpf: #86 ALU_ADD_K: 0 + 0x80000000 = 0x80000000 jited:0 1409 PASS
[  177.826734] test_bpf: #87 ALU_ADD_K: 0 + 0x80008000 = 0x80008000 jited:0 1411 PASS
[  177.833311] test_bpf: #88 ALU64_ADD_K: 1 + 2 = 3 jited:0 961 PASS
[  177.835150] test_bpf: #89 ALU64_ADD_K: 3 + 0 = 3 jited:0 961 PASS
[  177.836999] test_bpf: #90 ALU64_ADD_K: 1 + 2147483646 = 2147483647 jited:0 960 PASS
[  177.842197] test_bpf: #91 ALU64_ADD_K: 4294967294 + 2 = 4294967296 jited:0 1432 PASS
[  177.844508] test_bpf: #92 ALU64_ADD_K: 2147483646 + -2147483647 = -1 jited:0 961 PASS
[  177.846349] test_bpf: #93 ALU64_ADD_K: 1 + 0 = 1 jited:0 4800 PASS
[  177.852048] test_bpf: #94 ALU64_ADD_K: 0 + (-1) = 0xffffffffffffffff jited:0 1432 PASS
[  177.854355] test_bpf: #95 ALU64_ADD_K: 0 + 0xffff = 0xffff jited:0 1432 PASS
[  177.856669] test_bpf: #96 ALU64_ADD_K: 0 + 0x7fffffff = 0x7fffffff jited:0 4793 PASS
[  177.862365] test_bpf: #97 ALU64_ADD_K: 0 + 0x80000000 = 0xffffffff80000000 jited:0 1432 PASS
[  177.864676] test_bpf: #98 ALU_ADD_K: 0 + 0x80008000 = 0xffffffff80008000 jited:0 1432 PASS
[  177.866990] test_bpf: #99 ALU_SUB_X: 3 - 1 = 2 jited:0 1082 PASS
[  177.872479] test_bpf: #100 ALU_SUB_X: 4294967295 - 4294967294 = 1 jited:0 1083 PASS
[  177.874445] test_bpf: #101 ALU64_SUB_X: 3 - 1 = 2 jited:0 1098 PASS
[  177.876429] test_bpf: #102 ALU64_SUB_X: 4294967295 - 4294967294 = 1 jited:0 4458 PASS
[  177.881788] test_bpf: #103 ALU_SUB_K: 3 - 1 = 2 jited:0 938 PASS
[  177.883603] test_bpf: #104 ALU_SUB_K: 3 - 0 = 3 jited:0 938 PASS
[  177.885428] test_bpf: #105 ALU_SUB_K: 4294967295 - 4294967294 = 1 jited:0 938 PASS
[  177.891787] test_bpf: #106 ALU64_SUB_K: 3 - 1 = 2 jited:0 960 PASS
[  177.893634] test_bpf: #107 ALU64_SUB_K: 3 - 0 = 3 jited:0 960 PASS
[  177.895480] test_bpf: #108 ALU64_SUB_K: 4294967294 - 4294967295 = -1 jited:0 960 PASS
[  177.899749] test_bpf: #109 ALU64_ADD_K: 2147483646 - 2147483647 = -1 jited:0 960 PASS
[  177.901591] test_bpf: #110 ALU_MUL_X: 2 * 3 = 6 jited:0 1090 PASS
[  177.903565] test_bpf: #111 ALU_MUL_X: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:0 1090 PASS
[  177.905540] test_bpf: #112 ALU_MUL_X: -1 * -1 = 1 jited:0 1090 PASS
[  177.911742] test_bpf: #113 ALU64_MUL_X: 2 * 3 = 6 jited:0 1136 PASS
[  177.913762] test_bpf: #114 ALU64_MUL_X: 1 * 2147483647 = 2147483647 jited:0 1136 PASS
[  177.915782] test_bpf: #115 ALU_MUL_K: 2 * 3 = 6 jited:0 4300 PASS
[  177.920984] test_bpf: #116 ALU_MUL_K: 3 * 1 = 3 jited:0 945 PASS
[  177.922809] test_bpf: #117 ALU_MUL_K: 2 * 0x7FFFFFF8 = 0xFFFFFFF0 jited:0 945 PASS
[  177.924644] test_bpf: #118 ALU_MUL_K: 1 * (-1) = 0x00000000ffffffff jited:0 1417 PASS
[  177.926946] test_bpf: #119 ALU64_MUL_K: 2 * 3 = 6 jited:0 990 PASS
[  177.933091] test_bpf: #120 ALU64_MUL_K: 3 * 1 = 3 jited:0 991 PASS
[  177.934962] test_bpf: #121 ALU64_MUL_K: 1 * 2147483647 = 2147483647 jited:0 991 PASS
[  177.936837] test_bpf: #122 ALU64_MUL_K: 1 * -2147483647 = -2147483647 jited:0 991 PASS
[  177.942065] test_bpf: #123 ALU64_MUL_K: 1 * (-1) = 0xffffffffffffffff jited:0 1462 PASS
[  177.944406] test_bpf: #124 ALU_DIV_X: 6 / 2 = 3 jited:0 1234 PASS
[  177.946523] test_bpf: #125 ALU_DIV_X: 4294967295 / 4294967295 = 1 jited:0 4534 PASS
[  177.951958] test_bpf: #126 ALU64_DIV_X: 6 / 2 = 3 jited:0 1508 PASS
[  177.954344] test_bpf: #127 ALU64_DIV_X: 2147483647 / 2147483647 = 1 jited:0 1455 PASS
[  177.956685] test_bpf: #128 ALU64_DIV_X: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:0 5708 PASS
[  177.963297] test_bpf: #129 ALU_DIV_K: 6 / 2 = 3 jited:0 1082 PASS
[  177.965252] test_bpf: #130 ALU_DIV_K: 3 / 1 = 3 jited:0 1082 PASS
[  177.967218] test_bpf: #131 ALU_DIV_K: 4294967295 / 4294967295 = 1 jited:0 1021 PASS
[  177.972484] test_bpf: #132 ALU_DIV_K: 0xffffffffffffffff / (-1) = 0x1 jited:0 1493 PASS
[  177.974862] test_bpf: #133 ALU64_DIV_K: 6 / 2 = 3 jited:0 1371 PASS
[  177.977117] test_bpf: #134 ALU64_DIV_K: 3 / 1 = 3 jited:0 1371 PASS
[  177.982722] test_bpf: #135 ALU64_DIV_K: 2147483647 / 2147483647 = 1 jited:0 1318 PASS
[  177.984925] test_bpf: #136 ALU64_DIV_K: 0xffffffffffffffff / (-1) = 0x0000000000000001 jited:0 4540 PASS
[  177.990366] test_bpf: #137 ALU_MOD_X: 3 % 2 = 1 jited:0 1242 PASS
[  177.992487] test_bpf: #138 ALU_MOD_X: 4294967295 % 4294967293 = 2 jited:0 1181 PASS
[  177.994552] test_bpf: #139 ALU64_MOD_X: 3 % 2 = 1 jited:0 1599 PASS
[  177.997035] test_bpf: #140 ALU64_MOD_X: 2147483647 % 2147483645 = 2 jited:0 1546 PASS
[  178.003878] test_bpf: #141 ALU_MOD_K: 3 % 2 = 1 jited:0 1089 PASS
[  178.005850] test_bpf: #142 ALU_MOD_K: 3 % 1 = 0 jited:0 PASS
[  178.006634] test_bpf: #143 ALU_MOD_K: 4294967295 % 4294967293 = 2 jited:0 4384 PASS
[  178.011917] test_bpf: #144 ALU64_MOD_K: 3 % 2 = 1 jited:0 1462 PASS
[  178.014258] test_bpf: #145 ALU64_MOD_K: 3 % 1 = 0 jited:0 PASS
[  178.015044] test_bpf: #146 ALU64_MOD_K: 2147483647 % 2147483645 = 2 jited:0 1409 PASS
[  178.020656] test_bpf: #147 ALU_AND_X: 3 & 2 = 2 jited:0 1083 PASS
[  178.022621] test_bpf: #148 ALU_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:0 1083 PASS
[  178.024587] test_bpf: #149 ALU64_AND_X: 3 & 2 = 2 jited:0 1098 PASS
[  178.026570] test_bpf: #150 ALU64_AND_X: 0xffffffff & 0xffffffff = 0xffffffff jited:0 5372 PASS
[  178.032840] test_bpf: #151 ALU_AND_K: 3 & 2 = 2 jited:0 938 PASS
[  178.034655] test_bpf: #152 ALU_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:0 938 PASS
[  178.036476] test_bpf: #153 ALU64_AND_K: 3 & 2 = 2 jited:0 4522 PASS
[  178.041900] test_bpf: #154 ALU64_AND_K: 0xffffffff & 0xffffffff = 0xffffffff jited:0 961 PASS
[  178.043741] test_bpf: #155 ALU64_AND_K: 0x0000ffffffff0000 & 0x0 = 0x0000ffff00000000 jited:0 1432 PASS
[  178.046059] test_bpf: #156 ALU64_AND_K: 0x0000ffffffff0000 & -1 = 0x0000ffffffffffff jited:0 4807 PASS
[  178.051769] test_bpf: #157 ALU64_AND_K: 0xffffffffffffffff & -1 = 0xffffffffffffffff jited:0 1432 PASS
[  178.054079] test_bpf: #158 ALU_OR_X: 1 | 2 = 3 jited:0 1083 PASS
[  178.056045] test_bpf: #159 ALU_OR_X: 0x0 | 0xffffffff = 0xffffffff jited:0 4455 PASS
[  178.061401] test_bpf: #160 ALU64_OR_X: 1 | 2 = 3 jited:0 1098 PASS
[  178.063378] test_bpf: #161 ALU64_OR_X: 0 | 0xffffffff = 0xffffffff jited:0 1098 PASS
[  178.065358] test_bpf: #162 ALU_OR_K: 1 | 2 = 3 jited:0 938 PASS
[  178.067179] test_bpf: #163 ALU_OR_K: 0 & 0xffffffff = 0xffffffff jited:0 938 PASS
[  178.073269] test_bpf: #164 ALU64_OR_K: 1 | 2 = 3 jited:0 960 PASS
[  178.075117] test_bpf: #165 ALU64_OR_K: 0 & 0xffffffff = 0xffffffff jited:0 960 PASS
[  178.076965] test_bpf: #166 ALU64_OR_K: 0x0000ffffffff0000 | 0x0 = 0x0000ffff00000000 jited:0 1432 PASS
[  178.082639] test_bpf: #167 ALU64_OR_K: 0x0000ffffffff0000 | -1 = 0xffffffffffffffff jited:0 1432 PASS
[  178.084953] test_bpf: #168 ALU64_OR_K: 0x000000000000000 | -1 = 0xffffffffffffffff jited:0 1432 PASS
[  178.090657] test_bpf: #169 ALU_XOR_X: 5 ^ 6 = 3 jited:0 1082 PASS
[  178.092624] test_bpf: #170 ALU_XOR_X: 0x1 ^ 0xffffffff = 0xfffffffe jited:0 1083 PASS
[  178.094590] test_bpf: #171 ALU64_XOR_X: 5 ^ 6 = 3 jited:0 1098 PASS
[  178.096576] test_bpf: #172 ALU64_XOR_X: 1 ^ 0xffffffff = 0xfffffffe jited:0 4455 PASS
[  178.101932] test_bpf: #173 ALU_XOR_K: 5 ^ 6 = 3 jited:0 938 PASS
[  178.103748] test_bpf: #174 ALU_XOR_K: 1 ^ 0xffffffff = 0xfffffffe jited:0 938 PASS
[  178.105573] test_bpf: #175 ALU64_XOR_K: 5 ^ 6 = 3 jited:0 961 PASS
[  178.110750] test_bpf: #176 ALU64_XOR_K: 1 & 0xffffffff = 0xfffffffe jited:0 961 PASS
[  178.112594] test_bpf: #177 ALU64_XOR_K: 0x0000ffffffff0000 ^ 0x0 = 0x0000ffffffff0000 jited:0 1432 PASS
[  178.114914] test_bpf: #178 ALU64_XOR_K: 0x0000ffffffff0000 ^ -1 = 0xffff00000000ffff jited:0 1432 PASS
[  178.121736] test_bpf: #179 ALU64_XOR_K: 0x000000000000000 ^ -1 = 0xffffffffffffffff jited:0 1432 PASS
[  178.124060] test_bpf: #180 ALU_LSH_X: 1 << 1 = 2 jited:0 1083 PASS
[  178.126025] test_bpf: #181 ALU_LSH_X: 1 << 31 = 0x80000000 jited:0 3799 PASS
[  178.130723] test_bpf: #182 ALU64_LSH_X: 1 << 1 = 2 jited:0 1159 PASS
[  178.132759] test_bpf: #183 ALU64_LSH_X: 1 << 31 = 0x80000000 jited:0 1159 PASS
[  178.134801] test_bpf: #184 ALU_LSH_K: 1 << 1 = 2 jited:0 938 PASS
[  178.136621] test_bpf: #185 ALU_LSH_K: 1 << 31 = 0x80000000 jited:0 5329 PASS
[  178.142848] test_bpf: #186 ALU64_LSH_K: 1 << 1 = 2 jited:0 1021 PASS
[  178.144747] test_bpf: #187 ALU64_LSH_K: 1 << 31 = 0x80000000 jited:0 1021 PASS
[  178.146650] test_bpf: #188 ALU_RSH_X: 2 >> 1 = 1 jited:0 4491 PASS
[  178.152040] test_bpf: #189 ALU_RSH_X: 0x80000000 >> 31 = 1 jited:0 1083 PASS
[  178.154000] test_bpf: #190 ALU64_RSH_X: 2 >> 1 = 1 jited:0 1159 PASS
[  178.156040] test_bpf: #191 ALU64_RSH_X: 0x80000000 >> 31 = 1 jited:0 4521 PASS
[  178.161461] test_bpf: #192 ALU_RSH_K: 2 >> 1 = 1 jited:0 938 PASS
[  178.163276] test_bpf: #193 ALU_RSH_K: 0x80000000 >> 31 = 1 jited:0 938 PASS
[  178.165098] test_bpf: #194 ALU64_RSH_K: 2 >> 1 = 1 jited:0 1022 PASS
[  178.167002] test_bpf: #195 ALU64_RSH_K: 0x80000000 >> 31 = 1 jited:0 1021 PASS
[  178.173181] test_bpf: #196 ALU_ARSH_X: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:0 1105 PASS
[  178.175169] test_bpf: #197 ALU_ARSH_K: 0xff00ff0000000000 >> 40 = 0xffffffffffff00ff jited:0 968 PASS
[  178.177021] test_bpf: #198 ALU_NEG: -(3) = -3 jited:0 930 PASS
[  178.182220] test_bpf: #199 ALU_NEG: -(-3) = 3 jited:0 930 PASS
[  178.184030] test_bpf: #200 ALU64_NEG: -(3) = -3 jited:0 945 PASS
[  178.185860] test_bpf: #201 ALU64_NEG: -(-3) = 3 jited:0 4293 PASS
[  178.191055] test_bpf: #202 ALU_END_FROM_BE 16: 0x0123456789abcdef -> 0xcdef jited:0 968 PASS
[  178.192905] test_bpf: #203 ALU_END_FROM_BE 32: 0x0123456789abcdef -> 0x89abcdef jited:0 1418 PASS
[  178.195210] test_bpf: #204 ALU_END_FROM_BE 64: 0x0123456789abcdef -> 0x89abcdef jited:0 930 PASS
[  178.197030] test_bpf: #205 ALU_END_FROM_LE 16: 0x0123456789abcdef -> 0xefcd jited:0 1006 PASS
[  178.203329] test_bpf: #206 ALU_END_FROM_LE 32: 0x0123456789abcdef -> 0xefcdab89 jited:0 1440 PASS
[  178.205656] test_bpf: #207 ALU_END_FROM_LE 64: 0x0123456789abcdef -> 0x67452301 jited:0 991 PASS
[  178.209985] test_bpf: #208 ST_MEM_B: Store/Load byte: max negative jited:0 1075 PASS
[  178.211938] test_bpf: #209 ST_MEM_B: Store/Load byte: max positive jited:0 1075 PASS
[  178.213896] test_bpf: #210 STX_MEM_B: Store/Load byte: max negative jited:0 1226 PASS
[  178.216006] test_bpf: #211 ST_MEM_H: Store/Load half word: max negative jited:0 5365 PASS
[  178.222273] test_bpf: #212 ST_MEM_H: Store/Load half word: max positive jited:0 1075 PASS
[  178.224227] test_bpf: #213 STX_MEM_H: Store/Load half word: max negative jited:0 1227 PASS
[  178.226337] test_bpf: #214 ST_MEM_W: Store/Load word: max negative jited:0 4448 PASS
[  178.231687] test_bpf: #215 ST_MEM_W: Store/Load word: max positive jited:0 1075 PASS
[  178.233643] test_bpf: #216 STX_MEM_W: Store/Load word: max negative jited:0 1227 PASS
[  178.235753] test_bpf: #217 ST_MEM_DW: Store/Load double word: max negative jited:0 4478 PASS
[  178.241131] test_bpf: #218 ST_MEM_DW: Store/Load double word: max negative 2 jited:0 1592 PASS
[  178.243602] test_bpf: #219 ST_MEM_DW: Store/Load double word: max positive jited:0 1113 PASS
[  178.245601] test_bpf: #220 STX_MEM_DW: Store/Load double word: max negative jited:0 4605 PASS
[  178.251109] test_bpf: #221 STX_XADD_W: Test: 0x12 + 0x10 = 0x22 jited:0 1295 PASS
[  178.253284] test_bpf: #222 STX_XADD_W: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:0 PASS
[  178.254070] test_bpf: #223 STX_XADD_W: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:0 1143 PASS
[  178.256099] test_bpf: #224 STX_XADD_W: X + 1 + 1 + 1 + ... jited:0 1105655 PASS
[  179.368052] test_bpf: #225 STX_XADD_DW: Test: 0x12 + 0x10 = 0x22 jited:0 1523 PASS
[  179.370452] test_bpf: #226 STX_XADD_DW: Test side-effects, r10: 0x12 + 0x10 = 0x22 jited:0 PASS
[  179.371238] test_bpf: #227 STX_XADD_DW: Test side-effects, r0: 0x12 + 0x10 = 0x22 jited:0 1356 PASS
[  179.373478] test_bpf: #228 STX_XADD_DW: X + 1 + 1 + 1 + ... jited:0 1903525 PASS
[  181.278871] test_bpf: #229 JMP_EXIT jited:0 793 PASS
[  181.280538] test_bpf: #230 JMP_JA: Unconditional jump: if (true) return 1 jited:0 1021 PASS
[  181.282444] test_bpf: #231 JMP_JSLT_K: Signed jump: if (-2 < -1) return 1 jited:0 1249 PASS
[  181.284578] test_bpf: #232 JMP_JSLT_K: Signed jump: if (-1 < -1) return 0 jited:0 1098 PASS
[  181.286560] test_bpf: #233 JMP_JSGT_K: Signed jump: if (-1 > -2) return 1 jited:0 6936 PASS
[  181.294401] test_bpf: #234 JMP_JSGT_K: Signed jump: if (-1 > -1) return 0 jited:0 1098 PASS
[  181.296380] test_bpf: #235 JMP_JSLE_K: Signed jump: if (-2 <= -1) return 1 jited:0 3835 PASS
[  181.301117] test_bpf: #236 JMP_JSLE_K: Signed jump: if (-1 <= -1) return 1 jited:0 1249 PASS
[  181.303244] test_bpf: #237 JMP_JSLE_K: Signed jump: value walk 1 jited:0 2250 PASS
[  181.306379] test_bpf: #238 JMP_JSLE_K: Signed jump: value walk 2 jited:0 5391 PASS
[  181.312672] test_bpf: #239 JMP_JSGE_K: Signed jump: if (-1 >= -2) return 1 jited:0 1249 PASS
[  181.314800] test_bpf: #240 JMP_JSGE_K: Signed jump: if (-1 >= -1) return 1 jited:0 1249 PASS
[  181.316932] test_bpf: #241 JMP_JSGE_K: Signed jump: value walk 1 jited:0 2136 PASS
[  181.323378] test_bpf: #242 JMP_JSGE_K: Signed jump: value walk 2 jited:0 1841 PASS
[  181.326102] test_bpf: #243 JMP_JGT_K: if (3 > 2) return 1 jited:0 3713 PASS
[  181.330719] test_bpf: #244 JMP_JGT_K: Unsigned jump: if (-1 > 1) return 1 jited:0 1219 PASS
[  181.332818] test_bpf: #245 JMP_JLT_K: if (2 < 3) return 1 jited:0 1257 PASS
[  181.334964] test_bpf: #246 JMP_JGT_K: Unsigned jump: if (1 < -1) return 1 jited:0 1219 PASS
[  181.337070] test_bpf: #247 JMP_JGE_K: if (3 >= 2) return 1 jited:0 1914 PASS
[  181.344152] test_bpf: #248 JMP_JLE_K: if (2 <= 3) return 1 jited:0 1256 PASS
[  181.346293] test_bpf: #249 JMP_JGT_K: if (3 > 2) return 1 (jump backwards) jited:0 3816 PASS
[  181.351008] test_bpf: #250 JMP_JGE_K: if (3 >= 3) return 1 jited:0 1914 PASS
[  181.353801] test_bpf: #251 JMP_JGT_K: if (2 < 3) return 1 (jump backwards) jited:0 1363 PASS
[  181.356048] test_bpf: #252 JMP_JLE_K: if (3 <= 3) return 1 jited:0 4633 PASS
[  181.361578] test_bpf: #253 JMP_JNE_K: if (3 != 2) return 1 jited:0 1242 PASS
[  181.363699] test_bpf: #254 JMP_JEQ_K: if (3 == 3) return 1 jited:0 1249 PASS
[  181.365831] test_bpf: #255 JMP_JSET_K: if (0x3 & 0x2) return 1 jited:0 4600 PASS
[  181.371333] test_bpf: #256 JMP_JSET_K: if (0x3 & 0xffffffff) return 1 jited:0 1234 PASS
[  181.373447] test_bpf: #257 JMP_JSGT_X: Signed jump: if (-1 > -2) return 1 jited:0 1393 PASS
[  181.375727] test_bpf: #258 JMP_JSGT_X: Signed jump: if (-1 > -1) return 0 jited:0 4769 PASS
[  181.381397] test_bpf: #259 JMP_JSLT_X: Signed jump: if (-2 < -1) return 1 jited:0 1393 PASS
[  181.383670] test_bpf: #260 JMP_JSLT_X: Signed jump: if (-1 < -1) return 0 jited:0 1242 PASS
[  181.385798] test_bpf: #261 JMP_JSGE_X: Signed jump: if (-1 >= -2) return 1 jited:0 4780 PASS
[  181.391479] test_bpf: #262 JMP_JSGE_X: Signed jump: if (-1 >= -1) return 1 jited:0 1393 PASS
[  181.393752] test_bpf: #263 JMP_JSLE_X: Signed jump: if (-2 <= -1) return 1 jited:0 1393 PASS
[  181.396031] test_bpf: #264 JMP_JSLE_X: Signed jump: if (-1 <= -1) return 1 jited:0 4775 PASS
[  181.401706] test_bpf: #265 JMP_JGT_X: if (3 > 2) return 1 jited:0 1401 PASS
[  181.403986] test_bpf: #266 JMP_JGT_X: Unsigned jump: if (-1 > 1) return 1 jited:0 1355 PASS
[  181.406225] test_bpf: #267 JMP_JLT_X: if (2 < 3) return 1 jited:0 4783 PASS
[  181.411912] test_bpf: #268 JMP_JLT_X: Unsigned jump: if (1 < -1) return 1 jited:0 1355 PASS
[  181.414146] test_bpf: #269 JMP_JGE_X: if (3 >= 2) return 1 jited:0 1401 PASS
[  181.416432] test_bpf: #270 JMP_JGE_X: if (3 >= 3) return 1 jited:0 4775 PASS
[  181.422109] test_bpf: #271 JMP_JLE_X: if (2 <= 3) return 1 jited:0 1401 PASS
[  181.424390] test_bpf: #272 JMP_JLE_X: if (3 <= 3) return 1 jited:0 1401 PASS
[  181.426674] test_bpf: #273 JMP_JGE_X: ldimm64 test 1 jited:0 4782 PASS
[  181.432355] test_bpf: #274 JMP_JGE_X: ldimm64 test 2 jited:0 1409 PASS
[  181.434639] test_bpf: #275 JMP_JGE_X: ldimm64 test 3 jited:0 1280 PASS
[  181.436804] test_bpf: #276 JMP_JLE_X: ldimm64 test 1 jited:0 1409 PASS
[  181.442459] test_bpf: #277 JMP_JLE_X: ldimm64 test 2 jited:0 1409 PASS
[  181.444745] test_bpf: #278 JMP_JLE_X: ldimm64 test 3 jited:0 1280 PASS
[  181.446907] test_bpf: #279 JMP_JNE_X: if (3 != 2) return 1 jited:0 1385 PASS
[  181.452534] test_bpf: #280 JMP_JEQ_X: if (3 == 3) return 1 jited:0 1393 PASS
[  181.454808] test_bpf: #281 JMP_JSET_X: if (0x3 & 0x2) return 1 jited:0 1386 PASS
[  181.457079] test_bpf: #282 JMP_JSET_X: if (0x3 & 0xffffffff) return 1 jited:0 1386 PASS
[  181.462703] test_bpf: #283 JMP_JA: Jump, gap, jump, ... jited:1 185 PASS
[  181.463804] test_bpf: #284 BPF_MAXINSNS: Maximum possible literals jited:1 139 PASS
[  181.478541] test_bpf: #285 BPF_MAXINSNS: Single literal jited:1 147 PASS
[  181.492851] test_bpf: #286 BPF_MAXINSNS: Run/add until end jited:1 288268 PASS
[  181.793472] test_bpf: #287 BPF_MAXINSNS: Too many instructions PASS
[  181.793575] test_bpf: #288 BPF_MAXINSNS: Very long jump jited:1 178 PASS
[  181.808946] test_bpf: #289 BPF_MAXINSNS: Ctx heavy transformations jited:1 287886 287626 PASS
[  182.397707] test_bpf: #290 BPF_MAXINSNS: Call heavy transformations jited:1 144666 144287 PASS
[  182.698911] test_bpf: #291 BPF_MAXINSNS: Jump heavy test jited:1 572749 PASS
[  183.291353] test_bpf: #292 BPF_MAXINSNS: Very long jump backwards jited:0 1006 PASS
[  183.294161] test_bpf: #293 BPF_MAXINSNS: Edge hopping nuthouse jited:0 637927 PASS
[  183.933907] test_bpf: #294 BPF_MAXINSNS: Jump, gap, jump, ... jited:1 1085 PASS
[  183.946818] test_bpf: #295 BPF_MAXINSNS: jump over MSH UNEXPECTED_PASS
[  183.965180] test_bpf: #296 BPF_MAXINSNS: exec all MSH jited:1 1214542 PASS
[  185.198619] test_bpf: #297 BPF_MAXINSNS: ld_abs+get_processor_id jited:1 671449 PASS
[  185.886320] test_bpf: #298 LD_IND byte frag jited:1 ret 202 != 66 FAIL (1 times)
[  185.890631] test_bpf: #299 LD_IND halfword frag jited:1 ret 51958 != 17220 FAIL (1 times)
[  185.893461] test_bpf: #300 LD_IND word frag jited:1 1682 PASS
[  185.896227] test_bpf: #301 LD_IND halfword mixed head/frag jited:1 ret 51958 != 1305 FAIL (1 times)
[  185.902742] test_bpf: #302 LD_IND word mixed head/frag jited:1 2084 PASS
[  185.905907] test_bpf: #303 LD_ABS byte frag jited:1 ret 202 != 66 FAIL (1 times)
[  185.911128] test_bpf: #304 LD_ABS halfword frag jited:1 ret 51958 != 17220 FAIL (1 times)
[  185.913915] test_bpf: #305 LD_ABS word frag jited:1 1644 PASS
[  185.916646] test_bpf: #306 LD_ABS halfword mixed head/frag jited:1 ret 51958 != 1305 FAIL (1 times)
[  185.923107] test_bpf: #307 LD_ABS word mixed head/frag jited:1 2046 PASS
[  185.926234] test_bpf: #308 LD_IND byte default X jited:1 2995 PASS
[  185.930285] test_bpf: #309 LD_IND byte positive offset jited:1 406 PASS
[  185.931725] test_bpf: #310 LD_IND byte negative offset jited:1 406 PASS
[  185.933166] test_bpf: #311 LD_IND byte positive offset, all ff jited:1 406 PASS
[  185.934610] test_bpf: #312 LD_IND byte positive offset, out of bounds jited:1 664 PASS
[  185.936312] test_bpf: #313 LD_IND byte negative offset, out of bounds jited:1 5935 PASS
[  185.943310] test_bpf: #314 LD_IND byte negative offset, multiple calls jited:1 2272 PASS
[  185.946627] test_bpf: #315 LD_IND halfword positive offset jited:1 412 PASS
[  185.950539] test_bpf: #316 LD_IND halfword negative offset jited:1 413 PASS
[  185.951987] test_bpf: #317 LD_IND halfword unaligned jited:1 413 PASS
[  185.953441] test_bpf: #318 LD_IND halfword positive offset, all ff jited:1 413 PASS
[  185.954893] test_bpf: #319 LD_IND halfword positive offset, out of bounds jited:1 672 PASS
[  185.956606] test_bpf: #320 LD_IND halfword negative offset, out of bounds jited:1 749 PASS
[  185.963610] test_bpf: #321 LD_IND word positive offset jited:1 413 PASS
[  185.965053] test_bpf: #322 LD_IND word negative offset jited:1 414 PASS
[  185.966504] test_bpf: #323 LD_IND word unaligned (addr & 3 == 2) jited:1 3770 PASS
[  185.971340] test_bpf: #324 LD_IND word unaligned (addr & 3 == 1) jited:1 414 PASS
[  185.972788] test_bpf: #325 LD_IND word unaligned (addr & 3 == 3) jited:1 414 PASS
[  185.974241] test_bpf: #326 LD_IND word positive offset, all ff jited:1 413 PASS
[  185.975692] test_bpf: #327 LD_IND word positive offset, out of bounds jited:1 672 PASS
[  185.981673] test_bpf: #328 LD_IND word negative offset, out of bounds jited:1 748 PASS
[  185.983454] test_bpf: #329 LD_ABS byte jited:1 368 PASS
[  185.984857] test_bpf: #330 LD_ABS byte positive offset, all ff jited:1 368 PASS
[  185.986260] test_bpf: #331 LD_ABS byte positive offset, out of bounds jited:1 4897 PASS
[  185.992221] test_bpf: #332 LD_ABS byte negative offset, out of bounds load PASS
[  185.992896] test_bpf: #333 LD_ABS byte negative offset, in bounds jited:1 702 PASS
[  185.994636] test_bpf: #334 LD_ABS byte negative offset, out of bounds jited:1 703 PASS
[  185.996379] test_bpf: #335 LD_ABS byte negative offset, multiple calls jited:1 6353 PASS
[  186.003806] test_bpf: #336 LD_ABS halfword jited:1 375 PASS
[  186.005208] test_bpf: #337 LD_ABS halfword unaligned jited:1 375 PASS
[  186.006618] test_bpf: #338 LD_ABS halfword positive offset, all ff jited:1 375 PASS
[  186.011399] test_bpf: #339 LD_ABS halfword positive offset, out of bounds jited:1 634 PASS
[  186.013065] test_bpf: #340 LD_ABS halfword negative offset, out of bounds load PASS
[  186.013748] test_bpf: #341 LD_ABS halfword negative offset, in bounds jited:1 702 PASS
[  186.015487] test_bpf: #342 LD_ABS halfword negative offset, out of bounds jited:1 703 PASS
[  186.022433] test_bpf: #343 LD_ABS word jited:1 375 PASS
[  186.023851] test_bpf: #344 LD_ABS word unaligned (addr & 3 == 2) jited:1 375 PASS
[  186.025259] test_bpf: #345 LD_ABS word unaligned (addr & 3 == 1) jited:1 375 PASS
[  186.026670] test_bpf: #346 LD_ABS word unaligned (addr & 3 == 3) jited:1 375 PASS
[  186.031454] test_bpf: #347 LD_ABS word positive offset, all ff jited:1 375 PASS
[  186.032859] test_bpf: #348 LD_ABS word positive offset, out of bounds jited:1 634 PASS
[  186.034528] test_bpf: #349 LD_ABS word negative offset, out of bounds load PASS
[  186.035211] test_bpf: #350 LD_ABS word negative offset, in bounds jited:1 702 PASS
[  186.036951] test_bpf: #351 LD_ABS word negative offset, out of bounds jited:1 702 PASS
[  186.043899] test_bpf: #352 LDX_MSH standalone, preserved A jited:1 398 PASS
[  186.045326] test_bpf: #353 LDX_MSH standalone, preserved A 2 jited:1 762 PASS
[  186.047135] test_bpf: #354 LDX_MSH standalone, test result 1 jited:1 413 PASS
[  186.051937] test_bpf: #355 LDX_MSH standalone, test result 2 jited:1 413 PASS
[  186.053389] test_bpf: #356 LDX_MSH standalone, negative offset jited:1 710 PASS
[  186.055137] test_bpf: #357 LDX_MSH standalone, negative offset 2 jited:1 748 PASS
[  186.056927] test_bpf: #358 LDX_MSH standalone, out of bounds jited:1 656 PASS
[  186.063049] test_bpf: #359 ADD default X jited:1 170 PASS
[  186.064186] test_bpf: #360 ADD default A jited:1 155 PASS
[  186.065309] test_bpf: #361 SUB default X jited:1 170 PASS
[  186.066452] test_bpf: #362 SUB default A jited:1 163 PASS
[  186.072115] test_bpf: #363 MUL default X jited:1 171 PASS
[  186.073255] test_bpf: #364 MUL default A jited:1 155 PASS
[  186.074379] test_bpf: #365 DIV default X jited:1 193 PASS
[  186.075549] test_bpf: #366 DIV default A jited:1 148 PASS
[  186.076661] test_bpf: #367 MOD default X jited:1 192 PASS
[  186.083012] test_bpf: #368 MOD default A jited:1 223 PASS
[  186.084201] test_bpf: #369 JMP EQ default A jited:1 170 PASS
[  186.085346] test_bpf: #370 JMP EQ default X jited:1 201 PASS
[  186.086529] test_bpf: #371 JNE signed compare, test 1 jited:0 5788 PASS
[  186.093229] test_bpf: #372 JNE signed compare, test 2 jited:0 1530 PASS
[  186.095641] test_bpf: #373 JNE signed compare, test 3 jited:0 4230 PASS
[  186.100772] test_bpf: #374 JNE signed compare, test 4 jited:0 1211 PASS
[  186.102862] test_bpf: #375 JNE signed compare, test 5 jited:0 1098 PASS
[  186.104846] test_bpf: #376 JNE signed compare, test 6 jited:0 1212 PASS
[  186.106942] test_bpf: #377 JNE signed compare, test 7 jited:1 223 PASS
[  186.112429] test_bpf: Summary: 371 PASSED, 7 FAILED, [119/366 JIT'ed]

Christophe Leroy (7):
  powerpc/bpf: Remove classical BPF support for PPC32
  powerpc/bpf: Change register numbering for bpf_set/is_seen_register()
  powerpc/bpf: Move common helpers into bpf_jit.h
  powerpc/bpf: Move common functions into bpf_jit_comp.c
  powerpc/bpf: Change values of SEEN_ flags
  powerpc/asm: Add some opcodes in asm/ppc-opcode.h for PPC32 eBPF
  powerpc/bpf: Implement extended BPF on PPC32

 arch/powerpc/Kconfig                  |    3 +-
 arch/powerpc/include/asm/ppc-opcode.h |   12 +
 arch/powerpc/net/Makefile             |    6 +-
 arch/powerpc/net/bpf_jit.h            |   45 ++
 arch/powerpc/net/bpf_jit32.h          |  159 +---
 arch/powerpc/net/bpf_jit64.h          |   19 -
 arch/powerpc/net/bpf_jit_asm.S        |  226 ------
 arch/powerpc/net/bpf_jit_comp.c       |  780 +++++--------------
 arch/powerpc/net/bpf_jit_comp32.c     | 1020 +++++++++++++++++++++++++
 arch/powerpc/net/bpf_jit_comp64.c     |  286 +------
 10 files changed, 1312 insertions(+), 1244 deletions(-)
 delete mode 100644 arch/powerpc/net/bpf_jit_asm.S
 create mode 100644 arch/powerpc/net/bpf_jit_comp32.c

-- 
2.25.0



