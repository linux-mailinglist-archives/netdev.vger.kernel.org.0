Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35C92D39A4
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 05:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgLIEbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 23:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726719AbgLIEbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 23:31:47 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1974FC0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 20:31:07 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id 11so145203oty.9
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 20:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iqBjcqI2WOG4syDz8oqXuqy9srMSRb2XldywIL844L4=;
        b=qNwl431uKeQdUA5TFYsyHzck4nLR3fnHIUGkyLe/5HZhJ6biJ229RhwDjONoqitMEG
         Rn5MKqbCaxxcCREhVhlBPX6cgoop5iiEiSuDc2SEOCwvm/vc9h0Q4nF61K5WQ8lGWPzX
         zMnjUOr9tIOh5Y8IOniuqC0ApakFBDOFejlVgEsDkmMT9cStx+aIxw6iJfa3F1Yppm8I
         9p4S61frQvt086TIyQ8DTyDBsrytPqr3U5e23VuQGRTmwOCycL0YNvvnYM47TlG+9Lch
         9/wHmtp2NTf9XZS6bIu5TCSa9g3eUYtU95uCvkyvVxqzhdwXKFO1rJBUvhTmTCN72TkR
         1unA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iqBjcqI2WOG4syDz8oqXuqy9srMSRb2XldywIL844L4=;
        b=jCfSIGhkbcNzFWRWsSsI75lAjNxCdWuRDs6BLdtq6ci9MK5fH9K1aq920iz58ljYoj
         GlWkDw1P2syPqVBcAx00YfeIJkpuCZqzOzaqpo0Vf57SNUMOPvGrDZBd4H5dc1mYnmXi
         4fC8CIZITE008cnOyrtimCNIiEcouX4oePQlXnc7kH8pBpXThQzP4R5A1zQRVP88isj4
         G5q2BLetb0kWixFBM22HVC/yw7XjXDKm3uAtKkRxZPzLzf3IkC9UMXvnz9FHSYNkURlQ
         iUWYtipUqHUAVwG+qXtOrkTDj+dKORPjGaBUlDrLec/pPqESBO31Z7I5mv51HMt7RYv/
         QJkA==
X-Gm-Message-State: AOAM532o88VuEfaNsSRgPxckNXQKv9CPaYLiXvOle8uFuJF7c9AviDB1
        1JnQBUghU2yTqd/HPY0AV9eIqpxUsVw5GxrUNFw=
X-Google-Smtp-Source: ABdhPJxDElS8POZBOzRrY7ivHFPZd4G3wNoADYKzJnLmu+F6CrUjjKorpozC74WM34/BKcty6Y79oJa2IP/h6aAfnfQ=
X-Received: by 2002:a9d:27a7:: with SMTP id c36mr308280otb.59.1607488266532;
 Tue, 08 Dec 2020 20:31:06 -0800 (PST)
MIME-Version: 1.0
References: <20201209050315.5864-1-yanjun.zhu@intel.com> <f68c2d75-4a51-445d-cecf-894b65cb8d55@iogearbox.net>
In-Reply-To: <f68c2d75-4a51-445d-cecf-894b65cb8d55@iogearbox.net>
From:   Zhu Yanjun <zyjzyj2000@gmail.com>
Date:   Wed, 9 Dec 2020 12:30:55 +0800
Message-ID: <CAD=hENc8CmxdPeWbQ=4GFdtQCoCqUc87xS5sq+VePZEGC2-Z6g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] xdp: avoid calling kfree twice
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Zhu Yanjun <yanjun.zhu@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        netdev <netdev@vger.kernel.org>, jonathan.lemon@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 1:12 AM Daniel Borkmann <daniel@iogearbox.net> wrote=
:
>
> On 12/9/20 6:03 AM, Zhu Yanjun wrote:
> > In the function xdp_umem_pin_pages, if npgs !=3D umem->npgs and
> > npgs >=3D 0, the function xdp_umem_unpin_pages is called. In this
> > function, kfree is called to handle umem->pgs, and then in the
> > function xdp_umem_pin_pages, kfree is called again to handle
> > umem->pgs. Eventually, umem->pgs is freed twice.
> >
> > Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > Signed-off-by: Zhu Yanjun <yanjun.zhu@intel.com>
>
> Please also fix up the commit log according to Bjorn's prior feedback [0]=
.
> If it's just a cleanup, it should state so, the commit message right now
> makes it sound like an actual double free bug.

The umem->pgs is actually freed twice. Since umem->pgs is set to NULL
after the first kfree,
the second kfree would not trigger call trace.
IMO, the commit log is very clear about this.

Zhu Yanjun
>
>    [0] https://lore.kernel.org/netdev/0fef898d-cf5e-ef1b-6c35-c98669e9e0e=
d@intel.com/
