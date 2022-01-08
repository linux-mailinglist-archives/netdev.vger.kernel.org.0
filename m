Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF694880F6
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 03:44:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiAHCoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 21:44:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiAHCoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 21:44:17 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E271C061574;
        Fri,  7 Jan 2022 18:44:17 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p14so6433642plf.3;
        Fri, 07 Jan 2022 18:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LEduNzt4QRezuIgDbts+SGsDapK99Fx3fqZO8S2DoZg=;
        b=qcJ3nHXDwouNfJLB4t3A5R1xUKX6xRYMajK/+5LY1+4W0r9l4xrvdzoHav27iU3XQ2
         wgr+vuQ6LIIhUz+Ul77RkSUhmXMw1Bf+8Lglyky/VPBMhtmOUy3xY90kVQDLSP7S9J7O
         7hlg3if8D9KX3JTK+/YqH6vhcXawiUe6kVFT28tQA8tL+fOd2ttiXSaosCyYXlWLTxlE
         S+K7d6cNut41WXk0wTzPXM7juXJ1V36NSxuT9s0FzX0MMNM9AJYwKQU+aheM2ymITfg4
         fUBGvhDvAmc1eeCg90SWSEmICDP2L54tDE03/rUiM2qC3ZEemaPDUnSrXLtYBEoIbCT6
         H0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LEduNzt4QRezuIgDbts+SGsDapK99Fx3fqZO8S2DoZg=;
        b=PoHDBoPRVCa9hn1uyxLgc41G6Oz8tUavLu9CWHCL3PS5BmgvgDOZ61/hSNkqdUJLkX
         +0sOdsnraZCuOrckgacaSts3c8nvFnJ1KADGMBZqygDr3CssN5Lgadrgzf+/qr7O4xDN
         +TZyOSE/yCZT2jwDL/0h1PqKHwxCPzPNe8AeR9l/HQqsZoZL0pfw84tFk0kWKASVdE9v
         nQv9VqClCWBE3Hh4UzcFGOMEh9ZD2jiUTike53BJAZNB/fNQofZtnEVufq5oeCYJfsQf
         9S5D6Vuo++MGvng6nB53YRdgeyN6Zfk+XOgyZIdZfdppQlWvwRrsII0Hw44CAsREzqjg
         JruQ==
X-Gm-Message-State: AOAM533wf42HiGajsqLf/hnHkx4XQeUnWYFAoR61Ed7bNjZIdVd20N/d
        KyoOITum//KDE8Hx318wjSxEeS3DpIBoclynhpw=
X-Google-Smtp-Source: ABdhPJxW2FawKx8fQcRN/Py1Yl4CSqiDRDsIzKirYPd+ZS25dljjwGB6zQ6wVIeqMMxHygvPzFtIeYJJuKJF34BMQBI=
X-Received: by 2002:a17:90a:ba11:: with SMTP id s17mr18844012pjr.138.1641609856615;
 Fri, 07 Jan 2022 18:44:16 -0800 (PST)
MIME-Version: 1.0
References: <20220107215438.321922-1-toke@redhat.com> <20220107215438.321922-2-toke@redhat.com>
In-Reply-To: <20220107215438.321922-2-toke@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 7 Jan 2022 18:44:05 -0800
Message-ID: <CAADnVQ+uftgnRQa5nvG4FTJga_=_FMAGxuiPB3O=AFKfEdOg=A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 1/3] bpf: Add "live packet" mode for XDP in bpf_prog_run()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 7, 2022 at 1:54 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Because the data pages are recycled by the page pool, and the test runner
> doesn't re-initialise them for each run, subsequent invocations of the XD=
P
> program will see the packet data in the state it was after the last time =
it
> ran on that particular page. This means that an XDP program that modifies
> the packet before redirecting it has to be careful about which assumption=
s
> it makes about the packet content, but that is only an issue for the most
> naively written programs.

This is too vague and partially incorrect.
The bpf program can do bpf_xdp_adjust_meta() and otherwise change
packet boundaries. These effects will be seen by subsequent
XDP_PASS/TX/REDIRECT, but on the next iteration the boundaries
will get reset to the original values.
So the test runner actually re-initializes some parts of the data,
but not the contents of the packet.
At least that's my understanding of the patch.
The users shouldn't need to dig into implementation to discover this.
Please document it.
The more I think about it the more I believe that it warrants
a little blurb in Documentation/bpf/ that describes what one can
do with this "xdp live mode".

Another question comes to mind:
What happens when a program modifies the packet?
Does it mean that the 2nd frame will see the modified data?
It will not, right?
It's the page pool size of packets that will be inited the same way
at the beginning. Which is NAPI_POLL_WEIGHT * 2 =3D=3D 128 packets.
Why this number?
Should it be configurable?
Then the user can say: init N packets with this one pattern
and the program will know that exactly N invocation will be
with the same data, but N+1 it will see the 1st packet again
that potentially was modified by the program.
Is it accurate?
