Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6366A5F36EC
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiJCUUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 16:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiJCUUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 16:20:02 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228E812D0E;
        Mon,  3 Oct 2022 13:20:00 -0700 (PDT)
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ofRuw-0002Xm-5C; Mon, 03 Oct 2022 22:19:58 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: pull-request: bpf 2022-10-03
Date:   Mon,  3 Oct 2022 22:19:57 +0200
Message-Id: <20221003201957.13149-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26678/Mon Oct  3 09:56:12 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub, hi Paolo, hi Eric,

The following pull-request contains BPF updates for your *net* tree.

Note that into net tree this pulls cleanly, but for later merge of net into
net-next there will be a small merge conflict in kernel/bpf/helpers.c
between commit 8addbfc7b308 ("bpf: Gate dynptr API behind CAP_BPF") from
bpf and commit 5679ff2f138f ("bpf: Move bpf_loop and bpf_for_each_map_elem
under CAP_BPF") as well as 8a67f2de9b1d ("bpf: expose bpf_strtol and
bpf_strtoul to all program types") from bpf-next.

Resolve as follows for the first hunk:

        [...]
        case BPF_FUNC_ringbuf_query:
                return &bpf_ringbuf_query_proto;
        case BPF_FUNC_strncmp:
                return &bpf_strncmp_proto;
        case BPF_FUNC_strtol:
                return &bpf_strtol_proto;
        case BPF_FUNC_strtoul:
                return &bpf_strtoul_proto;
        default:
                break;
        }
        [...]

Take both hunks for the one coming after the if (!bpf_capable()):

        [...]
        case BPF_FUNC_kptr_xchg:
                return &bpf_kptr_xchg_proto;
        case BPF_FUNC_for_each_map_elem:
                return &bpf_for_each_map_elem_proto;
        case BPF_FUNC_loop:
                return &bpf_loop_proto;
        case BPF_FUNC_user_ringbuf_drain:
                return &bpf_user_ringbuf_drain_proto;
        case BPF_FUNC_ringbuf_reserve_dynptr:
                return &bpf_ringbuf_reserve_dynptr_proto;
        case BPF_FUNC_ringbuf_submit_dynptr:
                return &bpf_ringbuf_submit_dynptr_proto;
        case BPF_FUNC_ringbuf_discard_dynptr:
                return &bpf_ringbuf_discard_dynptr_proto;
        case BPF_FUNC_dynptr_from_mem:
                return &bpf_dynptr_from_mem_proto;
        case BPF_FUNC_dynptr_read:
                return &bpf_dynptr_read_proto;
        case BPF_FUNC_dynptr_write:
                return &bpf_dynptr_write_proto;
        case BPF_FUNC_dynptr_data:
                return &bpf_dynptr_data_proto;
        default:
                break;
        [...]

We've added 10 non-merge commits during the last 23 day(s) which contain
a total of 14 files changed, 130 insertions(+), 69 deletions(-).

The main changes are:

1) Fix dynptr helper API to gate behind CAP_BPF given it was not intended
   for unprivileged BPF programs, from Kumar Kartikeya Dwivedi.

2) Fix need_wakeup flag inheritance from umem buffer pool for shared xsk
   sockets, from Jalal Mostafa.

3) Fix truncated last_member_type_id in btf_struct_resolve() which had a
   wrong storage type, from Lorenz Bauer.

4) Fix xsk back-pressure mechanism on tx when amount of produced descriptors
   to CQ is lower than what was grabbed from xsk tx ring, from Maciej Fijalkowski.

5) Fix wrong cgroup attach flags being displayed to effective progs, from Pu Lehui.

Please consider pulling these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git

Thanks a lot!

Also thanks to reporters, reviewers and testers of commits in this pull-request:

Andrii Nakryiko, Magnus Karlsson, Stanislav Fomichev, Yonghong Song

----------------------------------------------------------------

The following changes since commit c0955bf957be4bead01fae1d791476260da7325d:

  ethernet: rocker: fix sleep in atomic context bug in neigh_timer_handler (2022-08-31 14:01:29 +0100)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git 

for you to fetch changes up to 60240bc26114543fcbfcd8a28466e67e77b20388:

  xsk: Inherit need_wakeup flag for shared sockets (2022-09-22 17:16:22 +0200)

----------------------------------------------------------------
Jalal Mostafa (1):
      xsk: Inherit need_wakeup flag for shared sockets

Kumar Kartikeya Dwivedi (1):
      bpf: Gate dynptr API behind CAP_BPF

Lee Jones (1):
      bpf: Ensure correct locking around vulnerable function find_vpid()

Lorenz Bauer (1):
      bpf: btf: fix truncated last_member_type_id in btf_struct_resolve

Maciej Fijalkowski (2):
      xsk: Fix backpressure mechanism on Tx
      selftests/xsk: Add missing close() on netns fd

Martin KaFai Lau (1):
      Merge branch 'Fix wrong cgroup attach flags being assigned to effective progs'

Pu Lehui (3):
      bpf, cgroup: Reject prog_attach_flags array when effective query
      bpftool: Fix wrong cgroup attach flags being assigned to effective progs
      selftests/bpf: Adapt cgroup effective query uapi change

Shung-Hsi Yu (1):
      MAINTAINERS: Add include/linux/tnum.h to BPF CORE

 MAINTAINERS                                        |  1 +
 include/net/xsk_buff_pool.h                        |  2 +-
 include/uapi/linux/bpf.h                           |  7 ++-
 kernel/bpf/btf.c                                   |  2 +-
 kernel/bpf/cgroup.c                                | 28 +++++++----
 kernel/bpf/helpers.c                               | 28 +++++------
 kernel/bpf/syscall.c                               |  2 +
 net/xdp/xsk.c                                      | 26 +++++------
 net/xdp/xsk_buff_pool.c                            |  5 +-
 net/xdp/xsk_queue.h                                | 22 ++++-----
 tools/bpf/bpftool/cgroup.c                         | 54 ++++++++++++++++++++--
 tools/include/uapi/linux/bpf.h                     |  7 ++-
 .../testing/selftests/bpf/prog_tests/cgroup_link.c | 11 ++---
 tools/testing/selftests/bpf/xskxceiver.c           |  4 ++
 14 files changed, 130 insertions(+), 69 deletions(-)
