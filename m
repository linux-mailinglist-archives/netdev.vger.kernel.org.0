Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBB0D42925D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 16:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244146AbhJKOo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 10:44:27 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:29120 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243934AbhJKOoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 10:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1633963327;
    s=strato-dkim-0002; d=gerhold.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=xSsNGdNQB08KyOhFukELZ4y35yt3el1uuyG09AFN9Gw=;
    b=UTq16JQObMxCVxmJy5Bblpbus46OFB8i+8sbv1hd/0iZD95z63xQOSYII3Fj+3uUVS
    h+F2mYFivYcakD/T+6MMLm/v6SsunRjx33iF/d9JRYAX3FiP/wWFwyRiI9niJ4Of9tat
    ClsruDZsFkxwVt4bNXP3P7vo4V4MrZ7TElzrjg83QV+s7PQipEjQI7KWjXqYcCvv5H7b
    /mjHkKlHBzuTmh/AFKzqk9rxqTl3ogFR2mkScG6CvROmZekn/PnIsXuik7diVALyT+0l
    B2jQwp+sk7vRwzllBomZG251qnwOsXNTZmypLQ57bSHrvnUg3bi4cCAY7/ZrPqvyRbnx
    yGsQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXTbAOHjRHIhr3eFeIrw=="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.33.8 SBL|AUTH)
    with ESMTPSA id 301038x9BEg3tv6
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 11 Oct 2021 16:42:03 +0200 (CEST)
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
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v2 0/4] net: wwan: Add Qualcomm BAM-DMUX WWAN network driver
Date:   Mon, 11 Oct 2021 16:17:32 +0200
Message-Id: <20211011141733.3999-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BAM Data Multiplexer provides access to the network data channels
of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
or MSM8974. This series adds a driver that allows using it.

For more information about BAM-DMUX, see PATCH 4/4.

Shortly said, BAM-DMUX is built using a simple protocol layer on top of
a DMA engine (Qualcomm BAM DMA). For BAM-DMUX, the BAM DMA engine runs in
a special mode where the modem/remote side is responsible for powering
on the BAM when needed but we are responsible to initialize it.
The BAM is powered off when unneeded by coordinating power control
via bidirectional interrupts from the BAM-DMUX driver.

The series first adds one possible solution for handling the "powered
remotely" mode in the bam_dma driver, then it adds the BAM-DMUX driver.
In combination with the RPMSG_WWAN_CTRL driver the WWAN control ports
(QMI/AT) are exposed via the WWAN subsystem. However, the driver does
not currently make use of the link management of the WWAN subsystem.
Unifying the link management for the many different Qualcomm modem
setups is a huge undertaking that I believe is better addressed
separately. I discuss this in detail in PATCH 4/4.

All the changes in this patch series are based on a fairly complicated
driver from Qualcomm [1]. I do not have access to documentation about
"BAM-DMUX", although Jeffrey Hugo has shared many helpful insights
about the creation process of BAM-DMUX [2].

The driver has been used in postmarketOS [3] on various smartphones/tablets
based on Qualcomm MSM8916 and MSM8974 for more than a year now with
no reported problems. It works out of the box with ModemManager and only
requires minor changes in oFono (in particular since it does not support
WWAN control ports, e.g. /dev/wwan0qmi0 yet).

Changes in v2:
  - Rename "qcom,remote-power-collapse" -> "qcom,powered-remotely"
  - Rebase on net-net and fix conflicts
  - Rename network interfaces from "rmnet%d" -> "wwan%d"
  - Fix wrong file name in MAINTAINERS entry

[1]: https://source.codeaurora.org/quic/la/kernel/msm-3.10/tree/drivers/soc/qcom/bam_dmux.c?h=LA.BR.1.2.9.1-02310-8x16.0
[2]: https://lore.kernel.org/netdev/e37868ee-2bd0-3b50-eb95-8eb2bf32d956@quicinc.com/
[3]: https://postmarketos.org/

Stephan Gerhold (4):
  dt-bindings: dmaengine: bam_dma: Add "powered remotely" mode
  dmaengine: qcom: bam_dma: Add "powered remotely" mode
  dt-bindings: net: Add schema for Qualcomm BAM-DMUX
  net: wwan: Add Qualcomm BAM-DMUX WWAN network driver

 .../devicetree/bindings/dma/qcom_bam_dma.txt  |   2 +
 .../bindings/net/qcom,bam-dmux.yaml           |  87 ++
 MAINTAINERS                                   |   8 +
 drivers/dma/qcom/bam_dma.c                    |  88 +-
 drivers/net/wwan/Kconfig                      |  13 +
 drivers/net/wwan/Makefile                     |   1 +
 drivers/net/wwan/qcom_bam_dmux.c              | 907 ++++++++++++++++++
 7 files changed, 1074 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
 create mode 100644 drivers/net/wwan/qcom_bam_dmux.c

-- 
2.33.0

