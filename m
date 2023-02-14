Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B0E695F8A
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbjBNJoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbjBNJoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:44:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F48C113F7;
        Tue, 14 Feb 2023 01:44:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3EB8B81BF4;
        Tue, 14 Feb 2023 09:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2965AC433D2;
        Tue, 14 Feb 2023 09:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676367873;
        bh=FOmsk5fnXqo2RHs4yKki8c5ZfBF1FXU8FSjoNcYsGtE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=LFPC2xCHyZEp+4VSCp/bh0BjqK/nLUOVJuP44VcN3L6g+/v7hByLQ08R6Qw1JLtiE
         lmWOAKkcIGrpkyOknb7ezKfSurGekGVRYptLz8LM2H+SpRKrW7pTcWWQvjH2lwTVrS
         i5VH1nQmrRh7+iGeMos/QYBsK8HL95Bxc/KwclK8dsRWqASBi7QXOM1bwQG4tPekUt
         tx01+zA4cC0ij4RJYk6qOTcPd0ZmM1t+Q3sU4P1fTVIoQUGX2X1NKDm9lkQIdRzstG
         hxADpk4AnrP/BziRQ/d6cavRWEZuoi+SgkEkd/eenlIKudozD4YVdbv2OaCrfjRTES
         Ws/yVWPpMwCeg==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Zachary Leaf <zachary.leaf@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-riscv@lists.infradead.org,
        Quentin Monnet <quentin@isovalent.com>,
        linux-morello@op-lists.linaro.org
Subject: Re: [PATCH bpf-next] selftests/bpf: Cross-compile bpftool
In-Reply-To: <9d83e21c-01c8-9729-0e2b-54d405b6b1ee@arm.com>
References: <20230210084326.1802597-1-bjorn@kernel.org>
 <87pmad63jb.fsf@all.your.base.are.belong.to.us>
 <9d83e21c-01c8-9729-0e2b-54d405b6b1ee@arm.com>
Date:   Tue, 14 Feb 2023 10:44:30 +0100
Message-ID: <87y1p08ttt.fsf@all.your.base.are.belong.to.us>
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

Zachary Leaf <zachary.leaf@arm.com> writes:

> On 13/02/2023 14:30, Bj=C3=B6rn T=C3=B6pel wrote:
>> Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> writes:
>>=20
>>> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>>>
>>> When the BPF selftests are cross-compiled, only the a host version of
>>> bpftool is built. This version of bpftool is used to generate various
>>> intermediates, e.g., skeletons.
>>>
>>> The test runners are also using bpftool. The Makefile will symlink
>>> bpftool from the selftest/bpf root, where the test runners will look
>>> for the tool:
>>>
>>>   | ...
>>>   | $(Q)ln -sf $(if $2,..,.)/tools/build/bpftool/bootstrap/bpftool \
>>>   |    $(OUTPUT)/$(if $2,$2/)bpftool
>>>
>>> There are two issues for cross-compilation builds:
>>>
>>>  1. There is no native (cross-compilation target) build of bpftool
>>>  2. The bootstrap variant of bpftool is never cross-compiled (by
>>>     design)
>>>
>>> Make sure that a native/cross-compiled version of bpftool is built,
>>> and if CROSS_COMPILE is set, symlink to the native/non-bootstrap
>>> version.
>>=20
>> ...and the grand master plan is to add BPF CI support for riscv64, where
>> this patch a prerequisite to [1]. I would suspect that other platforms
>> might benefit from cross-compilation builds as well.
>
> Similar use case. There also seems to be a lot of issues building these
> tests out of tree.
>
> I have some potential fixes up to 6.1 but linux-next seems to have
> introduced a few more issues on top.

Ah, yes. FWIW, the BPF CI builds the selftests *in-tree*, so with this
patch (and my PRs) the BPF CI is capable of cross-compiling.


Bj=C3=B6rn
