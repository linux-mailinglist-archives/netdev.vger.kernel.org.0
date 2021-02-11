Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36233191AE
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 18:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhBKR52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 12:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhBKRzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 12:55:03 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F0EC061797;
        Thu, 11 Feb 2021 09:54:17 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id w20so4810946qta.0;
        Thu, 11 Feb 2021 09:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FE1ZBcSfCaelUsbMiW2sW80k0mp0cw5wjA0Pttm4Erc=;
        b=OZ78IULdBST2DLbaRBNrDlLihVppvO8x0ZnpxrEe+iPwB44EVIaOVGDhCvK13VpwVr
         bUtu0AWFfcwtnyGFqiReZzYiDF2IGVfyjbI7KnJYjzZj/BSyQ5UD4ojTUavXTQbDjmek
         y09/Z/XztPbejWcTgnckEijS2WhLPmSHMoq+AeoncztQmii9KRkZMvsYOehUeQX9x1y4
         XH0GmUfwD15y9Smm6fVDTEQPpupuJ1EbnFeVxIBA0gg4mCJ1jinQFX2psQ0MUfjVrVoz
         TGAaoEeaHZTZ8now2+acRav6lnA9jTuNkHKblOXNQwDTVAe9P5XX52HFN/MuGiDQs/V1
         d2nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FE1ZBcSfCaelUsbMiW2sW80k0mp0cw5wjA0Pttm4Erc=;
        b=oPycPt623nwHRBMLK8ixngyZQkeWKSolFNV3lzdptwUu9ihCCbruCoMUfDBsxUmhrw
         9eVO/BXjL1UWeUraPMWsnhRrcF/eLL6c7RPKkivysVh2+qStQsavFF3gFER0y6yhjYH8
         /cN09WeXPsE0XxDjloVFh1LOf4YX1qeZ6BwNkg29MaaOcqQiird+Ixcig4oMis6+Tfyb
         bbPGW4MkOZ/73CS0mbHYBw00Qi1PXd7il35ukBbXINbXRwAKmuQA+XGs4Oc/80sdTIzl
         kWfRPkkEaQao4pOgGQjbwr8COoNDmK0uc26ZnHm1v1/lBZ0A5RZO5PfMoQi37OjJrip/
         5t3Q==
X-Gm-Message-State: AOAM53191ECgz7nZ2LOuRuwJHJLQaA/CVdffW9JaT489uOW5Hu8pou+e
        L/EMFy/hWfj+UcUUZVyPf8E=
X-Google-Smtp-Source: ABdhPJxwOM/4CryanyoN+zzXB6o3yia2mgqdTBaTY41wjgeCxVL/169g9oS3RtWpwrVLboZ/R7LkRw==
X-Received: by 2002:a05:622a:90:: with SMTP id o16mr8212376qtw.49.1613066056313;
        Thu, 11 Feb 2021 09:54:16 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:d9d4:9919:4b2f:f800])
        by smtp.googlemail.com with ESMTPSA id h9sm4427552qkh.104.2021.02.11.09.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 09:54:16 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH v2] enetc: auto select PHYLIB and MDIO_DEVRES
Date:   Thu, 11 Feb 2021 12:54:11 -0500
Message-Id: <20210211175411.3115021-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <dcb02f4e-2fad-b44f-9bc0-098cb654b145@gmail.com>
References: <dcb02f4e-2fad-b44f-9bc0-098cb654b145@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FSL_ENETC_MDIO use symbols from PHYLIB (MDIO_BUS) and MDIO_DEVRES,
however there are no dependency specified in Kconfig

ERROR: modpost: "__mdiobus_register" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
ERROR: modpost: "mdiobus_unregister" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!
ERROR: modpost: "devm_mdiobus_alloc_size" [drivers/net/ethernet/freescale/enetc/fsl-enetc-mdio.ko] undefined!

add depends on MDIO_DEVRES && MDIO_BUS

Signed-off-by: Tong Zhang <ztong0001@gmail.com>
---
v2:change to depends on MDIO_DEVRES&& MDIO_BUS as suggested by Florian Fainelli <f.fainelli@gmail.com>>

 drivers/net/ethernet/freescale/enetc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index d99ea0f4e4a6..ab92382c399a 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -27,7 +27,7 @@ config FSL_ENETC_VF
 
 config FSL_ENETC_MDIO
 	tristate "ENETC MDIO driver"
-	depends on PCI
+	depends on PCI && MDIO_DEVRES && MDIO_BUS
 	help
 	  This driver supports NXP ENETC Central MDIO controller as a PCIe
 	  physical function (PF) device.
-- 
2.25.1

