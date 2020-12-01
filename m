Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F67E2C93CA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730920AbgLAATT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730866AbgLAATT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:19:19 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC3DC0613CF;
        Mon, 30 Nov 2020 16:18:38 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id o71so214626ybc.2;
        Mon, 30 Nov 2020 16:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TVrEVqt/8ABsHBtv0Fp/W/KXpGc70umzdJ6FtxyY6EQ=;
        b=bBDiPJYS+JPOZ4/6wQzzaFPhVd3ywta5QKS1jDowPE/cRtLznV6HC1K/50tlOZWZs1
         RpNd0mxZ+tGs1xabduJi2FjnFcNNhgdZh7gFzl/I2z0bbxh5RvB196Y9FmWc0TK0R2P5
         rb6FkLA3VBY0xYviBumFiemHRtQE9dTjxyK1O7/H3Wu0Pgf5sy6OsYcdo2GISacYaQnj
         Wx7WgUgXcp59o1URHh708TgyWX/tPm0q3EXeKzSSO2Grh68ZR4Vn1MT7C0e6A407Fhy9
         CwYlo18F6zrDl7Up35wzSyIC6bn9uahrX7dp/MVHK7BjG4mYvLgLkLzgjZIFtDJ8LGH6
         qQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TVrEVqt/8ABsHBtv0Fp/W/KXpGc70umzdJ6FtxyY6EQ=;
        b=n9RvnqhmxLDgUzze4D+yCY8+QRKJEkQ4hKrwQCgHdPWLdbpd/QtWTw7IpXJeY5Owve
         9R2fgmCWesEv9z3/z+fAFx2MNIiUgLgtG4uKAFJfsqs9J5MiClR9CvWD9ZimrXQtSXSH
         eSeJtloeSlRnKg+a7+nL/qrAk5RWHGcsfwZ/RJ7aSdloM0SCJwYYgtUDaJhAI68rAx+S
         KEiE3yWJbr8ZXjBg0eXu3QjVVHidiGapCg+ZA+3h5EEPUvNMiG+7XQhRtR06TnI7+gf+
         nvnJSScIQ4CRBgLQoU1P9Kd6VFjevWT9ETECJIad6woNi/TLpLJn0kc5e6h79T28JyU+
         1toA==
X-Gm-Message-State: AOAM533E8J+Jx0i/sbdiktaRsCs0p+lhk0ehTpc4lLCVeaVKqRDJEAe8
        fSx7+fk0I7mwf+B/D2oOlOWzA1IeBl+DY8DYkp4=
X-Google-Smtp-Source: ABdhPJyiin5FC2vyv5AH20qeRrdSteNjE7sy9nMnEoy5XokXVvfJhpOCGWGfPX8+F4tsx2PyHffH+oKZY6D1WZq3prI=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr13028ybd.27.1606781918010;
 Mon, 30 Nov 2020 16:18:38 -0800 (PST)
MIME-Version: 1.0
References: <20201130154143.292882-1-toke@redhat.com> <CAEf4BzZy0Y1hAwOpY=Azod3bSqUKfGNwycGS7s=-DQvTWd8ThA@mail.gmail.com>
 <87pn3uwjrd.fsf@toke.dk>
In-Reply-To: <87pn3uwjrd.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Nov 2020 16:18:27 -0800
Message-ID: <CAEf4BzavUADiak9FboiThRC2W_agJXXh3dGm7zKqDNJ+dUFnHA@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: reset errno after probing kernel features
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 2:41 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Mon, Nov 30, 2020 at 7:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> The kernel feature probing results in 'errno' being set if the probing
> >> fails (as is often the case). This can stick around and leak to the ca=
ller,
> >> which can lead to confusion later. So let's make sure we always reset =
errno
> >> after calling a probe function.
> >
> > What specifically is the problem and what sort of confusion we are
> > talking about here? You are not supposed to check errno, unless the
> > function returned -1 or other error result.
> >
> > In some cases, you have to reset errno manually just to avoid
> > confusion (see how strtol() is used, as an example).
> >
> > I.e., I don't see the problem here, any printf() technically can set
> > errno to <0, we don't reset errno after each printf call though,
> > right?
>
> Well yeah, technically things work fine in the common case. But this

It works fine in all cases. Assuming "errno !=3D 0 means last
libc/syscall failed" is just wrong.

> errno thing sent me on quite the wild goose chase when trying to find
> the root cause of the pinning issue I also sent a patch for...
>
> So since reseting errno doesn't hurt either I figured I'd save others
> ending up in similar trouble. If it's not to your taste feel free to
> just drop the patch :)

Yep, let's just drop it, no need to create a bad precedent.

>
> -Toke
>
