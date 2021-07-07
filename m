Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0310F3BF1E9
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 00:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGGWTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 18:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhGGWTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 18:19:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACA2C061574
        for <netdev@vger.kernel.org>; Wed,  7 Jul 2021 15:17:06 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id d12so3789901pgd.9
        for <netdev@vger.kernel.org>; Wed, 07 Jul 2021 15:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=riotgames.com; s=riotgames;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCJ2vjtmZHMCWsNz6Dr7+zk1JKTc+6CNVa3EJes2r6Y=;
        b=WybaUxC/xyGUNVzUnR1rSwmeNOau1hF3Yrv4B2EEDVO30piMHQsX0ISX6AsVdxUdcm
         p15cu3Em7oEKP/FxoSUdvq0/1gtEvJ6TN4uqNV7CRC3McngwGFlB+/xSlVL7FjTrNDqf
         Yi4iWYHb3qHTXUSIjhN9f9KVLGNyhqTwZq86I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCJ2vjtmZHMCWsNz6Dr7+zk1JKTc+6CNVa3EJes2r6Y=;
        b=SsqpMzUG9GiP+zx7i6nkqa6adfWJ4U9+KVbzuCbUQIWiWOoDEaiX3HxMPqIyfXsi+n
         FoXNPt6nA6ANWf/4asr4UByi45BfWKX5Dkz/3nxJjIa79xtc9VqSxoldwaoi/ixe9vOC
         mNyyxZgv08ar7jaFchB0Owzg4D+xVjOWdiSyxq3uGpzQcjkZEZXPvvuLigXb8c7XLMlH
         Yr3Iaq8JQ0y1vSYB6v82e/WGyaj4KVkcaFlKvgCrx/hMVdO3PIjFRUvT5dEbDO/X3VGh
         zPOiBRsWinXS8HYxUZO8i7501a2z1n5yktBT+NXULG8lnvZqX8ZX8GdhDYIUJHxodFyC
         GvAQ==
X-Gm-Message-State: AOAM533baUSEnt1gIpzJjdFqEx4lEihAkYmvXBXU6FzvXfgxlR1o45nB
        KjfQwR0Kv/ErUjfCu64+ACVJPg==
X-Google-Smtp-Source: ABdhPJy4myl+qui+gZm2zXFdoecY2JHnmovCajXaqly5YXsJrtfTJ+lxDTMsVsC6LxHknQmvlwK63A==
X-Received: by 2002:a62:ed0b:0:b029:30c:7193:68f6 with SMTP id u11-20020a62ed0b0000b029030c719368f6mr28342189pfh.73.1625696226069;
        Wed, 07 Jul 2021 15:17:06 -0700 (PDT)
Received: from ip-10-184-182-114.us-west-2.compute.internal (ec2-54-191-147-77.us-west-2.compute.amazonaws.com. [54.191.147.77])
        by smtp.gmail.com with ESMTPSA id 75sm203748pfx.71.2021.07.07.15.17.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 15:17:05 -0700 (PDT)
From:   Zvi Effron <zeffron@riotgames.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, KP Singh <kpsingh@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Song Liu <songliubraving@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Zvi Effron <zeffron@riotgames.com>
Subject: [PATCH bpf-next v8 0/4] bpf: support input xdp_md context in BPF_PROG_TEST_RUN
Date:   Wed,  7 Jul 2021 22:16:53 +0000
Message-Id: <20210707221657.3985075-1-zeffron@riotgames.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for passing an xdp_md via ctx_in/ctx_out in
bpf_attr for BPF_PROG_TEST_RUN of XDP programs.

Patch 1 adds a function to validate XDP meta data lengths.

Patch 2 adds initial support for passing XDP meta data in addition to
packet data.

Patch 3 adds support for also specifying the ingress interface and
rx queue.

Patch 4 adds selftests to ensure functionality is correct.

Changelog:
----------
v7->v8
v7: https://lore.kernel.org/bpf/20210624211304.90807-1-zeffron@riotgames.com/

 * Fix too long comment line in patch 3

