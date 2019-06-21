Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 790B14E812
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 14:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfFUMeL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 08:34:11 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39979 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfFUMeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 08:34:11 -0400
Received: by mail-yw1-f66.google.com with SMTP id b143so2626397ywb.7
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 05:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YNSnBy/4YUyuPYB2TavjOZ31uKk3Z1fMKbz42QTKg5w=;
        b=noSz6WWXaZsLn3dGDsLUkmjLbYZvTdQZNyEhJ3mD7n3wjirBdfgUINfs149bSt2vtf
         Y2OKsvMaVX1dNcZjW0qE3eeq5owx2g94T7v/WjesD56KslwUrIQaKoZ54CFyE036pUig
         mQBh+c2dFMHkcZsoc2qC8K9xo12VeXCra4hJra4LJpm9w79AN4zSo2D60gQh3d2YKRzL
         UJuK2yR3sAaRaLzBTa9LpndQXijW8Z+zCo4QhFQSpKjNLGnZPg6SrsnTp26eLA4F4XzH
         eGS2zzmhh7tpQ0TPFa4zQRxQUQT+9L1ga/fmrqQC1iQb+toZvoIWJw2nXjZWTOSW0fKP
         Jd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YNSnBy/4YUyuPYB2TavjOZ31uKk3Z1fMKbz42QTKg5w=;
        b=ibD6dQPnrZk8abMKArtxKQp3wa6NrWNaB1sdnNlr0onDv0KYPy9BKxkdC26fyjGEP0
         uImVJQrp/yGXd5lmV5MqBpAfzFTqJs9FJMDUUAiiq3ARYCCvRKcDX9BmjdR5+4kmauIG
         UTQ5G41oyiWywfL3Db+aY7by1Sp1vNXM30n4xPqKxltDh4lS7k0Tvw1/C0Ezu5wkUY2R
         2/qSCvwjANxl5FCvxfBiFYwZgsUdipBBup+Z2ASD3ME3kqiOAsYxmJJpKtJdjBu8FvQU
         /+6PNLlmdfrVDyjB+9D1cwAVO6+8Ze1C1aD/8NdHLOfiyhpOeaJzDz8LJ5sTMqEIa5Vb
         /VFw==
X-Gm-Message-State: APjAAAVFjFy8Epf5LDWJMLMwoUMAXYV6Tf+1jxCzEEOLqvoa+xeAKeKg
        Oipksekm6FDQ0dL/C15w3FCR6buB30fWT3HARTqBbA==
X-Google-Smtp-Source: APXvYqxrR2+gYAtolE6ieEnD2TJ8PAKNlanUWwzBppQF7JovPGriopusMBFeDRVA4U/gSGVyJ26oCuactC/8Crwl8zI=
X-Received: by 2002:a81:57d0:: with SMTP id l199mr60839820ywb.179.1561120449842;
 Fri, 21 Jun 2019 05:34:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190621003641.168591-1-tracywwnj@gmail.com> <b7e58c88-a1d8-323d-caa2-99360ca5144e@gmail.com>
In-Reply-To: <b7e58c88-a1d8-323d-caa2-99360ca5144e@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 21 Jun 2019 08:33:57 -0400
Message-ID: <CANn89iK-Q5zhA0iXSCL+kbK9RXS2bM+cK3b1iR_+bOTJ2EPN0A@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 0/5] ipv6: avoid taking refcnt on dst during
 route lookup
To:     David Ahern <dsahern@gmail.com>
Cc:     Wei Wang <tracywwnj@gmail.com>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 20, 2019 at 8:50 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 6/20/19 6:36 PM, Wei Wang wrote:
> > From: Wei Wang <weiwan@google.com>
> >
> > Ipv6 route lookup code always grabs refcnt on the dst for the caller.
> > But for certain cases, grabbing refcnt is not always necessary if the
> > call path is rcu protected and the caller does not cache the dst.
> > Another issue in the route lookup logic is:
> > When there are multiple custom rules, we have to do the lookup into
> > each table associated to each rule individually. And when we can't
> > find the route in one table, we grab and release refcnt on
> > net->ipv6.ip6_null_entry before going to the next table.
> > This operation is completely redundant, and causes false issue because
> > net->ipv6.ip6_null_entry is a shared object.
> >
> > This patch set introduces a new flag RT6_LOOKUP_F_DST_NOREF for route
> > lookup callers to set, to avoid any manipulation on the dst refcnt. And
> > it converts the major input and output path to use it.
> >
> > The performance gain is noticable.
> > I ran synflood tests between 2 hosts under the same switch. Both hosts
> > have 20G mlx NIC, and 8 tx/rx queues.
> > Sender sends pure SYN flood with random src IPs and ports using trafgen.
> > Receiver has a simple TCP listener on the target port.
> > Both hosts have multiple custom rules:
> > - For incoming packets, only local table is traversed.
> > - For outgoing packets, 3 tables are traversed to find the route.
> > The packet processing rate on the receiver is as follows:
> > - Before the fix: 3.78Mpps
> > - After the fix:  5.50Mpps
> >
>
> LGTM. Thanks for doing this - big improvement.
>
> Reviewed-by: David Ahern <dsahern@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>
