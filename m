Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAEF36D8A49
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 00:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjDEWJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 18:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231880AbjDEWJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 18:09:09 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD68D59D5;
        Wed,  5 Apr 2023 15:09:07 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id kc4so35723579plb.10;
        Wed, 05 Apr 2023 15:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680732547; x=1683324547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2kwNwGAgyjtt7uSKc/qEWdyaie8OB2blRY1cHaNlDYM=;
        b=Uhpxl8+qcMGMTDdpRvFp8IAnq9VzjJ27H8jxStR0sVTfSPW8F597li4sDsM7hqQ3H3
         v83WSN0HN+vprRYYRvJSPzwX6aCGkCSvJ+/QRkuJGoMEy7uhp/uFV51fWDv9iPjIvcRQ
         PIPCx6SkB44bkR/R9+jTd+oCIpxP+7Y7ET6tGiTJuooOKEKHxk9N+5hNM1x1Up5HFw8J
         OB+GEACjwSdjNeNsQCS+FiIp1WSsf428uG+5227sFtX4RcatZYz3+S7cvBdwg77pnKlZ
         QociCiQ2p8mSPsACqVF1SSF3UT6SQmRPQKxuPsmio3NatagzrXdm4lnhXJ88iQmPMqDX
         Z34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680732547; x=1683324547;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2kwNwGAgyjtt7uSKc/qEWdyaie8OB2blRY1cHaNlDYM=;
        b=rLn/fV56aHjHymyMpjwsxlQDlJYltfpCKS3smCuMZcRAZBZbEZGHwOcJVnm9aFIHKz
         CDFhU4DXES/5VbYGeEWoLE1y+39aZR8pkI190EknmTIuHs77fbyTJF90JYw1wPrLyrcO
         BJI1LHLW3gUyUkGssOew90okr2UwExv58Zi5wOKTqaDRIWilPj9Vo9KVQ5GpIDbDdRpt
         Nxt4k1CvVLrIpeys9kybEDaZSFbq2fUhOU72NAO08SXCqKheVCo5G6NK4lxfXDfoHWlb
         +suc0VEUA5H9rCqjrJIHrOxYmynFOfpJgtrJKUQxxJgLWoan4Cl5MZMh7iuzN8s6J1Jx
         dbQA==
X-Gm-Message-State: AAQBX9f1+vRSIPhaBK3yM5thcdvtUvhhghnBCVAu/yBve8aw3ZVq5VPs
        GJGOAfJ+1rCL1GJ73ep8ysQ=
X-Google-Smtp-Source: AKy350brYknTuIpCp90yKCr/ngb9oj7Xhuce+35iLwMQ7BUF5PbGTwhDDUX+m2TlTxNZFn3VlYHnfA==
X-Received: by 2002:a17:90b:4b84:b0:234:bf0:86b9 with SMTP id lr4-20020a17090b4b8400b002340bf086b9mr7871589pjb.25.1680732547060;
        Wed, 05 Apr 2023 15:09:07 -0700 (PDT)
Received: from john.lan ([2605:59c8:4c5:7110:5120:4bff:95ea:9ce0])
        by smtp.gmail.com with ESMTPSA id gz11-20020a17090b0ecb00b00230ffcb2e24sm1865697pjb.13.2023.04.05.15.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 15:09:06 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com,
        cong.wang@bytedance.com, lmb@isovalent.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v4 00/12] bpf sockmap fixes
Date:   Wed,  5 Apr 2023 15:08:52 -0700
Message-Id: <20230405220904.153149-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes for sockmap running against NGINX TCP tests and also on an
underprovisioned VM so that we hit error (ENOMEM) cases regularly.

The first 3 patches fix cases related to ENOMEM that were either
causing splats or data hangs.

Then 4-7 resolved cases found when running NGINX with its sockets
assigned to sockmap. These mostly have to do with handling fin/shutdown
incorrectly and ensuring epoll_wait works as expected.

Patches 8 and 9 extract some of the logic used for sockmap_listen tests
so that we can use it in other tests because it didn't make much
sense to me to add tests to the sockmap_listen cases when here we
are testing send/recv *basic* cases.

Finally patches 10, 11 and 12 add the new tests to ensure we handle
ioctl(FIONREAD) and shutdown correctly.

To test the series I ran the NGINX compliance tests and the sockmap
selftests. For now our compliance test just runs with SK_PASS.

There are some more things to be done here, but these 11 patches
stand on their own in my opionion and fix issues we are having in
CI now. For bpf-next we can fixup/improve selftests to use the
ASSERT_* in sockmap_helpers, streamline some of the testing, and
add more tests. We also still are debugging a few additional flakes
patches coming soon.

v2: use skb_queue_empty instead of *_empty_lockless (Eric)
    oops incorrectly updated copied_seq on DROP case (Eric)
    added test for drop case copied_seq update

v3: Fix up comment to use /**/ formatting and update commit
    message to capture discussion about previous fix attempt
    for hanging backlog being imcomplete.

v4: build error sockmap things are behind NET_SKMSG not in
    BPF_SYSCALL otherwise you can build the .c file but not
    have correct headers.

John Fastabend (11):
  bpf: sockmap, pass skb ownership through read_skb
  bpf: sockmap, convert schedule_work into delayed_work
  bpf: sockmap, improved check for empty queue
  bpf: sockmap, handle fin correctly
  bpf: sockmap, TCP data stall on recv before accept
  bpf: sockmap, wake up polling after data copy
  bpf: sockmap incorrectly handling copied_seq
  bpf: sockmap, pull socket helpers out of listen test for general use
  bpf: sockmap, build helper to create connected socket pair
  bpf: sockmap, test shutdown() correctly exits epoll and recv()=0
  bpf: sockmap, test FIONREAD returns correct bytes in rx buffer

 include/linux/skmsg.h                         |   2 +-
 include/net/tcp.h                             |   1 +
 net/core/skmsg.c                              |  58 ++-
 net/core/sock_map.c                           |   3 +-
 net/ipv4/tcp.c                                |   9 -
 net/ipv4/tcp_bpf.c                            |  81 +++-
 net/ipv4/udp.c                                |   5 +-
 net/unix/af_unix.c                            |   5 +-
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 119 +++++-
 .../bpf/prog_tests/sockmap_helpers.h          | 374 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 352 +----------------
 .../bpf/progs/test_sockmap_pass_prog.c        |  32 ++
 12 files changed, 659 insertions(+), 382 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sockmap_helpers.h
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_pass_prog.c

-- 
2.33.0

