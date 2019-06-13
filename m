Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D6644E3A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfFMVR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:17:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42226 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMVR0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:17:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id s15so87207qtk.9
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 14:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VSzfnHn2m5yDmIrDg5MuySzKmfGkpGT2pO4EK7oLzVU=;
        b=m0OHxUiFIpmRr7kPccYtZeWEFBbYu1R+GcZn6VtgMJKrXFMovKpg9PVOzKErQTYQse
         QZ76ktK4Lb7I/052D5sYCO8mHXns3R5vIBbgWBce7/eflmCBLsU1HgodTr1PTFTumOmC
         EbOPkevDxW6P2O13VbKa6OJTbTaZN8/sG3sNiUqCrD5/igtF522RaJeDWIqmM9O6f2M8
         P1SqrwFiv5PFrjx6MYcL9TQEATqhyLIO+biYpzhzIpfoLXOC+9+rt6nx3GgetKqa74ZF
         HW3IvQ9TaZS3NAHrldQRvdtAPqATp52+oYmQVPA2U+4U/He6EUbFEbiUgM3oREae+m26
         EwNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VSzfnHn2m5yDmIrDg5MuySzKmfGkpGT2pO4EK7oLzVU=;
        b=rWI27u6awf3YF+TYOknJRi+G4+0WMz9BUQabMh66GvoOxlU0RdckkO+/6PVksvQeAS
         3wxTEdw8P2hLjhMJsC6e2c4ZTTRvWmgAv+5ms6LfhrrrGaDweoMAed3t+li0cRCvpRsZ
         dAmkukzNY7HfeQX0cR0YBaEq3+rQYDKzdsPW/KrJcxFUYfw8Goc1Ul0fVI9VrLfymYFS
         p7TjhtmZ/aRuW3WsyTkIT3Dm9ZyxEaqaQ4F7i/l8DjXkgWmQ31cnCJ3Ip2iyFrKcfX2o
         aZS88CDvhy+XICTlKhSc2dH9UES36Q9JQuBeBF9PIksf8lOfX3jYu+Zz0vrGMhcEGXzO
         AUkQ==
X-Gm-Message-State: APjAAAWidGTZ9JG4Ft/Ta0USPOr6+5Z1ITlqBZH4ULp1pfQA1v2GiV+c
        z/XMXwzDLFc6qnKET591uYCYDQ==
X-Google-Smtp-Source: APXvYqyjihnPNNCaAAm78zx8a/QoxyWtxrRwkQN0+6z7ABWUN/aUKkb1UEYsln2CnQAErrX5Iac6hw==
X-Received: by 2002:ac8:3308:: with SMTP id t8mr65303355qta.390.1560460645261;
        Thu, 13 Jun 2019 14:17:25 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x7sm497322qth.37.2019.06.13.14.17.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 14:17:24 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 1/3] nfp: flower: check L4 matches on unknown IP protocols
Date:   Thu, 13 Jun 2019 14:17:09 -0700
Message-Id: <20190613211711.5505-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613211711.5505-1-jakub.kicinski@netronome.com>
References: <20190613211711.5505-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Matching on fields with a protocol that is unknown to hardware
is not strictly unsupported. Determine if hardware can offload
a filter with an unknown protocol by checking if any L4 fields
are being matched as well.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 1fbfeb43c538..3cccd0911e31 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -132,6 +132,14 @@ static bool nfp_flower_check_higher_than_mac(struct tc_cls_flower_offload *f)
 	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
 }
 
+static bool nfp_flower_check_higher_than_l3(struct tc_cls_flower_offload *f)
+{
+	struct flow_rule *rule = tc_cls_flower_offload_flow_rule(f);
+
+	return flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS) ||
+	       flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ICMP);
+}
+
 static int
 nfp_flower_calc_opt_layer(struct flow_match_enc_opts *enc_opts,
 			  u32 *key_layer_two, int *key_size)
@@ -297,7 +305,6 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 	}
 
 	if (basic.mask && basic.mask->ip_proto) {
-		/* Ethernet type is present in the key. */
 		switch (basic.key->ip_proto) {
 		case IPPROTO_TCP:
 		case IPPROTO_UDP:
@@ -311,7 +318,9 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			/* Other ip proto - we need check the masks for the
 			 * remainder of the key to ensure we can offload.
 			 */
-			return -EOPNOTSUPP;
+			if (nfp_flower_check_higher_than_l3(flow))
+				return -EOPNOTSUPP;
+			break;
 		}
 	}
 
-- 
2.21.0

