Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF1CA5EFCC7
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 20:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235550AbiI2SOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 14:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235438AbiI2SOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 14:14:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC561F65EC
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:14:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3553d2d9d7fso17131937b3.5
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 11:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=jYPKWuT1u5m0MnKr4TovJZUrMbudnfje+CzX8rxj9dY=;
        b=Ury0CFn0zT2Q+dgdtmwk3iQr3s9PWnviEmpKdjL2ckeEaSmqrBmREvZyOZsYx7mfNx
         ECzbRm2XMKNf8IHIfQieAGeVmFDIKL4DvNsgEpkMewEU+OzV/roiRamuWScwv9Oc1wRN
         ijQp0mOci65LBvTFCA0oCNoNC8WlfpZsz+Tq7aVC8M0pO+Hj+OnGwI5r7GGQ2npv/b+V
         21bRDiDcuTW39u8v2MFAmqGu/gcyiUSyN20+vWsHPh1gtHAvk8ThOVjIFxdOBhx8XTyc
         jfszHIqgdfl0jAOVUeHhK+UvFa1CyD4djovV+L8K84r1YaiZsjc9wGyt7ZHsGqI8mieF
         JEVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=jYPKWuT1u5m0MnKr4TovJZUrMbudnfje+CzX8rxj9dY=;
        b=c3oVyoSNoR0Ixu0fSdNhV5MAC1pcGLXnDbY8A3inTTq1hBn/8MfQ16KOJUSt2Oyzed
         gvPCfHf3jyDECXS0FN2MLer/SOjrXuSReDoKl3kUC/P/0/1BQSWHPNpfn2JxEJn1cJ5O
         dQ9Q8BNgpS0az1fWCxr13rroxzbcSqA882rlhVsFCioPxLSneKGg1rJl4Ft3UtCtwZq/
         2m9GPLvz5K6T5JQPmZbY8xUWMizK0LQTY5shkSQQbEtLYg4vtwu1yBy2osVXY0USgFdz
         F3EBeZROf+aEgzATW94onOXCx9WMap5ocII30S44HbeNKaASUIcIo790dL9E4cWjjN1K
         CuAw==
X-Gm-Message-State: ACrzQf3C73IJM6zEFeIvzS+Cet655+KSbQDJXphKype1dEpJlftBqTU7
        5U05iXQbLGEIQGaRUBAOyU/Ae+taZw==
X-Google-Smtp-Source: AMsMyM6Pf2IhccLpOcVpEi4t74u7CQmid4Z2TwcCudea8RUMSv/ibgUI3NSufaIAn+mbxQCtqU2gHTq9QA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:9104:0:b0:6bc:5ecf:30b7 with SMTP id
 v4-20020a259104000000b006bc5ecf30b7mr4758739ybl.293.1664475257510; Thu, 29
 Sep 2022 11:14:17 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:14:11 -0700
In-Reply-To: <20220919182832.158c0ea2@kernel.org>
Mime-Version: 1.0
References: <20220919182832.158c0ea2@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929181411.61331-1-nhuck@google.com>
Subject: [PATCH v2] net: mana: Fix return type of mana_start_xmit
From:   Nathan Huckleberry <nhuck@google.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, decui@microsoft.com, edumazet@google.com,
        error27@gmail.com, haiyangz@microsoft.com, kys@microsoft.com,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, nhuck@google.com, pabeni@redhat.com,
        sthemmin@microsoft.com, trix@redhat.com, wei.liu@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of mana_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
---

Changes v1 -> v2
- Update header file

 drivers/net/ethernet/microsoft/mana/mana_en.c | 2 +-
 include/net/mana/mana.h                       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 7ca313c7b7b3..a3df5678bb4f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -141,7 +141,7 @@ static int mana_map_skb(struct sk_buff *skb, struct mana_port_context *apc,
 	return -ENOMEM;
 }
 
-int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	enum mana_tx_pkt_format pkt_fmt = MANA_SHORT_PKT_FMT;
 	struct mana_port_context *apc = netdev_priv(ndev);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index 20212ffeefb9..3bb579962a14 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -390,7 +390,7 @@ struct mana_port_context {
 	struct mana_ethtool_stats eth_stats;
 };
 
-int mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
+netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev);
 int mana_config_rss(struct mana_port_context *ac, enum TRI_STATE rx,
 		    bool update_hash, bool update_tab);
 
-- 
2.38.0.rc1.362.ged0d419d3c-goog

