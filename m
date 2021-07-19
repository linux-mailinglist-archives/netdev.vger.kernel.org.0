Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95D93CD861
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 17:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243058AbhGSOV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 10:21:59 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:29110 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242651AbhGSOUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 10:20:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626706846;
    s=strato-dkim-0002; d=gerhold.net;
    h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=6MnR6L4mXMePcbKExrBmlzA/geD023b1awg39iUW1gY=;
    b=V5IXFQ1bkuRIcrEYRjBENZPC8IKTWeaZvEa2luLmj+ad5HrPjXIMoeeNFm8dZECwpz
    b4PVGmWLkjHMV5QDI/tiRtJsI22seZy8tonlBEWVz3SQMdL1PYx+NV1rKlcv+rPOaoLQ
    V/8y0XzqA12VAMWdmEMzqQjpWcCIEW47cl7d0YGAOwyL6JDHkSsboEE6fYD1XfLpJhh0
    g17xiXXNDxqFmk1jYJ1dDcDBWCqVn5HGXASgbA5+0npzvNKZg2DeN5A9xyscn/VCP0p9
    4GZFEpar4Q5v+vMxyjPSUmpVCSG28bjfAl530yPMWhDaTQhPmPWtGhNcM4uXSuMVBeTh
    L+mw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB4m6O43/v"
X-RZG-CLASS-ID: mo00
Received: from droid..
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id g02a44x6JF0g42g
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 19 Jul 2021 17:00:42 +0200 (CEST)
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
Subject: [RFC PATCH net-next 1/4] dt-bindings: dmaengine: bam_dma: Add remote power collapse mode
Date:   Mon, 19 Jul 2021 16:53:14 +0200
Message-Id: <20210719145317.79692-2-stephan@gerhold.net>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719145317.79692-1-stephan@gerhold.net>
References: <20210719145317.79692-1-stephan@gerhold.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, the BAM DMA controller is set up by a remote
processor and the local processor can simply start making use of it
without setting up the BAM. This is already supported using the
"qcom,controlled-remotely" property.

However, for some reason another possible configuration is that the
remote processor is responsible for powering up the BAM, but we are
still responsible for initializing it (e.g. resetting it etc). Add
a "qcom,remote-power-collapse" property to describe that configuration.

Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
NOTE: This is *not* a compile-time requirement for the BAM-DMUX driver
      so this could also go through the dmaengine tree.

Also note that there is an ongoing effort to convert these bindings
to DT schema but sadly there were not any updates for a while. :/
https://lore.kernel.org/linux-arm-msm/20210519143700.27392-2-bhupesh.sharma@linaro.org/
---
 Documentation/devicetree/bindings/dma/qcom_bam_dma.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
index cf5b9e44432c..362a4f0905a8 100644
--- a/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
+++ b/Documentation/devicetree/bindings/dma/qcom_bam_dma.txt
@@ -15,6 +15,8 @@ Required properties:
   the secure world.
 - qcom,controlled-remotely : optional, indicates that the bam is controlled by
   remote proccessor i.e. execution environment.
+- qcom,remote-power-collapse : optional, indicates that the bam is powered up by
+  a remote processor but must be initialized by the local processor.
 - num-channels : optional, indicates supported number of DMA channels in a
   remotely controlled bam.
 - qcom,num-ees : optional, indicates supported number of Execution Environments
-- 
2.32.0

