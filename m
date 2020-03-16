Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABEE218750E
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732728AbgCPVqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:46:54 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41689 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732636AbgCPVqy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 17:46:54 -0400
Received: by mail-oi1-f193.google.com with SMTP id b17so4578316oic.8
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 14:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8CmJdYSWZIQfBnyBWznqXYCsdYq1set93wjMdh18cA4=;
        b=j/7A9n9udAPuW0A7tdnVweJRoLL6C1o7VCxHekl+tc/1HgnFl56F8oh9VduUj/blwA
         OVElcmFAxrzvggJbLldz62aywA/xO7e9YeZqg+BIqo40zw+9VjVlNmmpH1j3rp79a26H
         6OiyHpP8fRXx+/51nbdVqZjQ+K0gK0Fru5hmb/r31i2VbJtRz1VfHXxm0ZcXBdTLRjLm
         caGeK9eyeNN3MDVo0Esj93LGqyHlHpHKkM3IQyXFCz/Z0tGDb9HDSp41Do2vDyZmVbLK
         3GLCp/R/BMQmPuPa8kS0fQKg1in9K6D68xtP0DOSDgQBcOaZwPjqnt192GSRccK0AVlx
         PFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8CmJdYSWZIQfBnyBWznqXYCsdYq1set93wjMdh18cA4=;
        b=E1dy0Rs0CluYLIKPVS6h7UpKdRspDBMulz2x7e5b02DUOpKZzrWt5SLqAsDndl27Xk
         bxAMB7rsJJLmXyZdpnUMktbpUMZQXSWncInFWLbuIuuJSkJ5p1U2mdcO8l8B+XBWlkRw
         9ILH9fi9DuhqDAKXYA7z1cyUx9Ix8e0N/uMdCbzZn1xyak6JrPQkv0yAFNfEBqz7kZyN
         K8zq8S3UhsCq6oj2YvaNVfdUmxr2hxqOmdjmMYvSChLAvE5cr4nvHw+k+3N3nYEoZRzq
         SbkjdG/mk8sLc0wFidSc6u4lWd5JcsGGDjhd62EswTYaFmgcRZy/ij85mCXm/gqk/bH0
         Rm2Q==
X-Gm-Message-State: ANhLgQ0R4zDN+dEplkeNdInKk7goqLcf66/N9KE26XxNo3AG01uk+KwQ
        TzdHxi9847M8eH3OCKZZSY69Usb+VFJOFVo/BEizkQ==
X-Google-Smtp-Source: ADFU+vvKEObI4d1IMgr7TgcMawiSGpw42oxTKWzBTdtRajAINP1KYreKYwIl2bzMVs8QJn5PvCWGWWqbC/WDdlX9Mkc=
X-Received: by 2002:aca:100c:: with SMTP id 12mr1188687oiq.22.1584395213181;
 Mon, 16 Mar 2020 14:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <1584340511-9870-1-git-send-email-yangpc@wangsu.com> <1584340511-9870-5-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1584340511-9870-5-git-send-email-yangpc@wangsu.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 16 Mar 2020 17:46:35 -0400
Message-ID: <CADVnQym78VNfiOHHoZK88dBqG=hJijr4041VCqRFqZAef-7PRQ@mail.gmail.com>
Subject: Re: [PATCH RESEND net-next v2 4/5] tcp: fix stretch ACK bugs in Veno
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 16, 2020 at 2:36 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
>
> Change Veno to properly handle stretch ACKs in additive
> increase mode by passing in the count of ACKed packets
> to tcp_cong_avoid_ai().
>
> Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> ---
>  net/ipv4/tcp_veno.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)

Acked-by: Neal Cardwell <ncardwell@google.com>

thanks,
neal
