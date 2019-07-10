Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 794C764C1B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbfGJSas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:30:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35522 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbfGJSas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:30:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so3276796wmg.0
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=J1polEHR6zNsqvd/wi5fYTixTxgtkkeSm5PSntnADOE=;
        b=X/aYHQBDgrr/WnjYV0qHqUSeKZZRn2FyeJRSjm+BgI0wrGGt1WL/MM71OtZABzZzFC
         lb3t3I/Zvm4LpY2PXE653+ulclk6ACzaIhCn5dga7r3gq4GOkA0GUZMFWp3i6QrFJwtX
         xu61EkbaALzOBgz74gPgc2oRrKcRElZ+F9ylZjuePHayCRn73RWm6Gpn7Mo+Z5bOLC4A
         l6cxCUKZ4AP9HxqYI4HqRMuFIJoSG8kERVrfitGrja6QNrwHM+rvYDs8xuNtoM3Q6Jpw
         a9jegIik0zeJynZS+dfPY8Tvd2LGeFJxV4Z+uVeXzZRK8Q9VKoxhPv+a+IqWeqR8P1/v
         QfmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=J1polEHR6zNsqvd/wi5fYTixTxgtkkeSm5PSntnADOE=;
        b=f0W6BA46jFnFGPHDdqSE6s0ejPJSemp3XpuX7YHjdMZCbdM6eA1LdpLG883Fc5jCNS
         9c/95sHP7Ooy1/8bWZEiXq0VI7+Mp1YGea3dPfNWcM8H4awctM2T484oUOnTdDf9kvzZ
         dkO+ihzeCkf3VbemR8gLlPl3uZJ/l6KIkF+S03oxtwc1EkCsDou3dXU3GYfRuMS+2JOT
         JJYixNQOHCW4ezLJr4A3Azv2JCecoLbKbmhK/+/I9SQZ9LRb9mtaAB1yertFu0s4tpgG
         I8+vbx5koViRWTUVYsD7Oe11T9AqXqQqYbFKQ+Nv22bzaw55AfhEixUPfS18oMXG4Xh/
         NNyw==
X-Gm-Message-State: APjAAAUVXFjbHsIZXi9vpT3PSnUMiRk/k62E72XGGLsfPI13hfmMs5r1
        WSBP01vOdb9nakmb8vEIOnVhqUsDRIU=
X-Google-Smtp-Source: APXvYqxnSRe7EjqXKDY3PfckBfw92Uxjf2/HB9Xi3AIxX4M/szJWzUEJpqzL0SGiP0tOHCM9lumrPQ==
X-Received: by 2002:a1c:3c04:: with SMTP id j4mr6055913wma.37.1562783446373;
        Wed, 10 Jul 2019 11:30:46 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id p3sm2747584wmg.15.2019.07.10.11.30.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 11:30:45 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 1/2] nfp: flower: fix ethernet check on match fields
Date:   Wed, 10 Jul 2019 19:30:29 +0100
Message-Id: <1562783430-7031-2-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562783430-7031-1-git-send-email-john.hurley@netronome.com>
References: <1562783430-7031-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NFP firmware does not explicitly match on an ethernet type field. Rather,
each rule has a bitmask of match fields that can be used to infer the
ethernet type.

Currently, if a flower rule contains an unknown ethernet type, a check is
carried out for matches on other fields of the packet. If matches on
layer 3 or 4 are found, then the offload is rejected as firmware will not
be able to extract these fields from a packet with an ethernet type it
does not currently understand.

However, if a rule contains an unknown ethernet type without any L3 (or
above) matches then this will effectively be offloaded as a rule with a
wildcarded ethertype. This can lead to misclassifications on the firmware.

Fix this issue by rejecting all flower rules that specify a match on an
unknown ethernet type.

Further ensure correct offloads by moving the 'L3 and above' check to any
rule that does not specify an ethernet type and rejecting rules with
further matches. This means that we can still offload rules with a
wildcarded ethertype if they only match on L2 fields but will prevent
rules which match on further fields that we cannot be sure if the firmware
will be able to extract.

Fixes: af9d842c1354 ("nfp: extend flower add flow offload")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 7e725fa..885f968 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -368,15 +368,12 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			break;
 
 		default:
-			/* Other ethtype - we need check the masks for the
-			 * remainder of the key to ensure we can offload.
-			 */
-			if (nfp_flower_check_higher_than_mac(flow)) {
-				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: non IPv4/IPv6 offload with L3/L4 matches not supported");
-				return -EOPNOTSUPP;
-			}
-			break;
+			NL_SET_ERR_MSG_MOD(extack, "unsupported offload: match on given EtherType is not supported");
+			return -EOPNOTSUPP;
 		}
+	} else if (nfp_flower_check_higher_than_mac(flow)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot match above L2 without specified EtherType");
+		return -EOPNOTSUPP;
 	}
 
 	if (basic.mask && basic.mask->ip_proto) {
-- 
2.7.4

