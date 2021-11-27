Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CC64600A3
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 18:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355515AbhK0Rrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 12:47:47 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:9000 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239269AbhK0Rpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 12:45:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1638034590;
    s=strato-dkim-0002; d=gerhold.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=Xzv17N3CDQDDrbPVHlU8qZQIuDU6u6Dr5h5Df6SE3wA=;
    b=B9rXyFw8uHwexIUdODY87ISEyGmWSrdi5PPnVJ4qqlP8y+aNEgvaLMBljoN4uwaVCL
    T7HfDYzPFUCcsYDe6Q/n1X1A4xhCSqdVnYhTetRmRU48XXG6x/ydlHnFRqfNtY3P2DoY
    Fv3B4G1lWoc3BSXKuqlrh2EJffSWCVmLV4Nxn7Qq4hNc8dO4hsW/RUT6SZp9fEW7dwl6
    kk37etvM3Q43LJvQduG/1WjECmkN5q+2HiYsVVXJ4mn876bt9n/2KlbQFVL4YH7q4+lH
    SbeqJdUrLb8DGMvjbJyW5zirOpdcdJKRgVMGLri+pCMsNnQ7RoG9V/2W1z9CCJp1/ByG
    Qflg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXQ7UOGqRde+a0fiL/b+s="
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.34.10 AUTH)
    with ESMTPSA id j03bcbxARHaTFuH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 27 Nov 2021 18:36:29 +0100 (CET)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        phone-devel@vger.kernel.org, ~postmarketos/upstreaming@lists.sr.ht,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        Stephan Gerhold <stephan@gerhold.net>
Subject: [PATCH net-next v3 0/2] net: wwan: Add Qualcomm BAM-DMUX WWAN network driver
Date:   Sat, 27 Nov 2021 18:31:06 +0100
Message-Id: <20211127173108.3992-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BAM Data Multiplexer provides access to the network data channels
of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
or MSM8974. This series adds a driver that allows using it.

All the changes in this patch series are based on a quite complicated
driver from Qualcomm [1]. The driver has been used in postmarketOS [2]
on various smartphones/tablets based on Qualcomm MSM8916 and MSM8974
for more than a year now with no reported problems. It works out of
the box with open-source WWAN userspace such as ModemManager.

[1]: https://source.codeaurora.org/quic/la/kernel/msm-3.10/tree/drivers/soc/qcom/bam_dmux.c?h=LA.BR.1.2.9.1-02310-8x16.0
[2]: https://postmarketos.org/

---
Changes in v3:
  - Clarify DT schema based on discussion
  - Drop bam_dma/dmaengine patches since they already landed in 5.16
  - Rebase on net-next
  - Simplify cover letter and commit messages

Changes in v2:
  - Rename "qcom,remote-power-collapse" -> "qcom,powered-remotely"
  - Rebase on net-next and fix conflicts
  - Rename network interfaces from "rmnet%d" -> "wwan%d"
  - Fix wrong file name in MAINTAINERS entry

Stephan Gerhold (2):
  dt-bindings: net: Add schema for Qualcomm BAM-DMUX
  net: wwan: Add Qualcomm BAM-DMUX WWAN network driver

 .../bindings/net/qcom,bam-dmux.yaml           |  92 ++
 MAINTAINERS                                   |   8 +
 drivers/net/wwan/Kconfig                      |  13 +
 drivers/net/wwan/Makefile                     |   1 +
 drivers/net/wwan/qcom_bam_dmux.c              | 907 ++++++++++++++++++
 5 files changed, 1021 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/qcom,bam-dmux.yaml
 create mode 100644 drivers/net/wwan/qcom_bam_dmux.c

-- 
2.34.1

