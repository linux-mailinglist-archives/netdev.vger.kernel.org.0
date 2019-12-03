Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 118DF111EC6
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 00:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730060AbfLCXE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 18:04:29 -0500
Received: from valentin-vidic.from.hr ([94.229.67.141]:59581 "EHLO
        valentin-vidic.from.hr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729913AbfLCWvi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 17:51:38 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2019 17:51:37 EST
X-Virus-Scanned: Debian amavisd-new at valentin-vidic.from.hr
Received: by valentin-vidic.from.hr (Postfix, from userid 1000)
        id 30A4B239; Tue,  3 Dec 2019 23:45:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
        d=valentin-vidic.from.hr; s=2017; t=1575413122;
        bh=pW9/x/Zaa3RBLFywltpoZxMRWGFuvmhPgETDh4Fc5RA=;
        h=From:To:Cc:Subject:Date:From;
        b=IboLnfXAwYBH5cDl563Z2p5sUk3zV8gtKgyIx/XyP86yTJ2r3n79OTDACpt5Eis1+
         BcK+IDjy82l6MgnAupVWz3UcXYSnEGXouP3E5jEmlwISUFL9yLAPJGTmVB3sTqSlgX
         TQ4TrXqInWPMqIjejWn4MQea7aBs2cYhCYpkG1A4xoaVav2+pcb7e50BGATudGcSZY
         J3mYfEEQiRX/Rc57jvKXturlpqbDFohMPjbZhNUVsyd59TqroBUQcTS2Ni48zW9JDi
         ZviYxGuIOKP8IPfkF9f7ANI44vSDADmp7E4I2eDUa5aN6uCTYV1iA/xvvjXoTpYO7p
         zYMWszZNzrsKA==
From:   Valentin Vidic <vvidic@valentin-vidic.from.hr>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Valentin Vidic <vvidic@valentin-vidic.from.hr>
Subject: [PATCH] net/tls: Fix return values for setsockopt
Date:   Tue,  3 Dec 2019 23:44:58 +0100
Message-Id: <20191203224458.24338-1-vvidic@valentin-vidic.from.hr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ENOTSUPP is not available in userspace:

  setsockopt failed, 524, Unknown error 524

Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
---
 net/tls/tls_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index bdca31ffe6da..5830b8e02a36 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -496,7 +496,7 @@ static int do_tls_setsockopt_conf(struct sock *sk, char __user *optval,
 	/* check version */
 	if (crypto_info->version != TLS_1_2_VERSION &&
 	    crypto_info->version != TLS_1_3_VERSION) {
-		rc = -ENOTSUPP;
+		rc = -EINVAL;
 		goto err_crypto_info;
 	}
 
@@ -723,7 +723,7 @@ static int tls_init(struct sock *sk)
 	 * share the ulp context.
 	 */
 	if (sk->sk_state != TCP_ESTABLISHED)
-		return -ENOTSUPP;
+		return -ENOTCONN;
 
 	/* allocate tls context */
 	write_lock_bh(&sk->sk_callback_lock);
-- 
2.20.1

