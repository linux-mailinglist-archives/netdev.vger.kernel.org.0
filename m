Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FFE3A6AEF
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 17:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhFNPwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 11:52:44 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:41620 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233035AbhFNPwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 11:52:43 -0400
Received: by mail-oi1-f180.google.com with SMTP id t40so14816168oiw.8
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 08:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EF0dfIoZvGU+Vr41C27DkXbrmuNfjCy1Hwp9ovd+bds=;
        b=GC+FG5q/xW2WP9rip2RROeECnGA3KeU/o2HTP/yKrIa/joZPZ+mqYr/mwklLZmv7fU
         MF8bfdCr8TTXU/dkSLYDCwCH79NysBoDKQufOE5sDBsRhJCNQuQMoW3Jvtjjp9rcCQd/
         QlGSZB1Ggi4qPgEPnRIRSIaEA+bAzZYfKeEKx6MkgZSmgt5Z6HQtVZ+vyXXa9plPi0Qd
         66QxoAIitSlHTHnYZa0keK5FraGFBDx7t8lZA9trF6V6JLjQNdnHxQ4kwf1dOtSX5eGH
         IwZXd+GWYOfT4R3hP1l+rXdgE+nTX5JkPaRWL12YnzgfC6Ntvz2UiDNMP9U9wr1fLrRl
         BIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EF0dfIoZvGU+Vr41C27DkXbrmuNfjCy1Hwp9ovd+bds=;
        b=k/SqLm1FLG5avdDV9KPDt/DXpoRc7j6WNjAL32JG4EXRBdXCxPIZhSTrzVIiMcpR8L
         8gtiFBfBN8GhrbDDt501XZWyJ9+2EVTs9ukRCZ/EL3knGMG8aBKOXzJ3UiL+B8ptOm5w
         DDfFyhABEKi3F1oD+NUfQZMTY71VwKu6WH7W7Y9TT8JOXCs5eIKsuFG4FAALCXCX2WiY
         XSLlgxYRDBiz1QUnb4ums3jnX2cjeMgzR8sR2NsoJxypVpQZXRjuhGSN0Qw/a2gNgs1p
         VXTx/Yxl+Qus08W+4TjT52Mk5ZPnsM7xih5UTyXVhLpKPekkkuQWFd8gyaotNRxvV9uA
         bg7Q==
X-Gm-Message-State: AOAM531bzWuOZU2PSSiPYw+bfNNUzIlSJH4A7/iI7Azx88JlKGgNyXyg
        Ao2+r53h3/gvCr8PCAtqdKFkJEiXBWh++fXlKU/HB2yU
X-Google-Smtp-Source: ABdhPJwqySPlqYc3f3dxhmb6UJcVGQFX7RpNzT6j2Rmjy0ssnlqT+iisR151MDo/H0HtiTBeYjkNMc8scsDQ3PDj318=
X-Received: by 2002:aca:b7c3:: with SMTP id h186mr21475003oif.70.1623685767145;
 Mon, 14 Jun 2021 08:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210614141849.3587683-1-kristian.evensen@gmail.com> <8735tky064.fsf@miraculix.mork.no>
In-Reply-To: <8735tky064.fsf@miraculix.mork.no>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Mon, 14 Jun 2021 17:49:16 +0200
Message-ID: <CAKfDRXgZeWCeGXhfukeeAGrHHUMtsHWRPEebUkZf07QCnU4CFw@mail.gmail.com>
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bj=C3=B8rn,

On Mon, Jun 14, 2021 at 4:46 PM Bj=C3=B8rn Mork <bjorn@mork.no> wrote:
> Thanks for pointing this out.  But it still looks strange to me.  Why do
> we call netif_rx(skb) here instead of just returning 1 and leave that
> for usbnet_skb_return()?  With cloning we end up doing eth_type_trans()
> on the duplicate - is that wise?

Thanks for pointing this out. You are right and looking at the code
again, we should end up in usbnet_skb_return() if the call to netif_rx
is succesful. I do agree that calling netif_rx() is a bit strange,
considering that usbnet_skb_return() already calls this function.
Perhaps the issue is that we end up calling netif_rx() on the same skb
twice? rmnet also frees the skb when done with the de-aggregation.

I will do some more testing tomorrow and see if I can figure out
something. So far, the only thing I know is that if I try to perform a
more demanding transfer (like downloading a file) using qmi_wwan +
rmnet then I get a kernel oops immediatly.

Kristian
