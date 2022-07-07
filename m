Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1916D56A230
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 14:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbiGGMjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 08:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234774AbiGGMjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 08:39:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04DF2AE16
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 05:39:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id t10-20020a5b07ca000000b0066ec1bb6e2cso692645ybq.14
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 05:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PSs8GSF9fKtK3coD71Wm1KuzoLxRaCJtUBFp2eC8ArE=;
        b=QkB6fzLHgsc7WQ//VSio3p7Y23v6palwLeswYO9qz6howMhvMhXh+9oD6Hqo1Z6r0f
         t4lEqlrc82QWcdFcAN9yqchRITg3eLjZAabIFpphOpf46xUAoGSCsfHgd9JWGinJVbDA
         EWKwyrdQUyQGufKQRbBX0Dz0Z700H6uezK6x0yMpudZ02Lut4RNmy+pCDvTvx0Ef4+L4
         iYA+5F75T0EwBQ7vnOBZiQ5Ju7xDNGoz0Gk3em/TzXjWsOQukpEJUONuORThYiV6k5HZ
         +3ZjX/fk7dh45aSBDIi7izp3X73VFpVhL/ORJdeZQROR2xESpS07EobSXjlLtsykbjAX
         3deg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PSs8GSF9fKtK3coD71Wm1KuzoLxRaCJtUBFp2eC8ArE=;
        b=7xNPjfSDs+c3BfTpgDJNQGXSA34WeepEBUmPGP4ETs0YVCuYwei69PPbz5r0XLGO6y
         TuqsDGoSNd8QT+n3E/0GsP3F8Sh16SGV7pfD9PbcN+KI/2cVNyfl67oZWpGIDqvStBqu
         SbytMZJe8u/xUEb/4QQ9rPHqpyzKE0z+YfYxM8Ld/z4Kx6gTB0vOeqOWJhDGTckALay+
         vz3aOMG4VnDESifNOE1D/K9CuoYZhOCd0pp9eXU7/Wwy1ty0AFfuvc/i+/eWeptYblzc
         kOlCqu/AV45bVM+T1Cd3VujTeToUPKchIpkJSRE3LIHCu56Kkr1zOsaGOE8F3+KTFwOo
         t+FA==
X-Gm-Message-State: AJIora9ADG9Q84ja+cXNrY7zEiG0+/TPaIfanbHw6EJs/65nMAjBMVUl
        B1KEdc8UpPTeKJx0D/b0gDkOEvINzWjbiw==
X-Google-Smtp-Source: AGRyM1sVm0UdUjAoQ21LBY7o0Hir+gzmClLXfYMVGdSKKgp7WRwrF90Uo0lV5ryQZZgVhyNgsCSD5gJk6k5p7Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:154e:b0:66e:6718:f6f2 with SMTP
 id r14-20020a056902154e00b0066e6718f6f2mr17903305ybu.228.1657197541914; Thu,
 07 Jul 2022 05:39:01 -0700 (PDT)
Date:   Thu,  7 Jul 2022 12:39:00 +0000
Message-Id: <20220707123900.945305-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH] bpf: make sure mac_header was set before using it
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Classic BPF has a way to load bytes starting from the mac header.

Some skbs do not have a mac header, and skb_mac_header()
in this case is returning a pointer that 65535 bytes after
skb->head.

Existing range check in bpf_internal_load_pointer_neg_helper()
was properly kicking and no illegal access was happening.

New sanity check in skb_mac_header() is firing, so we need
to avoid it.

WARNING: CPU: 1 PID: 28990 at include/linux/skbuff.h:2785 skb_mac_header include/linux/skbuff.h:2785 [inline]
WARNING: CPU: 1 PID: 28990 at include/linux/skbuff.h:2785 bpf_internal_load_pointer_neg_helper+0x1b1/0x1c0 kernel/bpf/core.c:74
Modules linked in:
CPU: 1 PID: 28990 Comm: syz-executor.0 Not tainted 5.19.0-rc4-syzkaller-00865-g4874fb9484be #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
RIP: 0010:skb_mac_header include/linux/skbuff.h:2785 [inline]
RIP: 0010:bpf_internal_load_pointer_neg_helper+0x1b1/0x1c0 kernel/bpf/core.c:74
Code: ff ff 45 31 f6 e9 5a ff ff ff e8 aa 27 40 00 e9 3b ff ff ff e8 90 27 40 00 e9 df fe ff ff e8 86 27 40 00 eb 9e e8 2f 2c f3 ff <0f> 0b eb b1 e8 96 27 40 00 e9 79 fe ff ff 90 41 57 41 56 41 55 41
RSP: 0018:ffffc9000309f668 EFLAGS: 00010216
RAX: 0000000000000118 RBX: ffffffffffeff00c RCX: ffffc9000e417000
RDX: 0000000000040000 RSI: ffffffff81873f21 RDI: 0000000000000003
RBP: ffff8880842878c0 R08: 0000000000000003 R09: 000000000000ffff
R10: 000000000000ffff R11: 0000000000000001 R12: 0000000000000004
R13: ffff88803ac56c00 R14: 000000000000ffff R15: dffffc0000000000
FS: 00007f5c88a16700(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdaa9f6c058 CR3: 000000003a82c000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
____bpf_skb_load_helper_32 net/core/filter.c:276 [inline]
bpf_skb_load_helper_32+0x191/0x220 net/core/filter.c:264

Fixes: f9aefd6b2aa3 ("net: warn if mac header was not set")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 kernel/bpf/core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index b5ffebcce6ccae22ad3d252c823b7a61d7bfd206..9d17baac1144227f61bdbd69294a3ad70bf26389 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -68,11 +68,13 @@ void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, uns
 {
 	u8 *ptr = NULL;
 
-	if (k >= SKF_NET_OFF)
+	if (k >= SKF_NET_OFF) {
 		ptr = skb_network_header(skb) + k - SKF_NET_OFF;
-	else if (k >= SKF_LL_OFF)
+	} else if (k >= SKF_LL_OFF) {
+		if (unlikely(!skb_mac_header_was_set(skb)))
+			return NULL;
 		ptr = skb_mac_header(skb) + k - SKF_LL_OFF;
-
+	}
 	if (ptr >= skb->head && ptr + size <= skb_tail_pointer(skb))
 		return ptr;
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

