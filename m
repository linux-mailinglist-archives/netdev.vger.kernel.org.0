Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33213CEDB8
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 22:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358596AbhGSTaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 15:30:22 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:16127 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382878AbhGSRnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 13:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626719024;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=ClQ4hFI2ri15r2D64MGjX/QT1jx5PAs/tCwhga7iJjs=;
    b=IfpoGtfUWZUgkhl31pCMfcSD7eSFez5Y9J2OP18mqcnZ+K4xFCDoYUKFoDtTEQOAJi
    HEb7AUfp8DPUGnRlp3vK0FVstqXbr1glWCDgOqCvwonCed08bZ1jI72793zE4jmHQwdD
    IvYWx164Lc7O/uPNlcCcyC3hB+hC8GKh9SyGkAmov0gNqNp3LuryV4+Ew45zqZozjzXT
    NCS2MuSgZUkxcxCP9uUw/lJsaTiNLuc4bpOM+rSo2PLdOk2mw1fMj+hwRW6I5YudkdeW
    ijqilUc/SEQQTzoFWvaLU9eT40pDSvPXEyQ6/viWpCd68j/Y5weTOnnNX+BRsxhBauMI
    tGjw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u26zEodhPgRDZ8j4Icup"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id g02a44x6JINg63q
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 19 Jul 2021 20:23:42 +0200 (CEST)
Date:   Mon, 19 Jul 2021 20:23:29 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        MSM <linux-arm-msm@vger.kernel.org>, dmaengine@vger.kernel.org,
        DTML <devicetree@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht
Subject: Re: [RFC PATCH net-next 0/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
Message-ID: <YPXC7PDCUopdCdTV@gerhold.net>
References: <20210719145317.79692-1-stephan@gerhold.net>
 <CAOCk7NonuOKWrpr-MwdjAwF1F4jviEMf=c04vVBxQ-OmfY2b-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOCk7NonuOKWrpr-MwdjAwF1F4jviEMf=c04vVBxQ-OmfY2b-g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 09:43:27AM -0600, Jeffrey Hugo wrote:
> On Mon, Jul 19, 2021 at 9:01 AM Stephan Gerhold <stephan@gerhold.net> wrote:
> >
> > The BAM Data Multiplexer provides access to the network data channels
> > of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
> > or MSM8974. This series adds a driver that allows using it.
> >
> > For more information about BAM-DMUX, see PATCH 4/4.
> >
> > Shortly said, BAM-DMUX is built using a simple protocol layer on top of
> > a DMA engine (Qualcomm BAM DMA). For BAM-DMUX, the BAM DMA engine runs in
> > a quite strange mode that I call "remote power collapse", where the
> > modem/remote side is responsible for powering on the BAM when needed but we
> > are responsible to initialize it. The BAM is power-collapsed when unneeded
> > by coordinating power control via bidirectional interrupts from the
> > BAM-DMUX driver.
> 
> The hardware is physically located on the modem, and tied to the modem
> regulators, etc.  The modem has the ultimate "off" switch.  However,
> due to the BAM architecture (which is complicated), configuration uses
> cooperation on both ends.
> 

What I find strange is that it wasn't done similarly to e.g. Slimbus
which has a fairly similar setup. (I used that driver as inspiration for
how to use the mainline qcom_bam driver instead of the "SPS" from
downstream.)

Slimbus uses qcom,controlled-remotely together with the LPASS
remoteproc, so it looks like there LPASS does both power-collapse
and initialization of the BAM. Whereas here the modem does the
power-collapse but we're supposed to do the initialization.

> >
> > The series first adds one possible solution for handling this "remote power
> > collapse" mode in the bam_dma driver, then it adds the BAM-DMUX driver to
> > the WWAN subsystem. Note that the BAM-DMUX driver does not actually make
> > use of the WWAN subsystem yet, since I'm not sure how to fit it in there
> > yet (see PATCH 4/4).
> >
> > Please note that all of the changes in this patch series are based on
> > a fairly complicated driver from Qualcomm [1].
> > I do not have access to any documentation about "BAM-DMUX". :(
> 
> I'm pretty sure I still have the internal docs.
> 
> Are there specific things you want to know?

Oh, thanks a lot for asking! I mainly mentioned this here to avoid
in-depth questions about the hardware (since I can't answer those).

I can probably think of many, many questions, but I'll try to limit
myself to the two I'm most confused about. :-)


It's somewhat unrelated to this initial patch set since I'm not using
QMAP at the moment, but I'm quite confused about the "MTU negotiation
feature" that you added support for in [1]. (I *think* that is you,
right?) :)

The part that I somewhat understand is the "signal" sent in the "OPEN"
command from the modem. It tells us the maximum buffer size the modem
is willing to accept for TX packets ("ul_mtu" in that commit).

Similarly, if we send "OPEN" to the modem we make the modem aware
of our maximum RX buffer size plus the number of RX buffers.
(create_open_signal() function).

The part that is confusing me is the way the "dynamic MTU" is
enabled/disabled based on the "signal" in "DATA" commands as well.
(process_dynamic_mtu() function). When would that happen? The code
suggests that the modem might just suddenly announce that the large
MTU should be used from now on. But the "buffer_size" is only changed
for newly queued RX buffers so I'm not even sure how the modem knows
that it can now send more data at once.

Any chance you could clarify how this should work exactly?


And a second question if you don't mind: What kind of hardware block
am I actually talking to here? I say "modem" above but I just know about
the BAM and the DMUX protocol layer. I have also seen assertion failures
of the modem DSP firmware if I implement something incorrectly.

Is the DMUX protocol just some firmware concept or actually something
understood by some hardware block? I've also often seen mentions of some
"A2" hardware block but I have no idea what that actually is. What's
even worse, in a really old kernel A2/BAM-DMUX also appears as part of
the IPA driver [2], and I thought IPA is the new thing after BAM-DMUX...

Not sure how much you can reveal about this. :)

Thanks a lot!
Stephan

[1]: https://source.codeaurora.org/quic/la/kernel/msm-3.10/commit/?h=LA.BR.1.2.9.1-02310-8x16.0&id=c7001b82388129ee02ac9ae1a1ef9993eafbcb26
[2]: https://source.codeaurora.org/quic/la/kernel/msm/tree/drivers/platform/msm/ipa/a2_service.c?h=LA.BF.1.1.3-01610-8x74.0
