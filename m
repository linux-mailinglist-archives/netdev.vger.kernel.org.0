Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08A5439B47
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhJYQQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232929AbhJYQQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:16:08 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AE0C061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:13:46 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id o12so23312695ybk.1
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QvnoffndWGJ86XSQeVrdJfh2/PtW1BghkuUV9s9SlAQ=;
        b=jDTXBLbl/kEE6x3ylgUmPG6oUaVDYn9EVkMI76jwftZPDvpsx2cBoVr2hmAzwtNYI0
         w75YwsGKfiPcSaSjvxHV7KfbL9iIW3QjldVhcQGx5tf6sUOK08qeqw2Vj/Q2FxYX45dZ
         1yy+bSlxlVmPoorOUNSojH6H/5I+8DJd5tt8k2FZKmkIloLjmXi3yptaog3FkN2g/+FY
         yZTOu3olrwSuXbq/MgCL+gZnmb8DsI6kC9eKhD+htQ3RgTzKa9sAPiOVi1iuNsr5SK24
         cmaML04VURu8jSabHF2JUg12bEYaWAE6Fl9m5kkcVRGEMajw/cWXE/MI7QZAaxh8E9Cs
         h0MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QvnoffndWGJ86XSQeVrdJfh2/PtW1BghkuUV9s9SlAQ=;
        b=tDauxkWg5Tm+9nhv7pmZpgTDav4hRRvdFv82Lxd9n1mUhn0dwYZQUjQoL2eUwyyZSS
         sDeWMENlZViVJF5sYDeLR4yriUhBVSGH7nxeZpyv+XzK8g6tN58g50h5LQK99LSJKLaw
         l/JjiRWKXMlWTy/CA417GyUYlwGDrRNFA/u5vknf2tfL3E4afBuApSE0QNOj2A1slMEk
         z8P8gv/6ZBi2ve1kGAHIaPZ0G5K68WXVXl2IGoCYgq/IGvxmiLKclw4/U9GPlGdHO1bN
         mT+qJ7cKo4QfrJFebT+ZjQBOmtP6ls8cNxRRUQRPNw9lc1Nm3vxCiR9g+PgL2a5sCNwc
         SebQ==
X-Gm-Message-State: AOAM532iFM/UmWcokVGwktlpfxYw5u26ApqmDMxsC11p0IZRAfmAHwgt
        lo0bvoyD2iuJqA2VnOdb53TJuOMeavGy+1aaZccfbg==
X-Google-Smtp-Source: ABdhPJwL6+DhfzKoSc8kMOjLVQhMEAL7jPjrLTvYQUWyCkf9dmQd3zp9h8BzY2olZLO8NrVFPSETpR0n2I6FVPdxzGk=
X-Received: by 2002:a05:6902:701:: with SMTP id k1mr7784331ybt.225.1635178423768;
 Mon, 25 Oct 2021 09:13:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211024235903.371430-1-jmaxwell37@gmail.com>
In-Reply-To: <20211024235903.371430-1-jmaxwell37@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 25 Oct 2021 09:13:32 -0700
Message-ID: <CANn89i+PDXYxS_Rbior27T-JAqLTA3OmBjcu7WnAGmtdXBO3Yw@mail.gmail.com>
Subject: Re: [net-next v1] tcp: don't free a FIN sk_buff in tcp_remove_empty_skb()
To:     Jon Maxwell <jmaxwell37@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 4:59 PM Jon Maxwell <jmaxwell37@gmail.com> wrote:
>
> v1: Implement a more general statement as recommended by Eric Dumazet. Th=
e
> sequence number will be advanced, so this check will fix the FIN case and
> other cases.
>
> A customer reported sockets stuck in the CLOSING state. A Vmcore revealed=
 that
> the write_queue was not empty as determined by tcp_write_queue_empty() bu=
t the
> sk_buff containing the FIN flag had been freed and the socket was zombied=
 in
> that state. Corresponding pcaps show no FIN from the Linux kernel on the =
wire.
>
> Some instrumentation was added to the kernel and it was found that there =
is a
> timing window where tcp_sendmsg() can run after tcp_send_fin().
>
> tcp_sendmsg() will hit an error, for example:
>
> 1269 =E2=96=B9       if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN))=
=E2=86=A9
> 1270 =E2=96=B9       =E2=96=B9       goto do_error;=E2=86=A9
>
> tcp_remove_empty_skb() will then free the FIN sk_buff as "skb->len =3D=3D=
 0". The
> TCP socket is now wedged in the FIN-WAIT-1 state because the FIN is never=
 sent.
>
> If the other side sends a FIN packet the socket will transition to CLOSIN=
G and
> remain that way until the system is rebooted.
>
> Fix this by checking for the FIN flag in the sk_buff and don't free it if=
 that
> is the case. Testing confirmed that fixed the issue.
>
> Fixes: fdfc5c8594c2 ("tcp: remove empty skb from write queue in error cas=
es")
> Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> Reported-by: Monir Zouaoui <Monir.Zouaoui@mail.schwarz>
> Reported-by: Simon Stier <simon.stier@mail.schwarz>

Thanks for this fix !
Reviewed-by: Eric Dumazet <edumazet@google.com>
