Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD4D193CEF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgCZKZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:25:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36130 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbgCZKZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 06:25:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id i7so1246083edq.3
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 03:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zYVIAcP46mBovRvIjiIyOb4sMzl9vUVyWRtQ5DlC2HE=;
        b=sZWkeIck4+gNPihoJan2enClRSLOhZPLqiPSWGpSmE0ufdTvnVCDMWQq/5ZhCrMeW0
         7zkTz9f4W0k9DE9lyOpbidga0d96UU3gT/DJLTSDy7YIT949f2FaSZflvbF2sEXOQLSR
         YFkuTLCTUutMGy3NiUWsuBrR7DMj7+OOjcZ91vtCk/zia7C8Y1eIPve8TaT0HxziyTPQ
         tEAJkchK+rMOfD3kzhyc0GkiUSoeXwaCV9Xcq4S3/K6h2I66W2vqSY7/2sCVORS0p9H4
         qpnHvruH5qfwL90iBeazW0+uvuCQC3FkcOoPq1wcbFwcjgO0ahdt7Er/CKJN+WA3rpfE
         ksyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zYVIAcP46mBovRvIjiIyOb4sMzl9vUVyWRtQ5DlC2HE=;
        b=qEIu1Plo7M/7hcAtLwWKcp87y6Ph5bJhsZFRIvdKBt0RfX/qrXhXFpK/JFoh9tLpRy
         pJLA9y4bIkoa2Pw+FpWGTHvtnw83GrHAOY7shDjdHlGVQS3oCfGIZkpXyuzNWwzvsZZE
         V146ei3EhGgH4ksTHQnX7NGbOp3e3z7Osw9qCdja2/NyzAt3IFK5LHlHYa1gpqXxAzcb
         So2XbVzmK/7R89bFXW6fxOeNp0ZgO8dzdp+Z0MgWC5s7Wg4HjiHJly2rV5Jr78uUrZMH
         tvNZn4BmfQHXs2oUVLDWutZJM/I4+VKW7HQLHfvVZemZDsHHaWetGNf1rh4AocH6yv+Z
         Zc5Q==
X-Gm-Message-State: ANhLgQ3nhFuP2hjdNvVe+exHKFQcqaSkOpWWxIqZH8h8kixdC4f8iEdL
        HqZEr1nR+hQEh/AvzxifGwJii/PzCu2jt8hfmJI=
X-Google-Smtp-Source: ADFU+vvtSnbTbhrGnIVPz/aPBDhgNMApXa+s6ADAPDMMLOcE5xb5AEcL/WW4jsG7PtytIuzw3Kwz3DKBW9bicoqQxG0=
X-Received: by 2002:a50:aca3:: with SMTP id x32mr7489596edc.368.1585218331157;
 Thu, 26 Mar 2020 03:25:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200325152209.3428-1-olteanv@gmail.com> <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter>
In-Reply-To: <20200326101752.GA1362955@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 26 Mar 2020 12:25:20 +0200
Message-ID: <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido,

On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
>
> Hi Vladimir,
>
> On Wed, Mar 25, 2020 at 05:22:09PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > In the initial attempt to add MTU configuration for DSA:
> >
> > https://patchwork.ozlabs.org/cover/1199868/
> >
> > Florian raised a concern about the bridge MTU normalization logic (when
> > you bridge an interface with MTU 9000 and one with MTU 1500). His
> > expectation was that the bridge would automatically change the MTU of
> > all its slave ports to the minimum MTU, if those slaves are part of the
> > same hardware bridge. However, it doesn't do that, and for good reason,
> > I think. What br_mtu_auto_adjust() does is it adjusts the MTU of the
> > bridge net device itself, and not that of any slave port.  If it were to
> > modify the MTU of the slave ports, the effect would be that the user
> > wouldn't be able to increase the MTU of any bridge slave port as long as
> > it was part of the bridge, which would be a bit annoying to say the
> > least.
> >
> > The idea behind this behavior is that normal termination from Linux over
> > the L2 forwarding domain described by DSA should happen over the bridge
> > net device, which _is_ properly limited by the minimum MTU. And
> > termination over individual slave device is possible even if those are
> > bridged. But that is not "forwarding", so there's no reason to do
> > normalization there, since only a single interface sees that packet.
> >
> > The real problem is with the offloaded data path, where of course, the
> > bridge net device MTU is ignored. So a packet received on an interface
> > with MTU 9000 would still be forwarded to an interface with MTU 1500.
> > And that is exactly what this patch is trying to prevent from happening.
>
> How is that different from the software data path where the CPU needs to
> forward the packet between port A with MTU X and port B with MTU X/2 ?
>
> I don't really understand what problem you are trying to solve here. It
> seems like the user did some misconfiguration and now you're introducing
> a policy to mitigate it? If so, it should be something the user can
> disable. It also seems like something that can be easily handled by a
> user space application. You get netlink notifications for all these
> operations.
>

Actually I think the problem can be better understood if I explain
what the switches I'm dealing with look like.
None of them really has a 'MTU' register. They perform length-based
admission control on RX. At this moment in time I don't think anybody
wants to introduce an MRU knob in iproute2, so we're adjusting that
maximum ingress length through the MTU. But it becomes an inverted
problem, since the 'MTU' needs to be controlled for all possible
sources of traffic that are going to egress on this port, in order for
the real MTU on the port itself to be observed.

Regards,
-Vladimir
