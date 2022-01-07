Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F596487C75
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 19:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiAGSv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 13:51:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiAGSv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 13:51:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2128BC061574;
        Fri,  7 Jan 2022 10:51:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4F1B61F60;
        Fri,  7 Jan 2022 18:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A78EC36AEF;
        Fri,  7 Jan 2022 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641581518;
        bh=VC42HmZeAm565z2JaDi81GUTXInUDnQH6O8dfuXC23M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GyTAHfCapdDkce4Cm4/fM1otNHhtKFegAjYpegu3hp9YKi7xS6LZ7J6f9NLUcMYYZ
         /j6MkEcRtBgf19flOEotXxzjRN8VySn7KhaEfGTQgIw9bhm7eVxvk2nrx0ztblN9sd
         LsHieHPVei3mvf4MOQ4GFQvkYC8O0sdDmOlxEP+7a0OKM2SHrie3XyzOKl+IozIfhX
         jiobwzzE8HklEFzbGUlMltsc2tQNqAVyl+77DwwuAf88vNxv+6wwBRmwlGYnQv4Gjp
         f24IErHplDPq8QwZw5B/g4eCMlLm/qPVv1V70nzLNZycmjfm6dJvzLcK6TkvLvBCVH
         zbFFMptYZR+Eg==
Received: by mail-yb1-f169.google.com with SMTP id c6so17257627ybk.3;
        Fri, 07 Jan 2022 10:51:58 -0800 (PST)
X-Gm-Message-State: AOAM530JRIroK52LzzpWrWijPpLC8lkmNyUK/q+MbTjf2x6JmzLdXeve
        n+2Eiy0wfkUnxG4ZmOvF6MdnI7Qp6b5EBigRogM=
X-Google-Smtp-Source: ABdhPJzxOhjqBFaCxuGyDDeN84E+5W6O4yaUYFeDhsxidy0v5B+nspI4jqOvF4gUGU2UUThlfu/kphBWMg1fQMBZvVI=
X-Received: by 2002:a25:8b85:: with SMTP id j5mr74750303ybl.558.1641581517327;
 Fri, 07 Jan 2022 10:51:57 -0800 (PST)
MIME-Version: 1.0
References: <20220107152620.192327-1-mauricio@kinvolk.io> <20220107152620.192327-2-mauricio@kinvolk.io>
In-Reply-To: <20220107152620.192327-2-mauricio@kinvolk.io>
From:   Song Liu <song@kernel.org>
Date:   Fri, 7 Jan 2022 10:51:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5rmuGqN5LYzjQ6fTv0nsyGeMLqv8-4RsSZU-x62Vr-UQ@mail.gmail.com>
Message-ID: <CAPhsuW5rmuGqN5LYzjQ6fTv0nsyGeMLqv8-4RsSZU-x62Vr-UQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/2] bpftool: Fix error check when calling hashmap__new()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 7:26 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>
> hashmap__new() encodes errors with ERR_PTR(), hence it's not valid to
> check the returned pointer against NULL and IS_ERR() has to be used
> instead.
>
> libbpf_get_error() can't be used in this case as hashmap__new() is not
> part of the public libbpf API and it'll continue using ERR_PTR() after
> libbpf 1.0.
>
> Fixes: 8f184732b60b ("bpftool: Switch to libbpf's hashmap for pinned path=
s of BPF objects")
> Fixes: 2828d0d75b73 ("bpftool: Switch to libbpf's hashmap for programs/ma=
ps in BTF listing")
> Fixes: d6699f8e0f83 ("bpftool: Switch to libbpf's hashmap for PIDs/names =
references")
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>

Acked-by: Song Liu <songliubraving@fb.com>
