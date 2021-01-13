Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB5B2F50DB
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbhAMRQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:16:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbhAMRQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:16:58 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB72FC0617AA
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:42 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u26so5667790iof.3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ne5Zo1fGRu2iVcYjOo63CG/Ih5OIPi4+1L9+3+54RU=;
        b=sbTiZViyBdcIcY4TVKLFp8dMDvOB4aVI4mbfI/SnTr0qjNrxX70pM1g+vz1sNk3GQG
         5ua75OuvAWyvNffK2SnKjyBQXPEGehG9YcSDUTb25W9uXNlJeR9g0K+1w/Mw2hoB0ul9
         qK88hj4K0F35DtHh+Jpkuo9fZmHGbiFCH1amd5EuGFa6HY1PuQi0fVy9m6vVOjpFLn+6
         gw4JytVhDzdpgtnmLZzm0ujlTRNebECGbuGasjItPUm3gR0Mwxd4iGAzNTUT5FlIUOfB
         304dS++1ksF9IFYEXKGfWJ23OtEArnIjaE+4WrwsHPQEHbpqKEBMIF1D0ut470lXDoj+
         JCLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ne5Zo1fGRu2iVcYjOo63CG/Ih5OIPi4+1L9+3+54RU=;
        b=bn4oSlSBeleyjj1fs3k8FVA3QXSEo8pnjQCzL42Yn2EmIx76nj9Ii8FzsIqriNh7j/
         fHVPz7qkqYFpykIBewLGGNWXmq7uIpil7o2rwnh9MffRbNLi+1D04Q6Dz3s1qry0fVUK
         4fYTBGzLC96pR1jUjoCh93NjXxFX2R89fr7SH225pyIacLEqbONhAonGlpVBlbempops
         +xG9UeRsNbXEQtppnSQxe2Nz3z3jSaqRwPfcU5ab3l729ELp1qFVgvtMgkhIuLoCUGdw
         VdFtwhCBTpbqBXme6HwQIIQKiXTkeUARlmnHGWIADLA9/PTVtnRK9tq2PEVFT/U9ffC8
         GIAg==
X-Gm-Message-State: AOAM531+UQvpSS7XrBQgT3wDmJN6n3fFt6VD+FnrLV+ZDEDt5yPsfNpC
        YoITx4J3uPBTUUSaruACQFa7Lg==
X-Google-Smtp-Source: ABdhPJwqgwzDrfl1xbczv4gWCZ6+t/rZG8bYbPRZzSuQ+fnazWGSZlOMnh6fqSXE9w0TNxSGNjOJig==
X-Received: by 2002:a5e:dc0d:: with SMTP id b13mr2581885iok.31.1610558142318;
        Wed, 13 Jan 2021 09:15:42 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm1120579ili.43.2021.01.13.09.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:15:41 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: change stop channel retry delay
Date:   Wed, 13 Jan 2021 11:15:31 -0600
Message-Id: <20210113171532.19248-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210113171532.19248-1-elder@linaro.org>
References: <20210113171532.19248-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a GSI stop channel command leaves the channel in STOP_IN_PROC
state, we retry the stop command after a 1-2 millisecond delay.

I have been told that a 3-5 millisecond delay is a better choice.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4de769166978b..5c163f9c0ea7b 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -903,7 +903,7 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 		ret = gsi_channel_stop_command(channel);
 		if (ret != -EAGAIN)
 			break;
-		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
+		usleep_range(3 * USEC_PER_MSEC, 5 * USEC_PER_MSEC);
 	} while (retries--);
 
 	mutex_unlock(&gsi->mutex);
-- 
2.20.1

