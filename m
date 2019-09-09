Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E4BAE13F
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 00:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbfIIWwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 18:52:34 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:45698 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfIIWwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 18:52:33 -0400
Received: by mail-pl1-f171.google.com with SMTP id x3so7365190plr.12
        for <netdev@vger.kernel.org>; Mon, 09 Sep 2019 15:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tY0RP+vo8Hd+sEG6i8r+0SyzMMWsYOOp2olh3OhgPTE=;
        b=EsqgUMtobgYWCJZCPY7Z5zce+Y7Q2KgTfLfyAVFY+3mfZur7OhJlYn5ofQZFi/xLou
         hOjmveh2iLTAKBPAYUL5H4lgpuXpWPXtm8QbgrFO2+Gm/wd8oFsTTyubiro0x1KmP8GW
         1+x/DoxWa9RFRhxDa+z5Xl2WjB3RUo7z6h56VatDMeg8wcpxnQDjx3zQSBfMDdMwQops
         WRX+np44bt2suEq1eEFv5pM9NKDFauuA1SnQmbt+TybkrqcORvc8mceHAJbceZ/od8UI
         sABiktmHYyXsC281csCWV82U37Wa6xIXilbBDuP+fD6vtumKNUZwdDe7XcJvQWkkpD/X
         V6fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tY0RP+vo8Hd+sEG6i8r+0SyzMMWsYOOp2olh3OhgPTE=;
        b=ojqJn8qIWaIYd3JoYruiYcad6IzeWH1BX1RvkkdwCEded55Dgip04MafSCU4rwHM8s
         I6Uw4o2xh82ub1UMjAl4o9fEcL47Gj4MVITtqECm+XecujPzYwtchHGr5BcoGtGyB4Cv
         Ugmcdvr1HEWGvG8jPiPFDEdd4Yjqh6S28ZSsfF8ltt9CI8tlO1+DWjDbaympXNr9E2jg
         2QMFInH+nFOYmXcj13nb4qoZxTzPDI+veQV5D7HDpGGnAwhX4OCp2c9Q05KweBjOojy0
         n1TzCiYmmOcEvUKMyRYEh78Xx5oPzKq+r/Rg9Lolb14DOp6j96MagUlWtzWyMtrW8kxy
         m0NA==
X-Gm-Message-State: APjAAAU5sw7Y8tmDHdvny4XwBKLViIsVi2OZBDbRMc6ghyAZ1QI5vIyQ
        3VBy0VDNJqpI3FUDG+YzbKgJ0PAGt8jEC5vM54qlOaUz
X-Google-Smtp-Source: APXvYqzBarsgbTRpxH6uTBV4ekchHQpUGhwr4f8gluJHNgvKC9VfDM6pMQE5mzpxTl8Oxvo5J9VQFAu88c3V0BcmIX0=
X-Received: by 2002:a17:902:a5c5:: with SMTP id t5mr25931480plq.316.1568069552784;
 Mon, 09 Sep 2019 15:52:32 -0700 (PDT)
MIME-Version: 1.0
References: <211c7151-7500-f895-7fd7-2c868dd48579@applied-asynchrony.com>
In-Reply-To: <211c7151-7500-f895-7fd7-2c868dd48579@applied-asynchrony.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 9 Sep 2019 15:52:21 -0700
Message-ID: <CAM_iQpWKsSWDZ55kMO6mzDe5C7tHW-ub_eH91hRzZMdUtKJtfA@mail.gmail.com>
Subject: Re: Default qdisc not correctly initialized with custom MTU
To:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 9, 2019 at 5:44 AM Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
> I can't help but feel this is a slight bug in terms of initialization ord=
er,
> and that the default qdisc should only be created when it's first being
> used/attached to a link, not when the sysctls are configured.

Yeah, this is because the fq_codel qdisc is initialized once and
doesn't get any notification when the netdev's MTU get changed.
We can "fix" this by adding a NETDEV_CHANGEMTU notifier to
qdisc's, but I don't know if it is really worth the effort.

Is there any reason you can't change that order?

Thanks.
