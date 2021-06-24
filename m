Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4BB3B278A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 08:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbhFXGo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 02:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhFXGo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 02:44:27 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B44FC061760
        for <netdev@vger.kernel.org>; Wed, 23 Jun 2021 23:42:08 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lwJ3u-0008QV-Pr
        for netdev@vger.kernel.org; Thu, 24 Jun 2021 08:42:06 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 67D496427B8
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 06:42:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 175D06427A4;
        Thu, 24 Jun 2021 06:42:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c7d39db2;
        Thu, 24 Jun 2021 06:42:02 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Norbert Slusarek <nslusarek@gmx.net>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/2] can: j1939: j1939_sk_setsockopt(): prevent allocation of j1939 filter for optlen == 0
Date:   Thu, 24 Jun 2021 08:41:59 +0200
Message-Id: <20210624064200.2998085-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624064200.2998085-1-mkl@pengutronix.de>
References: <20210624064200.2998085-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>

If optval != NULL and optlen == 0 are specified for SO_J1939_FILTER in
j1939_sk_setsockopt(), memdup_sockptr() will return ZERO_PTR for 0
size allocation. The new filter will be mistakenly assigned ZERO_PTR.
This patch checks for optlen != 0 and filter will be assigned NULL in
case of optlen == 0.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Link: https://lore.kernel.org/r/20210620123842.117975-1-nslusarek@gmx.net
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index fce8bc8afeb7..e1a399821238 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -676,7 +676,7 @@ static int j1939_sk_setsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case SO_J1939_FILTER:
-		if (!sockptr_is_null(optval)) {
+		if (!sockptr_is_null(optval) && optlen != 0) {
 			struct j1939_filter *f;
 			int c;
 

base-commit: c2f5c57d99debf471a1b263cdf227e55f1364e95
-- 
2.30.2


