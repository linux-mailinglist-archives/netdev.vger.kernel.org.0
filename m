Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53246308E68
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhA2UWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:22:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233055AbhA2UVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:21:25 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40C3C0613ED
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:24 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id 16so10662580ioz.5
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KTuHAn9OfqeY3lac31rjWWvnuONhCRgNtLqnNnrmMyE=;
        b=b09q/t9cXwHgn7gEz1ttOt0SKrpalrnMta/O+XS2r+PGF8M+qlHiFlxmrR5nMKCaBl
         yDIpYLL+7ArJQAOTQ2o8o3YB766fkqL6XyZcWu6/63/ALThIKdAj0zUJa3ErrgFY692t
         lO5kDXekRAlBZcLQtsgtIZH4ejgngrn2Hp0BtKJBbca7Zq6/wB82hp3IdA5iDl/jc4dP
         fP8kUtcSTVr2coltsP6uqyfwtayE6GxlIhd36tiN1neHslxACPjtBKVZ9xQLAl3ORdA/
         GL6/cjiP4rmANwegY/UhElaZNdhxaVJUY0kC7peRjXwhDuTuXhQwE1C0zq9mFlM3QP0I
         ZcHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KTuHAn9OfqeY3lac31rjWWvnuONhCRgNtLqnNnrmMyE=;
        b=lZyuOjH25AwHE3+WayPP7C95iLGt/zgl3rosApMdw7O8I7Dt9yK/saffasu93T3THo
         zAmx0daBEyobzsCkzqMDaxotlJ3ctDZEMKt64xvg1Pni5AeMcX+LsZM+77qwxumHgAy5
         Cth6WGU/B+QqowjmCxzkFtHsCRVi9i5UeG7UdZDh3MxxXljBmzkhxKNOkQV063qBGHS/
         +g3Qa7uDm/WgMQjuj6LgeglyOiwICw0NRWQ8RgR6EaK0kMk7mSfmPeCLZsqV4TFHA7xW
         3dEK7Eu2BkCBUGJpAdDwSca6Z+3IQP+EQs/nNJaCU0gYwijhaHNp97ohT9wafeqq9NPN
         nxlw==
X-Gm-Message-State: AOAM532KxjhHtHuAnvuHMOuLExBO8FIVZL8c5XlN+1RK4TRp1XicMdFf
        uK7AN2K0xxdEEvmIFFz9vlBH2A==
X-Google-Smtp-Source: ABdhPJxuYTt+68CM8jrwaPa9As7C2xTjI+zXvh5wnNslMxaN+pkJLxIw8sv8Ee/so737te0MdIFjCA==
X-Received: by 2002:a02:cead:: with SMTP id z13mr5219880jaq.62.1611951624296;
        Fri, 29 Jan 2021 12:20:24 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h23sm4645738ila.15.2021.01.29.12.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:20:23 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/9] net: ipa: don't thaw channel if error starting
Date:   Fri, 29 Jan 2021 14:20:11 -0600
Message-Id: <20210129202019.2099259-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210129202019.2099259-1-elder@linaro.org>
References: <20210129202019.2099259-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an error occurs starting a channel, don't "thaw" it.
We should assume the channel remains in a non-started state.

Update the comment in gsi_channel_stop(); calls to this function are
no longer retried.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f79cf3c327c1c..4a3e125e898f6 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -885,7 +885,9 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 
 	mutex_unlock(&gsi->mutex);
 
-	gsi_channel_thaw(channel);
+	/* Thaw the channel if successful */
+	if (!ret)
+		gsi_channel_thaw(channel);
 
 	return ret;
 }
@@ -910,7 +912,7 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 
 	mutex_unlock(&gsi->mutex);
 
-	/* Thaw the channel if we need to retry (or on error) */
+	/* Re-thaw the channel if an error occurred while stopping */
 	if (ret)
 		gsi_channel_thaw(channel);
 
-- 
2.27.0

