Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BEA25AA20
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 13:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIBLTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 07:19:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46032 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgIBLTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 07:19:13 -0400
Received: by mail-lj1-f196.google.com with SMTP id c2so5373430ljj.12;
        Wed, 02 Sep 2020 04:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sIqApshDOtTxlo5FK8DhBC+GEPu//rVe7EZe6AlqDB0=;
        b=mXfRi7nPl2saIhJRyJ0d888xpn6ibcJVbojEc+k2Ap9MyLEnY0oFxzknNNB0i2LaIx
         NdXrnFRTi3PpMaJcnEMiilmrp+QxTNyj3fQI6JUWxT5SrBe0oGKpLPR4w4bJ1ClBA86T
         wrSgBt4CDoLxt1StCZbf2Uv/fProBV+ZKuADX5RR6H1w/muUNZZ7B4QTVJFIywTbhIGH
         PyL7LRmiGWGMSSTZZ/+MS0lT+Eyee7bjfzD81FybkKt52IWjKqSd5Hs5Z0BQUUMf/hmi
         ckEL15CsbfOnp+QfC2JH2/jbN79hQCi0aOEVQrpUr3hBR0o0AIe97/6ZX05+QfRUp3cP
         tDTg==
X-Gm-Message-State: AOAM532PaR0nsDLf7JDMlqlqCI8icuaV89x2XhYLwx4za64+QTLQpVCs
        kFvRpqTo7C3DPw6Mj7asBK8anv6NExM=
X-Google-Smtp-Source: ABdhPJxxkPw6jkHz1bBom1/zQNxuNhpGQd3XWzcNVPjJ0/ap1nFPYYKYWNKtXDnbixx9Dbl5Af7dFA==
X-Received: by 2002:a2e:91d2:: with SMTP id u18mr3039908ljg.436.1599045550650;
        Wed, 02 Sep 2020 04:19:10 -0700 (PDT)
Received: from localhost.localdomain (broadband-37-110-38-130.ip.moscow.rt.ru. [37.110.38.130])
        by smtp.googlemail.com with ESMTPSA id n62sm465066lfa.82.2020.09.02.04.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 04:19:09 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Doug Berger <opendmb@gmail.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] net: bcmgenet: fix mask check in bcmgenet_validate_flow()
Date:   Wed,  2 Sep 2020 14:18:45 +0300
Message-Id: <20200902111845.9915-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VALIDATE_MASK(eth_mask->h_source) is checked twice in a row in
bcmgenet_validate_flow(). Add VALIDATE_MASK(eth_mask->h_dest)
instead.

Fixes: 3e370952287c ("net: bcmgenet: add support for ethtool rxnfc flows")
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
I'm not sure that h_dest check is required here, it's only my guess.
Compile tested only.

 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 0ca8436d2e9d..be85dad2e3bc 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1364,7 +1364,7 @@ static int bcmgenet_validate_flow(struct net_device *dev,
 	case ETHER_FLOW:
 		eth_mask = &cmd->fs.m_u.ether_spec;
 		/* don't allow mask which isn't valid */
-		if (VALIDATE_MASK(eth_mask->h_source) ||
+		if (VALIDATE_MASK(eth_mask->h_dest) ||
 		    VALIDATE_MASK(eth_mask->h_source) ||
 		    VALIDATE_MASK(eth_mask->h_proto)) {
 			netdev_err(dev, "rxnfc: Unsupported mask\n");
-- 
2.26.2

