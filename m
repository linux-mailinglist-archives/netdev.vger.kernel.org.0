Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 987B68BE74
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfHMQ0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:26:34 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:46081 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfHMQ0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:26:34 -0400
Received: by mail-vs1-f73.google.com with SMTP id x10so29232411vsp.13
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 09:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rEg3vpBiSevgVJYfmkI0ugswBbPAxHgecBPHEJKFNuM=;
        b=SjcCJiMmDTyooV26WYe92/vA1lSSXCKJOCPz/bKL7KS79MVYDuTcLVCoJpV8mc1KgD
         J9Pp+aAjVgm1xip+wlEQYK62JqJ1FygrLHIidU22x5dfxcOg0E9UGAHB52YcdBQY69bl
         tdeccbPwDp4jq2hzBrFurAbQAocejsc/wMI1fio+wMxtw0f03sLN2h+2Q/IlkScRdMiv
         6qG7Oj58db84lKKF0OXhmAg7cTv5uRxmxe8xfeRAH54QfZyjJXnOXOnhlA6Lp/GsiDzo
         geYcpZQBQdNZOGJ0bXfpbwwiZS9Kibq/Httl6ciMS1tmctuKroGUQszfQNmjreTydjd5
         s/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rEg3vpBiSevgVJYfmkI0ugswBbPAxHgecBPHEJKFNuM=;
        b=XIfF2ryO494hBHzEBi2aG0mL59VdS2x+KF75cYbFLRzXffcyp/QO4fZeBzHYnAuRxi
         5zqrPbBvq3Oa0rTnNT0UMZumZ0rpOBKwwsSvE2cAXpauXifLxzFyt44qo6SC7RgYvuKV
         OXZT0fYT4DoFqpwJFESqr7mWAqV1z50vtIaZ9C50NHJ3Eft7X4LqV2BtLXlfmWbKXjKB
         AG5lIc9LO3B90IzOkgQMXVv+HdzodeK+SATvgtuYGC4MJBXgdO44yZXkBNO9dOOd67pf
         hfH8WHjmExz5DK6kTgD/RH2dSD2upxRJPGAikqcMUJMURNmyaQdakHd0sgvtsxA6NFiL
         worg==
X-Gm-Message-State: APjAAAXh3zX3IHzxk+wvieWdby0rcNY2FPb197+aCxQRAPzcYnQGrc9a
        7Nx9ZpzV/Lvs0iuslJl11Wc0ESzvWXRWXHQ9Garem0SjDWQVni2eohQgwwXIsCLAty+5JL84J8U
        +a8/6P3IiwWIDHjQBFWA8cvvrF+FPhfVXZUVNV34yzDsfv3Uxcsn3LA==
X-Google-Smtp-Source: APXvYqychZ3DfVuOpbrNugd0OUpob50vjnpuBW4EL0utwAp1CiHRYiSbfg0e6vI7m+vSrrOUSypyH2I=
X-Received: by 2002:a1f:94e:: with SMTP id 75mr8867303vkj.8.1565713593137;
 Tue, 13 Aug 2019 09:26:33 -0700 (PDT)
Date:   Tue, 13 Aug 2019 09:26:26 -0700
Message-Id: <20190813162630.124544-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v3 0/4] bpf: support cloning sk storage on accept()
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there is no way to propagate sk storage from the listener
socket to a newly accepted one. Consider the following use case:

        fd = socket();
        setsockopt(fd, SOL_IP, IP_TOS,...);
        /* ^^^ setsockopt BPF program triggers here and saves something
         * into sk storage of the listener.
         */
        listen(fd, ...);
        while (client = accept(fd)) {
                /* At this point all association between listener
                 * socket and newly accepted one is gone. New
                 * socket will not have any sk storage attached.
                 */
        }

Let's add new BPF_F_CLONE flag that can be specified when creating
a socket storage map. This new flag indicates that map contents
should be cloned when the socket is cloned.

v3:
* make sure BPF_F_NO_PREALLOC is always present when creating
  a map (Martin KaFai Lau)
* don't call bpf_sk_storage_free explicitly, rely on
  sk_free_unlock_clone to do the cleanup (Martin KaFai Lau)

v2:
* remove spinlocks around selem_link_map/sk (Martin KaFai Lau)
* BPF_F_CLONE on a map, not selem (Martin KaFai Lau)
* hold a map while cloning (Martin KaFai Lau)
* use BTF maps in selftests (Yonghong Song)
* do proper cleanup selftests; don't call close(-1) (Yonghong Song)
* export bpf_map_inc_not_zero

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>

Stanislav Fomichev (4):
  bpf: export bpf_map_inc_not_zero
  bpf: support cloning sk storage on accept()
  bpf: sync bpf.h to tools/
  selftests/bpf: add sockopt clone/inheritance test

 include/linux/bpf.h                           |   2 +
 include/net/bpf_sk_storage.h                  |  10 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/syscall.c                          |  16 +-
 net/core/bpf_sk_storage.c                     | 103 ++++++-
 net/core/sock.c                               |   9 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/progs/sockopt_inherit.c     |  97 +++++++
 .../selftests/bpf/test_sockopt_inherit.c      | 253 ++++++++++++++++++
 11 files changed, 490 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/sockopt_inherit.c
 create mode 100644 tools/testing/selftests/bpf/test_sockopt_inherit.c

-- 
2.23.0.rc1.153.gdeed80330f-goog
