Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487984BCEAF
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 14:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237065AbiBTNsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 08:48:39 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiBTNsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 08:48:38 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5029921813;
        Sun, 20 Feb 2022 05:48:17 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id ay3so2024504plb.1;
        Sun, 20 Feb 2022 05:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tyzdp/jbfseg65ev0g7jdUi8Rfi1IKTDUUpRhEM4lag=;
        b=iVoZO2+UF6GzmTL25SzJseUqI1wWLCFh/Z2RVawQD2XqnyGgzZLOaezd054PX/z7Xz
         hgm1pd40El7Ih3O1zC8i8nqLbpkf5U+9reursUW2Ckv+pIl65gGLkMBLBgStX/p/YuQ1
         mQtWgwO0nTIBNy3wW76fSHECg2qCA1dT8ovs54GmpKZV1ujsyBGftYeRC77u0801eeWn
         c/w5YgbfM/IJ5qI/Lz0DlzlLfVKktXnryeaHHRtKwDgpO+fnHN/p4+nspUT8KMR54zp2
         glOHU95aZEN+Z3bhyzxxEwVXD+kvFukBU0CqCWrsHv09M39FYFCGFpuTlDG4dk5Qhl/t
         McNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tyzdp/jbfseg65ev0g7jdUi8Rfi1IKTDUUpRhEM4lag=;
        b=7uvyViZL4j4VNWd1fTHstoPD7DUjQj6B1dSshYJvspr55O7PCOvZPH+IPrmDUyihe9
         HZ3e2XZ1I9R8ZfN9uASBi81nzKsbnMg77F2aCuzQq1dMdPBxk15MVkz8Yd/MOu/0+SAL
         OlY3dWDEfRR8E7jqC0zIEIFrwRXYWcg4V6IGxq7+JylMjZkA73TuvhMuC4R+VShDyp5D
         j2jnN2Pika9gtJ6lXLD5V0oX33V924L0vAoVsDhgY5t5OXCzaeSQj2Tzbl4EiC3HVdMJ
         eIhORZMFTJql4AASkLfeO3Ay0sZT9kSdZy5HPv8koLczOnLafZXLXZ5M0qmA3UdXtgte
         1M1A==
X-Gm-Message-State: AOAM5317Si+aILImez/o42N8eZXiRGKSXVNE8li1caXyAiYwIfbM2uTD
        mS0ZBob+4zUy3XzWrRD/fk8SMdLPNrc=
X-Google-Smtp-Source: ABdhPJz7yDAir3Pp7By8EcC8ZsQw2erTXsUCZA0TU/KByTGLho+tTGXn2BM3gGGFlS2Emyr1Ejhl3A==
X-Received: by 2002:a17:902:a412:b0:14f:9c99:1690 with SMTP id p18-20020a170902a41200b0014f9c991690mr4863165plq.142.1645364896576;
        Sun, 20 Feb 2022 05:48:16 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id d8sm10057328pfv.84.2022.02.20.05.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 05:48:16 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 00/15] Introduce typed pointer support in BPF maps
