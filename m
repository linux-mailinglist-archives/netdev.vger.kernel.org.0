Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46CBC89A0
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 15:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbfJBNa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 09:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbfJBNa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 09:30:29 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 82D4788307
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 13:30:28 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id b90so4859699ljf.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 06:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=XzdTNQVTcM9PqilE8DvtNGRuNhLxecb8IlMwsQq1hP8=;
        b=pBIOQ03FS24RyyIhJeUnNmpXGig/3K6yZRdvFrO3qB21VpXSZhRfkvrS/TkV+2gz+f
         KpaT74wjCufj9ECtd8GE8scXua7KEXNREiu02EaL+imbPYCtYvOjcUNF+tRumUSCkavX
         Cxw6nlTMQuIKiYdytaeFxilX/JC22RNTX2TTDZUFTYj5y2eS6oB9Zi3HsvlW6ra5fW31
         vYqXiCFHEHjv/63o0rd9I5OphlKhaoSZJKVxkxFD6juEO6+bjsbDp6sLVTKMYT2S2iZk
         hiUxfqk0aIHadkQkjYEGPAykPRhOLftKl/xrCPj7YxzAKoL8OrZIeJf6//bmwJApk/+v
         k0iw==
X-Gm-Message-State: APjAAAU1VMy/RjCVE/FWM6s11Movy4C0uAmpCCRwackEJJiSUp3JM14S
        O1Lk9OLXf2d5GiisiYtkyVwe7T6whI2uQ+ubpZuYJFx1LcIba1+816vluYRRD9/3jneAN3HFqtZ
        Y6F06APK/TsrDeK0r
X-Received: by 2002:a2e:5358:: with SMTP id t24mr2512523ljd.209.1570023026782;
        Wed, 02 Oct 2019 06:30:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzgLnOQiLlFTPh+I/dXdIGUpO3jQu6dvcibZo1wkHybJGVC/sKpcHdX9oVHJaBAgf4jHl7r2Q==
X-Received: by 2002:a2e:5358:: with SMTP id t24mr2512496ljd.209.1570023026500;
        Wed, 02 Oct 2019 06:30:26 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id m21sm4652958lfh.39.2019.10.02.06.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 06:30:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A060918063D; Wed,  2 Oct 2019 15:30:24 +0200 (CEST)
Subject: [PATCH bpf-next 0/9] xdp: Support multiple programs on a single
 interface through chain calls
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Wed, 02 Oct 2019 15:30:24 +0200
Message-ID: <157002302448.1302756.5727756706334050763.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for executing multiple XDP programs on a single
interface in sequence, through the use of chain calls, as discussed at the Linux
Plumbers Conference last month:

https://linuxplumbersconf.org/event/4/contributions/460/

# HIGH-LEVEL IDEA

The basic idea is to express the chain call sequence through a special map type,
which contains a mapping from a (program, return code) tuple to another program
to run in next in the sequence. Userspace can populate this map to express
arbitrary call sequences, and update the sequence by updating or replacing the
map.

The actual execution of the program sequence is done in bpf_prog_run_xdp(),
which will lookup the chain sequence map, and if found, will loop through calls
to BPF_PROG_RUN, looking up the next XDP program in the sequence based on the
previous program ID and return code.

An XDP chain call map can be installed on an interface by means of a new netlink
attribute containing an fd pointing to a chain call map. This can be supplied
along with the XDP prog fd, so that a chain map is always installed together
with an XDP program.

# PERFORMANCE

I performed a simple performance test to get an initial feel for the overhead of
the chain call mechanism. This test consists of running only two programs in
sequence: One that returns XDP_PASS and another that returns XDP_DROP. I then
measure the drop PPS performance and compare it to a baseline of just a single
program that only returns XDP_DROP.

For comparison, a test case that uses regular eBPF tail calls to sequence two
programs together is also included. Finally, because 'perf' showed that the
hashmap lookup was the largest single source of overhead, I also added a test
case where I removed the jhash() call from the hashmap code, and just use the
u32 key directly as an index into the hash bucket structure.

The performance for these different cases is as follows (with retpolines disabled):

| Test case                       | Perf      | Add. overhead | Total overhead |
|---------------------------------+-----------+---------------+----------------|
| Before patch (XDP DROP program) | 31.0 Mpps |               |                |
| After patch (XDP DROP program)  | 28.9 Mpps |        2.3 ns |         2.3 ns |
| XDP tail call                   | 26.6 Mpps |        3.0 ns |         5.3 ns |
| XDP chain call (no jhash)       | 19.6 Mpps |       13.4 ns |        18.7 ns |
| XDP chain call (this series)    | 17.0 Mpps |        7.9 ns |        26.6 ns |

From this it is clear that while there is some overhead from this mechanism; but
the jhash removal example indicates that it is probably possible to optimise the
code to the point where the overhead becomes low enough that it is acceptable.

# PATCH SET STRUCTURE
This series is structured as follows:

- Patch 1: Prerequisite
- Patch 2: New map type
- Patch 3: Netlink hooks to install the chain call map
- Patch 4: Core chain call logic
- Patch 5-7: Bookkeeping updates to tools
- Patch 8: Libbpf support for installing chain call maps
- Patch 9: Selftests with example user space code

The whole series is also available in my git repo on kernel.org:
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=xdp-multiprog-01

---

Toke Høiland-Jørgensen (9):
      hashtab: Add new bpf_map_fd_put_value op
      xdp: Add new xdp_chain_map type for specifying XDP call sequences
      xdp: Support setting and getting device chain map
      xdp: Implement chain call logic to support multiple programs on one interface
      tools/include/uapi: Add XDP chain map definitions
      tools/libbpf_probes: Add support for xdp_chain map type
      bpftool: Add definitions for xdp_chain map type
      libbpf: Add support for setting and getting XDP chain maps
      selftests: Add tests for XDP chain calls


 include/linux/bpf.h                             |   10 +
 include/linux/bpf_types.h                       |    1 
 include/linux/filter.h                          |   26 ++
 include/linux/netdevice.h                       |    3 
 include/uapi/linux/bpf.h                        |   12 +
 include/uapi/linux/if_link.h                    |    2 
 kernel/bpf/hashtab.c                            |  169 +++++++++++++-
 kernel/bpf/map_in_map.c                         |    7 +
 kernel/bpf/map_in_map.h                         |    1 
 kernel/bpf/syscall.c                            |   11 +
 net/core/dev.c                                  |   42 +++-
 net/core/rtnetlink.c                            |   23 ++
 tools/bpf/bpftool/Documentation/bpftool-map.rst |    4 
 tools/bpf/bpftool/bash-completion/bpftool       |    2 
 tools/bpf/bpftool/map.c                         |    3 
 tools/include/uapi/linux/bpf.h                  |   12 +
 tools/include/uapi/linux/if_link.h              |    2 
 tools/lib/bpf/libbpf.h                          |    4 
 tools/lib/bpf/libbpf.map                        |    2 
 tools/lib/bpf/libbpf_probes.c                   |    4 
 tools/lib/bpf/netlink.c                         |   49 ++++
 tools/testing/selftests/bpf/.gitignore          |    1 
 tools/testing/selftests/bpf/Makefile            |    3 
 tools/testing/selftests/bpf/progs/xdp_dummy.c   |    6 +
 tools/testing/selftests/bpf/test_maps.c         |   45 ++++
 tools/testing/selftests/bpf/test_xdp_chain.sh   |   77 +++++++
 tools/testing/selftests/bpf/xdp_chain.c         |  271 +++++++++++++++++++++++
 27 files changed, 765 insertions(+), 27 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_chain.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_chain.c

