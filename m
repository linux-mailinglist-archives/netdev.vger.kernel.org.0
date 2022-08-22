Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC18559C904
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 21:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238748AbiHVTfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 15:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238671AbiHVTfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 15:35:46 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953FBA194
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 12:35:44 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id AC1DE10CDA500; Mon, 22 Aug 2022 12:35:29 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     andrii@kernel.org, daniel@iogearbox.net, ast@kernel.org,
        kafai@fb.com, kuba@kernel.org, netdev@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH bpf-next v3 0/3] Add skb + xdp dynptrs
Date:   Mon, 22 Aug 2022 12:34:39 -0700
Message-Id: <20220822193442.657638-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.3 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,SPOOFED_FREEMAIL,SPOOF_GMAIL_MID,
        TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is the 2nd in the dynptr series. The 1st can be found here =
[0].

This patchset adds skb and xdp type dynptrs, which have two main benefits=
 for
packet parsing:
    * allowing operations on sizes that are not statically known at
      compile-time (eg variable-sized accesses).
    * more ergonomic and less brittle iteration through data (eg does not=
 need
      manual if checking for being within bounds of data_end)

When comparing the differences in runtime for packet parsing without dynp=
trs
vs. with dynptrs for the more simple cases, there is no noticeable differ=
ence.
For the more complex cases where lengths are non-statically known at comp=
ile
time, there can be a significant speed-up when using dynptrs (eg a 2x spe=
ed up
for cls redirection). Patch 3 contains more details as well as examples o=
f how
to use skb and xdp dynptrs.

[0] https://lore.kernel.org/bpf/20220523210712.3641569-1-joannelkoong@gma=
il.com/

--
Changelog:

v2 =3D https://lore.kernel.org/bpf/20220811230501.2632393-1-joannelkoong@=
gmail.com/
v2 -> v3
    * Fix kernel test robot build test errors

v1 =3D https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@g=
mail.com/
v1 -> v2
  * Return data slices to rd-only skb dynptrs (Martin)
  * bpf_dynptr_write allows writes to frags for skb dynptrs, but always
    invalidates associated data slices (Martin)
  * Use switch casing instead of ifs (Andrii)
  * Use 0xFD for experimental kind number in the selftest (Zvi)
  * Put selftest conversions w/ dynptrs into new files (Alexei)
  * Add new selftest "test_cls_redirect_dynptr.c"=20

Joanne Koong (3):
  bpf: Add skb dynptrs
  bpf: Add xdp dynptrs
  selftests/bpf: tests for using dynptrs to parse skb and xdp buffers

 include/linux/bpf.h                           |  14 +-
 include/linux/filter.h                        |   7 +
 include/uapi/linux/bpf.h                      |  59 +-
 kernel/bpf/helpers.c                          |  93 +-
 kernel/bpf/verifier.c                         | 105 +-
 net/core/filter.c                             |  99 +-
 tools/include/uapi/linux/bpf.h                |  59 +-
 .../selftests/bpf/prog_tests/cls_redirect.c   |  25 +
 .../testing/selftests/bpf/prog_tests/dynptr.c | 132 ++-
 .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +
 .../bpf/prog_tests/parse_tcp_hdr_opt.c        |  85 ++
 .../selftests/bpf/prog_tests/xdp_attach.c     |   9 +-
 .../testing/selftests/bpf/progs/dynptr_fail.c | 111 ++
 .../selftests/bpf/progs/dynptr_success.c      |  29 +
 .../bpf/progs/test_cls_redirect_dynptr.c      | 968 ++++++++++++++++++
 .../bpf/progs/test_l4lb_noinline_dynptr.c     | 468 +++++++++
 .../bpf/progs/test_parse_tcp_hdr_opt.c        | 119 +++
 .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c | 110 ++
 .../selftests/bpf/progs/test_xdp_dynptr.c     | 240 +++++
 .../selftests/bpf/test_tcp_hdr_options.h      |   1 +
 20 files changed, 2649 insertions(+), 86 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_=
opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_d=
ynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_=
dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_=
opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_=
opt_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c

--=20
2.30.2