v6->v7
v6: https://lore.kernel.org/bpf/20210617232904.1899-1-zeffron@riotgames.com/

 * Add Yonghong Song's Acked-by to commit message in patch 1
 * Add Yonghong Song's Acked-by to commit message in patch 2
 * Extracted the post-update of the xdp_md context into a function (again)
 * Validate that the rx queue was registered with XDP info
 * Decrement the reference count on a found netdevice on failure to find
  a valid rx queue
 * Decrement the reference count on a found netdevice after the XDP
  program is run
 * Drop Yonghong Song's Acked-By for patch 3 because of patch changes
 * Improve a comment in the selftests
 * Drop Yonghong Song's Acked-By for patch 4 because of patch changes

v5->v6
v5: https://lore.kernel.org/bpf/20210616224712.3243-1-zeffron@riotgames.com/

 * Correct commit messages in patches 1 and 3
 * Add Acked-by to commit message in patch 4
 * Use gotos instead of returns to correctly free resources in
  bpf_prog_test_run_xdp
 * Rename xdp_metalen_valid to xdp_metalen_invalid
 * Improve the function signature for xdp_metalen_invalid
 * Merged declaration of ingress_ifindex and rx_queue_index into one line

v4->v5
v4: https://lore.kernel.org/bpf/20210604220235.6758-1-zeffron@riotgames.com/

 * Add new patch to introduce xdp_metalen_valid inline function to avoid
  duplicated code from net/core/filter.c
 * Correct size of bad_ctx in selftests
 * Make all declarations reverse Christmas tree
 * Move data check from xdp_convert_md_to_buff to bpf_prog_test_run_xdp
 * Merge xdp_convert_buff_to_md into bpf_prog_test_run_xdp
 * Fix line too long
 * Extracted common checks in selftests to a helper function
 * Removed redundant assignment in selftests
 * Reordered test cases in selftests
 * Check data against 0 instead of data_meta in selftests
 * Made selftests use EINVAL instead of hardcoded 22
 * Dropped "_" from XDP function name
 * Changed casts in XDP program from unsigned long to long
 * Added a comment explaining the use of the loopback interface in selftests
 * Change parameter order in xdp_convert_md_to_buff to be input first
 * Assigned xdp->ingress_ifindex and xdp->rx_queue_index to local variables in
  xdp_convert_md_to_buff
 * Made use of "meta data" versus "metadata" consistent in comments and commit
  messages

v3->v4
v3: https://lore.kernel.org/bpf/20210602190815.8096-1-zeffron@riotgames.com/

 * Clean up nits
 * Validate xdp_md->data_end in bpf_prog_test_run_xdp
 * Remove intermediate metalen variables

v2 -> v3
v2: https://lore.kernel.org/bpf/20210527201341.7128-1-zeffron@riotgames.com/

 * Check errno first in selftests
 * Use DECLARE_LIBBPF_OPTS
 * Rename tattr to opts in selftests
 * Remove extra new line
 * Rename convert_xdpmd_to_xdpb to xdp_convert_md_to_buff
 * Rename convert_xdpb_to_xdpmd to xdp_convert_buff_to_md
 * Move declaration of device and rxqueue in xdp_convert_md_to_buff to
  patch 2
 * Reorder the kfree calls in bpf_prog_test_run_xdp

v1 -> v2
v1: https://lore.kernel.org/bpf/20210524220555.251473-1-zeffron@riotgames.com

 * Fix null pointer dereference with no context
 * Use the BPF skeleton and replace CHECK with ASSERT macros

Zvi Effron (4):
  bpf: add function for XDP meta data length check
  bpf: support input xdp_md context in BPF_PROG_TEST_RUN
  bpf: support specifying ingress via xdp_md context in
    BPF_PROG_TEST_RUN
  selftests/bpf: Add test for xdp_md context in BPF_PROG_TEST_RUN

 include/net/xdp.h                             |   5 +
 include/uapi/linux/bpf.h                      |   3 -
 net/bpf/test_run.c                            | 109 ++++++++++++++++--
 net/core/filter.c                             |   4 +-
 .../bpf/prog_tests/xdp_context_test_run.c     | 105 +++++++++++++++++
 .../bpf/progs/test_xdp_context_test_run.c     |  20 ++++
 6 files changed, 233 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_context_test_run.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_context_test_run.c


base-commit: 5e437416ff66981d8154687cfdf7de50b1d82bfc
-- 
2.31.1

