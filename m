Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFD1B27B73
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 13:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728309AbfEWLLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 07:11:24 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43578 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728518AbfEWLLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 07:11:24 -0400
Received: by mail-ed1-f67.google.com with SMTP id w33so5299804edb.10
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 04:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=TEcYx4e8I1IBeEOAlN0GMJ9nUk33G79fZt9bS9b3jQw=;
        b=R7r9sepU0OIjJsvBEnxyCj9QjM9C/wujdP528ef8E1yjBTSKW7Tt/tPjXogVmZNEj9
         auFIAl2Pf2T2roo+4Qhx49PAbw0Krx6zFswCI6aZpl2fR/Auzifu5IEYBUhQV09v+lwA
         MMQRixZDxJyg70M3eAHhSwfJf+762WIV2KS2Pa2T46To3drHHqqbmmvHSCxmzEeY6u7O
         PfHsBIRSCIv+zCf/DL52daNUmITEadQgRNkMDrTigCc+LtRtUV4k3YsA/wvR855p42qa
         4VFkcwbkMqwJ3lNwMk3iTCcqXm9Bu+cwmZu5vEHZVDFbn3tGM7FDW1fpX85/h3J8mPPy
         KQPw==
X-Gm-Message-State: APjAAAXN6IT5MT9GVeHJz50VJ0H+bOVT5N/AlZQ2BOUIS78w+JXVMoxj
        AZnnZqyktTroMdUflKPXTRyUFw==
X-Google-Smtp-Source: APXvYqzVQN2E/n7NMyN+o7d/FeA07G5C5giBp7Fy4y1Q2TrCQUrXc3jEJ0axiPSawB/9FYlrw10fug==
X-Received: by 2002:a50:a389:: with SMTP id s9mr95264723edb.113.1558609882589;
        Thu, 23 May 2019 04:11:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id 26sm4272690ejy.78.2019.05.23.04.11.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 23 May 2019 04:11:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E4AEC1800B1; Thu, 23 May 2019 13:11:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/3] xdp: Add bulk XDP_TX queue
In-Reply-To: <1558609008-2590-2-git-send-email-makita.toshiaki@lab.ntt.co.jp>
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp> <1558609008-2590-2-git-send-email-makita.toshiaki@lab.ntt.co.jp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 23 May 2019 13:11:20 +0200
Message-ID: <8736l52zon.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:

> XDP_TX is similar to XDP_REDIRECT as it essentially redirects packets to
> the device itself. XDP_REDIRECT has bulk transmit mechanism to avoid the
> heavy cost of indirect call but it also reduces lock acquisition on the
> destination device that needs locks like veth and tun.
>
> XDP_TX does not use indirect calls but drivers which require locks can
> benefit from the bulk transmit for XDP_TX as well.

XDP_TX happens on the same device, so there's an implicit bulking
happening because of the NAPI cycle. So why is an additional mechanism
needed (in the general case)?

-Toke
