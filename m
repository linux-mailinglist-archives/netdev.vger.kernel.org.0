Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9041B1F52E8
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgFJLMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbgFJLMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 07:12:50 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5CA8C03E96B;
        Wed, 10 Jun 2020 04:12:49 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id t18so1791689wru.6;
        Wed, 10 Jun 2020 04:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bs7vLQrGmBJhWlXYf2rStBzvqd+01Bu4jF9rWSDJZQE=;
        b=uZ0FnnjHjW+r0mWKT0AVquXKDLRxlZpss3knp0cn295tlTshrnZHxCUxnoCpmtKtAe
         8Wgx8RDcyg5MueEtaZlLF9abq1AcG3A2fVz8eJffjPqlSD54vVEabirMbie7wvBZJ67D
         68o/wXxsCcNKx3aHvA0U5G9F+eH7hRf/6Gy4r6rzcnnOy0BrEA9wnQl+sYpPbIue4oeP
         JmOjdZZ4oWcKOflli6Sev13LPljI40Sxl8Q3LK6a01lkB0e7lar6ITl+cjZgWPShMnp3
         emGRTGI4Ho2tI7V3SegWswcQPBf7m8Haogrnif77od1sbCRyIphGDI4M5B1Zaiz2MlUA
         oTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bs7vLQrGmBJhWlXYf2rStBzvqd+01Bu4jF9rWSDJZQE=;
        b=c46W87ryZ2huGasMLjMFlNfRr4MVS3/VkA2+epEUEyELo60JTOS4N0Lhkc/Ss5ohO3
         9sm8EWfdDG+6I2qGD+Ytar+7MUU03boYxftPK8eZL7Mw+FSTRwVg42MwHag5l8AO69DM
         Sx6VPYlzHrd3QFeffOk+wjYVM5BgV6ER3nFmWC922Vcku8y0se3FEjuRIKgJKkR4eezA
         OQAN1wLjONCi3F7g+2OiLs4tIUczenOnZxo7oV9SzeYmcRXQLixOlPQRp4j6KAJx0Isf
         HsfCv36EZ9NbiPP51HXtpz1F39zEZ60IizckGghSziuLCuZhkNU+ioFsyOprR8cbvXXs
         hh/g==
X-Gm-Message-State: AOAM531oImGO03wsRx3ip+RjYIXCdyzL/8aWyCX1HIfkoK11mQd+JZEF
        hzUM8XQ/MkHVLe/Qk4CVbagp3iIfjzNneMx7PMcW3D0k
X-Google-Smtp-Source: ABdhPJxn1B2wdGMPUiV6zhyjh5npTgcxkHHcDniBnQfTz8qywlFFgMy/gV14YeXQGR11F3gyKOAYpzSPaRwNY4d8kbw=
X-Received: by 2002:a5d:610f:: with SMTP id v15mr3094406wrt.52.1591787568559;
 Wed, 10 Jun 2020 04:12:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200609172622.37990-1-bjorn.topel@gmail.com> <20200609172622.37990-3-bjorn.topel@gmail.com>
 <87r1uo81i5.fsf@toke.dk>
In-Reply-To: <87r1uo81i5.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 10 Jun 2020 13:12:37 +0200
Message-ID: <CAJ+HfNiuag3MQ94K__vWfpS5wqTtzSs839t_cKQTpw1k_QZeYQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/2] i40e: avoid xdp_do_redirect() call when
 "redirect_tail_call" is set
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jun 2020 at 21:47, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.=
com> wrote:
>
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > If an XDP program, where all the bpf_redirect_map() calls are tail
> > calls (as defined by the previous commit), the driver does not need to
> > explicitly call xdp_do_redirect().
> >
> > The driver checks the active XDP program, and notifies the BPF helper
> > indirectly via xdp_set_redirect_tailcall().
> >
> > This is just a naive, as-simple-as-possible implementation, calling
> > xdp_set_redirect_tailcall() for each packet.
>
> Do you really need the driver changes? The initial setup could be moved
> to bpf_prog_run_xdp(), and xdp_do_redirect() could be changed to an
> inline wrapper that just checks a flag and immediately returns 0 if the
> redirect action was already performed. Or am I missing some reason why
> this wouldn't work?
>

Indeed! That's a good idea!


Bj=C3=B6rn

> -Toke
>
