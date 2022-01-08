Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CB84882CA
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 10:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbiAHJ0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 04:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231347AbiAHJ0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 04:26:03 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570B0C061574;
        Sat,  8 Jan 2022 01:26:03 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso13311126pjm.4;
        Sat, 08 Jan 2022 01:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=6nGZ0pLNYlQTPH0NXXUjZUHfFeHpc7NAdMEEoI+ow0I=;
        b=qALKBex/Q9MtAlITgQZES39/tDZjItlQEq8MT1Cwqb8quQa4PJWzUIkPrl74PuVJTY
         5FAvyGCnnWrOy03Mx2trbLiJ63Tr7uoczKLpXS62CYqkBfh8tVY5rDz3/KLG7wwSVOzP
         ahg//JToDxDLVOCljakxTTCiRXojJiwqrfUGhl0cj1Don9qK12lVgCrlDaAKkmGmjFTL
         hUyAHUSIePk/eCkTXld9jlnwN3ANOQkkOPiUwEDDclW685nOJPeFj5zbftZwMh5Ac7Bj
         iGY2OfnUQYL1MGL7uoOQqsyyc4h2uDpTMSZ67emfIPmUM739iYT7e/P6OV+pexKBuxIS
         Q2bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6nGZ0pLNYlQTPH0NXXUjZUHfFeHpc7NAdMEEoI+ow0I=;
        b=eR/KCzje9/fJNAuOns6aX7/ofBHQvwViS/ChjVWmJys3CDSIqk6qPFIPIrg3n9dGJ0
         Z8St5hTI5uTQVmXlPiMyapetmOtpfablt9LuhN0JwCk58Uc7ALv1WV0/Rtqyw2KKXozb
         HC8exEXtz88/VptkIXeqtAGQX+Zyarc2iGjOzfqHXR0C1swuf94HWS9ZjbUPXE99uV8w
         1tT3CUwg80dywXjbwAJ9V1o36Rwy23IA0Dy3J0MUmE9uxMTOlbOjgTdUUKAjJAfOgkby
         AQT/KhOu1c3HuHg46cGiyPA59LMjkaO34ZMJv93nNemy1Az6jrI0Iq+WjmlzUek7LdER
         gd4g==
X-Gm-Message-State: AOAM533MIR42NJK6y4E8a1t6Bd6N8ZS+OTVGKKZUwo8hkgD9T0oAk108
        4422/KsVFRNFq/IS/mAkWnM=
X-Google-Smtp-Source: ABdhPJxmGkqDH4BJnA1p8TC/7pgW/pY93/igX/cglBZh/2xksuflnPGBanHcy7ZEK47eTl6rYvK+IQ==
X-Received: by 2002:a17:902:ea83:b0:148:95f3:4f4d with SMTP id x3-20020a170902ea8300b0014895f34f4dmr66801614plb.54.1641633962850;
        Sat, 08 Jan 2022 01:26:02 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id h4sm1139666pjk.2.2022.01.08.01.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 01:26:02 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
Cc:     linmq006@gmail.com, Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] softingcs: Fix memleak on registration failure in softingcs_probe
Date:   Sat,  8 Jan 2022 09:25:51 +0000
Message-Id: <20220108092555.17648-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case device registration fails during module initialisation, the
platform device structure needs to be freed using platform_device_put()
to properly free all resources (e.g. the device name).

Fixes: 0a0b7a5f7a04 ("can: add driver for Softing card")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/can/softing/softing_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/softing/softing_cs.c b/drivers/net/can/softing/softing_cs.c
index 2e93ee792373..e5c939b63fa6 100644
--- a/drivers/net/can/softing/softing_cs.c
+++ b/drivers/net/can/softing/softing_cs.c
@@ -293,7 +293,7 @@ static int softingcs_probe(struct pcmcia_device *pcmcia)
 	return 0;
 
 platform_failed:
-	kfree(dev);
+	platform_device_put(pdev);
 mem_failed:
 pcmcia_bad:
 pcmcia_failed:
-- 
2.17.1

