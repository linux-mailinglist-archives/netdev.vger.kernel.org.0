Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B6D368C81
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 07:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240756AbhDWFWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 01:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240530AbhDWFWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 01:22:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B2BC06138E;
        Thu, 22 Apr 2021 22:21:22 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id u7so22860294plr.6;
        Thu, 22 Apr 2021 22:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oCguuBzXzGvGn2bpnQzkSyzGRllJCSh+eewGXVSf1rE=;
        b=MHMI7yDYGqn8zq/FZ4jyCKzBzBSGVUpLws/egw5RYREDUwNt1/5nibN5vsTSaK0mPJ
         5XMBffQrNzw6+e9/43KdK9qgdT0sn5bob2n2/3b1ahrzQ5STCqZFqXHhrURRRn3AVZTf
         hE64u9uDhJNNcaTRAyo7FVGPM6M4a99+V1266y0wwrC7WfyVJsg4bmCGBnGQwd1Y1d4S
         4+g8sNZ+cOIgY3E657sYN2VWja0DbyhJLommN264eB8JKGLfVIV+TBkR/UDOtwIIuU6h
         2lAqU9L0iZAjoClMeQ0ac2cAFE8AYLuyaLWIPBEUTJq3htUUcHuQ9+aIXpfC9thWRjQI
         CL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oCguuBzXzGvGn2bpnQzkSyzGRllJCSh+eewGXVSf1rE=;
        b=jkNDd8sM+sviAtrC+oegRcooct1dQRHHKfTxa6DUWMvdA/LBsVwBnMKtPauwEMpf+D
         oV4uDrQJ+dx3a8hP3HMcf/VfLvXOg19tAlfntzLVOc8QxOO4p78FztCm83p0TC2+qmI0
         uOoqqQYtlwRq4qiy/1x7h7JvIogkAKNxeGnY8uDK4U11Y4KDFmMSOSdfDNrQMwvFYnyh
         abob57zBTelQDXUlsgQr0BBhwbVcBz1owfDwjSeW72VqpUp0brdPUpBWq0bYRNhwIecH
         bblInF+P6m2nVB4fN/XKq7KW7VDRq85bglhapibGjy5G8IIFAe8Us1pVdFY7qrhiaHrX
         cxfA==
X-Gm-Message-State: AOAM533JwZzquIJ2qqTF/FxUzlVUQ8DZGi3S3rYbiUgnyIytU6kwX7+7
        xGJU1acXwuN+TYlSbK4nG2w=
X-Google-Smtp-Source: ABdhPJxXEwjA66TlNmzYlUZCuMfuAaRE+874S9Bqpa0e67m7LPYgUUhtbwPh1eTSX8cCwirlRy23Ag==
X-Received: by 2002:a17:90a:2acb:: with SMTP id i11mr2381934pjg.131.1619155282437;
        Thu, 22 Apr 2021 22:21:22 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id y24sm6238825pjp.26.2021.04.22.22.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 22:21:22 -0700 (PDT)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next v2 05/15] net: ethernet: mtk_eth_soc: reduce MDIO bus access latency
Date:   Thu, 22 Apr 2021 22:20:58 -0700
Message-Id: <20210423052108.423853-6-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
References: <20210423052108.423853-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

usleep_range often ends up sleeping much longer than the 10-20us provided
as a range here. This causes significant latency in mdio bus acceses,
which easily adds multiple seconds to the boot time on MT7621 when polling
DSA slave ports.
Use cond_resched instead of usleep_range, since the MDIO access does not
take much time

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5cf64de3ddf8..d992d4f1f400 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -86,7 +86,7 @@ static int mtk_mdio_busy_wait(struct mtk_eth *eth)
 			return 0;
 		if (time_after(jiffies, t_start + PHY_IAC_TIMEOUT))
 			break;
-		usleep_range(10, 20);
+		cond_resched();
 	}
 
 	dev_err(eth->dev, "mdio: MDIO timeout\n");
-- 
2.31.1

