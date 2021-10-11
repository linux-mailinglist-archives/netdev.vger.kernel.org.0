Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959FC429292
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239105AbhJKOxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:53:23 -0400
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.100]:25177 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237236AbhJKOxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1633963878;
    s=strato-dkim-0002; d=gerhold.net;
    h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:Cc:Date:
    From:Subject:Sender;
    bh=aPdmmwfYu/N36PdvoMDHm+Iisa38vvvxbSOQGVHHG6g=;
    b=hysDLpUK0e3i+XAmX6jEtAm6OHSn0BkbUgWTKMx2O+hLf1/HFXG4N+YlOqA1++q9K9
    9VypPwlmRDRj2QtoxGR1KV0U3/RMkEzznebsLIvg0NfI6VndELQFZjIBEywO+jnvpTmC
    bXrt0vNHJw5rQRq2i6/l1xknV+ZbdboDyK7uYoqU/wH9PwEeAwQRU6GHw0dwKaJeWX8Z
    JPU+AdDnQ5Yvd4/kg3vXI71/85u+VPDr4BCN7xY3UvbPUP4r1YCwjbNeGvuT01KmmYbZ
    MqRQ4LeiPcJS9iveUS9OL/LtaovD/lafUg8r1owsLdbUt7UfVaSLgerq8vDSDRS6Rhnh
    yAVw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u261EJF5OxJD4pSA8p7h"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
    by smtp.strato.de (RZmta 47.33.8 SBL|AUTH)
    with ESMTPSA id 301038x9BEpItxG
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 11 Oct 2021 16:51:18 +0200 (CEST)
Date:   Mon, 11 Oct 2021 16:51:10 +0200
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Subject: Re: [PATCH net-next v2 4/4] net: wwan: Add Qualcomm BAM-DMUX WWAN
 network driver
Message-ID: <YWRPXnzh+NLVqHvo@gerhold.net>
References: <20211011141733.3999-1-stephan@gerhold.net>
 <20211011141733.3999-5-stephan@gerhold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011141733.3999-5-stephan@gerhold.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 04:17:36PM +0200, Stephan Gerhold wrote:
> The BAM Data Multiplexer provides access to the network data channels of
> modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916 or
> MSM8974. It is built using a simple protocol layer on top of a DMA engine
> (Qualcomm BAM) and bidirectional interrupts to coordinate power control.
> 
> The modem announces a fixed set of channels by sending an OPEN command.
> The driver exports each channel as separate network interface so that
> a connection can be established via QMI from userspace. The network
> interface can work either in Ethernet or Raw-IP mode (configurable via
> QMI). However, Ethernet mode seems to be broken with most firmwares
> (network packets are actually received as Raw-IP), therefore the driver
> only supports Raw-IP mode.
> 
> Note that the control channel (QMI/AT) is entirely separate from
> BAM-DMUX and is already supported by the RPMSG_WWAN_CTRL driver.
> 
> The driver uses runtime PM to coordinate power control with the modem.
> TX/RX buffers are put in a kind of "ring queue" and submitted via
> the bam_dma driver of the DMAEngine subsystem.
> 
> The basic architecture looks roughly like this:
> 
>                    +------------+                +-------+
>          [IPv4/6]  |  BAM-DMUX  |                |       |
>          [Data...] |            |                |       |
>         ---------->|wwan0       | [DMUX chan: x] |       |
>          [IPv4/6]  | (chan: 0)  | [IPv4/6]       |       |
>          [Data...] |            | [Data...]      |       |
>         ---------->|wwan1       |--------------->| Modem |
>                    | (chan: 1)  |      BAM       |       |
>          [IPv4/6]  | ...        |  (DMA Engine)  |       |
>          [Data...] |            |                |       |
>         ---------->|wwan7       |                |       |
>                    | (chan: 7)  |                |       |
>                    +------------+                +-------+
> 
> However, on newer SoCs/firmware versions Qualcomm began gradually moving
> to QMAP (rmnet driver) as backend-independent protocol for multiplexing
> and data aggegration. Some firmware versions allow using QMAP on top of
> BAM-DMUX (effectively resulting in a second multiplexing layer plus data
> aggregation). The architecture with QMAP would look roughly like this:
> 
>            +-------------+           +------------+                  +-------+
>  [IPv4/6]  |    RMNET    |           |  BAM-DMUX  |                  |       |
>  [Data...] |             |           |            | [DMUX chan: 0]   |       |
> ---------->|rmnet_data1  |     ----->|wwan0       | [QMAP mux-id: x] |       |
>            | (mux-id: 1) |     |     | (chan: 0)  | [IPv4/6]         |       |
>            |             |     |     |            | [Data...]        |       |
>  [IPv4/6]  | ...         |------     |            |----------------->| Modem |
>  [Data...] |             |           |            |       BAM        |       |
> ---------->|rmnet_data42 | [QMAP: x] |[wwan1]     |   (DMA Engine)   |       |
>            | (mux-id: 42)| [IPv4/6]  |... unused! |                  |       |
>            |             | [Data...] |[wwan7]     |                  |       |
>            |             |           |            |                  |       |
>            +-------------+           +------------+                  +-------+
> 
> In this case, wwan1-7 would remain unused. The firmware used on the most
> recent SoCs with BAM-DMUX even seems to announce only a single BAM-DMUX
> channel (wwan0), which makes QMAP the only option for multiplexing there.
> 
> However, so far the driver is mainly tested without QMAP, on various
> smartphones/tablets based on Qualcomm MSM8916/MSM8974. It looks like QMAP
> depends on a MTU negotiation feature in BAM-DMUX which is not supported yet.
> 
> Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> ---
> Note that this is my first network driver, so I apologize in advance
> if I made some obvious mistakes. :)
> 
> Changes since RFC:
>   - Rebase on net-next and fix conflicts
>   - Rename network interfaces from "rmnet%d" -> "wwan%d"
>   - Fix wrong file name in MAINTAINERS entry
>   - Clarify control channel in commit message. (It is entirely independent
>     of BAM-DMUX and is already supported by the RPMSG WWAN CTRL driver.)
> 
> Like in the RFC version [1], the driver does not currently use the link
> management of the WWAN subsystem. Instead, it simply exposes one network
> interface for each of the up to 8 channels.
> 
> This setup works out of the box with all available open-source userspace
> WWAN implementations, especially ModemManager (no changes needed).
> oFono works too although it requires minor changes to support WWAN control
> ports (/dev/wwan0qmi0) which are independent of BAM-DMUX (already provided
> by the "rpmsg_wwan_ctrl" driver).
> It was easy to support because the setup is very similar to ones already
> supported for USB modems. Some of them provide multiple network interfaces
> and ModemManager can bundle them together to a single modem.
> 
> I believe it is best to keep this setup as-is for now and not add even
> more complexity to userspace with another setup that works only in this
> particular configuration. I will reply to this patch separately to explain
> that a bit more clearly. This patch is already long enough as-is. :)
> 
> [1]: https://lore.kernel.org/netdev/20210719145317.79692-5-stephan@gerhold.net/
>

