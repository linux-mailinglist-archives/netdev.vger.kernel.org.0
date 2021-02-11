Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22A56318486
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 06:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhBKFSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 00:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBKFSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 00:18:51 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8867C061574
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 21:18:11 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t29so2989524pfg.11
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 21:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=date:message-id:from:to:cc:subject:content-transfer-encoding
         :mime-version;
        bh=gOPNDZq8HYpauMOR0hyqdiQ38cvLLe/eZD4jYmPJ3zQ=;
        b=U0N+9+NiY/fuXDf9mJUfuRCyhqpgm5tB+gRngmfmsOSRL37TaU/A96DN8KU2XS+GFt
         IxCR2xwS1KkUbKYhKcPdZV3uPTBMnyhyhFNg7N59sPar/L1AbefIUL4u158b4AGx1EfE
         6leJrzHgL/CMMBAkhVo5spWrH6GXHe0zOUe5ErThGN0l3XjGNYbGY2jLylOKZ3hQMWNo
         Cv3w+opfZ9Ki7GFihx/O5jGTg5lWP53C3qCqHx2rMK7IC3b8097a9r/TjB2EdzRVH4VX
         eoCeuIV9nsReO9O+nNqQpyCpRINYcxJOar/FDGYDxU4pi0fRIwhpbj32FDG87u2trrYR
         LbYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject
         :content-transfer-encoding:mime-version;
        bh=gOPNDZq8HYpauMOR0hyqdiQ38cvLLe/eZD4jYmPJ3zQ=;
        b=O97iUDZmlqEVkoYg1b/Jv6u39b0S/QBTny1fYzzVhCr0HUxRgeYs51MZSL9IpE9Tcw
         fLLDv1ZYLMwKgsf581M0WeSRtRq1R97OesIhVm17wun8DdchiKfMmVir/Cga6Hgd1RnX
         +EcEaAFq/+jUjgIXW7fKW7+7sdfoGLJ58Jw4NumFB1TvIBMd5Hhlu0iFDNdKAdA/mrZs
         XcW0Pgeq6mjGxNhr4hGxq+PhVRA+BNAZHlbksASm5Q63fRhrKp5AXaFnBkFQ0FNqrhzW
         p2UDfMiKgrq74QxnvFll6m7uCW0rdU4N0wpbOjpkKre1ajPxcHA+AtU1z3Py92nyhRQ1
         yoAA==
X-Gm-Message-State: AOAM532hD66OvrtG1pQ5/GBbog/cC3U/ZVNO2SbpUZKiM9W8ba8mFUb7
        pPIfuFtm2Y4dQrbn48G2cDH8Ww==
X-Google-Smtp-Source: ABdhPJyyy6uu1MOJntTeklX5gXHOyn1y3901O3Tt2gPHuymkg7bFVHh6AKyLXGW9VtwgIlgEuKrEKg==
X-Received: by 2002:a63:289:: with SMTP id 131mr6288883pgc.366.1613020691260;
        Wed, 10 Feb 2021 21:18:11 -0800 (PST)
Received: from [127.0.1.1] (117-20-70-209.751446.bne.nbn.aussiebb.net. [117.20.70.209])
        by smtp.gmail.com with UTF8SMTPSA id w3sm3730983pjb.2.2021.02.10.21.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 21:18:10 -0800 (PST)
Date:   Thu, 11 Feb 2021 05:17:57 +0000
Message-Id: <20210211051757.1051950-1-nathan@nathanrossi.com>
From:   Nathan Rossi <nathan@nathanrossi.com>
To:     netdev@vger.kernel.org
Cc:     Nathan Rossi <nathan@nathanrossi.com>,
        Nathan Rossi <nathan.rossi@digi.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: ethernet: aquantia: Handle error cleanup of start on open
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Rossi <nathan.rossi@digi.com>

The aq_nic_start function can fail in a variety of cases which leaves
the device in broken state.

An example case where the start function fails is the
request_threaded_irq which can be interrupted, resulting in a EINTR
result. This can be manually triggered by bringing the link up (e.g. ip
link set up) and triggering a SIGINT on the initiating process (e.g.
Ctrl+C). This would put the device into a half configured state.
Subsequently bringing the link up again would cause the napi_enable to
BUG.

In order to correctly clean up the failed attempt to start a device call
aq_nic_stop.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 8f70a39099..4af0cd9530 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -71,8 +71,10 @@ static int aq_ndev_open(struct net_device *ndev)
 		goto err_exit;
 
 	err = aq_nic_start(aq_nic);
-	if (err < 0)
+	if (err < 0) {
+		aq_nic_stop(aq_nic);
 		goto err_exit;
+	}
 
 err_exit:
 	if (err < 0)
---
2.30.0