Date:   Sun, 20 Feb 2022 19:17:58 +0530
Message-Id: <20220220134813.3411982-1-memxor@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7134; h=from:subject; bh=gN4hB4C2rirVwlB4suNXTjjGmsF7Zx1ocsK735GCqhc=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBiEkZXvZi6e1cepTHG/wb9O2j8RRGbgYNvn+RnMikn t4Y8pfWJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYhJGVwAKCRBM4MiGSL8RysOWEA Cb9H6Jy3z7PjK/6K3Hdc6YLgBrZAxD9yjsEkW/XyA69O73Z2hS4XiN76Ilx/3PSDzZcv7u6DIuiXH1 F0IiyXA928mequyQfB3wJI1AKLD2eRYkUr8SIdCtxRuat/8aaTfucI7oVJXHn6JjJIb7GIt6vYxJ+h clbKFcLc+6YIx20MhvxiiHdV1ECr/8YDf/gnjAOcV0lPc/98Uy90QeUTHJ8kNmjjxwEchevJgXD72E ddZEqZJcJbAkcqm+7qyYhke0wgC6Y/EFOPwsTTLc4hPPKZgNs+Pd+UHLGrCZkvTXPwQjJlCxJD3Pqd r+h7kRLT/gRILcA8Ngk8xz8CcMrrCo6TYu9WyshYRn1EaLjoRkjj8t2QpxOvK1f1iU7W+Ga7DZToFQ B4A1ELMDrZSJjHxz3XSq8RmevwjX/RHcELsCvo9s+PSDmPy1MUwLFoj6v/MB4hCgrbKDK1sdgrSfh5 37hMaCmQveHKk7TwV1bbFFD3t3HKJ74x4RKweiiY1Pl+X2+G2GnfOsrUcno3ZXJapABkIUNaag+9k4 BLWG4AuoaEbka2Q5kqnILIlCFS1D+Fg+QXJdYxj3xOpvrvcbYwnMFmUl5Wsy+w3TBus/zIkFeuCJR0 Rytyss0ySbdBMdnxyyxq1hGUQBENMU9Yx/aBeII5UgGSmX+RbRnzq1IhvmCA==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduction
------------

This set enables storing pointers of a certain type in BPF map, and extends the
verifier to enforce type safety and lifetime correctness properties.

The infrastructure being added is generic enough for allowing storing any kind
of pointers whose type is available using BTF (user or kernel) in the future
(e.g. strongly typed memory allocation in BPF program), which are internally
tracked in the verifier as PTR_TO_BTF_ID, but for now the series limits them to
four kinds of pointers obtained from the kernel.

Obviously, use of this feature depends on map BTF.

1. Unreferenced kernel pointer

In this case, there are very few restrictions. The pointer type being stored
must match the type declared in the map value. However, such a pointer when
loaded from the map can only be dereferenced, but not passed to any in-kernel
helpers or kernel functions available to the program. This is because while the
verifier's exception handling mechanism coverts BPF_LDX to PROBE_MEM loads,
which are then handled specially by the JIT implementation, the same liberty is
not available to accesses inside the kernel. The pointer by the time it is
passed into a helper has no lifetime related guarantees about the object it is
pointing to, and may well be referencing invalid memory.

2. Referenced kernel pointer

This case imposes a lot of restrictions on the programmer, to ensure safety. To
transfer the ownership of a reference in the BPF program to the map, the user
must use the BPF_XCHG instruction, which returns the old pointer contained in
the map, as an acquired reference, and releases verifier state for the
referenced pointer being exchanged, as it moves into the map.

This a normal PTR_TO_BTF_ID that can be used with in-kernel helpers and kernel
functions callable by the program.

However, if BPF_LDX is used to load a referenced pointer from the map, it is
still not permitted to pass it to in-kernel helpers or kernel functions. To
obtain a reference usable with helpers, the user must invoke a kfunc helper
which returns a usable reference (which also must be eventually released before
BPF_EXIT, or moved into a map).

Since the load of the pointer (preserving data dependency ordering) must happen
inside the RCU read section, the kfunc helper will take a pointer to the map
value, which must point to the actual pointer of the object whose reference is
to be raised. The type will be verified from the BTF information of the kfunc,
as the prototype must be:

	T *func(T **, ... /* other arguments */);

Then, the verifier checks whether pointer at offset of the map value points to
the type T, and permits the call.

This convention is followed so that such helpers may also be called from
sleepable BPF programs, where RCU read lock is not necessarily held in the BPF
program context, hence necessiating the need to pass in a pointer to the actual
pointer to perform the load inside the RCU read section.

3. per-CPU kernel pointer

These have very little restrictions. The user can store a PTR_TO_PERCPU_BTF_ID
into the map, and when loading from the map, they must NULL check it before use,
because while a non-zero value stored into the map should always be valid, it can
still be reset to zero on updates. After checking it to be non-NULL, it can be
passed to bpf_per_cpu_ptr and bpf_this_cpu_ptr helpers to obtain a PTR_TO_BTF_ID
to underlying per-CPU object.

