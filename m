Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331E76D2A3E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbjCaVsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbjCaVsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:48:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD2723688
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lI/wTNKANfMxYvWqJ0umcXHaHwboSDwAnj65voZzExc=;
        b=g6Sd8A7sSwezAAcFSLbYv/kO/OhXh70MZ2wI5+tg3sSVNcWqZVUs9FoLLlw3DcxbXI3XIq
        t/etMbA3rHV39ytK0lS+u9vazKrdrBl+ecZQBfN0iwGcjjr1Wrsgs+wRii/t6j5f3ZS4wY
        DyvfqrBgDMWzmweWzZNdK8iqzdJYdPY=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-Ns6YijwOML-PlDU1fMshcA-1; Fri, 31 Mar 2023 17:46:28 -0400
X-MC-Unique: Ns6YijwOML-PlDU1fMshcA-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-18032227bc5so1988299fac.9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lI/wTNKANfMxYvWqJ0umcXHaHwboSDwAnj65voZzExc=;
        b=6o5xQKecocPfAe3uRCPQxTgIadddqKRMzPP1xNfCVHsL7kTnC5o8lhOd1hcj0lKrL2
         7blZIN7Z3yb5zPMsJD5JQt9HD/Namnu4Zxphi1EMWJtSLJnjbkuMj8sBDHdzYadcG24i
         2ajjH12XUJ6hvd1uyVtdobBPhcdYWye3BiVb+CMKVF5SV0f9WawlQty6GSAUGQ8toGaR
         uARIn+mtO/tSpQJ/nQEWTFQ/+KgBlb1uESPVB4fo+F1HI9fVctXQqVtZnQseV0dE9VGO
         VbTnuRrugMvqL2jKxhCSRYOJx8TZ2f8ONHLYFEy7Be4bUQFxramtV3CHiGPvZU6LP4LI
         sKqw==
X-Gm-Message-State: AO0yUKWwwp3aGhWN9ozV5HM/o+4F2u6fn1YsseyOk2zZW7ogBLYoeyg2
        qHE2ktaOzjXN7eTxrA8Fr+CZ6Q7UcSQAyjhQ+8TL3lxo/wCDRWmo+WAWyO3wpuDJgfXFEGVa2SM
        XIo915MWGdQU3Tozs
X-Received: by 2002:a05:6808:4246:b0:384:41e3:75d0 with SMTP id dp6-20020a056808424600b0038441e375d0mr13650063oib.21.1680299187640;
        Fri, 31 Mar 2023 14:46:27 -0700 (PDT)
X-Google-Smtp-Source: AK7set+cnC/lvq+HQYTkPySHxCv7Oqj79qtnzLha/xwBat64KUQy8cafpalczgXYXQNna9WcIF3elQ==
X-Received: by 2002:a05:6808:4246:b0:384:41e3:75d0 with SMTP id dp6-20020a056808424600b0038441e375d0mr13650046oib.21.1680299187462;
        Fri, 31 Mar 2023 14:46:27 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id x80-20020a4a4153000000b0053d9be4be68sm1328531ooa.19.2023.03.31.14.46.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:46:27 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v3 05/12] net: stmmac: Remove unnecessary if statement brackets
Date:   Fri, 31 Mar 2023 16:45:42 -0500
Message-Id: <20230331214549.756660-6-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331214549.756660-1-ahalaney@redhat.com>
References: <20230331214549.756660-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The brackets are unnecessary, remove them to match the coding style
used in the kernel.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v2:
    * None

Changes since v1:
    * This patch is split from the next patch since it is a logically
      different change (Andrew Lunn)

 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 21aaa2730ac8..6807c4c1a0a2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -281,9 +281,8 @@ static int stmmac_mdio_read_c22(struct mii_bus *bus, int phyaddr, int phyreg)
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
 	value |= (priv->clk_csr << priv->hw->mii.clk_csr_shift)
 		& priv->hw->mii.clk_csr_mask;
-	if (priv->plat->has_gmac4) {
+	if (priv->plat->has_gmac4)
 		value |= MII_GMAC4_READ;
-	}
 
 	data = stmmac_mdio_read(priv, data, value);
 
-- 
2.39.2

