Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4DF3EAB56
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbhHLTvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236112AbhHLTvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:51:09 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6378CC0613A4
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:43 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id w6so3333921ill.3
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 12:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QSpci64/hMqy88Q22faTec2s8wp9JGPuRuA3v3rI9YQ=;
        b=P3PRMZs3/UXYGNdQf6SaCtATu/V7phGy1FxQf7KjkvhAxxvjN3hT//M8K4o4ZBQ7Fq
         3dHx2dIcLC6jIsftPgWyWs4noXGATMniiRJxxFAbN+j8t+TDnsM0qUHYoiPwh2EVwWo/
         ud4rYqKOEe1v1AjP4t4lIJ2aLiAcK90QyRTg5+/+EAwD/DhNv65eQwPX7XPjsJAn3Hnd
         HPvYsAR4a2STwLpB2581d7NsTAR83QTdTPApN1cOmTWAq78WAkIrlbQytKTiVPEY4q22
         QandDbjzdrgMHQyogapKm+tDPg3OG8Ppe80H/y0rLEo/erFfc63hrdVTULUsJnEeMXXF
         cb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QSpci64/hMqy88Q22faTec2s8wp9JGPuRuA3v3rI9YQ=;
        b=tLzOx5YgGIUexDTNesWNDzeEj0XJp+CN0M2MnLKOt+oqnph1cVBIpSaGcjdPajpHbN
         fIxk3v3Wh5xuvYEWQUT++UxPbY+uV2kp0WA167tlLo8lxWwwxOnT+OFK7cVpNHbBppdG
         lpfx/iqqeOIa+qm3j11fGZZhVOv5iMlEvKD/ShtfJa0d0NBCr5h9IXvJ0rj6tAsoggvk
         psHEs0KFIAlYun2JGC/tkqFP8+uwbJIjIUvOZC2fguO4wbPaOhTe0zjdmtQ2V1YgWgVW
         qCtPGz1g/ze7I/1OH7Vqoa3zn1o7rTGrUPBg2KEVdc+FZMi+9IeHEB2RGkjPASpbJlJM
         KqQQ==
X-Gm-Message-State: AOAM532b4AV+1EzRXOkm4pFAjumkjwmwVaHpjo3daV3SvlQXu93bysmg
        gaKG+pt1p3h2sYsKZcX1JsRgKA==
X-Google-Smtp-Source: ABdhPJxdTlMj27RouCNABii+wKYviIwvoHaqmPVm9lPO4xCIx7uNnSQbqY0w+GPM1/qc5YTQtlwa6w==
X-Received: by 2002:a92:d18c:: with SMTP id z12mr176696ilz.295.1628797842839;
        Thu, 12 Aug 2021 12:50:42 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s16sm2058821iln.5.2021.08.12.12.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 12:50:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: don't stop TX on suspend
Date:   Thu, 12 Aug 2021 14:50:34 -0500
Message-Id: <20210812195035.2816276-6-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210812195035.2816276-1-elder@linaro.org>
References: <20210812195035.2816276-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we stop the modem netdev transmit queue when suspending
the hardware.  For system suspend this ensured we'd never attempt
to transmit while attempting to suspend the modem endpoints.

For runtime suspend, the IPA hardware might get suspended while the
system is operating.  In that case we want an attempt to transmit a
packet to cause the hardware to resume if necessary.  But if we
disable the queue this cannot happen.

So stop disabling the queue on suspend.  In case we end up disabling
it in ipa_start_xmit() (see the previous commit), we still arrange
to start the TX queue on resume.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index aa1b483d9f7db..b176910d72868 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -214,8 +214,6 @@ void ipa_modem_suspend(struct net_device *netdev)
 	if (!(netdev->flags & IFF_UP))
 		return;
 
-	netif_stop_queue(netdev);
-
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	ipa_endpoint_suspend_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 }
-- 
2.27.0

