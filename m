Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C723453AB
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbhCWANa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:13:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230473AbhCWAMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B94A1619B6
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 00:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616458371;
        bh=ibxP5zDfP0TkJs2Ee1icHqmU6VKbjo5/lQBVOUSDdT4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J/iCtVhZ9ZNXoD3jRx5Uxe4n/uiKeuLrlLEMpk58g2M/HIjEPMJ001yfM+VpViskX
         +XNLY41Jkbp06QSq4F/dWEqOhVBAvSnSEm6yY1zFBOto7ceeX2zjOrGjZM8TxKZMm4
         JMWen4oDQwltTfxKm8lUn8fcC0cS3lkUGsk9+lq8Dp1J90RD2xTJtu3aPSyOCB9sSm
         DqI6BX3VClOVa490KIxfg80M09EeijbhhcT3hJhVOBGkkhhvh875huYBGyydYrkvS1
         pUFvbEFfcPs857yeF0k8mhKuZiBYARlrfMNErC6Q+Fv0jHFVo0IjWrM0tng+ae61Ig
         JrATbp7sf9myw==
Received: by mail-lj1-f173.google.com with SMTP id r20so23343448ljk.4
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 17:12:50 -0700 (PDT)
X-Gm-Message-State: AOAM532apGKvR8Yn/psbMTHwaSg3KECEQBZ5zPIERQ0w+62flV52UYZQ
        dcyYo9EfRTg+dJ1RGydBsSbfFu3e17y7hJmbQ2VddQ==
X-Google-Smtp-Source: ABdhPJyTWQjBsJRBm75XW+kB699yiYvgjrWxto3SuRfdIVITfc5vc7vvVcU/+ycxvrzp4T6ZflDs0HL16finwKKwnsE=
X-Received: by 2002:a2e:9b99:: with SMTP id z25mr1295319lji.103.1616458368851;
 Mon, 22 Mar 2021 17:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210322215201.1097281-1-arnd@kernel.org>
In-Reply-To: <20210322215201.1097281-1-arnd@kernel.org>
From:   KP Singh <kpsingh@kernel.org>
Date:   Tue, 23 Mar 2021 01:12:38 +0100
X-Gmail-Original-Message-ID: <CACYkzJ4KzWbBmCp-ar-amezqUngaoszNLUnPYDc=dXD9VtQBsg@mail.gmail.com>
Message-ID: <CACYkzJ4KzWbBmCp-ar-amezqUngaoszNLUnPYDc=dXD9VtQBsg@mail.gmail.com>
Subject: Re: [PATCH] bpf: avoid old-style declaration warnings
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@chromium.org>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Mikko Ylinen <mikko.ylinen@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 10:52 PM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> gcc -Wextra wants type modifiers in the normal order:
>
> kernel/bpf/bpf_lsm.c:70:1: error: 'static' is not at beginning of declaration [-Werror=old-style-declaration]
>    70 | const static struct bpf_func_proto bpf_bprm_opts_set_proto = {
>       | ^~~~~
> kernel/bpf/bpf_lsm.c:91:1: error: 'static' is not at beginning of declaration [-Werror=old-style-declaration]
>    91 | const static struct bpf_func_proto bpf_ima_inode_hash_proto = {
>       | ^~~~~
>
> Fixes: 3f6719c7b62f ("bpf: Add bpf_bprm_opts_set helper")
> Fixes: 27672f0d280a ("bpf: Add a BPF helper for getting the IMA hash of an inode")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thanks for fixing!

Acked-by: KP Singh <kpsingh@kernel.org>
