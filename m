Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D539F311858
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhBFCfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:35:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhBFCcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:32:31 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FEA9C061BC3
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:11:14 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id e1so7282808ilu.0
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:11:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ktpO/jSmoOx5RVisI52DM6PeD/6jBsQ5/HisJypSEHU=;
        b=ozvSvOes+inyPBHz80LRvVrFcsrJMzQcACU5LKGFx08VpOGwelVCRaOGmPRhfUgQCf
         N5rqnPRhUMvCvkCVIkkyaPXJ6xaVQ/AoMuGpi6zk8CwVLjaQ8KbMscdkjSWapEY8O8EQ
         vTLjdqs+t2mXJMIP4Npaiv16vWRmN36xVdMJ4i2sw+Z7elNhC6x42O+YvahqLGUDv4MG
         ZgH5Tvs3PWP03HWf/1e1H5C2npvac6I6W8e3OFf/HvHaDiP5UVgRq7nf46JLwL0C9bA2
         DmaKbWBsP/apTInIRbWEwjExMmiDJ7MFjsv85P9AJ/Z2bNfoC3UqxoxSbfNrFgd34dD4
         uExQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ktpO/jSmoOx5RVisI52DM6PeD/6jBsQ5/HisJypSEHU=;
        b=T8H0r0+LEtD7F3v9pWsw2dZ/fHLDJImnGrPAmPtX/MGX4eBUpoZ0ySXGVVQyhmcD9K
         V5b3c+y2NwPshyO/1khIuw1CD9cq7MieiGrc1FSuCwtz799jA35O3jm+xuBXUignAXT4
         hCVSj/3p0GecRiq4nx7rHHZo7/hc8c687iksK1BAvjF/OUCPBIxyKIkjuXMiiRapY61x
         B924oT9uQ0qn5/tvr+OuUgrvPEnnD4CCSvT1QSCskCHp8jlMLmHvRVj0rzGke8QNRyCp
         flDqy9/VdXoJpHNIt/CZlha7lyhHUXN1yMRSkfeXVznm9F/vgYVsMGoCwjOPjj34dCAr
         E2+A==
X-Gm-Message-State: AOAM530LuhbHusoTAuGrIZ2Z7/JWYvtRd19KBckzhuGepLM1hNdfXuSt
        qjCJ6fFCxm1r66nMZHxpLraAXg==
X-Google-Smtp-Source: ABdhPJxC0bJgCkwEtZG6d2RJ3paGFc9aTLxSS6YQQ28hdw4p7jc/JS4xelRiLwvAYsVfxkek60BtmA==
X-Received: by 2002:a92:2e05:: with SMTP id v5mr6146744ile.241.1612563073683;
        Fri, 05 Feb 2021 14:11:13 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m15sm4647171ilh.6.2021.02.05.14.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:11:13 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 6/7] net: ipa: get rid of status size constraint
Date:   Fri,  5 Feb 2021 16:10:59 -0600
Message-Id: <20210205221100.1738-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210205221100.1738-1-elder@linaro.org>
References: <20210205221100.1738-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a build-time check that the packet status structure is a
multiple of 4 bytes in size.  It's not clear where that constraint
comes from, but the structure defines what hardware provides so its
definition won't change.  Get rid of the check; it adds no value.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index bff5d6ffd1186..7209ee3c31244 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -174,9 +174,6 @@ static bool ipa_endpoint_data_valid(struct ipa *ipa, u32 count,
 	enum ipa_endpoint_name name;
 	u32 limit;
 
-	/* Not sure where this constraint come from... */
-	BUILD_BUG_ON(sizeof(struct ipa_status) % 4);
-
 	if (count > IPA_ENDPOINT_COUNT) {
 		dev_err(dev, "too many endpoints specified (%u > %u)\n",
 			count, IPA_ENDPOINT_COUNT);
-- 
2.20.1

