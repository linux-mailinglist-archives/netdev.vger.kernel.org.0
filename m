Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF8CE368FC
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfFFBDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:03:48 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:37597 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfFFBDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:03:48 -0400
Received: by mail-wm1-f53.google.com with SMTP id 22so643463wmg.2
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 18:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=quantonium-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1XSBFFGgW+iSXbmIatDZk2chQpORBxRrUZBGIeFkHr4=;
        b=fJ0VrHTURaBu0wVhadZcUH6Oo1c0zSxzCLNUd+1hqQcBecRX4cJfJjG1F1gxKq91Cv
         tgTp0NBQwNNhyVZyQyE2/MlFqfgF92Ajqttyol4POSdACLL/fo7yr5+lg2e/I+5xF6qc
         E/34x/WEnGgsg23HwQyktVYqDBf4PtJ76mjydJEsQzce+JgyP2TsNwex7JpEn035OdSA
         6IxUte7mdOBIRdgXeYwnInwHv4tRn2P7m6FP3WQ+13FMg64PNHsPNBSNQ05pwVnZPhzq
         hKp6X+ul7FZm6cXZ9ntxduS2j8bmfXxB2w7BfrMAEzkG2bZLfnvHphmwm71P/TAfHTs/
         c4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1XSBFFGgW+iSXbmIatDZk2chQpORBxRrUZBGIeFkHr4=;
        b=G3gpr/nY4seEQgqlAF82IoBKn7/0fF26cCgPkmfJdoN890VgDNr/XbYu0xQYHDGDY1
         Ysk07S9hBi5A/2K/cjaMdu1+yiY52ZuBeSGIqTyv926avjgPSZFZetLF0XYjOxrVBccx
         W97EvENxqSNmMgjWBP8Wyjaqh61TeWlB/Z7kCONxOuzGOwHFgZgtcF5PHBjhMcfi36mp
         gJIKo3+6gL/6kBIQbJUpen6A1/halZc7d6oyRekSsKN2J+SC3o4a83MZg1t89uRsso9W
         Uyr2xRankR6sJi2LMa8kpatSibqrZz+P4j2j9XEiJi6wQS5LJO9qa5H2WFu2p4md/AkK
         Rxpg==
X-Gm-Message-State: APjAAAUOto52gUDZ8P7KJNeItft1IwDluEAmlfpGmW8slFr/zjOjNYQy
        lOD9SDMm42V5lBjnIGK2uXzCvjY6zhYqzmUK1ES2ip+P
X-Google-Smtp-Source: APXvYqyQVJ1dStjGWqLP3Rj6YynBnhGVzbSwd/52Ll3tsiJek+5DWmD6VnkaHkv+fnq/6CJ8bpvf8G0rZBsM9DgqrI0=
X-Received: by 2002:a05:600c:240e:: with SMTP id 14mr992394wmp.30.1559783026195;
 Wed, 05 Jun 2019 18:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <1559576867-4241-1-git-send-email-tom@quantonium.net> <20190605.171118.681501460677717252.davem@davemloft.net>
In-Reply-To: <20190605.171118.681501460677717252.davem@davemloft.net>
From:   Tom Herbert <tom@quantonium.net>
Date:   Wed, 5 Jun 2019 18:03:35 -0700
Message-ID: <CAPDqMepSpAMP2ars86OOqnN8RFM=0PQC6grCn-tnVF-UJkVUig@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] ipv6: Send ICMP errors for exceeding
 extension header limits
To:     David Miller <davem@davemloft.net>
Cc:     Tom Herbert <tom@herbertland.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 5:11 PM David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <tom@herbertland.com>
> Date: Mon,  3 Jun 2019 08:47:47 -0700
>
> > Define constants and add support to send ICMPv6 Parameter Problem
> > errors as specified in draft-ietf-6man-icmp-limits-02.
>
> Tom, I've kinda had enough of this pushing your agenda by trying to
> add support for ipv6 features that are in draft state with the IETF
> and you are the author of said drafts.
>
I'm sorry, I had no idea that there were criteria that we had to
follow with respect to patches and IETF. Please specify the criteria,
which I will assume that apply to everyone and not to just me, so that
we can avoid further instances of wasted time.

Thanks,
Tom

> I'm not applying this stuff, sorry.
