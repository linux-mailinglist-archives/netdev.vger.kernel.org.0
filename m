Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5EEF5793
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfKHT1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:27:14 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:42833 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730649AbfKHT1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:27:13 -0500
Received: by mail-qt1-f194.google.com with SMTP id t20so7698830qtn.9;
        Fri, 08 Nov 2019 11:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bx4/nJP8jQ7cX3XnfK6fNYAYA7WHBCX82wHsa/B8TTg=;
        b=ndFL8t3+s5eU+2qKQ/7BmP5WWW3wDPXzbUjUCur9zt2a8craFiCEXtuQyflQ6e/LrJ
         iduF/CIp0pZS+fUTNv70NIK6GKvPCKSD2mIGwJcUsD4mcvUw4ZfED4TfdgiAsSPuaAd7
         mp8WBj6vuRK5ZiyO2IgWB6YZLUgTpUVCspUysPDVsgIiR0/BnU8fd26IP4tu6qJncKPL
         dav+NSjcbSszIfihgpVIu9thUzR7tB5eAdTknuS9cKoLhylyL4Mtz2eNUcAOW+E9Fcpl
         vOkiWUq4vJDkvW1vSpVqyxq9T5MkVnCKatxPnjgmmsEGN+B7c/zDjZcydGh97FlHJZ5k
         gdwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bx4/nJP8jQ7cX3XnfK6fNYAYA7WHBCX82wHsa/B8TTg=;
        b=Q4x4bzTbZi6BGFFKMdM+0zdGLI8GNqR2cHpel6HXdqc/jEbyYoOHKySX6O2S23EkFz
         1aXHfrktKRHql7shyGnEMvjTO1GnI2v6IV8EssE6S+P0s1iECx8rIVGXKdc7P2Y8iADH
         DB+uDpUUJzU37IG9FCFdLts4zXcK9Te4yvWg2mU+xBLEPkRDuOhfyovIvb/uyzDVlQpQ
         NVH65lKp3zJmZTu2RPLvyEOI31Jx1hmxxsEDv7jeCR0GrYaPvzqxqV8+SO7DGnIw8DzB
         8x0agLppCg2fuep3sZi7ZjWdn1s98OctiUruRJVTbfPbP7rM4kARLhp+rQ2uFNgDpBsk
         Q98w==
X-Gm-Message-State: APjAAAWDdXviSBg6s4GL8KGgY8wwNG4uVk8pmFxWg48A6HsMOl1fgDX4
        XNV9g6RVfhs+obFCmInEiMv9mHrbzuuDM1KatrE=
X-Google-Smtp-Source: APXvYqx9EIe0ePIH0fdEw8fJzJInxVIZbLJZNOPWX18k2EhnO53NL+jUJ16hy8CU8ZUecvn3THpPHyPC5VLOEa04hTI=
X-Received: by 2002:ac8:2f45:: with SMTP id k5mr12316187qta.183.1573241232005;
 Fri, 08 Nov 2019 11:27:12 -0800 (PST)
MIME-Version: 1.0
References: <157314553801.693412.15522462897300280861.stgit@toke.dk> <157314553913.693412.16341111239421040141.stgit@toke.dk>
In-Reply-To: <157314553913.693412.16341111239421040141.stgit@toke.dk>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 8 Nov 2019 11:27:00 -0800
Message-ID: <CAPhsuW5yr1EX8r3iRT_Hb8+hnz1MJzW=rc__FoP1-A5+K4Pb2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] libbpf: Unpin auto-pinned maps if loading fails
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 8:52 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Since the automatic map-pinning happens during load, it will leave pinned
> maps around if the load fails at a later stage. Fix this by unpinning any
> pinned maps on cleanup. To avoid unpinning pinned maps that were reused
> rather than newly pinned, add a new boolean property on struct bpf_map to
> keep track of whether that map was reused or not; and only unpin those ma=
ps
> that were not reused.
>
> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF o=
bjects")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>
