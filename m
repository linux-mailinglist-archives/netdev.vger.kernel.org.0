Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A25330E920
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 02:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234096AbhBDBHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 20:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbhBDBHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 20:07:40 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0C4C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 17:07:00 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id u8so1417664ior.13
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 17:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CgG8Hwt3SxrrGY2glvsXSBuEtqHY0gWizrBC8qUvw4s=;
        b=D1pTorP4NprD0zWgkamOJfsGSCSkxnvm31BrzhpMlqbViV+4DDU9FL8W9UQt3bdOR7
         KiQvr+MFwzkcYS9kqf9RoB8QlEHq6PdgxYv7r+HYot9Tz2LWutxOO6ub4pIE9pWitBg9
         sVp8QqKP+4QKs0RuVoNGtkZVwai+UQu7UW55YdNtwxupxRYTgAzLZJsKcCsVq4QhPTYR
         yRXgE1xutsru6N2nUJxUy3T1l7YiP/rXjUNsRxYlib8Tvy/S52qm/KGzacllErHf+4zt
         TEdzSTn0f6cRKEHEmEztcLnpy6vPHrr8EeXrAx176Y0pd/A1tiokhPgXv87Zya1l+/ha
         hdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CgG8Hwt3SxrrGY2glvsXSBuEtqHY0gWizrBC8qUvw4s=;
        b=TCqB5GRXaDVdQW3kwrWKYBVKJOTINRd3MLZvdNKQtL9wjhJpBal31iL+Y/GDE0H5vm
         3PooHUFyc73yVyZotBX32eiuQtvj3hHhYn06qwjFNGLPfGO2VskXkTLKHmFl5cchHfSp
         HZ5ut9bJDdnk0egiD5m5gN5iJ3PGA8RRvlGeD3RvYam7Avr1vhdFJAw0oqrlI1eWtR94
         PjpBFvBhTPc9rP4jBKh0KSqFQXLI7RgmPhSwOErgBaSAcFQdpHVwMzC2BJciE3qPToMM
         NCCnJn5UI5WvKXnwouEoUQn+00dYD1OsGKO1P8OeNPDuLSBNc4GyKVPJ/F0Ce7PaIxia
         aP/Q==
X-Gm-Message-State: AOAM533KIVWKsi6r8RD/jnElL9rW9OyulL+2OFVeum/34ShoWQd/9yvG
        L/6BFulbwqZ2G9mJXDl5JBqRuQ==
X-Google-Smtp-Source: ABdhPJxKmk71GPIYpaPKqRrvRpuGe1xO+J77RRLMh3ShL3srd/V74hqtyMo4vsgjpA7QsMaB7qke6w==
X-Received: by 2002:a05:6602:1223:: with SMTP id z3mr4786869iot.130.1612400820029;
        Wed, 03 Feb 2021 17:07:00 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y16sm1813495ilm.7.2021.02.03.17.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 17:06:59 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     dan.carpenter@oracle.com, elder@kernel.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v2] net: ipa: set error code in gsi_channel_setup()
Date:   Wed,  3 Feb 2021 19:06:55 -0600
Message-Id: <20210204010655.15619-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_channel_setup(), we check to see if the configuration data
contains any information about channels that are not supported by
the hardware.  If one is found, we abort the setup process, but
the error code (ret) is not set in this case.  Fix this bug.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Added "Fixes" tag.

 drivers/net/ipa/gsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 34e5f2155d620..b77f5fef7aeca 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1710,6 +1710,7 @@ static int gsi_channel_setup(struct gsi *gsi)
 		if (!channel->gsi)
 			continue;	/* Ignore uninitialized channels */
 
+		ret = -EINVAL;
 		dev_err(gsi->dev, "channel %u not supported by hardware\n",
 			channel_id - 1);
 		channel_id = gsi->channel_count;
-- 
2.20.1

