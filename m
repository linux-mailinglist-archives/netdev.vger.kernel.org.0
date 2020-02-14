Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FF215F115
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387949AbgBNSAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:00:08 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:33505 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387875AbgBNP4f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:56:35 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3a176c00
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=8+OMImskvuJ+znhW7pup/j8GzMU=; b=ic1S+J
        9xnQV8YIueRW+AV4Iv7lMmDhp884dzAWFMMgkEd1Hmq/7Aj23MR2Zt8cmK/fSyaw
        jVodzQ0VlzWhIFRyZQLGRI4nbUyH6eItOXv8zNNCxE5VLS4VbgAzvAfWC7qvDmtK
        qMWhk4jY3DxW2ccgbw2iABoBiK/JM4iAiAUZsF945f+AeacfOl7OBX+JA543p9Pw
        wN6rqce6Veuegf/qgPoX7gTSYUWol+6jp3c3SmIv7ANgY0aYv2VwGDy1gwUdDA16
        n/qpJ58FaMlttT3cmwfrHVSXJHMeIgabmLKc6HaWpeGogqUxC8KtBTa8d20WB+3C
        HrHwOEkrLQmc1KDQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id cde96cd4 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 15:54:26 +0000 (UTC)
Received: by mail-ot1-f50.google.com with SMTP id 59so9560817otp.12
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 07:56:33 -0800 (PST)
X-Gm-Message-State: APjAAAXVM8EB6nvkvurmzcciclZoOAo65FWVJ7mOrInpBG1GApwo6r/I
        sk9xd5rTf9M4vOQ8M0N7xfkPJVemFHDW1CxhCnE=
X-Google-Smtp-Source: APXvYqwAc7urz5adKTuufS0/hrhruLcViA+EqEj43aKSTZnze+YzaB0AUk8jlheBw55sUM/FjDQA9QqI3H/I2kui/q4=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr2819054otm.243.1581695793184;
 Fri, 14 Feb 2020 07:56:33 -0800 (PST)
MIME-Version: 1.0
References: <20200214133404.30643-1-Jason@zx2c4.com> <20200214133404.30643-4-Jason@zx2c4.com>
 <ba6b4c66-3c15-cdbc-7d0e-eaf307c5904c@gmail.com>
In-Reply-To: <ba6b4c66-3c15-cdbc-7d0e-eaf307c5904c@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Feb 2020 16:56:22 +0100
X-Gmail-Original-Message-ID: <CAHmME9qErQbU5Y36i=3L_R_PYw2Li_Vv2a9k7bSuMxpuLMcgsg@mail.gmail.com>
Message-ID: <CAHmME9qErQbU5Y36i=3L_R_PYw2Li_Vv2a9k7bSuMxpuLMcgsg@mail.gmail.com>
Subject: Re: [PATCH net 3/3] wireguard: send: account for mtu=0 devices
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 14, 2020 at 4:18 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > However, while min_mtu=0 seems fine, it makes sense to restrict the
> > max_mtu. This commit also restricts the maximum MTU to the greatest
> > number for which rounding up to the padding multiple won't overflow a
> > signed integer. Packets this large were always rejected anyway
> > eventually, due to checks deeper in, but it seems more sound not to even
> > let the administrator configure something that won't work anyway.
> >
> If mtu is set to 0, the device must not send any payload.

Yes, but there's still internal keepalive messages.

>
> Are you sure this works ?
>
> Last statement :
>
> return padded_size - last_unit;
>
> will return a a ' negative number'

Woah nelly I don't know how I missed this. Thanks! Will send a v2 of
this patchset.
