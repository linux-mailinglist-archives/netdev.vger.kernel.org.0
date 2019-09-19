Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3432FB792A
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 14:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390175AbfISMSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 08:18:07 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:46123 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388575AbfISMSG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 08:18:06 -0400
Received: by mail-yb1-f194.google.com with SMTP id t2so1223309ybo.13
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 05:18:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rMH0/TCnPmpHjKfLgfvo5PO+21HtvH58PyBJZ4eeme0=;
        b=I3/Ju7XbO174sqiMyurMJWSZXNozM4d6I9F14kIX7xHOO4nPWJqcg/2vdiIcXsFkht
         Rh1iFzwpSoteCEvwVqvMWFqwTsXebImyM6SAYlVvSMiQbT6peTo4ja0BrGlOwWsfeG1r
         xHlf+I9ZMlyvFBwnDve4pfpxciWzkLvr4mn7hYQBGhNP4KRdelRRk9s9/CkvYhe24emU
         baHswknxCSmYjJDpf/mEol52E1yTpXLiJfHhrDcSTSFn3nIE3Afq6Ng56RWm883KoU3C
         L3C+dntPkDKOljyv3PD+E5H4xLw0egShJsnEqJ5tU3LTosORg34oOw0TsPODxm6ADWud
         Ktlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rMH0/TCnPmpHjKfLgfvo5PO+21HtvH58PyBJZ4eeme0=;
        b=N+YwYlrcaZcQ6XfK2jkejvQq8ntqli2lTG9edFuZYwC/lMf5+1Y7No38Dxi6RuFavA
         KtFRvlGkM5RM2tEjhVMTL/nXeJHrOM3Ez6/W1meaFMuYVf7KtRTypkzkD4mpF/thdsvu
         Ucskx8C1h2iFKLeKEj9jfxUCFeNMV4QYfPLBHsHZ1VmzVYM6+Zjy38p+kNQHdS0LHA6X
         S7vog0pCv330syPOr2ey0wfDfJ9nT1mo83Oy+e0Pdh/nSKxHKk10FxZVFquBe/rX4y6/
         gv5MDGLYNQDdBc0IHFUrzFteyBRNNDwsNNtjtlUE7GkWGUAp8wWKcLSa0IxYu3I00W6Y
         lAkA==
X-Gm-Message-State: APjAAAXQkkcyr/WNr4VOFJqffwWzJmKcctWvzZUMt6/VA/8jly2evyCS
        edfdZ1DJUqS+IHVeGOu6AOqLvU3KU1oZ6nHpJDE=
X-Google-Smtp-Source: APXvYqyqJ+7N2W600x+z/5JpVIKUkUzrwD4J0ntWTl3e3mY6Ycz2Z4pdoJUf0ZLC4XZN5YLV9K7u7raL7+PyX2XhXdc=
X-Received: by 2002:a25:a545:: with SMTP id h63mr6544887ybi.257.1568895485798;
 Thu, 19 Sep 2019 05:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190910214928.220727-1-edumazet@google.com>
In-Reply-To: <20190910214928.220727-1-edumazet@google.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 19 Sep 2019 15:17:54 +0300
Message-ID: <CAJ3xEMhh=Ow-fZqnPtxUyZsCN89dRmy=NcaO+iK+iZZYBdZbqA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: force a PSH flag on TSO packets
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 12:54 AM Eric Dumazet <edumazet@google.com> wrote:
> When tcp sends a TSO packet, adding a PSH flag on it
> reduces the sojourn time of GRO packet in GRO receivers.
>
> This is particularly the case under pressure, since RX queues
> receive packets for many concurrent flows.
>
> A sender can give a hint to GRO engines when it is
> appropriate to flush a super-packet, especially when pacing

Hi Eric,

Is this correct that we add here the push flag for the tcp header template
from which all the tcp headers for SW GSO packets will be generated?

Wouldn't that cause a too early flush on GRO engines at the receiver side?

Or.
