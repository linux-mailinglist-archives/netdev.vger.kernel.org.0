Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C8E2EBC43
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbhAFKUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:20:34 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.23]:31229 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAFKUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:20:34 -0500
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Jan 2021 05:20:31 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1609928200;
        s=strato-dkim-0002; d=gerhold.net;
        h=Message-Id:Date:Subject:Cc:To:From:From:Subject:Sender;
        bh=8KxY5irpQ097A3tAvailqc8mDIM3gs4oskLSe6ZDz8I=;
        b=XaHhbf1VmsvRMr9JxQlYIb31hPZZsR8fMsnTFqxW6DYKv+WsrQLElDrhhtD2cs07tp
        ZU1RK1he4ywBs5KFjM+1KU1ZfmUqlENxKOHy3/FIS6hdSSIP6GjVkcqkTksyrMbrEUTj
        2wvGZGoIzKVVTygQq7kBlI1KPJHfX55Jf5yBoE6SQ+goTGJNacXjreCuMmwhZiu9ihTb
        vvaQH7RK6JVFmiv93ATujdCkEH2mbwgIRz5ZqenyCUG8laKFqZcHvGj3Mx1X9SUuQzFx
        o19T250pab1cRZuHnNwxThH1mj48bw3HeKgiNyG/0sO6g0LtVc6BV0mdARTkq9uzO9r5
        zx+g==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVORvLd4SsytBXS7IYBkLahKxB5G6JlrU="
X-RZG-CLASS-ID: mo00
Received: from droid..
        by smtp.strato.de (RZmta 47.10.7 DYNA|AUTH)
        with ESMTPSA id e09c6dx06A8U54B
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 6 Jan 2021 11:08:30 +0100 (CET)
From:   Stephan Gerhold <stephan@gerhold.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, aleksander@aleksander.es,
        andrewlassalle@chromium.org, Stephan Gerhold <stephan@gerhold.net>,
        Alex Elder <elder@kernel.org>
Subject: [PATCH net] net: ipa: modem: add missing SET_NETDEV_DEV() for proper sysfs links
Date:   Wed,  6 Jan 2021 11:07:55 +0100
Message-Id: <20210106100755.56800-1-stephan@gerhold.net>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment it is quite hard to identify the network interface
provided by IPA in userspace components: The network interface is
created as virtual device, without any link to the IPA device.
The interface name ("rmnet_ipa%d") is the only indication that the
network interface belongs to IPA, but this is not very reliable.

Add SET_NETDEV_DEV() to associate the network interface with the
IPA parent device. This allows userspace services like ModemManager
to properly identify that this network interface is provided by IPA
and belongs to the modem.

Cc: Alex Elder <elder@kernel.org>
Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
---
 drivers/net/ipa/ipa_modem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index e34fe2d77324..9b08eb823984 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -216,6 +216,7 @@ int ipa_modem_start(struct ipa *ipa)
 	ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]->netdev = netdev;
 	ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]->netdev = netdev;
 
+	SET_NETDEV_DEV(netdev, &ipa->pdev->dev);
 	priv = netdev_priv(netdev);
 	priv->ipa = ipa;
 
-- 
2.30.0

