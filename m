Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941BD694818
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBMOa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:30:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBMOaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:30:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63BAEFB5;
        Mon, 13 Feb 2023 06:30:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E0DAB80DEE;
        Mon, 13 Feb 2023 14:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F96EC433EF;
        Mon, 13 Feb 2023 14:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676298651;
        bh=cDc4IsiB86tpg1vB4zCOCaSjbBP1jEgnrT19b56SQY4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Bd+N4+6m85prGtqvR00XliSxuGo9oQ6xTSHk85/NRIEtA5W/dx9pI5vJywxA0Bmcy
         y2mNflRkXrMzaPXOn9K4yiLoHBTqEb4HGsL7SZzKYxjUyKGEgbzAVZGORrnZNA1yX/
         PAv076SK4ckRYh/lp9NIzXj079tyAdQOHuXjGTsGPmYlZCTxG9JIuJV0RYHD0DCrRz
         n7K+fuQI7g+zSj/B81t/H1C3hmwxwiBIS47reB8bpZmp/KwFV+XP50Kcg3EFVmz+Bu
         PdlWv6vUWr7WZEXSu7XRKXfDvMVzKAEf6g8HMWkgyUkozVaC09u1KPUvHwT5EuSzay
         6Moeh+0R24oiQ==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH bpf-next] selftests/bpf: Cross-compile bpftool
In-Reply-To: <20230210084326.1802597-1-bjorn@kernel.org>
References: <20230210084326.1802597-1-bjorn@kernel.org>
Date:   Mon, 13 Feb 2023 15:30:48 +0100
Message-ID: <87pmad63jb.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>
> When the BPF selftests are cross-compiled, only the a host version of
> bpftool is built. This version of bpftool is used to generate various
> intermediates, e.g., skeletons.
>
> The test runners are also using bpftool. The Makefile will symlink
> bpftool from the selftest/bpf root, where the test runners will look
> for the tool:
>
>   | ...
>   | $(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
>   |    $(OUTPUT)/$(if $2,$2/)bpftool
>
> There are two issues for cross-compilation builds:
>
>  1. There is no native (cross-compilation target) build of bpftool
>  2. The bootstrap variant of bpftool is never cross-compiled (by
>     design)
>
> Make sure that a native/cross-compiled version of bpftool is built,
> and if CROSS_COMPILE is set, symlink to the native/non-bootstrap
> version.

...and the grand master plan is to add BPF CI support for riscv64, where
this patch a prerequisite to [1]. I would suspect that other platforms
might benefit from cross-compilation builds as well.

[1] https://github.com/kernel-patches/vmtest/pull/194
