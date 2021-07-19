Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6873CD838
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 17:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242859AbhGSOVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 10:21:13 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:11923 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242638AbhGSOUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 10:20:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626706842;
    s=strato-dkim-0002; d=gerhold.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=5asqN0lZNo3xHl1CBAymxXSuEQ1yqbDJbz4DcdRrSLk=;
    b=J9E+jk/CxpvlIzVoB/gE8iHadnpWEZV9qry2QxLZXyEkGS7q4EgvuV9EjmJIRSVpem
    KeFT3hGVQ6Tj9uCV5zEIE4TqdyV1AFUiM1Hry1Fof7HFo6pNjNOKae5EmecnZ5+DHFRR
    ayD0gafOmrrg9Tl82I/2xmSaciITVipVQU0LdlBaii+/6w2b6rTJhsuWVkp0VzmKK7rG
    dTJed3H6EXEJof3peozzJWgjGwHDCJzXg4ijsslOKUowXCcsU+33yb0ApAwQvyh3ituP
    mZAduTazt+061IzKtbWUOfzTOpzboSLhVsM4fQ9uDmPy2jSNB0JIeCcoNojLHFrxacBP
    Fy9g==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB4m6O43/v"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id g02a44x6JF0c42H
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 19 Jul 2021 17:00:38 +0200 (CEST)
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
Subject: [RFC PATCH net-next 0/4] net: wwan: Add Qualcomm BAM-DMUX WWAN network driver
Date:   Mon, 19 Jul 2021 16:53:13 +0200
Message-Id: <20210719145317.79692-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
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
a quite strange mode that I call "remote power collapse", where the
modem/remote side is responsible for powering on the BAM when needed but we
are responsible to initialize it. The BAM is power-collapsed when unneeded
by coordinating power control via bidirectional interrupts from the
BAM-DMUX driver.

The series first adds one possible solution for handling this "remote power
collapse" mode in the bam_dma driver, then it adds the BAM-DMUX driver to
the WWAN subsystem. Note that the BAM-DMUX driver does not actually make
use of the WWAN subsystem yet, since I'm not sure how to fit it in there
yet (see PATCH 4/4).

Please note that all of the changes in this patch series are based on
a fairly complicated driver from Qualcomm [1].
I do not have access to any documentation about "BAM-DMUX". :(

The driver has been used in postmarketOS [2] on various smartphones/tablets
based on Qualcomm MSM8916 and MSM8974 for a year now with no reported
problems.

At runtime (but not compile-time), the following two patches are needed
additionally for full functionality:
  - https://lore.kernel.org/linux-arm-msm/20210712135703.324748-1-stephan@gerhold.net/
  - https://lore.kernel.org/linux-arm-msm/20210712135703.324748-2-stephan@gerhold.net/

[1]: https://source.codeaurora.org/quic/la/kernel/msm-3.10/tree/drivers/soc/qcom/bam_dmux.c?h=LA.BR.1.2.9.1-02310-8x16.0
[2]: https://postmarketos.org/

Stephan Gerhold (4):
  dt-bindings: dmaengine: bam_dma: Add remote power collapse mode
  dmaengine: qcom: bam_dma: Add remote power collapse mode
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
2.32.0

