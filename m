Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322E6248A70
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgHRPtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbgHRPtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 11:49:19 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02213C061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 08:49:18 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id qc22so22664379ejb.4
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 08:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version:content-transfer-encoding;
        bh=W6Tfe+QakpZckAfszo/KpyJGHhhROB9h5XZ09W6Izrg=;
        b=Ukod+5kGqwxK2DCR5wSV1/Hv4Le4ZZU4g30q9U1qNYy775uCF2tFKez/PCVOitLQuP
         tWrXOxy2ji/36zv47JpGMyF1xhtEH8nr0XxgRkonfe0W947BYY3UV5bFswr7aDdzcIkC
         6HnN0RdyAgRajFzaxRQhwFbRZKg28BBaKZjos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version:content-transfer-encoding;
        bh=W6Tfe+QakpZckAfszo/KpyJGHhhROB9h5XZ09W6Izrg=;
        b=jqU8KQGb62QuxZ+fA54t7SqR0VB6Pn2iedbm1+3sLoglh9dRdyQ92SXPZsB1p8Xv5m
         O38eo8noR2Exgk9UoYuUC06oUIz5nXXZ4PLvOsK/xM3O6yipC5yOfBFb0ArEJUGthKcE
         5HW25fKfXCSKNafzERQDGm2MLXmR0XIUyloEzlnhuX/QgZ4mdnLclb8hCIv/smDvJRw6
         Voi57Rg2W69aCDSO7JkUFLZBNeqT7kHmzoVhh70UEwBsW6GGxOiExWrswWlSZg36EJtE
         CwkZky1KuWg0p6O4MlwX1yhWPnYPPFGwGCiG9hR5HEeRuvMSX5RLULzWhqsTEiovdE/w
         aeMA==
X-Gm-Message-State: AOAM533Bn0zR1Hzp3Blfkr3dSvlIa3pp9k8jo0u+Quwmu1F6WQ9PHkqx
        5kDSfpYwNd/gc5hDlevm20MZvQ==
X-Google-Smtp-Source: ABdhPJyPkKqzAQez2eaOrYu3zX6UR3teACF++Ti/oH6N9za48qmmfjTTVw4g6Vy6NrKN07BcV8qsWA==
X-Received: by 2002:a17:906:dbd8:: with SMTP id yc24mr20330417ejb.176.1597765754015;
        Tue, 18 Aug 2020 08:49:14 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id sb9sm17105232ejb.90.2020.08.18.08.49.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 08:49:13 -0700 (PDT)
References: <20200717103536.397595-1-jakub@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: BPF sk_lookup v5 - TCP SYN and UDP 0-len flood benchmarks
In-reply-to: <20200717103536.397595-1-jakub@cloudflare.com>
Date:   Tue, 18 Aug 2020 17:49:12 +0200
Message-ID: <87lficrm2v.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got around to re-running flood benchmarks. Mainly to confirm that
introduction of static key had the desired effect - users not attaching
BPF sk_lookup programs won't notice a performance hit in Linux v5.9.

But also to check for any unexpected bottlenecks when BPF sk_lookup
program is attached, like struct in6_addr copying that turned out to be
a bad idea in v1.

The test setup has been already covered in the cover letter for v1 of
the series so I'm not going to repeat it here. Please take a look at
"Performance considerations" in [0].

BPF program [1] used during benchmarks has been updated to work with the
BPF sk_lookup uAPI in v5.

RX pps and CPU cycles events were recorded in 3 configurations:

 1. 5.8-rc7 w/o this BPF sk_lookup patch series (baseline),
 2. 5.8-rc7 with patches applied, but no SK_LOOKUP program attached,
 3. 5.8-rc7 with patches applied, and SK_LOOKUP program attached;
    BPF program [1] is doing a lookup LPM_TRIE map with 200 entries.

RX pps measured with `ifpps -d <dev> -t 1000 --csv --loop` for 60 sec.

| tcp4 SYN flood               | rx pps (mean =C2=B1 sstdev) | =CE=94 rx pp=
s |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   | 899,875 =C2=B1 1.0%         |        - |
| no SK_LOOKUP prog attached   | 889,798 =C2=B1 0.6%         |    -1.1% |
| with SK_LOOKUP prog attached | 868,885 =C2=B1 1.4%         |    -3.4% |

| tcp6 SYN flood               | rx pps (mean =C2=B1 sstdev) | =CE=94 rx pp=
s |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   | 823,364 =C2=B1 0.6%         |        - |
| no SK_LOOKUP prog attached   | 832,667 =C2=B1 0.7%         |     1.1% |
| with SK_LOOKUP prog attached | 820,505 =C2=B1 0.4%         |    -0.3% |

