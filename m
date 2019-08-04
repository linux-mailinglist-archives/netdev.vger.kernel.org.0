Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8408D80B5E
	for <lists+netdev@lfdr.de>; Sun,  4 Aug 2019 17:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfHDPKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 11:10:30 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35529 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfHDPK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 11:10:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id l2so70694175wmg.0
        for <netdev@vger.kernel.org>; Sun, 04 Aug 2019 08:10:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GIK3vLRJwz2VMoF4+r1s0h38UAW4YbVeLg7YVAMmYKw=;
        b=K667K8pJtqNghyF+Tj40CxvuTIMaiUqUqe8GNzgc9gCLDP3O9UEL2UQP1tA5WQNsz2
         s4xo1opK4dfx2ptLUpwYykRpAXfOXseWLwOaB4QkMPP2dIeenrAReJbxGaBlL6plEpNC
         1Wa+FHC81XhiNB3VUXZ44Od+GXsw3PTplRT7tLbtmODpFnBvF8d1KtpQEoGtN7ZO0XDs
         x5Ygb0K8GUVP6H4hbmYNLq6uxpg6oYbEYmOy4wuWWq7nV4xONxsSnU3HG/IFmvzZqnZk
         e3Dz1n5LUjTbUWflvdwt17YrEeAK/5ZjtVl/iOL7d82cSjxWsc4iKRHziuPQXvLT9S+7
         HC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GIK3vLRJwz2VMoF4+r1s0h38UAW4YbVeLg7YVAMmYKw=;
        b=h2fZjlFrgsgAbtXcldmP33KUX62eSrwlT+DD8sFucUbPy/2r+HVuN7Bn5kQiLmq/1G
         7Saex5dYBQgafbqJmiXBBMiFSjZqPHkYUd5KstvcfOfmEb+dlZda3VIWh4wm9/FQp+gL
         DAtWKTtxoVesYH8jibo87R+zwuaymTrLjiyzN9zffPPPQV4VFDL4xmuCSePtp6r1pWU+
         mNDbqtSekaLr3D+pX3DLCXt745n5tp93Cyic08f06u8UZ/H1n7cYRrrVqRQESl1NkAO1
         Bt/eZOjNoMeERZ40eqmafIsa37bXPQ+n9sjN/pklwYNq6dr9ODSLMZwdmxq5gmREYVXB
         bUGw==
X-Gm-Message-State: APjAAAUy22duSp4rxc3Us83jLVJ0NnDHngtFDomWJFTkIxpvG9mwxvwJ
        u4U5kvND6BF/jEjwpxu/+sGFzL339SQ=
X-Google-Smtp-Source: APXvYqw6M4lDEFIDDE/Ggl3X7tuYrCcw2WcSx/3czxN9CxpNT8ZFQTrZ8/f0YfcYHIa5YkbsMHIHWw==
X-Received: by 2002:a1c:2c41:: with SMTP id s62mr14237536wms.8.1564931425845;
        Sun, 04 Aug 2019 08:10:25 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm63769441wmh.36.2019.08.04.08.10.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 04 Aug 2019 08:10:25 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 02/10] net: sched: add skbedit of ptype action to hardware IR
Date:   Sun,  4 Aug 2019 16:09:04 +0100
Message-Id: <1564931351-1036-3-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
References: <1564931351-1036-1-git-send-email-john.hurley@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TC rules can impliment skbedit actions. Currently actions that modify the
skb mark are passed to offloading drivers via the hardware intermediate
representation in the flow_offload API.

Extend this to include skbedit actions that modify the packet type of the
skb. Such actions may be used to set the ptype to HOST when redirecting a
packet to ingress.

Signed-off-by: John Hurley <john.hurley@netronome.com>
Reviewed-by: Simon Horman <simon.horman@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 include/net/flow_offload.h | 2 ++
 net/sched/cls_api.c        | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 00b9aab..04c29f5 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -126,6 +126,7 @@ enum flow_action_id {
 	FLOW_ACTION_ADD,
 	FLOW_ACTION_CSUM,
 	FLOW_ACTION_MARK,
+	FLOW_ACTION_PTYPE,
 	FLOW_ACTION_WAKE,
 	FLOW_ACTION_QUEUE,
 	FLOW_ACTION_SAMPLE,
@@ -168,6 +169,7 @@ struct flow_action_entry {
 		const struct ip_tunnel_info *tunnel;	/* FLOW_ACTION_TUNNEL_ENCAP */
 		u32			csum_flags;	/* FLOW_ACTION_CSUM */
 		u32			mark;		/* FLOW_ACTION_MARK */
+		u16                     ptype;          /* FLOW_ACTION_PTYPE */
 		struct {				/* FLOW_ACTION_QUEUE */
 			u32		ctx;
 			u32		index;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 3565d9a..ae73d37 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3294,6 +3294,9 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 			default:
 				goto err_out;
 			}
+		} else if (is_tcf_skbedit_ptype(act)) {
+			entry->id = FLOW_ACTION_PTYPE;
+			entry->ptype = tcf_skbedit_ptype(act);
 		} else {
 			goto err_out;
 		}
-- 
2.7.4

