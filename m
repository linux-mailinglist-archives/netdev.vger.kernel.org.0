Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADBA16D85D9
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbjDESTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjDEST3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:19:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4E95FD4;
        Wed,  5 Apr 2023 11:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 482D1628B6;
        Wed,  5 Apr 2023 18:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D83C4339E;
        Wed,  5 Apr 2023 18:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680718767;
        bh=ltcRjzdGmjNXGEWJl/BooIeS7nLENBrFKJLG6Y5huOs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rof4iplmdm6LS8gZFFtPkv+WWg2r511NloWG9UpdytcmLlTi9ZWefU/bSNuGeYWhP
         UkKnK68QxnLTpdk8BsDhiKrbG61FNCu1eu5Ke/zVi68dMpjKBPNAqoetCnADJJypzr
         tuHVZ2y56ppzCVWUHteUx48D1b8bE8iyB4rzgxugQSbVHjZAuBSHfViAUC51BW9zpk
         pd8m44EmC2A7LFQtS44voYcoolYADQii7YALs3R5A6tUyspVrjqZMqJHLHVIKi3R+7
         GPBe09IgRPYKlHn9jWoG7AV3jYXJobyRgvTNaRdnqMStqOBgWEGEKFSmPKczH5k6kL
         G8uXYybArQBJg==
Date:   Wed, 5 Apr 2023 11:19:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the
 verifier.
Message-ID: <20230405111926.7930dbcc@kernel.org>
In-Reply-To: <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
        <20230404145131.GB3896@maniforge>
        <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
        <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
        <20230404185147.17bf217a@kernel.org>
        <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 10:22:16 -0700 Andrii Nakryiko wrote:
> So I'm exclusively using `pw-apply -c <patchworks-url>` to apply
> everything locally.

I think you can throw -M after -c $url? It can only help... :)

> I'd expect that at this time the script would
> detect any Acked-by replies on *cover letter patch*, and apply them
> across all patches in the series. Such that we (humans) can look at
> them, fix them, add them, etc. Doing something like this in git hook
> seems unnecessary?

Maybe mb2q can do it, IDK. I don't use the mb2q thing.
I don't think git has a way of doing git am and insert these tags if
they don't exist, in a single command.

> So I think the only thing that's missing is the code that would fetch
> all replies on the cover letter "patch" (e.g., like on [0]) and just
> apply it across everything. We must be doing something like this for
> acks on individual patches, so I imagine we are not far off to make
> this work, but I haven't looked at pw-apply carefully enough to know
> for sure.

The individual patches are handled by patchwork.

Don't get me wrong, I'm not disagreeing with you. Just trying to help
and point out existing workarounds..
