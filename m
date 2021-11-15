Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0326145187C
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 23:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349534AbhKOXAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 18:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353134AbhKOWfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 17:35:00 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D03C04A499
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 13:48:06 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id az33-20020a05600c602100b00333472fef04so333815wmb.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 13:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z3OdB0x5a+j+jlf0dMOM0PWdUuZx3BRJAftWyyfklE0=;
        b=KRI9Y3d00cSsH127LkaUftW84wb8FqH2u1z+N60FXxQ2soKq8sjAnxAlwnbduKCPML
         /4IkuXMD8n8U0fHde/j45ykHVjyJqzm0SWH/Te8dmeYi7TR6Of4XhlmtVXa5+mcRqEwh
         OHg8Yd/Osg1Sgs3lEREKQ69nZCtwnk5TSdD/EEkMkjhDzmpbAMmO03dyries1w9DP5lw
         jOZlkc2zPdMwbEXJzBn4LqVJPGHCFhXi0piJpwBi7O7Rfb4ryxaS8USTjLIAtAHeLNcw
         EMczlV8fRNpI5MlazrQ8FQYjtcnAhzbmLxuP7orbJEOxGjHl1xZjk5kGJUutjt92JQHk
         nq3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z3OdB0x5a+j+jlf0dMOM0PWdUuZx3BRJAftWyyfklE0=;
        b=xyVLPRAfNyiz4sW3ozQIVJBaLPaQWOwhBiIWqRqSY39hIZmmd00uIjKT/GvuH+KVIM
         JvgJi1Lej0XvaZkORogPG/CjhUvCFOqC7ovU0mzOEJfyYIHxKeXvIgx/YCVZI0o/Rgj8
         m1bZ7NvADcuQlk6Xn+oZUF3Aoq1scQI0JpIDkky3TJnwwfbCvKmELc2lCFnW8kQKM7sb
         Gvaq4MpIwfHKScfwF8UMA1eZLhCABKskH1mRyO0S2MffhPNJfm2iGi/98gPttTt4orBt
         0xxdBhoFeI5p/IuY2aSRQ+qnJBTqsdtmFFpZzbguj+Z706Rfe5w7MNNkkQh35XRmeeCh
         943g==
X-Gm-Message-State: AOAM533IP6zaYny5lZLp0ozrbuYzj+M+FpUby1gNSRS++5z6f624O0zZ
        vJhspTVfMF2iOfKp2EIzwCdffuW2OSpM4yaD+AZTmQ==
X-Google-Smtp-Source: ABdhPJzEfz1Qot4z5PKhEs/srjUPwDOGWKQF6gQMAHpJOZdOH8/zzmkPX1UjudMdlTaNVrYqU1uoa1wcnNnoqW/CIrg=
X-Received: by 2002:a05:600c:3ba3:: with SMTP id n35mr2012524wms.88.1637012884230;
 Mon, 15 Nov 2021 13:48:04 -0800 (PST)
MIME-Version: 1.0
References: <20211115190249.3936899-1-eric.dumazet@gmail.com>
 <CACSApvZ47Z9pKGxH_UU=yY+bQqdNt=jc2kpxP-VfZkCXLVSbCg@mail.gmail.com> <dacd415c06bc854136ba93ef258e92292b782037.camel@redhat.com>
In-Reply-To: <dacd415c06bc854136ba93ef258e92292b782037.camel@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 15 Nov 2021 13:47:52 -0800
Message-ID: <CANn89iJFFQxo9qA-cLXRjbw9ob5g+dzRp7H0016JJdtALHKikg@mail.gmail.com>
Subject: Re: [PATCH net-next 00/20] tcp: optimizations for linux-5.17
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 15, 2021 at 1:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
>

>
> Possibly there has been some issues with the ML while processing these
> patches?!? only an handful of them reached patchwork (and my mailbox :)
>

Yeah, this sort of thing happens. Let's wait a bit before re-sending ?

Maybe too much traffic today on vger or gmail, I honestly do not know.

I will send the series privately to you in the meantime :)
