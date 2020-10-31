Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E092A187D
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgJaPPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgJaPPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:15:31 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6075C0617A6
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:15:29 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u62so10588748iod.8
        for <netdev@vger.kernel.org>; Sat, 31 Oct 2020 08:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB7yqaNrldEgZneTIj0VJhMPYOHInXzygYCi0tQFObQ=;
        b=fXEktLgrrzV8tvbnYEBIwNqB93RGbxX78MytAJ4EAeEnn1SyOdWnwLNw+XgpLA88ID
         Dfoq2Rrh4qgHWjQOU38aJmHeZ9gnXSc/h/LxSps2LFS2dSKb+MSrbrdmbJcGi7VMvaSQ
         d+uFNfT4fDlJyQ1vCNCMrtS25sCKj6hHiaQpSLmZtw+nbVsT9vM0DytVeTnWSOOzaf0O
         gEnTgZNny40gqLHR0iHcz8vdljGlxk2+wbJI7l/CXmRV1+l9HSLBD319KRxBvsucn+KI
         3bofJDANzsyHeU3ZKvK3JYlszy+T/uwtbPo3j+u8+WgEMk91DGZYze6XsOmmgDoW8xIv
         hTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zB7yqaNrldEgZneTIj0VJhMPYOHInXzygYCi0tQFObQ=;
        b=hsjG+GBmk2xvZ+pDCW+rXi+ZSdA9jTfZ8SISPVKgPKSJmRuZHWyXtR1JyqZO9Aww5+
         eABxL/+aL6Q6SsjowiuHw4dm92kDiN1Xn9dVJACosPX6OJPLRqjr1lXppfdmJyHNfwzl
         9Ic1gajDdItblMGboh5JhB/sgGdMuXFZ3WDQoUCdzLyIIXd4t72bcrUxd/y9djyBU/HC
         FtqjSf7bJbEsbwTpLwQOFI2wC7Vgeczm9CT/RpzLtC4mXouCQ+84FmF4N1xcXCAJBbFU
         3XLCLhOJob+nqsUDrC66WazYERhgvE52o9JVuE6MFxBkJTrjByhu4ewZEpaxUuL7uEqT
         zdPg==
X-Gm-Message-State: AOAM533VCUrnaqNVFrv/4nFuvLglfGc3csc5JwAqDimvJkHtazoX+5YW
        6fltKkunSNq0fsKG57DCnDgZCQ==
X-Google-Smtp-Source: ABdhPJxf1AKZMrIEfxciAqHwT+3NHE5v840lMxlKaLStFOfGMXr7SlrauDqD+OdZ7fxrj7riNdy7Nw==
X-Received: by 2002:a02:7:: with SMTP id 7mr5848815jaa.112.1604157329229;
        Sat, 31 Oct 2020 08:15:29 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id e4sm6777988ils.75.2020.10.31.08.15.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2020 08:15:28 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: avoid a bogus warning
Date:   Sat, 31 Oct 2020 10:15:24 -0500
Message-Id: <20201031151524.32132-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit added support for IPA having up to six source
and destination resources.  But currently nothing uses more than
four.  (Five of each are used in a newer version of the hardware.)

I find that in one of my build environments the compiler complains
about newly-added code in two spots.  Inspection shows that the
warnings have no merit, but this compiler does not recognize that.

    ipa_main.c:457:39: warning: array index 5 is past the end of the
        array (which contains 4 elements) [-Warray-bounds]
    (and the same warning at line 483)

We can make this warning go away by changing the number of elements
in the source and destination resource limit arrays--now rather than
waiting until we need it to support the newer hardware.  This change
was coming soon anyway; make it now to get rid of the warning.

Signed-off-by: Alex Elder <elder@linaro.org>
---
Sorry about this; I got no warnings on my primary build system.

 drivers/net/ipa/ipa_data.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index 0225d81d85028..83c4b78373efb 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -46,8 +46,8 @@
  */
 
 /* The maximum value returned by ipa_resource_group_{src,dst}_count() */
-#define IPA_RESOURCE_GROUP_SRC_MAX	4
-#define IPA_RESOURCE_GROUP_DST_MAX	4
+#define IPA_RESOURCE_GROUP_SRC_MAX	5
+#define IPA_RESOURCE_GROUP_DST_MAX	5
 
 /**
  * struct gsi_channel_data - GSI channel configuration data
-- 
2.20.1

