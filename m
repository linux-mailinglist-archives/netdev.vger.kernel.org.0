Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C392D52DE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 05:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731916AbgLJEfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 23:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731718AbgLJEfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 23:35:00 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA51C0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 20:34:20 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id 11so3710999oty.9
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 20:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YuCTFAaAxreWABeq+DhtSFvJAhBFMMBZ+mON2QcqSSo=;
        b=qAzQ7gdebTOgmorjS0OdJDMYeBFTqrptleLgMenA4ELOk+aOadWzS8JGe3KlP9gp5G
         HzX1zbunhb5LNLzOgUE9KEhwOaeCWt5fExbrrwKHvaHcP1OVsW5LJFpmabRJ6cpP1hdK
         i8f4j+DrUWHo0fdnNjJhqoIk8JAPKhFMOYjLBLKfDiGgw7ZBTzj+gmxL/hOEtOm3NVcc
         eZIwePq2yK4DE+9NAtI7zxoUxesDD3abOG6H9pwHeNhXsdjLBNpHDWS2FdbYsv7qacpE
         ol8HkDXqzrnTWtODywegRIi1zlJ4LqTb6Dv/oijxTwDMo8d1mj1ohTGv03sFOPSEYop9
         oDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YuCTFAaAxreWABeq+DhtSFvJAhBFMMBZ+mON2QcqSSo=;
        b=AhGIciDuf/ao8Tp+Ht01uU8GWuJ3hSD2UZUUFp2XwdTcG/bPduiky6tgharbv3/vaE
         lZ89cyWIjF4AANjiN9S/4pKtT+oiSvHXOMaLFOQCkjz6eYPL8FpUKxuUFrprT87iwFCg
         aFEUW3TkP2x21tF6gyTj8VpgUhFwbVGPj0Vad95Tv9cRdFGOq+AVROXeYPfJEnjjKy5S
         SjanxUUCB3TJXm6ihZ6jV4HeLtDXJxFvmviqKt06wuR/BZNcJZH55gQXQClBIMSI6sR+
         2SktocSYmF9VDveoFj76HRrFEsxtyVh7TXhhA7bI8noBkGTHIabAYJzf2IhSCDqqYSqe
         tCLw==
X-Gm-Message-State: AOAM531OCFKUQA05TKKQMWpi2jo7Wzex0McjeKTEmFDz07MJopsf3s+p
        bbZmqiyhMy+gMqreMtjxJmVgXTiL+XnpqhkElRo=
X-Google-Smtp-Source: ABdhPJw7eCCbxiN8bXDsezuk6u34Hnv9DzcE+beU+JF5wjqGrVMZ2/MrcVNLJnEKlmjQp+Kj/OEZv5G2HjER+MGfJGQ=
X-Received: by 2002:a05:6830:784:: with SMTP id w4mr4592614ots.53.1607574859826;
 Wed, 09 Dec 2020 20:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20201209050315.5864-1-yanjun.zhu@intel.com> <f68c2d75-4a51-445d-cecf-894b65cb8d55@iogearbox.net>
 <CAD=hENc8CmxdPeWbQ=4GFdtQCoCqUc87xS5sq+VePZEGC2-Z6g@mail.gmail.com> <87a6unp8ck.fsf@toke.dk>
In-Reply-To: <87a6unp8ck.fsf@toke.dk>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Thu, 10 Dec 2020 12:34:08 +0800
Message-ID: <CAD=hENc-VK2fKeQ108nYSDZ3B0s-tDBXLoc--bfSMndsOqEUqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] xdp: avoid calling kfree twice
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Zhu Yanjun <yanjun.zhu@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        netdev <netdev@vger.kernel.org>, jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 6:44 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Zhu Yanjun <zyjzyj2000@gmail.com> writes:
>
> > On Wed, Dec 9, 2020 at 1:12 AM Daniel Borkmann <daniel@iogearbox.net> w=
rote:
> >>
> >> On 12/9/20 6:03 AM, Zhu Yanjun wrote:
> >> > In the function xdp_umem_pin_pages, if npgs !=3D umem->npgs and
> >> > npgs >=3D 0, the function xdp_umem_unpin_pages is called. In this
> >> > function, kfree is called to handle umem->pgs, and then in the
> >> > function xdp_umem_pin_pages, kfree is called again to handle
> >> > umem->pgs. Eventually, umem->pgs is freed twice.
> >> >
> >> > Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >> > Signed-off-by: Zhu Yanjun <yanjun.zhu@intel.com>
> >>
> >> Please also fix up the commit log according to Bjorn's prior feedback =
[0].
> >> If it's just a cleanup, it should state so, the commit message right n=
ow
> >> makes it sound like an actual double free bug.
> >
> > The umem->pgs is actually freed twice. Since umem->pgs is set to NULL
> > after the first kfree,
> > the second kfree would not trigger call trace.
> > IMO, the commit log is very clear about this.
>
> Yes, it is very clear; and also wrong. As someone already pointed out,
> passing a NULL pointer to kfree() doesn't actually lead to a double
> free:

In your commit, does "double free" mean the call trace bug? If so, I
will correct it in my commit log.
In my commit log, I just mean that kfree is called twice. And the
second kfree is meaningless. And since NULL
is passed to it, this will not trigger "double free" CallTrace.

I will send the latest version soon.

Zhu Yanjun
>
> https://elixir.bootlin.com/linux/latest/source/mm/slub.c#L4106
>
> -Toke
>
