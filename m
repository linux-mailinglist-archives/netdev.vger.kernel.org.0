Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352B6B2C01
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfINPpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 11:45:23 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33729 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfINPpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 11:45:22 -0400
Received: by mail-ot1-f67.google.com with SMTP id g25so30842535otl.0
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 08:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z6stuyKw6R7aWSyKRkL/ou6qErS4cyd2hvn9L62CTEk=;
        b=qAlchpt52cOsRSgJgcYxV/tf39eGwEAnb3iHo6xbm24IIHKIB1RNTT2xpah4GQhfcU
         zsP3ZtYmS+WssgOKkWdKbxGekOjGqBZsxOqJIEXRu8ZAho9u40AxmiKkchU3zAJrjiJ1
         QyBqp0LQoTPK/jmVzUTkw1PbmprvTYXy4obJEaLEqXQ3cGAgr8LFwyd5FRWp1xCH0eu0
         ETSRUnz4ZcDh2tB7t+GWULvPGmADz9ZfL8+rO2Km2BYrfZhw9lmjxlmwRRTSSWjPT7+3
         EISshca5KDZM9W4u50yWRHEudiZ9d5S28xm/VWDBB54lBR3opdidcJh29V3377e3/hUs
         lVaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z6stuyKw6R7aWSyKRkL/ou6qErS4cyd2hvn9L62CTEk=;
        b=t0PGMvxfIOgKUuF277mv/sdMNpwQ7EiDjyMT2J9uXCWuPLI+BD9eylFuywCtbkmDJ5
         n8QbC30kz26IiQweydZnSNhrEfdyoRXfRmrjd4+8NVbkXE7Rp1W6T9W8W8JpTgOQOlW9
         L+9LgqCJN+2tsxevwqTUBHrea3+9l6f0S51BmSDG0NhXCICuhK4XKTA0109GEcrqc+qD
         4okEBKCHdaiIM2ANVgIf+D/Hac9cggTtDkqunov/nWHB96SniZ5ONcUpEjh18vIfBvp4
         /8qUgz74GhBR9XgUSg/QjInlTVwasv18lJxFE2SETtGjmHxSDDUwszaa3D2t5o6hWOK5
         nlsA==
X-Gm-Message-State: APjAAAXbuAJNvKrnJb/fVTATjeLm3MVRScpSlMJhkWsVf3yUwwKjsw3m
        hgY14sJAhka453HsvHdvMQK8h7J5ynzk1V7dnj8cmg==
X-Google-Smtp-Source: APXvYqxg6wCWYEA6c4okl4WZ4EcpiEkuob3Irawl67OqAjzuTsN2Vnu/ZCSNpRw1pzAZNs00AZ+LdreFCme/V4mmyHU=
X-Received: by 2002:a9d:5f09:: with SMTP id f9mr2918303oti.341.1568475921476;
 Sat, 14 Sep 2019 08:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190913232332.44036-1-tph@fb.com> <20190913232332.44036-2-tph@fb.com>
In-Reply-To: <20190913232332.44036-2-tph@fb.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 14 Sep 2019 11:45:05 -0400
Message-ID: <CADVnQykBFBU5bFLXRr_aRzxNVpNGQRtELG5kd6viGWqO0uyyng@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] tcp: Add snd_wnd to TCP_INFO
To:     Thomas Higdon <tph@fb.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 7:23 PM Thomas Higdon <tph@fb.com> wrote:
>
> Neal Cardwell mentioned that snd_wnd would be useful for diagnosing TCP
> performance problems --
> > (1) Usually when we're diagnosing TCP performance problems, we do so
> > from the sender, since the sender makes most of the
> > performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> > From the sender-side the thing that would be most useful is to see
> > tp->snd_wnd, the receive window that the receiver has advertised to
> > the sender.
>
> This serves the purpose of adding an additional __u32 to avoid the
> would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
>
> Signed-off-by: Thomas Higdon <tph@fb.com>
> ---
> changes since v4:
>  - clarify comment

Acked-by: Neal Cardwell <ncardwell@google.com>

Thanks!

neal
