Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136536A7031
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCAPuu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:50:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCAPut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:50:49 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C272F32CF7;
        Wed,  1 Mar 2023 07:50:47 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id n5so8191625pfv.11;
        Wed, 01 Mar 2023 07:50:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677685847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3kgB83H3A8ef4MzHly3I75Y1V5BMA83KKGbGzdWi6dE=;
        b=fU2F9zgRZVkiPc3C7tPLYutezdDxVXOMiDR/+ccztLQMEheCY0+E4oIJcvkyj4mvJe
         3WX4qIgqZsQZ2k8pCVnOZboAOL/t02FhRTF0hu8Jwy5fIJXC0thBmh0+4hLYl1qf0I2I
         WRK1Z6lt5+1mCuOeCXq4v948OEWWaaDD0cC7X2NVKeinwOGLhgwbvexV1K4kBd4rIFBZ
         Djtebc4aBKh8wpsgd3VZL0CUEVULUgkjbQ1AnxqvETZzLTWD8HGG2PfXOImKBbQRrMy9
         uxa2cN6V99+5P5kOn6Wvoco83RQryJQe2ezssbX6eA50ClkKC/JkOCCOUgbupPQo8tFP
         eVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677685847;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3kgB83H3A8ef4MzHly3I75Y1V5BMA83KKGbGzdWi6dE=;
        b=l/u9aQ3fIYsIz2f+cTTyvvqNPe5ak/fJ4FL5dqjmJtmVwFZ5jnTBWQzml4k3ro+23Y
         9vlprn/6Yb5dqFLIqQTU4mQc3HxEuCeUPbCsp0RkDFws6wEQLAygrAAYdxzg/ojjM8uL
         QlYI3aKGKWQEj/9kiWNWqhKR3Ejx+Z5e2fTzpPdHgFueSJnk+a+EN/jG6fkY9IWiOqeu
         0L3v1YfnB25L+wxYTYuAFvHJy4cXxTxtUdSbgmhASbYSPZjZL0Yxe5oseoY3MhddD2y9
         YK6etOOAxmO+M0MvYOdAg5Py5+gglzsnKuvIUp2Rmh8/hGYMdcke4wTf1exWztYB+c9E
         fE4Q==
X-Gm-Message-State: AO0yUKXzUYVG4k4eRPuQUezigQlvS0Tc9jpR9Z7+xKwL/ybtVk/ciubQ
        MnDvHzUDFUwB/o3fsP0dBOQBR64Y3qk=
X-Google-Smtp-Source: AK7set8Ji+T/fuDe0/a8KXBzdumAl2W12580semnpQxKx41deKnfINuuq/cJuvg8F1o1InYG+ny73w==
X-Received: by 2002:a05:6a00:10c2:b0:5a8:b07b:82da with SMTP id d2-20020a056a0010c200b005a8b07b82damr8187123pfu.4.1677685846870;
        Wed, 01 Mar 2023 07:50:46 -0800 (PST)
Received: from gatsby.corp.tfbnw.net (75-172-126-232.tukw.qwest.net. [75.172.126.232])
        by smtp.gmail.com with ESMTPSA id c9-20020a637249000000b00502f20aa4desm7589490pgn.70.2023.03.01.07.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Mar 2023 07:50:46 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, ast@kernel.org,
        memxor@gmail.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        toke@kernel.org, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v13 bpf-next 00/10] Add skb + xdp dynptrs 
Date:   Wed,  1 Mar 2023 07:49:43 -0800
Message-Id: <20230301154953.641654-1-joannelkoong@gmail.com>
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

v12 = https://lore.kernel.org/bpf/20230226085120.3907863-1-joannelkoong@gmail.com/
v12 -> v13:
    * Fix missing { } for case statement

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
 kernel/bpf/verifier.c                         | 415 ++++++--
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
 24 files changed, 3320 insertions(+), 186 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/bpf_kfuncs.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c

-- 
2.34.1

