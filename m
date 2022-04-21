Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB6F50946E
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383506AbiDUAod (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383503AbiDUAmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:42:20 -0400
Received: from mail-40134.protonmail.ch (mail-40134.protonmail.ch [185.70.40.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4CA23140
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 17:39:32 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501571;
        bh=wuC1+vhay3ASZ7SmRAfdiwma2HlM/uaJNS3a/KTFZuQ=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=NIW25xfbt5y/meQ91SkENqxh9jDr3xHuEFfIe9oFetZeS9Esx9nq8D+f3xtwOA4R5
         b8GP5uR12nhhBLrs6GCiJ9HDeL2dRxCDOeTJFvJrsvupR+G9tQBAfOuRy3NbmPIKQG
         yUsJCTvZzpOmbj9S6V4ErjLhrazOgUcobhQeqJXW4HwXhIeTgHVcnj+sK2WvRUkvNp
         dnrx3QM6E4YCMKtE3+EIDd8FW/HTImIihzbNRxk28a1+yBz0CpoF09lH7OXpmdDOl+
         bWGk2DnVUw9kxrDqtPC+fMy3Eakf9VhoJseNmaf9Rycy1KX5opa+VHbFubileRA6jJ
         71UbHrbwvhDsQ==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf 05/11] samples/bpf: add 'asm/mach-generic' include path for every MIPS
Message-ID: <20220421003152.339542-6-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following:

In file included from samples/bpf/tracex2_kern.c:7:
In file included from ./include/linux/skbuff.h:13:
In file included from ./include/linux/kernel.h:22:
In file included from ./include/linux/bitops.h:33:
In file included from ./arch/mips/include/asm/bitops.h:20:
In file included from ./arch/mips/include/asm/barrier.h:11:
./arch/mips/include/asm/addrspace.h:13:10: fatal error: 'spaces.h' file not=
 found
 #include <spaces.h>
          ^~~~~~~~~~

'arch/mips/include/asm/mach-generic' should always be included as
many other MIPS include files rely on this.
Move it from under CONFIG_MACH_LOONGSON64 to let it be included
for every MIPS.

Fixes: 058107abafc7 ("samples/bpf: Add include dir for MIPS Loongson64 to f=
ix build errors")
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 38638845db9d..70323ac1114f 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -194,8 +194,8 @@ ifeq ($(ARCH), mips)
 TPROGS_CFLAGS +=3D -D__SANE_USERSPACE_TYPES__
 ifdef CONFIG_MACH_LOONGSON64
 BPF_EXTRA_CFLAGS +=3D -I$(srctree)/arch/mips/include/asm/mach-loongson64
-BPF_EXTRA_CFLAGS +=3D -I$(srctree)/arch/mips/include/asm/mach-generic
 endif
+BPF_EXTRA_CFLAGS +=3D -I$(srctree)/arch/mips/include/asm/mach-generic
 endif

 TPROGS_CFLAGS +=3D -Wall -O2
--
2.36.0


