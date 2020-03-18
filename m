Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 284C8189857
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbgCRJqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:46:44 -0400
Received: from smtp-rs2-vallila1.fe.helsinki.fi ([128.214.173.73]:53282 "EHLO
        smtp-rs2-vallila1.fe.helsinki.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727569AbgCRJqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 05:46:43 -0400
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
        by smtp-rs2.it.helsinki.fi (8.14.7/8.14.7) with ESMTP id 02I9cEcM006446;
        Wed, 18 Mar 2020 11:38:14 +0200
Received: by whs-18.cs.helsinki.fi (Postfix, from userid 1070048)
        id B39C7360F61; Wed, 18 Mar 2020 11:38:14 +0200 (EET)
From:   =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
To:     netdev@vger.kernel.org
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: [RFC PATCH 27/28] gro: flushing when CWR is set negatively affects AccECN
Date:   Wed, 18 Mar 2020 11:38:08 +0200
Message-Id: <1584524289-24187-27-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1584524289-24187-2-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1584524289-24187-2-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>

As AccECN may keep CWR bit asserted due to different
interpretation of the bit, flushing with GRO because of
CWR may effectively disable GRO until AccECN counter
field changes such that CWR-bit becomes 0.

There is no harm done from not immediately forwarding the
CWR'ed segment with RFC3168 ECN.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
---
 net/ipv4/tcp_offload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_offload.c b/net/ipv4/tcp_offload.c
index 58ce382c793e..555c9be84f10 100644
--- a/net/ipv4/tcp_offload.c
+++ b/net/ipv4/tcp_offload.c
@@ -240,7 +240,6 @@ struct sk_buff *tcp_gro_receive(struct list_head *head, struct sk_buff *skb)
 found:
 	/* Include the IP ID check below from the inner most IP hdr */
 	flush = NAPI_GRO_CB(p)->flush;
-	flush |= (__force int)(flags & TCP_FLAG_CWR);
 	flush |= (__force int)((flags ^ tcp_flag_word(th2)) &
 		  ~(TCP_FLAG_FIN | TCP_FLAG_PSH));
 	flush |= (__force int)(th->ack_seq ^ th2->ack_seq);
-- 
2.20.1