| udp4 0-len flood             | rx pps (mean =C2=B1 sstdev) | =CE=94 rx pp=
s |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   | 2,486,313 =C2=B1 1.2%       |        - |
| no SK_LOOKUP prog attached   | 2,486,932 =C2=B1 0.4%       |     0.0% |
| with SK_LOOKUP prog attached | 2,340,425 =C2=B1 1.6%       |    -5.9% |

| udp6 0-len flood             | rx pps (mean =C2=B1 sstdev) | =CE=94 rx pp=
s |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   | 2,505,270 =C2=B1 1.3%       |        - |
| no SK_LOOKUP prog attached   | 2,522,286 =C2=B1 1.3%       |     0.7% |
| with SK_LOOKUP prog attached | 2,418,737 =C2=B1 1.3%       |    -3.5% |

cpu-cycles measured with `perf record -F 999 --cpu 1-4 -g -- sleep 60`.

|                              |      cpu-cycles events |          |
| tcp4 SYN flood               | __inet_lookup_listener | =CE=94 events |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   |                  1.31% |        - |
| no SK_LOOKUP prog attached   |                  1.24% |    -0.1% |
| with SK_LOOKUP prog attached |                  2.59% |     1.3% |

|                              |      cpu-cycles events |          |
| tcp6 SYN flood               |  inet6_lookup_listener | =CE=94 events |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   |                  1.28% |        - |
| no SK_LOOKUP prog attached   |                  1.22% |    -0.1% |
| with SK_LOOKUP prog attached |                  3.15% |     1.4% |

|                              |      cpu-cycles events |          |
| udp4 0-len flood             |      __udp4_lib_lookup | =CE=94 events |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   |                  3.70% |        - |
| no SK_LOOKUP prog attached   |                  4.13% |     0.4% |
| with SK_LOOKUP prog attached |                  7.55% |     3.9% |

|                              |      cpu-cycles events |          |
| udp6 0-len flood             |      __udp6_lib_lookup | =CE=94 events |
|------------------------------+------------------------+----------|
| 5.8-rc7 vanilla (baseline)   |                  4.94% |        - |
| no SK_LOOKUP prog attached   |                  4.32% |    -0.6% |
| with SK_LOOKUP prog attached |                  8.07% |     3.1% |

Couple comments:

1. udp6 outperformed udp4 in our setup. The likely suspect is
   CONFIG_IP_FIB_TRIE_STATS which put fib_table_lookup at the top of
   perf report when it comes to cpu-cycles w/o counting children. It
   should have been disabled.

2. When BPF sk_lookup program is attached, the hot spot remains to be
   copying data to populate BPF context object before each program run.

   For example, snippet from perf annotate for __udp4_lib_lookup:

---8<---
         :                      rcu_read_lock();
         :                      run_array =3D rcu_dereference(net->bpf.run_=
array[NETNS_BPF_SK_LOOKUP]);
    0.01 :   ffffffff817f8624:       mov    0xd68(%r12),%rsi
         :                      if (run_array) {
    0.00 :   ffffffff817f862c:       test   %rsi,%rsi
    0.00 :   ffffffff817f862f:       je     ffffffff817f87a9 <__udp4_lib_lo=
okup+0x2c9>
         :                      struct bpf_sk_lookup_kern ctx =3D {
    1.05 :   ffffffff817f8635:       xor    %eax,%eax
    0.00 :   ffffffff817f8637:       mov    $0x6,%ecx
    0.01 :   ffffffff817f863c:       movl   $0x110002,0x40(%rsp)
    0.00 :   ffffffff817f8644:       lea    0x48(%rsp),%rdi
   18.76 :   ffffffff817f8649:       rep stos %rax,%es:(%rdi)
    1.12 :   ffffffff817f864c:       mov    0xc(%rsp),%eax
    0.00 :   ffffffff817f8650:       mov    %ebp,0x48(%rsp)
    0.00 :   ffffffff817f8654:       mov    %eax,0x44(%rsp)
    0.00 :   ffffffff817f8658:       movzwl 0x10(%rsp),%eax
    1.21 :   ffffffff817f865d:       mov    %ax,0x60(%rsp)
    0.00 :   ffffffff817f8662:       movzwl 0x20(%rsp),%eax
    0.00 :   ffffffff817f8667:       mov    %ax,0x62(%rsp)
         :                      .sport          =3D sport,
         :                      .dport          =3D dport,
         :                      };
         :                      u32 act;
         :
         :                      act =3D BPF_PROG_SK_LOOKUP_RUN_ARRAY(run_ar=
ray, ctx, BPF_PROG_RUN);
--->8---

   Looking at the RX pps drop this is not something we're concerned with
   ATM. The overhead will drown in cycles burned in iptables, which were
   intentionally unloaded for the benchmark.

   If someone has an idea how to tune it, though, I'm all ears.

Thanks,
-jkbs

[0] https://lore.kernel.org/bpf/20200506125514.1020829-1-jakub@cloudflare.c=
om/
[1] https://github.com/majek/inet-tool/blob/master/ebpf/inet-kern.c
