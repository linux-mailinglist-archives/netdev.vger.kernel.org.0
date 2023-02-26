Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EACD46A2EDB
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 09:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjBZIvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 03:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBZIvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 03:51:55 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5813E113F1;
        Sun, 26 Feb 2023 00:51:52 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id i5so2095767pla.2;
        Sun, 26 Feb 2023 00:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iId5kM56T4q4lSaSsh+X8YPMGiFX5DsYGa42UGupNGE=;
        b=lHKxgrHo+R/EPL5r4Evx6YILGKB7AlGVrXgtY0Futp8v2teuhw+1qtX1FkJh2jGjFn
         AhUwxtxOEmKDcGXUCdAmAXpsAmYb4BCQbpsFT6flVETo8mfP5Hx/IIbHZBUC5IeKnaMp
         yUcOawD1Ee2/wfafPwTyd7MkqO/fAH7yLSaqX+nFdHAnzljIEDsUmPzonqskFyLH38VC
         l3RMCXxOzeCvvhdQQsu3D2MBa42UXHz+UXZPQ2qY+lbn2pjCqoFgmzUbzmPCIzjSoHSH
         CSan6IYbpT8jQbRNun/s2UGO72rJ9yjo/eFbB9CYWZn2hPXir2Stthkagx/fTb6uX9fz
         sfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iId5kM56T4q4lSaSsh+X8YPMGiFX5DsYGa42UGupNGE=;
        b=KTA9KGOBIvdDnhVU+yN8w96814LoW6j/LuGjOclXRlj07RM2kY3NYjRdNXfdKx64R1
         NSKDNCC06p6inYEdPA3aBa/T0kJ73+xMdE9fVgdorWLPH3ynJea5KlnGVij9+o5Ncy8h
         JUTMuwLG1Sp8AiaOt0PQ4oAzsST/jcbMSqmGxqiZIGXAO06yZUoWHMwOpscVXvggW4Um
         vwpLSo7BMOeR/ZY+UYjMnm0txyTFP09+yW/VsMd8ElCId7UABOXAbu0dG0KALv7li7D6
         QquvBOd3OsscQus89EBXMWifRptVvyqYxaH7E36N7ULvv5mDGChxGmgluJyzC8CdIvd/
         STGw==
X-Gm-Message-State: AO0yUKVxdGbhQgqwDmOQmBhgAYmVZwc482jzZMy20p2aMlUQXha33/DN
        Tpvdt2HUpgf4lfl4wIdv2gmGS2TFmVg=
X-Google-Smtp-Source: AK7set8mFK6HzjaZfzdwAljioqGZDLBNTWxH0LXy7ZeLpfYW2uFWLkD8+OZdpnO5JcQpBMu/f6H9Rw==
X-Received: by 2002:a05:6a20:3d81:b0:cc:32aa:8570 with SMTP id s1-20020a056a203d8100b000cc32aa8570mr12933726pzi.14.1677401511476;
        Sun, 26 Feb 2023 00:51:51 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id s10-20020a62e70a000000b00592591d1634sm2227299pfh.97.2023.02.26.00.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Feb 2023 00:51:51 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v12 bpf-next 00/10] Add skb + xdp dynptrs 
Date:   Sun, 26 Feb 2023 00:51:10 -0800
Message-Id: <20230226085120.3907863-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is the 2nd in the dynptr series. The 1st can be found here [0].

This patchset adds skb and xdp type dynptrs, which have two main benefits for
packet parsing:
    * allowing operations on sizes that are not statically known at
      compile-time (eg variable-sized accesses).
    * more ergonomic and less brittle iteration through data (eg does not need
      manual if checking for being within bounds of data_end)

When comparing the differences in runtime for packet parsing without dynptrs
vs. with dynptrs, there is no noticeable difference. Patch 9 contains more
details as well as examples of how to use skb and xdp dynptrs.

[0] https://lore.kernel.org/bpf/20220523210712.3641569-1-joannelkoong@gmail.com/

--
Changelog:

v11 = https://lore.kernel.org/bpf/20230222060747.2562549-1-joannelkoong@gmail.com/
v11 -> v12:
    * Change constant mem size checking to use "__szk" kfunc annotation
      for slices
    * Use autoloading for success selftests

v10 = https://lore.kernel.org/bpf/20230216225524.1192789-1-joannelkoong@gmail.com/
v10 -> v11:
    * Reject bpf_dynptr_slice_rdwr() for non-writable progs at load time
      instead of runtime
    * Add additional patch (__uninit kfunc annotation)
    * Expand on documentation
    * Add bpf_dynptr_write() calls for persisting writes in tests

v9 = https://lore.kernel.org/bpf/20230127191703.3864860-1-joannelkoong@gmail.com/
v9 -> v10:
    * Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr interface
    * Add some more tests
    * Split up patchset into more parts to make it easier to review

