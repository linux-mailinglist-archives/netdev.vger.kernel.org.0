Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6748669908C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 10:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjBPJ45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 04:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBPJ44 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 04:56:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BFF3770D;
        Thu, 16 Feb 2023 01:56:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C932B826A9;
        Thu, 16 Feb 2023 09:56:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475D7C433EF;
        Thu, 16 Feb 2023 09:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676541412;
        bh=DUg3YOeKnzjay7egaWmLgW5mZl9+u14ElLFt8uiDPNQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=s1tmRVfnx92JRM7mIPYIcWP4TGf7u0UFD2RnL7Yw1ZuQnMFty8PoUbRPkenE+GRHS
         xVxRX4LzYVhIhunIPQZ4fmj2XSgjQBFWyjXZFxv1t52mQ6dugSjfZ5T1aFOa+ch5GK
         2lN+O/xYDeoeLnPQD/TZUtNK2EsA9TIW3WDHWD3rj7oepJoC4j43ZIDKnxHgHPFvSZ
         iIJ667+hzuYaIrcYfwj6MQmyAFes9rUCJUU3Z+mD8QIzm/131ww3nqAHBOUVRDqttV
         bDsS30ipKqU3hIpYiLpKmVgw3BBUHfYTdIfYUaaUxWUCsT4dm/PZNf6qYLF65lI6VW
         rg+MJvRP7qpvw==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Pu Lehui <pulehui@huaweicloud.com>, bpf@vger.kernel.org,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Palmer Dabbelt <palmer@rivosinc.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Guo Ren <guoren@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Pu Lehui <pulehui@huawei.com>,
        Pu Lehui <pulehui@huaweicloud.com>
Subject: Re: [PATCH bpf-next v1 0/4] Support bpf trampoline for RV64
In-Reply-To: <20230215135205.1411105-1-pulehui@huaweicloud.com>
References: <20230215135205.1411105-1-pulehui@huaweicloud.com>
Date:   Thu, 16 Feb 2023 10:56:49 +0100
Message-ID: <8735763pcu.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pu Lehui <pulehui@huaweicloud.com> writes:

> BPF trampoline is the critical infrastructure of the bpf
> subsystem, acting as a mediator between kernel functions
> and BPF programs. Numerous important features, such as
> using ebpf program for zero overhead kernel introspection,
> rely on this key component. We can't wait to support bpf
> trampoline on RV64. Since RV64 does not support ftrace
> direct call yet, the current RV64 bpf trampoline is only
> used in bpf context.
>
> As most of riscv cpu support unaligned memory accesses,
> we temporarily use patch [1] to facilitate testing. The
> test results are as follow, and test_verifier with no
> new failure ceses.
>
> - fexit_bpf2bpf:OK
> - dummy_st_ops:OK
> - xdp_bpf2bpf:OK
>
> [1] https://lore.kernel.org/linux-riscv/20210916130855.4054926-2-chenhuan=
g5@huawei.com/
>
> v1:
> - Remove the logic of bpf_arch_text_poke supported for
>   kernel functions. (Kuohai and Bj=C3=B6rn)
> - Extend patch_text for multiple instructions. (Bj=C3=B6rn)
> - Fix OOB issue when image too big. (Bj=C3=B6rn)

This series is ready to go in as is.

@Palmer I'd like to take this series via the bpf-next tree (as usual),
but note that there are some non-BPF changes as well, related to text
poking.

@Lehui I'd like to see two follow-up patches:

1. Enable kfunc for RV64, by adding:
 | bool bpf_jit_supports_kfunc_call(void)
 | {
 |         return true;
 | }

2. Remove the checkpatch warning on patch 4:
 | WARNING: kfree(NULL) is safe and this check is probably not required
 | #313: FILE: arch/riscv/net/bpf_jit_comp64.c:984:
 | +	if (branches_off)
 | +		kfree(branches_off);


For the series:

Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
