Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FB046AE98
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 00:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377534AbhLFXwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 18:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377492AbhLFXwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 18:52:22 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F8DC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 15:48:52 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id 131so35861831ybc.7
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 15:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=djv++UAAqOxYpnmdFGjPtq7qewuue8KMEbUg9TA755A=;
        b=HdjL1E9bVCukxOYjS0Y8Z9EwSvD2hZ8qn4KXrlCvvOcFmGITk2D0Ck41anS2+CI6Oq
         zNe8JoQWFAre5gKlEe+hFVLY6JBV3Nx4Hl0N7tluyUNfEeT4FYFRE3hJT5L7D1dmpmZy
         jT0tgOWo7p/5IH92mtoWBvIhjVKPQGrvxrnJIvE3dCU1bvWv4uFhyWhvQ4rs7EBhhCyK
         IXJi1MHM/9IqSJ6zbvoHSLnbFAiOsJ3bhOLio+VUI/WQPmYjFcXBR7uyABpdaJc5kTYA
         jWxH5Lmm5N+wW5vPevCBXO4Can77ig/CQUtXgkm500iQUtPJj9ETz0k7JJ14T4c2Fa3U
         bdTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=djv++UAAqOxYpnmdFGjPtq7qewuue8KMEbUg9TA755A=;
        b=6mv1P+J4skW+e/6597IvDDlwHoTsOabH/x7GO+qqmYeWO8yidMant1D6dJcAGy+9NP
         JM5YnWM/eK5Zxf25zPhx2VRkKRbsGf1Tx/N09wTeDH2kLxJeJkX9t28C9HkjHh5XZryW
         yO1kgbr2NjolYeLnfoC5ahNVRKU9hYpKW6e2t0w41pamDoNTOyJmk3HSn3kxeecuWuaP
         QJGjmmKAE4zxnZQTMGdkuXOYwNcChaaItLrTb4cyvGMaJ0v+JFb2pWhOuMVupmv0y8ke
         sd784jpLGyCG/+7cdcpIltpVAlVulT5F08kNn+PidSPdk/C60D1nu3Xu56NwruIML1ON
         auzg==
X-Gm-Message-State: AOAM530ImGYOpPx4wx0lywVaJRAmU1JLau0Y42/eAHAheeODYOUPzy6O
        u9yHwZBnNTNF1xl0dK5fmr1OYhDIZYTd7PqXuXJO2g==
X-Google-Smtp-Source: ABdhPJwSSCidfBLFcIhc15kdXLgtx6N3GFOn5BlSBuA6AhGYJYBq7izFC1UVsWhs9QBNp6qo+ctd0hLn73EJzhFfVdw=
X-Received: by 2002:a05:6902:120e:: with SMTP id s14mr49729879ybu.277.1638834531889;
 Mon, 06 Dec 2021 15:48:51 -0800 (PST)
MIME-Version: 1.0
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
 <Ya6bj2nplJ57JPml@lunn.ch> <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
In-Reply-To: <CANn89iLPSianJ7TjzrpOw+a0PTgX_rpQmiNYbgxbn2K-PNouFg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 15:48:40 -0800
Message-ID: <CANn89iL8oNr=Utt0OrOLk3RMhBF-AG_5kgwxCC98u+EKpCXiGg@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount tracking
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 3:44 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, Dec 6, 2021 at 3:24 PM Andrew Lunn <andrew@lunn.ch> wrote:

> > I'm not sure if these patches are part of the problem or not. None of
> > the traces i've seen are directly on the ICMP path. traceroute is
> > using udp, and one of the traces above is for tcp, and the other looks
> > like it is moving an interface into a different namespace?
> >
> > This is net-next from today.
>
> I do not understand, net-next does not contain this stuff yet ?
>
> I have other patches, this work is still in progress.

(Total of 55 patches, but I do not want to send them and flood the mailing list)

I will send next series when first round is merged.
