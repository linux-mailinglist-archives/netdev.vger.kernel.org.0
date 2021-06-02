Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E14399244
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 20:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhFBSOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:14:33 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38775 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhFBSOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:14:33 -0400
Received: by mail-pj1-f54.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so3917436pjz.3
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 11:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2GuUNe4sUbo8SYTJ3ZCyTMOYGwjKXZAJXEGqFop91ew=;
        b=Ry6vjTsznuzxu8W5O1DZkGVTjrLlo1KrgmIMAdFmU6cz2udwGF1gR0wD+bMu2MmYu/
         6lC4HrMDPCdXi59jSpLB5dIH1BnTgVij4NK1Ud34VraK+cbueZexA6NKJQgPZH+aexWG
         ZbvEyjb1m9Fu8EjzudGIz7vBkhccDZb6caNRM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2GuUNe4sUbo8SYTJ3ZCyTMOYGwjKXZAJXEGqFop91ew=;
        b=XzvmUvIiXREWjTTU353n4zP/TYUsXRjnY/XlNamrs0z7yiDP69B7Ag3n1lPl7g5vxm
         Pdl8oMgEMEyrKRJjrtus8trT/Y180p0w88I76r3vlFhfsC81QcodLZO256WAf6X2LZKA
         9Hvik5+vW8PbmRUWMbHkCcMO2d3XzMQ3Hnwny9iSvfg+2aPdaY6uyl7MRMwAoRkda+0I
         Nhb21HmgY0GwTUWJXeK2/+e9SW8E8TG2D+f+hLTJun1ZtEik/i2/QOvjIiAEfYgq0PND
         WqfdRTgvtmfY8nFORpyUQkPmDSlGB2WghpNXxc6GFOSTi5XWwbhgJQCEJdWLComsQ5U8
         TzoA==
X-Gm-Message-State: AOAM531zYsExYdKc4tgfv+qbwlpyGn5Ac/JjoNvTtMvqOKvrQ62uHuQj
        eyb57u3r3fwQ9xHzchwVt2rNTw==
X-Google-Smtp-Source: ABdhPJzzszQ4456Ap1WdtkdbN8tapHCqtT/yvYuGCx7dNarmq+s0H0g6yROU36W8D05oQxchGMWumA==
X-Received: by 2002:a17:90a:9bc4:: with SMTP id b4mr6703832pjw.42.1622657496853;
        Wed, 02 Jun 2021 11:11:36 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n69sm270015pfd.132.2021.06.02.11.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 11:11:36 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH] net: bonding: Use strscpy() instead of manually-truncated strncpy()
Date:   Wed,  2 Jun 2021 11:11:33 -0700
Message-Id: <20210602181133.3326856-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=3f61903c76c789f32d65acb60d6b57550ace0464; i=+jq1hjyNarBiZF1iCP+ld51I3zySb92TJIxasbU5Dvg=; m=Ah79ZzdISBOESKLrfqwFLaaLO/pavYkh4XaFeC1dpRE=; p=wiF5U0J2tCL474X+qPHfVl2ssY7ZE/qDY5eF8gxKAwA=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmC3ydUACgkQiXL039xtwCYZZxAAhUb 2z0F2AYS4Vmc+SCkudP4bOpCOnqSNfTHvMi+9y5JsQaxeNUUnuKquDnNxbX1FuLqHIJtyB0yya9o2 5b7Ayx9JHiZD3bDCUcAt3LZBFP1Cp26q8aXgupLZjzqN80OLMfHcfBDnTWC7tVnedVPbyVfl+xmpJ ej1rzkAWzVcG9g4Ez/gIzJg8+5Ca1L0beLZnsVXy7+VUXGGcyEWSxLCfnVMKxgzIgjZdL6UDLW78k qv7n0CCdQhX2wlS0epA3Uc0xlYwkMC5h8ym/rWLQ5l8tARqQvLhJDrgiRmWrhirhHdDnrF8XO8fLo XGFVWSFWTLy52KSLHLzuQqrUxYUla0g+EigLOtCRxxZ/t4ITiFEfyiyWaUVKzquoqfMCYVN7SMwdX v8cNzeIe4U80KB0eaJGpAuDM+fcVIMmOQ7aF/o8NE+R0IOsFNLnXTPN9dy759xolMFrpD9nq2dY2v Xqa6KRV505i85MXcN3eP38BfLDme/0IhwJJLyOWwQeLgCuS5ZrWSKZDQSgJ4sBqM/+ib+ieeoIm+h DXMmwuvFNqc5R4zLk58nsEqTxwWVq6cn6RGnvCUUcBxKiaPbKrhsEMoeJ+dz3wUF71sE9wZJXNDdh He/3J6jqPyJDJ4Eh8Z/OKItVGZg+9xzrrRT8WOBB3Qm3c7zgvLUoOsGYCzFqIWso=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Silence this warning by just using strscpy() directly:

drivers/net/bonding/bond_main.c:4877:3: warning: 'strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
    4877 |   strncpy(params->primary, primary, IFNAMSIZ);
         |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/lkml/202102150705.fdR6obB0-lkp@intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/bonding/bond_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index c5a646d06102..ecfc48f2d0d0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5329,10 +5329,8 @@ static int bond_check_params(struct bond_params *params)
 			(struct reciprocal_value) { 0 };
 	}
 
-	if (primary) {
-		strncpy(params->primary, primary, IFNAMSIZ);
-		params->primary[IFNAMSIZ - 1] = 0;
-	}
+	if (primary)
+		strscpy(params->primary, primary, sizeof(params->primary));
 
 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
 
-- 
2.25.1