The main goal of the WWAN link management is to make the multiplexing
setup transparent to userspace. Unfortunately it's still unclear to me
how or even if this can be achieved for the many different different
setups that exist for Qualcomm modems. To show that more clearly I'll
"briefly" list the various currently supported setups in ModemManager
(there might be even more that I am not even aware of).

The details are not too important, this list only exists to show the
complexity that is already handled in ModemManager:

Control ports (QMI/AT/MBIM):
 *1. Preferred: WWAN subsystem control port (chardev)*
     - cdc-wdm
     - rpmsg_wwan_ctrl (most common setup for BAM-DMUX)
     - mhi_wwan_ctrl
  2. QRTR network sockets (net/qrtr) on newer Qualcomm SoCs
     (most common setup for IPA (drivers/net/ipa)
 (3. Legacy: Driver-specific char devices)
     - cdc-wdm usbmisc chardev
     - rpmsg-char

Network interfaces:
 *1. Preferred: WWAN subsystem link management*
     - mhi_wwan_mbim (only for MHI+MBIM, not MHI+QMI)
     - (iosm, but that's not Qualcomm)
  2. Single/multiple exposed network interfaces
     - USB modems
     - qcom_bam_dmux (this patch)
  3. qmimux (built-in multiplexing of qmi_wwan driver)
     - qmi_wwan
  4. "rmnet" links created via netlink, works on top of:
     Note: Various different "rmnet" versions and configurations
           exist that need to be configured appropriately.
     - qmi_wwan, optional
     - IPA (drivers/net/ipa), always required
     - qcom_bam_dmux, optional
       (supported only on very recent firmware versions/SoCs)

ModemManager already provides an unified API for all these in userspace.
The goal for the WWAN subsystem would be to unify all these approaches
in the kernel, to simplify userspace.

We have *partially* achieved this for the QMI/AT control ports where
there are multiple backends with the same frontend now (USB cdc-wdm,
RPMSG, MHI). But not fully, new Qualcomm SoCs require controlling the
modem via QRTR network sockets and I'm not sure if this can be mapped to
the WWAN subsystem chardevs. The "partially" means that userspace still
needs to support multiple approaches, and usually needs to keep
supporting old approaches for compatibility with old kernels anyway.

And for the network interfaces it is even more unclear to me if
there is a good way to abstract those transparently to userspace.
The QMI configuration that is currently done in userspace is quite
specific to hardware/firmware version [2].

Sergey suggested to address some of these points by moving the
QMI setup to the the kernel [3]. Unfortunately, this comes with a lot of
complexity, which is why this was purposefully left up to userspace when
the qmi_wwan driver (for USB modems) was added to the kernel [4].

All in all, I believe finding a solution that can cover all the setups
listed above is a huge undertaking, for both kernel and userspace.
It goes way beyond the scope of this patch and is therefore better
addressed separately.

This is why I think it's best to keep the current setup in this patch
for now (which is already supported by userspace!), and investigate
unifying the interface separately.

Thanks for reading. :)
Stephan

[2]: https://lore.kernel.org/netdev/YPmRcBXpRtKKSDl8@gerhold.net/
[3]: https://lore.kernel.org/netdev/CAHNKnsQr4Ys8q3Ctru-H=L3ZDwb__2D3E08mMZchDLAs1KetAg@mail.gmail.com/
[4]: https://lore.kernel.org/netdev/CAAP7ucLDEoJzwNvWLCWyCNE+kKBDn4aBU-9XT_Uv_yetnX4h-g@mail.gmail.com/
