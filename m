Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE3435A53E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 20:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhDISHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 14:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbhDISHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 14:07:43 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE4FC061765
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 11:07:30 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id c18so5436303iln.7
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 11:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M02HcZujpZ/J/h5ieItU4HENzz4/4ThjFxhYAjdjTos=;
        b=o1NsykK06oGHfrPp8sbmPR0E2noKbbC6+m22RUf8G7xP+9K879owrt1IiRZEwLAcxm
         uKhx5XXFzCPDVHgLqm7P6dh7zYR5Z0w8D26voQ6LFHC6nHjo9vQQvdDSXMSNIy4TzYy/
         2lV47wv1nN2quRJ8ZhqBZrGvJr4yJpHTtdYxVjaGnKDn3qjeHKuZNv2Y72fFWNBTo5+p
         iu1VIHv+R3AI9sCIN+3ColckgwWlbcPbzbU38Q3fasf83HrLOXGXGBtyBk7IuBC0A6Nj
         1LhZcguacfNkijZ8v8RPRq6evcpn/YxtrksN6VIr6lJ2DQV8x/YVbG3nYNTp3iUGitKr
         va+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M02HcZujpZ/J/h5ieItU4HENzz4/4ThjFxhYAjdjTos=;
        b=KV/urMPbyD7pQt+qv5O8/aDL2MShc1+TfzMiKH+8u4fxFMe/a8xoX28rylNev93l+p
         lDlOJlngtg6m2vbqjE7qzsD+wAlzWzQPkupyTJ0bFRiT+A02GLpey1d5RVhloK2p2T0N
         1yYrQdlVJUqYFViwRjbgbdVr9/wX1T8IaPpMdH5NPKd01eW4PhskFFADdC23KgIZQl2H
         wSOem1eJb+Juu3RTVBuw45syedrBine71TwzaqnqKhAAB28heHW0kUESFHr2f4My6drm
         jXmJ1oy4RKhbawBGiOvweEQLd74b/UnPJ2mEk1+sRvfLqYAHs215HS+dgqRS7bnlnY1z
         EuAQ==
X-Gm-Message-State: AOAM5334U/DRav2QGIQM7vZ9G6SCPNEbmKp/sbT2SUfM2TZlIwQec3SF
        NM9CjB91NlZqFrH7upirgtrswA==
X-Google-Smtp-Source: ABdhPJzZascuW/5o61qMj3tI9JnZqn2RqjUffIyvYqVEX4p1/fLg1hQ6KKaALUb1P9WirBIX1H14Xg==
X-Received: by 2002:a05:6e02:1311:: with SMTP id g17mr12465813ilr.14.1617991649583;
        Fri, 09 Apr 2021 11:07:29 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g12sm1412786ile.71.2021.04.09.11.07.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:07:29 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/7] net: ipa: ipa_stop() does not return an error
Date:   Fri,  9 Apr 2021 13:07:19 -0500
Message-Id: <20210409180722.1176868-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210409180722.1176868-1-elder@linaro.org>
References: <20210409180722.1176868-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_modem_stop(), if the modem netdev pointer is non-null we call
ipa_stop().  We check for an error and if one is returned we handle
it.  But ipa_stop() never returns an error, so this extra handling
is unnecessary.  Simplify the code in ipa_modem_stop() based on the
knowledge no error handling is needed at this spot.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 8a6ccebde2889..af9aedbde717a 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -240,7 +240,6 @@ int ipa_modem_stop(struct ipa *ipa)
 {
 	struct net_device *netdev = ipa->modem_netdev;
 	enum ipa_modem_state state;
-	int ret;
 
 	/* Only attempt to stop the modem if it's running */
 	state = atomic_cmpxchg(&ipa->modem_state, IPA_MODEM_STATE_RUNNING,
@@ -257,29 +256,20 @@ int ipa_modem_stop(struct ipa *ipa)
 	/* Prevent the modem from triggering a call to ipa_setup() */
 	ipa_smp2p_disable(ipa);
 
+	/* Stop the queue and disable the endpoints if it's open */
 	if (netdev) {
-		/* Stop the queue and disable the endpoints if it's open */
-		ret = ipa_stop(netdev);
-		if (ret)
-			goto out_set_state;
-
+		(void)ipa_stop(netdev);
 		ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]->netdev = NULL;
 		ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]->netdev = NULL;
 		ipa->modem_netdev = NULL;
 		unregister_netdev(netdev);
 		free_netdev(netdev);
-	} else {
-		ret = 0;
 	}
 
-out_set_state:
-	if (ret)
-		atomic_set(&ipa->modem_state, IPA_MODEM_STATE_RUNNING);
-	else
-		atomic_set(&ipa->modem_state, IPA_MODEM_STATE_STOPPED);
+	atomic_set(&ipa->modem_state, IPA_MODEM_STATE_STOPPED);
 	smp_mb__after_atomic();
 
-	return ret;
+	return 0;
 }
 
 /* Treat a "clean" modem stop the same as a crash */
-- 
2.27.0

