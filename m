Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31596298F9
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiKOMgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiKOMgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:36:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279BDA198;
        Tue, 15 Nov 2022 04:36:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B6446171A;
        Tue, 15 Nov 2022 12:36:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B09BC433C1;
        Tue, 15 Nov 2022 12:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668515772;
        bh=qmPFiEaraXdgB5f1UJNBrZjNvt2PgIKdA/nVThcBsEQ=;
        h=From:To:Cc:Subject:Date:From;
        b=EiS6erefJTY+H7GXTdMUJUTMWyMXtFAk9NEzWd13Naw6lFjciU/Ptok0pvk/kWav2
         1A9XbBduLrSGo9mc+cGMl8YcSZgFTUdNdWnTId9Q1EnfotuYWqbsjicP0QNzekw2AP
         gLYHu/GEBKckP/4Ykfq/9eW/rCmm9vDeUqtENCnerV2Ic9Et0dXQYAKdRYWRPigk6r
         mOLAVtEPwp1rgfIaFP8RORBByHbreXdcD64ULgbhcSwzLNay1W3mHNsY1oyAWA/XiU
         qSPgSVATAfDViyH9iHNlKnVTdv9/xACZ61DwDiDzgVxPD7eXYHjSHCAcHN3+6bHwR6
         hC+3tM168wiqA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     Anders Roxell <anders.roxell@linaro.org>
Subject: BPF, cross-compiling, and selftests
Date:   Tue, 15 Nov 2022 13:36:08 +0100
Message-ID: <878rkc1jk7.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I ran into build issues when building selftests/net on Ubuntu/Debian,
which is related to that BPF program builds usually needs libc (and the
corresponding target host configuration/defines).

When I try to build selftests/net, on my Debian host I get:

  clang -O2 -target bpf -c bpf/nat6to4.c -I../../bpf -I../../../../lib -I..=
/../../../../usr/include/ -o /home/bjorn/src/linux/linux/tools/testing/self=
tests/net/bpf/nat6to4.o
  In file included from bpf/nat6to4.c:27:
  In file included from /usr/include/linux/bpf.h:11:
  /usr/include/linux/types.h:5:10: fatal error: 'asm/types.h' file not found
  #include <asm/types.h>
           ^~~~~~~~~~~~~
  1 error generated.

asm/types.h lives in /usr/include/"TRIPLE" on Debian, say
/usr/include/x86_64-linux-gnu. Target BPF does not (obviously) add the
x86-64 search path. These kind of problems have been worked around in,
e.g., commit 167381f3eac0 ("selftests/bpf: Makefile fix "missing"
headers on build with -idirafter").

However, just adding the host specific path is not enough. Typically,
when you start to include libc files, like "sys/socket.h" it's
expected that host specific defines are set. On my x86-64 host:

  $ clang -dM -E - < /dev/null|grep x86_
  #define __x86_64 1
  #define __x86_64__ 1
=20=20
  $ clang -target riscv64-linux-gnu -dM -E - < /dev/null|grep xlen
  #define __riscv_xlen 64

otherwise you end up with errors like the one below.

Missing __x86_64__:
  #if !defined __x86_64__
  # include <gnu/stubs-32.h>
  #endif

  clang -O2 -target bpf -c bpf/nat6to4.c -idirafter /usr/lib/llvm-16/lib/cl=
ang/16.0.0/include -idirafter /usr/local/include -idirafter /usr/include/x8=
6_64-linux-gnu -idirafter /usr/include  -Wno-compare-distinct-pointer-types=
 -I../../bpf -I../../../../lib -I../../../../../usr/include/ -o /home/bjorn=
/src/linux/linux/tools/testing/selftests/net/bpf/nat6to4.o
  In file included from bpf/nat6to4.c:28:
  In file included from /usr/include/linux/if.h:28:
  In file included from /usr/include/x86_64-linux-gnu/sys/socket.h:22:
  In file included from /usr/include/features.h:510:
  /usr/include/x86_64-linux-gnu/gnu/stubs.h:7:11: fatal error: 'gnu/stubs-3=
2.h' file not found
  # include <gnu/stubs-32.h>
            ^~~~~~~~~~~~~~~~
  1 error generated.

Now, say that we'd like to cross-compile for a platform. Should I make
sure that all the target compiler's "default defines" are exported to
the BPF-program build step? I did a hack for RISC-V a while back in
commit 6016df8fe874 ("selftests/bpf: Fix broken riscv build"). Not
super robust, and not something I'd like to see for all supported
platforms.

Any ideas? Maybe a convenience switch to Clang/target bpf? :-)


Bj=C3=B6rn
