Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A922F18DC22
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 00:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCTXgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 19:36:38 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38976 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727631AbgCTXgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 19:36:37 -0400
Received: by mail-io1-f67.google.com with SMTP id c19so7865543ioo.6;
        Fri, 20 Mar 2020 16:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r56c2sC6zamlywNB9189icYDyAGKVdxKEKYyEkkrtbs=;
        b=jIglHsdBBqGfP+iZRD+xmqhg6u0oes4iqVrlOxhxfrU1/HvYH5tqBY70q8K1GaW7F7
         QU2tfM/SHKVZDjBBz0r9YusVGDwACXLU1bCYVNAGidoXju78eb+xAUbeE2VgD2zpqIfb
         yBDLxS6nFFsQsbfOUo83L8DO4uPPdW9djOvDu0oi1szuCKH2KlxqCk+jCRWDJqmwxcvr
         78m1MAonXVES7tNbLechb9RFdd55Dh00aS2rycxffXWNAbZDp//pD7nCLeo3IJPjn+wk
         rSaw8qk9RS+22pcZEz+ee24ZRKw6DO0N6p+m1nqrdzOFbGfCRk938uF18LUKYL9jcdpz
         dnoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r56c2sC6zamlywNB9189icYDyAGKVdxKEKYyEkkrtbs=;
        b=o/m21ztVyO/AkF/nmBdH7SFF+R8pmzEA7CdUcKJ/43h5bjG3MAQShq2endrTJ1u/XR
         OGzryo7e/OlMnVKbyzbFgKWkkoqHYZseE7Dig0OV6grCutaP2jmifnHwe5Z4sHs+T9d+
         mAWg63dJxlSw3kboStnLrsvKKdwmcSC05dQbiVgM8i9v3ZfZtUL0Lr0KadcEbWgn/+6U
         vwAFHJ4XTUfEbbAy4Dr0tX4tohO/QIaRKVZIoIulzmw72nTRmFP9DrucElyJ73ls3Irn
         YcpMTyih/aDU2jCv48AiyOj/H0Md8YTaFQpQzAmL2IVYwiQwBXImB1qVMWqQz1uW4ODU
         LZJg==
X-Gm-Message-State: ANhLgQ2vgZ9gIaXyXga+IIomuyw4pu/r9QIP4qadXaku96dcADA7XXOz
        SfT189UBAv221mcT/4RZoFO/X1g2dhtR6YZRw7U=
X-Google-Smtp-Source: ADFU+vswMWOI+4/lmZP7NubSfTT4Gc+zjPJx/vu+4CB9gKmAIL7r/Cx3A4SqMr8iKsJ4UneSjQvw0JrHpgMFITL80rY=
X-Received: by 2002:a02:1683:: with SMTP id a125mr2499634jaa.61.1584747396297;
 Fri, 20 Mar 2020 16:36:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200320110959.2114-1-hqjagain@gmail.com> <2dc8673f-a46d-1438-95a8-cfb455bbea57@gmail.com>
In-Reply-To: <2dc8673f-a46d-1438-95a8-cfb455bbea57@gmail.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Sat, 21 Mar 2020 07:36:24 +0800
Message-ID: <CAJRQjoedC4PTycGEpv_pCfbzW9zaA+kz2JTJaTi-EDWxcPUvFA@mail.gmail.com>
Subject: Re: [PATCH v3] sctp: fix refcount bug in sctp_wfree
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 1:10 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
>
> This does not really solve the issue.
>
> Even if the particular syzbot repro is now fine.
>
> Really, having anything _after_ the sock_wfree(skb) is the bug, since the current thread no longer
> own a reference on a socket.

I get it, thanks.

>
>
>
>
