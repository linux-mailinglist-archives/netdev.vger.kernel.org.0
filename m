Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3B1334137
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 16:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbhCJPK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 10:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232405AbhCJPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 10:10:49 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CC4C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:10:48 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id t1so28570429eds.7
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 07:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txuoshCkPsm83iOosh/EIGCi7VepGMtIuivCuCl9xbI=;
        b=KYy1lIrio84+ziXIg2gLupK7Vu+vfBpVsh7qyQpUP89dL0wanpyCMJ1HVgz+VA8iYY
         0y3+nVGxIZZHMym6HjP+F43a/0A2CFoIAKlvFTaMf/iPf26e2mOCaTcbLbgndVU+Gf6M
         quprDskfz4xDbDwG9N+tQNlMN6gba0m5w09YpOcx3FLfmU+mkvwD/CI3yzw9jbMp+pyo
         MuzMBKSYmF4RQIKQtGzxgnVbT+UnJTAOqLe0iHxPM3LbsGFXR4w8pxT5JsT6f5SvDfc/
         gw1dTTw0TFcBTV/g6Ews3cUa/Ml4KCR+0ss4g/gH9alTgvtC75bMyWZQqQJK9emh2f07
         CwmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=txuoshCkPsm83iOosh/EIGCi7VepGMtIuivCuCl9xbI=;
        b=Z8aKBZk/mRg+dB77mDgC7F73Kit7B2eDrwgy9HB5dw3I1ICAroCptuQXn3/W6D9GXT
         RgUJQTprWqMqT0xoN26Hx4nMlej0mjzzFat6uuY6TMM45wIiJbYBqAR9OuX+dSg4Cdhg
         s78ktMJtk12JCJj/D0gRYd877eONvdDxULygbZxoSDna4pS+5iczWMU4KRkszIzRblj+
         zVylvartc88vvYZxcacu8/o/fs2QQot1msbF/6/3RWX+N5RpgIRwqj7Po6grFxdxrBpq
         lx4HiTYzP6V1qcqbCJ1wSE24B2pXEoTXJ8Vr5kDTSFTqWOtLXoXOyxs3iIhd+L0ovFHS
         QdbQ==
X-Gm-Message-State: AOAM530nNMx2nWRcWlIfWReJFPWO9Gp4NItqkVvqfeazaXMwTiGexDzM
        UCcfke5eL8qwE/SE5A/yU8gS6a7AQn8=
X-Google-Smtp-Source: ABdhPJyFrj3kHJsil4Wl2R9so/BjQKR1xAudKkj2N0ENpYzXnAPnH23e15nFy9SELXT9vF4+NUirtg==
X-Received: by 2002:aa7:cf17:: with SMTP id a23mr3940193edy.30.1615389047431;
        Wed, 10 Mar 2021 07:10:47 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id v9sm9992230ejc.37.2021.03.10.07.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 07:10:47 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [RFC PATCH net] net: stmmac: Fix hardware TX timestamping on queue with tc-etf enabled
Date:   Wed, 10 Mar 2021 17:10:33 +0200
Message-Id: <20210310151033.630349-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 29d98f54a4fe ("net: enetc: allow hardware timestamping on
TX queues with tc-etf enabled"), I went through the other drivers that
offload tc-etf, and I believe I found a similar bug in stmmac.

Fixes: 579a25a854d4 ("net: stmmac: Initial support for TBS")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 208cae344ffa..1393898a7d6d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3636,6 +3636,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		tbs_desc = &tx_q->dma_entx[first_entry];
 		stmmac_set_desc_tbs(priv, tbs_desc, ts.tv_sec, ts.tv_nsec);
+		skb->tstamp = ktime_set(0, 0);
 	}
 
 	stmmac_set_tx_owner(priv, first);
-- 
2.25.1

