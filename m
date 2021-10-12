Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE81042A02B
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 10:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235257AbhJLIpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 04:45:51 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:27806 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbhJLIpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 04:45:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1634028224;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=oICanehRZg82dw1asdlmnqvCvX+rTSrsFz+ERtaRocs=;
    b=rprOtrQPIFnqkl88wQKIIwGK3SFmMXfPbv6xeqppPdZCUJuPmgI4YJAUg7Zv+i8Xv1
    RjYv8H6vcHm9g6b7t32IuaHr/MGF1RfJp33oXlx9N54DMRJ+3Ureb30gBMLKUYw7d/D/
    I7QLwUTjFkND2TKilcMuhbhz9wdE/o55D010a3pQMIsKjC21tx/XM6/EVXBl38hEecmm
    vIZKBsW6u7RN6yXpD0cg0PKWSJ5zpfec+fndNjNgkjoyXrkz5CZ5bOL4Nx8L5UKgBzyW
    p1r99V2AFCFJpVScUlpoHIRFkk/tKOVv2ytVfBOvs7Yq/4aLArb/+O8MiwH6jwn6Vt4O
    EhbA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u261EJF5OxJD4pSA8p7h"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.33.8 SBL|AUTH)
    with ESMTPSA id 301038x9C8hgyWn
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 12 Oct 2021 10:43:42 +0200 (CEST)
Date:   Tue, 12 Oct 2021 10:43:41 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        dmaengine@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
Message-ID: <YWVKvTzohFCaZalj@gerhold.net>
References: <20211011141733.3999-1-stephan@gerhold.net>
 <20211011141733.3999-5-stephan@gerhold.net>
 <YWRPXnzh+NLVqHvo@gerhold.net>
 <CAMZdPi8G5wtcAxTYfzwdJVMauEx+5wk7eqP9VX9QaVqrzsZkEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMZdPi8G5wtcAxTYfzwdJVMauEx+5wk7eqP9VX9QaVqrzsZkEw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 09:55:48AM +0200, Loic Poulain wrote:
> Hi Stephan,
> 
> On Mon, 11 Oct 2021 at 16:51, Stephan Gerhold <stephan@gerhold.net> wrote:
> > > Like in the RFC version [1], the driver does not currently use the link
> > > management of the WWAN subsystem. Instead, it simply exposes one network
> > > interface for each of the up to 8 channels.
> > >
> > > This setup works out of the box with all available open-source userspace
> > > WWAN implementations, especially ModemManager (no changes needed).
> > > oFono works too although it requires minor changes to support WWAN control
> > > ports (/dev/wwan0qmi0) which are independent of BAM-DMUX (already provided
> > > by the "rpmsg_wwan_ctrl" driver).
> > > It was easy to support because the setup is very similar to ones already
> > > supported for USB modems. Some of them provide multiple network interfaces
> > > and ModemManager can bundle them together to a single modem.
> > >
> > > I believe it is best to keep this setup as-is for now and not add even
> > > more complexity to userspace with another setup that works only in this
> > > particular configuration. I will reply to this patch separately to explain
> > > that a bit more clearly. This patch is already long enough as-is. :)
> > >
> > > [1]: https://lore.kernel.org/netdev/20210719145317.79692-5-stephan@gerhold.net/
> > >
> >
> > The main goal of the WWAN link management is to make the multiplexing
> > setup transparent to userspace. Unfortunately it's still unclear to me
> > how or even if this can be achieved for the many different different
> > setups that exist for Qualcomm modems. To show that more clearly I'll
> > "briefly" list the various currently supported setups in ModemManager
> > (there might be even more that I am not even aware of).
> 
> The goal is also to have a common hierarchy, with the network link
> being a child of the WWAN device, as for the control ports. Making it
> easier for the user side to find the relation between all these
> devices. Moreover, it allows having a common set of attributes, like
> the LINK ID, and possibly new ones in the future. I mean it's probably
> fine if you create a static set of network devices and do not support
> dynamic link creation, but I think they should be created in some way
> via the WWAN subsystem, and get the same attributes (link id), we can
> have special meaning link ids (-1) for e.g. non context specific
> netdevs (e.g. for rmnet/qmap transport iface).
> 

At the moment, my driver makes the link IDs available via "dev_port".
I think this was also suggested for the WWAN subsystem at some point. [1]

If we skip the dynamic link creation as a first step, but want to create
the network device below the WWAN parent device, the main problem that
remains is that there is currently no good way to get the driver that
provides the network interfaces. The common WWAN parent device in my
case is the device that represents the modem remote processor, but this
is not enough to identify "bam-dmux".

Userspace needs to know which driver it is dealing with to set up the
multiplexing correctly via QMI. (The QMI message is different for
BAM-DMUX and e.g. rmnet).

I guess if the goal is only to have a common hierarchy (and not
necessarily to have multiplexing entirely transparent to userspace),
it is not too bad to make the driver that provides the ports somehow
available to userspace. Perhaps via some extra sysfs attribute.
What do you think?

Also note that a common hierarchy for all configurations is not possible
unless someone finds a solution to integrate the QRTR network sockets
into the WWAN subsystem. This is primarily relevant for the IPA driver,
but there are some SoCs with QRTR + BAM-DMUX as well. This will only
work in my case because I only work on "older" SoCs where QMI can still
go via the RPMSG_WWAN_CTRL driver.

Thanks,
Stephan

[1]: https://lore.kernel.org/netdev/CAMZdPi_e+ibRQiytAYkjo1A9GzLm6Np6Tma-6KMHuWfFcaFsCg@mail.gmail.com/