v8 = https://lore.kernel.org/bpf/20230126233439.3739120-1-joannelkoong@gmail.com/
v8 -> v9:
    * Fix dynptr_get_type() to check non-stack dynptrs 

v7 = https://lore.kernel.org/bpf/20221021011510.1890852-1-joannelkoong@gmail.com/
v7 -> v8:
    * Change helpers to kfuncs
    * Add 2 new patches (1/5 and 2/5)

v6 = https://lore.kernel.org/bpf/20220907183129.745846-1-joannelkoong@gmail.com/
v6 -> v7
    * Change bpf_dynptr_data() to return read-only data slices if the skb prog
      is read-only (Martin)
    * Add test "skb_invalid_write" to test that writes to rd-only data slices
      are rejected

v5 = https://lore.kernel.org/bpf/20220831183224.3754305-1-joannelkoong@gmail.com/
v5 -> v6
    * Address kernel test robot errors by static inlining

v4 = https://lore.kernel.org/bpf/20220822235649.2218031-1-joannelkoong@gmail.com/
v4 -> v5
    * Address kernel test robot errors for configs w/out CONFIG_NET set
    * For data slices, return PTR_TO_MEM instead of PTR_TO_PACKET (Kumar)
    * Split selftests into subtests (Andrii)
    * Remove insn patching. Use rdonly and rdwr protos for dynptr skb
      construction (Andrii)
    * bpf_dynptr_data() returns NULL for rd-only dynptrs. There will be a
      separate bpf_dynptr_data_rdonly() added later (Andrii and Kumar)

v3 = https://lore.kernel.org/bpf/20220822193442.657638-1-joannelkoong@gmail.com/
v3 -> v4
    * Forgot to commit --amend the kernel test robot error fixups

v2 = https://lore.kernel.org/bpf/20220811230501.2632393-1-joannelkoong@gmail.com/
v2 -> v3
    * Fix kernel test robot build test errors

v1 = https://lore.kernel.org/bpf/20220726184706.954822-1-joannelkoong@gmail.com/
v1 -> v2
  * Return data slices to rd-only skb dynptrs (Martin)
  * bpf_dynptr_write allows writes to frags for skb dynptrs, but always
    invalidates associated data slices (Martin)
  * Use switch casing instead of ifs (Andrii)
  * Use 0xFD for experimental kind number in the selftest (Zvi)
  * Put selftest conversions w/ dynptrs into new files (Alexei)
  * Add new selftest "test_cls_redirect_dynptr.c"

Joanne Koong (10):
  bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
  bpf: Refactor process_dynptr_func
  bpf: Allow initializing dynptrs in kfuncs
  bpf: Define no-ops for externally called bpf dynptr functions
  bpf: Refactor verifier dynptr into get_dynptr_arg_reg
  bpf: Add __uninit kfunc annotation
  bpf: Add skb dynptrs
  bpf: Add xdp dynptrs
  bpf: Add bpf_dynptr_slice and bpf_dynptr_slice_rdwr
  selftests/bpf: tests for using dynptrs to parse skb and xdp buffers

 Documentation/bpf/kfuncs.rst                  |  17 +
 include/linux/bpf.h                           |  95 +-
 include/linux/bpf_verifier.h                  |   3 -
 include/linux/filter.h                        |  46 +
 include/uapi/linux/bpf.h                      |  18 +-
 kernel/bpf/btf.c                              |  22 +
 kernel/bpf/helpers.c                          | 221 +++-
 kernel/bpf/verifier.c                         | 413 ++++++--
 net/core/filter.c                             | 108 +-
 tools/include/uapi/linux/bpf.h                |  18 +-
 tools/testing/selftests/bpf/bpf_kfuncs.h      |  38 +
 .../selftests/bpf/prog_tests/cls_redirect.c   |  25 +
 .../testing/selftests/bpf/prog_tests/dynptr.c |  74 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +
 .../bpf/prog_tests/parse_tcp_hdr_opt.c        |  93 ++
 .../selftests/bpf/prog_tests/xdp_attach.c     |  11 +-
 .../testing/selftests/bpf/progs/dynptr_fail.c | 287 ++++-
 .../selftests/bpf/progs/dynptr_success.c      |  55 +-
 .../bpf/progs/test_cls_redirect_dynptr.c      | 980 ++++++++++++++++++
 .../bpf/progs/test_l4lb_noinline_dynptr.c     | 487 +++++++++
 .../bpf/progs/test_parse_tcp_hdr_opt.c        | 119 +++
 .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c | 114 ++
 .../selftests/bpf/progs/test_xdp_dynptr.c     | 257 +++++
 .../selftests/bpf/test_tcp_hdr_options.h      |   1 +
 24 files changed, 3318 insertions(+), 186 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_kfuncs.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c

-- 
2.34.1