It is also permitted to write 0 and reset the value.

4. Userspace pointer

The verifier recently gained support for annotating BTF with __user type tag.
This indicates pointers pointing to memory which must be read using the
bpf_probe_read_user helper to ensure correct results. The set also permits
storing them into the BPF map, and ensures user pointer cannot be stored
into other kinds of pointers mentioned above.

When loaded from the map, the only thing that can be done is to pass this
pointer to bpf_probe_read_user. No dereference is allowed.

Notes
-----

This set requires the following LLVM fix to pass the BPF CI:

  https://reviews.llvm.org/D119799

Also, I applied Alexei's suggestion of removing callback for btf_find_field, but
that 'ugly' is still required, since bad offset alignment etc. can return an
error, and we don't want to leave a partial ptr_off_tab around in that case. The
other option is freeing inside btf_find_field, but that would be more code
conditional on BTF_FIELD_KPTR, when the caller can do it based on ret < 0.

TODO
----

Needs a lot more testing, especially for stuff apart from verifier correctness.
Will work on that in parallel during v1 review. The idea was to get a little
more feedback (esp. for kptr_get stuff) before moving forward with adding more
tests. Posting it now to just get discussion started. The verifier tests fairly
comprehensively test many edge cases I could think of.

Kumar Kartikeya Dwivedi (15):
  bpf: Factor out fd returning from bpf_btf_find_by_name_kind
  bpf: Make btf_find_field more generic
  bpf: Allow storing PTR_TO_BTF_ID in map
  bpf: Allow storing referenced PTR_TO_BTF_ID in map
  bpf: Allow storing PTR_TO_PERCPU_BTF_ID in map
  bpf: Allow storing __user PTR_TO_BTF_ID in map
  bpf: Prevent escaping of pointers loaded from maps
  bpf: Adapt copy_map_value for multiple offset case
  bpf: Populate pairs of btf_id and destructor kfunc in btf
  bpf: Wire up freeing of referenced PTR_TO_BTF_ID in map
  bpf: Teach verifier about kptr_get style kfunc helpers
  net/netfilter: Add bpf_ct_kptr_get helper
  libbpf: Add __kptr* macros to bpf_helpers.h
  selftests/bpf: Add C tests for PTR_TO_BTF_ID in map
  selftests/bpf: Add verifier tests for PTR_TO_BTF_ID in map

 include/linux/bpf.h                           |  90 ++-
 include/linux/btf.h                           |  24 +
 include/net/netfilter/nf_conntrack_core.h     |  17 +
 kernel/bpf/arraymap.c                         |  13 +-
 kernel/bpf/btf.c                              | 565 ++++++++++++++--
 kernel/bpf/hashtab.c                          |  27 +-
 kernel/bpf/map_in_map.c                       |   5 +-
 kernel/bpf/syscall.c                          | 227 ++++++-
 kernel/bpf/verifier.c                         | 311 ++++++++-
 net/bpf/test_run.c                            |  17 +-
 net/netfilter/nf_conntrack_bpf.c              | 132 +++-
 net/netfilter/nf_conntrack_core.c             |  17 -
 tools/lib/bpf/bpf_helpers.h                   |   4 +
 .../selftests/bpf/prog_tests/map_btf_ptr.c    |  13 +
 .../testing/selftests/bpf/progs/map_btf_ptr.c | 105 +++
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  31 +
 tools/testing/selftests/bpf/test_verifier.c   |  57 +-
 .../selftests/bpf/verifier/map_btf_ptr.c      | 624 ++++++++++++++++++
 18 files changed, 2144 insertions(+), 135 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/map_btf_ptr.c
 create mode 100644 tools/testing/selftests/bpf/progs/map_btf_ptr.c
 create mode 100644 tools/testing/selftests/bpf/verifier/map_btf_ptr.c

-- 
2.35.1

