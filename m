Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0AC4B7BA3
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 01:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbiBPAM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 19:12:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241502AbiBPAMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 19:12:55 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7486DBD16
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:44 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id a19-20020a25ca13000000b0061db44646b3so857596ybg.2
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 16:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Vrfhs9fM/f5flzQ6fo6JMQiAz44yb98YDndfmXgWlR0=;
        b=F6GeSpndj4rny/JoZpU0oayhIhxV7CcfrseOarmjurGggnwv6E3JxHe86eRa8m2Q0J
         8+L7j4NSN9YPBmEIudy+flzMruU0DNixNQxjqBN6hAx/74UmyAUxtPMM985xDRuT1il1
         VY002I0tobGPJuIiu3rl16y8YSw9vaZG/ICRPbf9v/xyPIHIN9j3F8SVQUB+kNK8LAD8
         TR+zEko7GUuSbMSnnstmms1HVDgXMbzxYhe+sAjZLzq1t0298rOHTiUnQ43HF5oi2GcX
         mQw41019OoduuIZHg5qXNsVZ9t49GT8jjbNhUurdueB1Z8LTReP911mKn8OCraS0Xms8
         DlxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Vrfhs9fM/f5flzQ6fo6JMQiAz44yb98YDndfmXgWlR0=;
        b=ntlIv+PIbY+JOXVnOOolDvnGHcK89mNGq1FN5jd9fTHwsFUzea7DGgMe0kRe6GXgVP
         GZYKJ/NR8YfFuVsXtOrWAkp3fYiRabLmeIFaeajn/FOYCQUhRDUo4a+8Ysh0tOvgEt2U
         Qu5865BTlAjzrDbm+DJTujD4JA/w/Mxz64MdvqriYHAF3ksLnUdTVkIwlXWRqtJ4q5yp
         aIKGrPMw1s4L21Xp4Ph7Z4uejvXDSSaIEXyTHgWSZ80EazbLGJx4M4ZP6LalHiqY/iyX
         bfIAHwZSPMmehq8s5/20fnnW0xU7ASiWKAghc5Q1A6dT4BF4hu5sMvfviekfXVGI2ZB8
         g9aQ==
X-Gm-Message-State: AOAM531sNb8yolkQjkCxXSCwdP4eOrceEUpnbuDKMePChsAPKP1RPhLl
        +Qo7Esq3q42G/KfCO2+ttyTVykrOrU7AwfvaSlNDGY5NFn1kk9DqLUltc9DEq0m14v1pS5qoYFR
        0ZcxKuWzc2uLqBHqXHzR6i2dHckvrEzI6BgkQZLWNdNKMRgvNGbN+vg==
X-Google-Smtp-Source: ABdhPJxkAWK3iyQxNpcDsl9XyL8owAbBsZcW97WYNcfT5UT17vc2FqaNQTndSk2wOqPX3fkcNXqZs9Y=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:754a:e17d:48a0:d1db])
 (user=sdf job=sendgmr) by 2002:a81:7141:0:b0:2d3:d549:23f8 with SMTP id
 m62-20020a817141000000b002d3d54923f8mr257069ywc.87.1644970363999; Tue, 15 Feb
 2022 16:12:43 -0800 (PST)
Date:   Tue, 15 Feb 2022 16:12:37 -0800
Message-Id: <20220216001241.2239703-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [RFC bpf-next 0/4] bpf: cgroup_sock lsm flavor
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>, kafai@fb.com,
        kpsingh@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC proposal for a recent discussion about default socket
policy [0]. The series implements new lsm flavor for attaching
lsm-like programs to existing lsm hooks that operate on 'struct socket'
The actual requirement is that the first argument is of type 'struct
socket'. Later on we can add support 'struct sock' based hooks without
any user-visible changes.

For demonstration purposes only two hooks are included (can be extended
to more later). Also, for demonstration purposes, writes to sock->sk_priority
are exposed to lsm hooks (can cover more bpf_sock fields later).

The intended workflow is:

The users load lsm_cgroup_sock tracepoint into the system. This installs
generic fmod_ret trampoline that runs __cgroup_bpf_run_lsm_sock.

After that, bpf_prog_attach should be called to activate this program
for the particular cgroup. This interface uses exiting cgroup_bpf
functionality and should support all existing inheritance flags.

I'd like to get a generic feedback whether I'm going into the right
direction or not. The thing I'm not sure about is the way I'm
abusing jit generation (maybe fmod_ret should be automagically
installed instead?).

For non-socket specific hooks, we can add a similar BPF_LSM_CGROUP
attach point that looks at current->cgroup instead of socket->cgroup.

[0] https://lore.kernel.org/bpf/YgPz8akQ4+qBz7nf@google.com/

Cc: ast@kernel.org
Cc: daniel@iogearbox.net
Cc: kafai@fb.com
Cc: kpsingh@kernel.org

Stanislav Fomichev (4):
  bpf: cgroup_sock lsm flavor
  bpf: allow writing to sock->sk_priority from lsm progtype
  libbpf: add lsm_cgoup_sock type
  selftest: lsm_cgroup_sock sample usage

 arch/x86/net/bpf_jit_comp.c                   | 27 +++++--
 include/linux/bpf-cgroup-defs.h               |  4 +
 include/linux/bpf.h                           |  2 +
 include/uapi/linux/bpf.h                      |  1 +
 kernel/bpf/bpf_lsm.c                          | 49 +++++++++++
 kernel/bpf/btf.c                              | 10 +++
 kernel/bpf/cgroup.c                           | 43 +++++++++-
 kernel/bpf/syscall.c                          |  6 +-
 kernel/bpf/trampoline.c                       |  1 +
 kernel/bpf/verifier.c                         |  4 +-
 tools/include/uapi/linux/bpf.h                |  1 +
 tools/lib/bpf/libbpf.c                        |  2 +
 .../bpf/prog_tests/lsm_cgroup_sock.c          | 81 +++++++++++++++++++
 .../selftests/bpf/progs/lsm_cgroup_sock.c     | 55 +++++++++++++
 14 files changed, 273 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/lsm_cgroup_sock.c
 create mode 100644 tools/testing/selftests/bpf/progs/lsm_cgroup_sock.c

-- 
2.35.1.265.g69c8d7142f-goog

