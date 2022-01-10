Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C317E48A2AB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 23:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345377AbiAJWWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 17:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345367AbiAJWWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 17:22:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE29C061751;
        Mon, 10 Jan 2022 14:22:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01D77B8180E;
        Mon, 10 Jan 2022 22:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956F2C36AEF;
        Mon, 10 Jan 2022 22:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641853327;
        bh=nZkaYKHFOdV7Q8Fp1n6WNBX4Yk9/H6nzbskM4qlf/e0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NY7FymS14WUzj4avmFazuFYRl/oGGUdTlb8lyrAZnnR0NTHtakr7wULLh4+mu1rRc
         E/Hxc5PfXx6YYMfO86+C9Y999/jjRQ1bBzDZSX2cZDkPaHe0zC2NlYce28rNldBEnM
         HUjg6DXge6gYWK6A7o8aNRXUsi5cDyVB9ovT0uG/iLMGOHHEoEMtH3fcR/x5gBlkAE
         3mVJsRxRMMXnEcrEesZkW5IagVomgfwZwbGuUmU89cV0m2XX7OsStiCM7kAeH/fjUV
         U1SI2VwytyjVvR+wjz3c1XHo48sScyfi2sTPHx/7OCcIPDj627MxDsvOS0rUG4Xupw
         Rbi2NRk7S4lSg==
Received: by mail-yb1-f173.google.com with SMTP id d1so42100186ybh.6;
        Mon, 10 Jan 2022 14:22:07 -0800 (PST)
X-Gm-Message-State: AOAM532xPMX9mSXg4VuLCRml4STKeNzcyMWskuKkxysvdY/EkLG5Zpp8
        gwSoCovumv6DTA2NQanftJLnE5PYQGg+wVcq5rM=
X-Google-Smtp-Source: ABdhPJwZH/DyO8E3u0XvP1BAo0vaLRN2AtOZrD/fa3LqP03NFGEPKRurGXJDM2jxiq3cLt7HnKX4H6nKCFqomMgn5wU=
X-Received: by 2002:a25:8b85:: with SMTP id j5mr2297231ybl.558.1641853326749;
 Mon, 10 Jan 2022 14:22:06 -0800 (PST)
MIME-Version: 1.0
References: <20220108051121.28632-1-yichun@openresty.com>
In-Reply-To: <20220108051121.28632-1-yichun@openresty.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 10 Jan 2022 14:21:55 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5+zCh2ZE6zUq2T=83Z6Ce93z_ojxrqGN9iYN9Qvyq_YQ@mail.gmail.com>
Message-ID: <CAPhsuW5+zCh2ZE6zUq2T=83Z6Ce93z_ojxrqGN9iYN9Qvyq_YQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: core: Fix the call ins's offset s32 -> s16 truncation
To:     "Yichun Zhang (agentzh)" <yichun@openresty.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 9:11 PM Yichun Zhang (agentzh)
<yichun@openresty.com> wrote:
>
> The BPF interpreter always truncates the BPF CALL instruction's 32-bit
> jump offset to 16-bit. Large BPF programs run by the interpreter often
> hit this issue and result in weird behaviors when jumping to the wrong
> destination instructions.
>
> The BPF JIT compiler does not have this bug.
>
> Fixes: 1ea47e01ad6ea ("bpf: add support for bpf_call to interpreter")
> Signed-off-by: Yichun Zhang (agentzh) <yichun@openresty.com>

Acked-by: Song Liu <songliubraving@fb.com>
