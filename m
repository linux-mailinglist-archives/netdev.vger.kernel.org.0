Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C2061FDF4
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiKGSzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbiKGSza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:55:30 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A295E1139;
        Mon,  7 Nov 2022 10:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rEqDOzrzv1cA6N1C5HIe09p8JEcexs62RmH77rmkVQs=; b=IWCk0ao9veAQ5SBFD7O1oI/aTQ
        GbtUnG5IY6yzXmxO80j7/qvUBvKANFx+UwIqk1AfavoCvx+IqEkX2WhxEQOFtScwjsRR7iLO1Ff0t
        ebQVzDPNmEdZ9cbPfjYABI16FwypzAgvh2lXtSyakE/kbFZXPYxxnQ1OscuWonR+iRsY=;
Received: from p200300daa72ee1007849d74f78949f6c.dip0.t-ipconnect.de ([2003:da:a72e:e100:7849:d74f:7894:9f6c] helo=Maecks.lan)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1os7HE-000LCc-0p; Mon, 07 Nov 2022 19:55:20 +0100
From:   Felix Fietkau <nbd@nbd.name>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Date:   Mon,  7 Nov 2022 19:54:46 +0100
Message-Id: <20221107185452.90711-8-nbd@nbd.name>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221107185452.90711-1-nbd@nbd.name>
References: <20221107185452.90711-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On MTK SoC ethernet, using NETIF_F_HW_VLAN_CTAG_RX in combination with hardware
special tag parsing can pass the special tag port metadata as VLAN protocol ID.
When the results is added as a skb hwaccel VLAN tag, it triggers a warning from
vlan_do_receive before calling the DSA tag receive function.
Remove this warning in order to properly pass the tag to the DSA receive function,
which will parse and clear it.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/8021q/vlan.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 5eaf38875554..3f9c0406b266 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -44,7 +44,6 @@ static inline int vlan_proto_idx(__be16 proto)
 	case htons(ETH_P_8021AD):
 		return VLAN_PROTO_8021AD;
 	default:
-		WARN(1, "invalid VLAN protocol: 0x%04x\n", ntohs(proto));
 		return -EINVAL;
 	}
 }
-- 
2.38.1

