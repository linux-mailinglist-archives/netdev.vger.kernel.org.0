Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1114464C1C
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbfGJSav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 14:30:51 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56015 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbfGJSat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 14:30:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so3263199wmj.5
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 11:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y+nhRyHtKngoHJN0lKHoiZm2Ls8+pD4TxzdEQq9blk8=;
        b=lvIQNsqy6J+X2UzbsuCzQW3R2d2AulHrOZ1k11l25Paxn4b6/9HdSTyc+jnbDnDdq0
         FwIWpXZPTYjKxGdF+2ZJrb2Ss3iRifDmPwop/5yjCDFr66Oj83FVO5GlOkKz252sAmOc
         pd4cQopiROOakHVPMALx1w/Qpb3tJI9ghJS/pD9AMFUm1HIXzr27DQ04FSaCQZXzr0PL
         blAZ12c/CZDotb4BhTJ1KN+R7F2u/she+9t7jW60wIIl2A+3u1efqB9QFnEcr34IBngq
         Bt3LFe9e2Ck1CfIZ47uS/Ihck2+VeR7gZqULJOLN+iiOHba/lxQhYbWYK6a2o2bIZaV3
         /S+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y+nhRyHtKngoHJN0lKHoiZm2Ls8+pD4TxzdEQq9blk8=;
        b=Gb/wll323hYGmY1CioPmZ3Aem2L+T2+V5Bwc0iXNnPBZX6sm31VevzesRf0dlCGdWF
         TEW1EZtvnwG48bq+tD/kWGLXr65echWIEY/HCq1l8p2bzDVUhaG3Z1ggz/ydC+jRpf0o
         23fswjtKxM8kyp3ofEeXqpSrY16s5YV6Qne6LKUT6MbCKVIWGlWVOvIJsXKRSG+5DG+B
         lU6W4IAyx8rdZ00lKh7mqmpjlZ5otOiYSAthEjmxP/A6uWbj7w0yD1k6R/GxJzJLjDpb
         pFFvWUpzeeGapFrL0zilqb5wYDxo0YM6UMGgJeX8UqlI16GaVBcsf8+UYrSUMJ9T5nBE
         spTA==
X-Gm-Message-State: APjAAAXykKEdywfaAwpC+pSmIrEqANQFQMN7WB0uvTVqvXOTzPPSC0o6
        uIBsZNENwzI9JsID2ADKNhLrrJAj8gY=
X-Google-Smtp-Source: APXvYqw8zZQ0Skl9zlLGWMWyQXdF75MJkUsuqH4ADVTa2kVK4SYNyPEmEsZk9EI7qz0G4CqdGoZSYA==
X-Received: by 2002:a1c:cfc3:: with SMTP id f186mr6034715wmg.134.1562783447826;
        Wed, 10 Jul 2019 11:30:47 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id p3sm2747584wmg.15.2019.07.10.11.30.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 10 Jul 2019 11:30:47 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 2/2] nfp: flower: ensure ip protocol is specified for L4 matches
Date:   Wed, 10 Jul 2019 19:30:30 +0100
Message-Id: <1562783430-7031-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562783430-7031-1-git-send-email-john.hurley@netronome.com>
References: <1562783430-7031-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Flower rules on the NFP firmware are able to match on an IP protocol
field. When parsing rules in the driver, unknown IP protocols are only
rejected when further matches are to be carried out on layer 4 fields, as
the firmware will not be able to extract such fields from packets.

L4 protocol dissectors such as FLOW_DISSECTOR_KEY_PORTS are only parsed if
an IP protocol is specified. This leaves a loophole whereby a rule that
attempts to match on transport layer information such as port numbers but
does not explicitly give an IP protocol type can be incorrectly offloaded
(in this case with wildcard port numbers matches).

Fix this by rejecting the offload of flows that attempt to match on L4
information, not only when matching on an unknown IP protocol type, but
also when the protocol is wildcarded.

Fixes: 2a04784594f6 ("nfp: flower: check L4 matches on unknown IP protocols")
Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 885f968..faa8ba0 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -386,18 +386,15 @@ nfp_flower_calculate_key_layers(struct nfp_app *app,
 			key_layer |= NFP_FLOWER_LAYER_TP;
 			key_size += sizeof(struct nfp_flower_tp_ports);
 			break;
-		default:
-			/* Other ip proto - we need check the masks for the
-			 * remainder of the key to ensure we can offload.
-			 */
-			if (nfp_flower_check_higher_than_l3(flow)) {
-				NL_SET_ERR_MSG_MOD(extack, "unsupported offload: unknown IP protocol with L4 matches not supported");
-				return -EOPNOTSUPP;
-			}
-			break;
 		}
 	}
 
+	if (!(key_layer & NFP_FLOWER_LAYER_TP) &&
+	    nfp_flower_check_higher_than_l3(flow)) {
+		NL_SET_ERR_MSG_MOD(extack, "unsupported offload: cannot match on L4 information without specified IP protocol type");
+		return -EOPNOTSUPP;
+	}
+
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_TCP)) {
 		struct flow_match_tcp tcp;
 		u32 tcp_flags;
-- 
2.7.4

