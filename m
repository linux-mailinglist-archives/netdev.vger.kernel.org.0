Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9136D8C48
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbjDFBBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbjDFBBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:01:00 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C837C7AB7;
        Wed,  5 Apr 2023 18:00:35 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id q102so35771714pjq.3;
        Wed, 05 Apr 2023 18:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680742835; x=1683334835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=n5JpIw02VGSWv/IHMLyDE/sl1CvoaDWD/Z9/7DqI19g=;
        b=EuOvdD6XmX8KSI3zKelISzWw4pmK25CaaWWI8zWvpCPkfMBzl0EGJtGiRR764Vgtw1
         5/MLDprmvRIbbpzuzij0wmn7Wtyx2kj6904Tcz6GgsW3gFkGfiOW1AS+4eEqWuzGY9OY
         JNlbyC6ouGVrTiqyncfXkjdf7Fct3/Zid9IY+UyzTioJ6Soe2WkR7qjInXq2X/lF4VDp
         wAYe6PEKmc2pbRQEccCRGn709gtb0KciHaHA1ZyXIaV9hJy5deHuIuECqQda8KYXHDpA
         4gF/7xUMQ54dDssnf8WEzesXcPZZwvYgrf33fd5awG1LniN77lqRny4jR4QTYcw5gLNG
         eziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680742835; x=1683334835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n5JpIw02VGSWv/IHMLyDE/sl1CvoaDWD/Z9/7DqI19g=;
        b=4JkUPTEEp2BMxuFi6eLLCckGciEC97Q41fpIiMzEm1z+97Z698/KgNNT5cmIjKL3gz
         bSJsCfYPL9nTfyCjKHOXOKSu8Dh8owRDSlLUY+VSAyatovbAtzpw6U4X2/0HEooM2tvL
         FDQYV7qhR4vUJxzFp3ublLD7IMiA17OT73mPjnUG0b7PAkJNsPXh9hKx04msObAx6RbN
         41sHhYuc+SMsfAIwt5sMttvZtpDEFdJxe1Ceczepx+wlCbtRsZtoEv2fY8nRYmn9d9BJ
         5AGX0n6KNAvK4LaMpAmOJujL7TFpRYxTDbTYr9z18ahsHJ+MPIpyZ2SMYvCpN/xqhs7d
         SesQ==
X-Gm-Message-State: AAQBX9f69CZe2wSSlwkcBPWYhnr3xnuMleQd67R3G7nmtZzrXSeDmAyh
        K+F43h/6eSkIa6OzFtC4rUc=
X-Google-Smtp-Source: AKy350al3TLeXcouwRR6n4nKlkhjMunwXqKTK4J/Miwr97XA+pvT2r/a8VzGPI1vu9+b/154wWz2oQ==
X-Received: by 2002:a05:6a20:cf49:b0:de:a889:c58b with SMTP id hz9-20020a056a20cf4900b000dea889c58bmr1077073pzb.25.1680742835156;
        Wed, 05 Apr 2023 18:00:35 -0700 (PDT)
Received: from john.lan ([98.97.117.85])
        by smtp.gmail.com with ESMTPSA id c14-20020aa78c0e000000b0062c0c3da6b8sm35377pfd.13.2023.04.05.18.00.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 18:00:34 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, edumazet@google.com,
        cong.wang@bytedance.com, lmb@isovalent.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v5 00/12] bpf sockmap fixes
Date:   Wed,  5 Apr 2023 18:00:19 -0700
Message-Id: <20230406010031.3354-1-john.fastabend@gmail.com>
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

v5: typo with mispelled SOCKMAP_HELPERS

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

