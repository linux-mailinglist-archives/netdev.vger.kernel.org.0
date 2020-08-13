Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587912431F2
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 03:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHMBJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 21:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgHMBJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 21:09:09 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63EC3C061383;
        Wed, 12 Aug 2020 18:09:09 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v12so4305578ljc.10;
        Wed, 12 Aug 2020 18:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=r99e4fgx1qPr7K6tkmxzVrj7pntaKTgmbE6RKbCCUXM=;
        b=umBqOlR83D9PJQMUEy369oLCGZieRkeZXLVbeRozfGKdpXH24SmMsUeALbLeyLcp6H
         nYhALgzhdgyke3pyzoHUEpNhPgkpnJyr2BL/F2Mi8sUplVeQOqIfJjpKXJdvjczMErP3
         0c4Q8lClBHp8q4FMgBf0JBUokVtl9n5KFLpwH5D6QRvZuTgxzPwzGeXJMN1RA6Tf1o30
         S812bczj14gSEWKYgMSz3U+3U5sjFlE/aSx9m8sIgMdo5KX8NRGFsKtXMsKj9pJRgd3h
         ueN9xMSyGWqXmkADdD1efX9jomJBij4DDEkG7WK5ZHG9OVGOZPHVy/a4O7ENpX15w7H5
         5F8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=r99e4fgx1qPr7K6tkmxzVrj7pntaKTgmbE6RKbCCUXM=;
        b=l8tyP+1MetGpyqAdnSG+F7TEQUI1ouTwXa0X0eFutFzo4JyqgqXB74ebES/mzhOXBH
         irXddaqeAAm9WmEYK4MTT3YqyJ+IrBZvQ+PRdNrBtT575qGCfM71s4YfLoBO9JnZWfVq
         79szWE1pX9Glut25me4m+gdHwL10q6JqApwD6z/jnPryFY7tf+U6sl2WtHspevWqm3sR
         kvZTHlzjvB0J0IVw7monndmtM2IjfraTSjtMoaQSCSpbsBZor/lAvt0Yho61R3RK7Xu3
         Hn2AMFplEV75Eg4W32iPHS+9IugU/dG01papKxcoTGA95QAUIgnhsNBzCJzsAXQf2K/0
         5GbA==
X-Gm-Message-State: AOAM530+LsuvJq+gcXq03HfMre7ILu89Il5vcY9D/H/L6rjq37T5odKg
        OwF8JfUaRO8tx0vvzn4cjJJykUrvYRWddUCjte4=
X-Google-Smtp-Source: ABdhPJz8U18qpvkxwr0EKPQZINKnRrFQvl08GZPWqfItXj9lmhmUMGNDPjH1j3NWaH7rs+uTV20W/ofwQPX1RI1Ajz4=
X-Received: by 2002:a2e:a17b:: with SMTP id u27mr846869ljl.2.1597280947619;
 Wed, 12 Aug 2020 18:09:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200812022923.1217922-1-andriin@fb.com> <87imdo1ajl.fsf@toke.dk> <CAKH8qBuz48Ww6S=DCzKRr3f46Eq3LyknvTjDGP_5QRPxtGZ_Hw@mail.gmail.com>
In-Reply-To: <CAKH8qBuz48Ww6S=DCzKRr3f46Eq3LyknvTjDGP_5QRPxtGZ_Hw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 12 Aug 2020 18:08:56 -0700
Message-ID: <CAADnVQLNi=r+H0+kc3BmN8GtRK-3f2h0+ssHSbSMMeh3Dsc_Kg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix XDP FD-based attach/detach logic around XDP_FLAGS_UPDATE_IF_NOEXIST
To:     Stanislav Fomichev <sdf@google.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 12, 2020 at 8:48 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> On Wed, Aug 12, 2020 at 2:24 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > Andrii Nakryiko <andriin@fb.com> writes:
> >
> > > Enforce XDP_FLAGS_UPDATE_IF_NOEXIST only if new BPF program to be att=
ached is
> > > non-NULL (i.e., we are not detaching a BPF program).
> > >
> > > Reported-by: Stanislav Fomichev <sdf@google.com>
> > > Fixes: d4baa9368a5e ("bpf, xdp: Extract common XDP program attachment=
 logic")
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> That fixed it for me, thank you!
>
> Tested-by: Stanislav Fomichev <sdf@google.com>

Applied. Thanks
