Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E543D30D8C8
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 12:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhBCLgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 06:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234142AbhBCLgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 06:36:25 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E902C0613ED;
        Wed,  3 Feb 2021 03:35:45 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id y187so4868551wmd.3;
        Wed, 03 Feb 2021 03:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Z3Nox9s/STqesTh8aOkGgimIjL0UCAkor1AKiLYQkg=;
        b=olJGewcDSkEmL09WbXdeh5PtYfl7IpbpmJAHgzFw/8kAvNRztpihB8GWo/LBN+tDmo
         FEM91HQrLdY+Q0R1vdYpIXcUtaYIzcRC0+K8rqJAOpvAhGkyqpBJ8Hy+Zlh5rxP6xXdZ
         /x/f4wr1NijczeLva7buw8UeKqyO4gfWLHR4T88D4h69pAQYf7/dALikbQrA7nWjsQNk
         K2axCfwvYfMDHWi6nlk6JaDXi4LPQgQL65Ax7Th7LWZo/EnyfSHqvUG4D51Wp+ki9wtR
         eNXyiI9e94zDVwWnrWbcjplNYq6p0H6KhHZTOkk6B6Xfo14adrIIAmeH9S+Zgmza5J4z
         ZBXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Z3Nox9s/STqesTh8aOkGgimIjL0UCAkor1AKiLYQkg=;
        b=r9LbHBQuVUp5T0F8lbEhzq0v0emesg10mvHFROSGF6tYUeYEOP9ftbEj2hHE9abMTC
         1N+UCOosWpkDY20rIhHRMdCR/+EOrEz5vYZ1ScQtYvdYEZZgixf8gUX4bZkf+04vqrwy
         +z8PDodL4XS34ofyxi6TJCYvJSegsA70lgOalV/M5SGL80sln67M+uN30Xf75RmF7vrD
         iDUISPUuIvKmct47f2TM01Ww14EmQOWI1ITE6qlDtfuzb9ILwasH1pKP9JBYXJCPXZjp
         RPPty46/JNDR8T5ktgcw0u4WFkVpcWfu+wySGHdZ2po0Pr3Ng/CHyV4rq6fukkP6V8jU
         jkEw==
X-Gm-Message-State: AOAM531uZDiALc9AjSercrhHr8G/kPkcj9moukKH7NWt41GGEDBn+2gN
        23Pg9QgkmzfKHsWOmD+FkzBNgTofCi5hyxcN
X-Google-Smtp-Source: ABdhPJy64SoEZRwkK/Q8MU9BfuKLsVYyLThmIDETi6/VHqDxBbDisrRiTyXri2f7k7V5lW9Cf65gkQ==
X-Received: by 2002:a7b:cf3a:: with SMTP id m26mr2423765wmg.66.1612352143822;
        Wed, 03 Feb 2021 03:35:43 -0800 (PST)
Received: from anparri.mshome.net (host-95-238-70-33.retail.telecomitalia.it. [95.238.70.33])
        by smtp.gmail.com with ESMTPSA id t18sm3295088wrr.56.2021.02.03.03.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 03:35:43 -0800 (PST)
From:   "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 2/2] hv_netvsc: Load and store the proper (NBL_HASH_INFO) per-packet info
Date:   Wed,  3 Feb 2021 12:35:13 +0100
Message-Id: <20210203113513.558864-3-parri.andrea@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203113513.558864-1-parri.andrea@gmail.com>
References: <20210203113513.558864-1-parri.andrea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the typo.

Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Fixes: 0ba35fe91ce34f ("hv_netvsc: Copy packets sent by Hyper-V out of the receive buffer")
---
 drivers/net/hyperv/rndis_filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 6c48a4d627368..0c2ebe7ac6554 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -465,7 +465,7 @@ void rsc_add_data(struct netvsc_channel *nvchan,
 		}
 		nvchan->rsc.pktlen = len;
 		if (hash_info != NULL) {
-			nvchan->rsc.csum_info = *csum_info;
+			nvchan->rsc.hash_info = *hash_info;
 			nvchan->rsc.ppi_flags |= NVSC_RSC_HASH_INFO;
 		} else {
 			nvchan->rsc.ppi_flags &= ~NVSC_RSC_HASH_INFO;
-- 
2.25.1

