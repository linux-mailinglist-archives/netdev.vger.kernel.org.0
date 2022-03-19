Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7834DE986
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 18:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242911AbiCSRcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 13:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiCSRcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 13:32:03 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC9C45505;
        Sat, 19 Mar 2022 10:30:40 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so4921643pjq.2;
        Sat, 19 Mar 2022 10:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gkky0ysAeDzdOeO3GqqHPK43boR/dATbOBWfwwR2rWY=;
        b=Yhfm7Oi6M91zdpAcdJ8Eq8EngtuD9X41Br2UE09MplRd9YCutcxFBtHj7IG2qUlqph
         NRo1/nZqT4g46zZUs5RsVDKTOSIskmMKXSCdCbSiiYfOTfr45yIIJqaNZzg0xV4ekovg
         gF3PqvIgRcDkampqEd5v8hxml0oEnHNBekN7uEgxeln7R0xa58HeVxoEoKyew1Hj7Ykx
         4nhAPcNrzr6YQFdOoFlhYZTwjLmg5W5VhylSjTcXKrerVF/7yW/EPIqAg4W691YA6/pN
         3wZr9r8OXD4yPM4X6+j4j6FpaAuTb2WlRkEtQB90TcpJorijurpp8SMtD3rDlCBcHh0w
         qPCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gkky0ysAeDzdOeO3GqqHPK43boR/dATbOBWfwwR2rWY=;
        b=XvE6nT30y1Ja7uGjmsQbeMGuZJ0XxJndc2q15PV17hcl/QO94JbvVCHvnQmJfZVWRR
         IEvRFd5NH2sFHu2sgVklw9CG85DVQeDIeJX/882NOFvV03sr2sWGeN7hhW+P7OCh4WjN
         KZ71MXYrWIz4RFaYJpbYjG55aY6l6cqO04OK0nlRCtd3URn2Buvmz8GDFM5cU81jC2SY
         qV6MGKeFTmqH5H6TWY5BLenh1MtHaZKRzl7HksyeW0l6e1HWqna7R39sqGzb1uihIabw
         TNzhbLnLi9z7mWC0Rby1zc4gURuR+UatYmMmZ+HSRMDjWpSnRbut0+uETNfJnAPzYXys
         18EA==
X-Gm-Message-State: AOAM533zo8kvoeed9juqSNp6s/2tmMUd8/c/RZ3cHXAz20F2K32PYi8V
        QuE5E1IEsDoGv0rUS8vnGfI=
X-Google-Smtp-Source: ABdhPJzPD40IHPfGNI4nK0Kxx/ACz+56A8fvNSZftre0O4FCiw5Zc/71Swb8opmJ6GfCIXIauJ3B2w==
X-Received: by 2002:a17:902:8ec9:b0:14f:11f7:db77 with SMTP id x9-20020a1709028ec900b0014f11f7db77mr5126357plo.136.1647711040168;
        Sat, 19 Mar 2022 10:30:40 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:4ab8:5400:3ff:fee9:a154])
        by smtp.gmail.com with ESMTPSA id k21-20020aa788d5000000b004f71bff2893sm12722136pff.67.2022.03.19.10.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 10:30:39 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     roman.gushchin@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, shuah@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH 00/14] bpf: Allow not to charge bpf memory 
Date:   Sat, 19 Mar 2022 17:30:22 +0000
Message-Id: <20220319173036.23352-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

After switching to memcg-based bpf memory accounting, the bpf memory is
charged to the loader's memcg by defaut, that causes unexpected issues for
us. For instance, the container of the loader-which loads the bpf programs
and pins them on bpffs-may restart after pinning the progs and maps. After
the restart, the pinned progs and maps won't belong to the new container
any more, while they actually belong to an offline memcg left by the
previous generation. That inconsistent behavior will make trouble for the
memory resource management for this container. 

The reason why these progs and maps have to be persistent across multiple
generations is that these progs and maps are also used by other processes
which are not in this container. IOW, they can't be removed when this
container is restarted. Take a specific example, bpf program for clsact
qdisc is loaded by a agent running in a container, which not only loads
bpf program but also processes the data generated by this program and do
some other maintainace things.

In order to keep the charging behavior consistent, we used to consider a
way to recharge these pinned maps and progs again after the container is
restarted, but after the discussion[1] with Roman, we decided to go
another direction that don't charge them to the container in the first
place. TL;DR about the mentioned disccussion: recharging is not a generic
solution and it may take too much risk.

This patchset is the solution of no charge. Two flags are introduced in
union bpf_attr, one for bpf map and another for bpf prog. The user who
doesn't want to charge to current memcg can use these two flags. These two
flags are only permitted for sys admin as these memory will be accounted to
the root memcg only.

Patches #1~#8 are for bpf map. Patches #9~#12 are for bpf prog. Patch #13
and #14 are for selftests and also the examples of how to use them.

[1]. https://lwn.net/Articles/887180/ 

Yafang Shao (14):
  bpf: Introduce no charge flag for bpf map
  bpf: Only sys admin can set no charge flag
  bpf: Enable no charge in map _CREATE_FLAG_MASK
  bpf: Introduce new parameter bpf_attr in bpf_map_area_alloc
  bpf: Allow no charge in bpf_map_area_alloc
  bpf: Allow no charge for allocation not at map creation time
  bpf: Allow no charge in map specific allocation
  bpf: Aggregate flags for BPF_PROG_LOAD command
  bpf: Add no charge flag for bpf prog
  bpf: Only sys admin can set no charge flag for bpf prog
  bpf: Set __GFP_ACCOUNT at the callsite of bpf_prog_alloc
  bpf: Allow no charge for bpf prog
  bpf: selftests: Add test case for BPF_F_NO_CHARTE
  bpf: selftests: Add test case for BPF_F_PROG_NO_CHARGE

 include/linux/bpf.h                           | 27 ++++++-
 include/uapi/linux/bpf.h                      | 21 +++--
 kernel/bpf/arraymap.c                         |  9 +--
 kernel/bpf/bloom_filter.c                     |  7 +-
 kernel/bpf/bpf_local_storage.c                |  8 +-
 kernel/bpf/bpf_struct_ops.c                   | 13 +--
 kernel/bpf/core.c                             | 20 +++--
 kernel/bpf/cpumap.c                           | 10 ++-
 kernel/bpf/devmap.c                           | 14 ++--
 kernel/bpf/hashtab.c                          | 14 ++--
 kernel/bpf/local_storage.c                    |  4 +-
 kernel/bpf/lpm_trie.c                         |  4 +-
 kernel/bpf/queue_stack_maps.c                 |  5 +-
 kernel/bpf/reuseport_array.c                  |  3 +-
 kernel/bpf/ringbuf.c                          | 19 ++---
 kernel/bpf/stackmap.c                         | 13 +--
 kernel/bpf/syscall.c                          | 40 +++++++---
 kernel/bpf/verifier.c                         |  2 +-
 net/core/filter.c                             |  6 +-
 net/core/sock_map.c                           |  8 +-
 net/xdp/xskmap.c                              |  9 ++-
 tools/include/uapi/linux/bpf.h                | 21 +++--
 .../selftests/bpf/map_tests/no_charg.c        | 79 +++++++++++++++++++
 .../selftests/bpf/prog_tests/no_charge.c      | 49 ++++++++++++
 24 files changed, 297 insertions(+), 108 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/no_charg.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/no_charge.c

-- 
2.17.1

