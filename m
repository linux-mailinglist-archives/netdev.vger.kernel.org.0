Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8670CEB653
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 18:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbfJaRnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 13:43:49 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41810 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbfJaRns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 13:43:48 -0400
Received: by mail-qk1-f194.google.com with SMTP id m125so7865971qkd.8;
        Thu, 31 Oct 2019 10:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u8oevFSkFa644ahK7KMD169VA8J9aujIwgv9sqolFwY=;
        b=SpUWcPHzQBnSzNDN2NMkT5dCbazUFcOZzisSQhIFX/HyML/hCtqgQgxgItDCRlkliw
         HQvcaRN18hvsLMFodlxXrw/b7qYKYQJf5WZz72aWocAabuSB9FCqdxouTC4IcwdsJIu1
         UCncNX4Qq80yu3BQwwaG+/6YuDPLiEs13eBnQG1DQBTeAt52ibYbCLnrmUkC5c/S2Anq
         NVNg3qZqWP5nq95RKnq760b/F0SZu+i9CqzNiQTT9d6V4ZfX0ZfZsQFx9UwSb+K7SILM
         MJFJ4YAiIFjw0uIQ63TvV9nrlM/sdvq3WKpXzOY0x/FJSMeLecgjYTYuI8ZAZEI0X/q9
         TDvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u8oevFSkFa644ahK7KMD169VA8J9aujIwgv9sqolFwY=;
        b=jhQL17GFczbgl4i3QyAhO6HEsOfrVvqmf8VzpvQoxvtE0cDgcZzJ1omMNMMIOYu5G/
         O5thE/Z6Rn5P0XlOktJtpEBmjA7eDG5NGsiVibBspAEWd4yDufzrEAVE2VdTDIp/LiEm
         fqZw9Qp+OvpX+5MeAuyKSEP9UkR52AhxD56G6y3kwAaAQTtlh7OrLXPcbbrEBAkXfs7M
         6aLlKzTj7/XetS9iaYIS3ZOds8SUj4+ZfyQ65MPwTRUPlBodd1YrD0ebmpuUo+Z9EafD
         7GVXXilligC0bxzwQt30O5Mn8k8DMBm78ojUp2+9hzrYOI+NIRos/acFeUCylmTIswir
         eA6A==
X-Gm-Message-State: APjAAAVRTclsyAmxL6jJ6DxvzPDVXG+SwAYX3rPQoCjco16bQVY1BqIl
        r3A68jXokSgELNrkwpiE8iMaF7/A1ilimBRwfJI=
X-Google-Smtp-Source: APXvYqxNynYFdnrO16j//tOAgyfq0Hxp0Uia96Yq1TZDzXAYtnQO5tyM1xkkpHikOJQqcT3uoL4X2qumTTOp2k8965U=
X-Received: by 2002:a37:4c13:: with SMTP id z19mr1617922qka.449.1572543827485;
 Thu, 31 Oct 2019 10:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <157237796219.169521.2129132883251452764.stgit@toke.dk>
 <157237796448.169521.1399805620810530569.stgit@toke.dk> <CAEf4BzZ4pRLhwX+5Hh1jKsEhBAkrZbC14rBgAVgUt1gf3qJ+KQ@mail.gmail.com>
 <8736f8om96.fsf@toke.dk>
In-Reply-To: <8736f8om96.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 31 Oct 2019 10:43:36 -0700
Message-ID: <CAEf4BzazkT7zUbXydSQJD7bk_0hAkb9SAAsM3bCeZb9Xzs=Zag@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/5] libbpf: Store map pin path and status in
 struct bpf_map
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 10:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > [...]
> >
> >>
> >>         return err;
> >> @@ -4131,17 +4205,24 @@ int bpf_object__unpin_maps(struct bpf_object *=
obj, const char *path)
> >>                 return -ENOENT;
> >>
> >>         bpf_object__for_each_map(map, obj) {
> >> +               char *pin_path =3D NULL;
> >>                 char buf[PATH_MAX];
> >
> > you can call buf as pin_path and get rid of extra pointer?
>
> The idea here is to end up with bpf_map__unpin(map, NULL) if path is
> unset. GCC complains if I reassign a static array pointer, so don't
> think I can actually get rid of this?

oh, right, it's nullable pointer, then you do need buf and pin_path,
never mind. I keep forgetting this NULL semantics for pin/unpin :)

>
> -Toke
