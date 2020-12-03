Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 758AB2CD893
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbgLCOJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:09:08 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:14471 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgLCOJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:09:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1607004375;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=OlLlHGEwvtQ1VIatDyql3LwQKLLdufpCbVcOkYrbqmQ=;
        b=i1lZ/Nr4WQGyrZsYClLqZgjp3upatjLYVwhinpMpK6LMkf815UMP/XGPLnMQI47YIA
        /D4xWKwr1aQdPRfga+b2Vs42dKGSVNGJZDNyEK7tWalS3FQCAcMhtT+uj+1vMSuSO1k+
        iSrKDyMBy2cmw7ZkLrJCPV2jkXXc1wuxNVGUXPUhRPkuDivVPxlwYFma0681JEgzhNcU
        /wt+FkbIRVrZl66gdi2413SXb3jz8lx1VnRJgKBj+UOKo4AT2Rah38gtYrUnXzq6ogdE
        LpFh6be4slxQOKpuRYhVfdIwWGr4n3yf3k8nsT4BcPKaamGJdnWxBm5QCarXlIdxqJq6
        KXQA==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9dyKNLCWJaRrQ0pDCeGtVbNHMQ98lI/DcPKMT"
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 47.3.4 AUTH)
        with ESMTPSA id n07f3bwB3E6EFor
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 3 Dec 2020 15:06:14 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     mkl@pengutronix.de, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>
Subject: [PATCH 1/2] can-isotp: block setsockopt on bound sockets
Date:   Thu,  3 Dec 2020 15:06:03 +0100
Message-Id: <20201203140604.25488-2-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203140604.25488-1-socketcan@hartkopp.net>
References: <20201203140604.25488-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The isotp socket can be widely configured in its behaviour regarding
addressing types, fill-ups, receive pattern tests and link layer length.
Usually all these settings need to be fixed before bind() and can not
be changed afterwards.

This patch adds a check to enforce the common usage pattern.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Tested-by: Thomas Wagner <thwa1@web.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d78ab13bd8be..26bdc3c20b7e 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1155,10 +1155,13 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 	int ret = 0;
 
 	if (level != SOL_CAN_ISOTP)
 		return -EINVAL;
 
+	if (so->bound)
+		return -EISCONN;
+
 	switch (optname) {
 	case CAN_ISOTP_OPTS:
 		if (optlen != sizeof(struct can_isotp_options))
 			return -EINVAL;
 
-- 
2.29.2

