Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D1B6CAC5C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbjC0Ryw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjC0Ryu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:54:50 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610FD1B0;
        Mon, 27 Mar 2023 10:54:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso9760310pjb.2;
        Mon, 27 Mar 2023 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679939689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XiEB4zde4rhhElO3EFcvdURmdk48Eu/JQfH+zgKOcBw=;
        b=naPwM2OpfUliWhFuKcSQeMELTlnWp8vqjHgKn8xaXaEmxZoyxXyucj6IhL/7knXM06
         oYDvAbfwI8Jzz9e2yYJ2iVoFBtYg0T8sfZRphtDiiKNXwdX6K20Qhxzbpyyb07VCFrGj
         XABqvqFSqCUICJ/bx84tXMLx/fvaicvoynmaX/lR6FY34haFhSwsD9Y5Ju+ZXOqfxMLP
         4iJZ5WjvX5y9c4PwW/cYlHEublCMzkBVeWMGnFOo5XO31aH+6a9XBlpI+VEWZ8dIbwB2
         IPT26mIaDc1ZfXL8NWQjbXf+jnzLIIxFgN9D4qK2nfyZiLToUZEjGetVpy2YAi0bjM09
         7j7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679939689;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XiEB4zde4rhhElO3EFcvdURmdk48Eu/JQfH+zgKOcBw=;
        b=Ryrvmq9ZJM+lGGp3pVkzdsSta8zMmVdOWE+iTjbGWfipPnsrIboNJ9AuYLjMEvo3Gw
         WTfeaGAI0FcC2Y4+8NQ3XgICgvHAKojozn+32wnW9J526o5qf0KIFiF/cBgRlbagNZML
         jFDzRE8K7u8Quj09v1DVeRo9mNGx8e1YInMwW3koaccT/xuKwr1HzoesqHCbaI4wV/W3
         DqByItf51XVPZdJcZQzK54iES70rrZk3yH4QkQvQGjK6yJeyEHWppBO6PWiPQtcqHSb/
         5JBo/6EPvTtcIwWx4BTySSkrt1FF1tEYpy0cM02sl97GyIGcnEk74k/RPbJpf0LzE+mv
         mVPg==
X-Gm-Message-State: AO0yUKVWlgHKnzAmKbcd7CwXyr3dmTD5Mc1ZgM0Vuy3LzEfNlv0QuMyx
        CSWh4mZ2As94IQLFbLJc8Uc=
X-Google-Smtp-Source: AK7set/s+rpEbdwQC40UmY7cJ/jgTabQgH21aRAymINdgoKiYLX4NM0/RIRQlxXTsIvKWEANHb3izA==
X-Received: by 2002:a05:6a20:29b:b0:d9:e6a9:d3e2 with SMTP id 27-20020a056a20029b00b000d9e6a9d3e2mr12476591pza.3.1679939688797;
        Mon, 27 Mar 2023 10:54:48 -0700 (PDT)
Received: from john.lan ([98.97.117.131])
        by smtp.gmail.com with ESMTPSA id r1-20020a62e401000000b005a8ba70315bsm19408316pfh.6.2023.03.27.10.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 10:54:48 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v2 00/11] bpf sockmap fixes
Date:   Mon, 27 Mar 2023 10:54:34 -0700
Message-Id: <20230327175446.98151-1-john.fastabend@gmail.com>
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

Finally patches 10 and 11 add the new tests to ensure we handle
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

