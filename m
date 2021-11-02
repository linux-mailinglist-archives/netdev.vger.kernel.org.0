Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D849E44376D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 21:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhKBUjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 16:39:19 -0400
Received: from mail.ispras.ru ([83.149.199.84]:51464 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhKBUjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 16:39:19 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Nov 2021 16:39:18 EDT
Received: from hednb3.Dlink (unknown [109.252.87.51])
        by mail.ispras.ru (Postfix) with ESMTPSA id C175E40D403D;
        Tue,  2 Nov 2021 20:27:16 +0000 (UTC)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] sctp: avoid NULL pointer dereference in sctp_sf_violation
Date:   Tue,  2 Nov 2021 23:27:04 +0300
Message-Id: <1635884824-28790-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some callers (e.g. sctp_sf_violation_chunk) passes NULL to
asoc argument of sctp_sf_violation. So, it should check it
before calling sctp_vtag_verify().

Probably it could be exploited by a malicious SCTP packet
to cause NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: aa0f697e4528 ("sctp: add vtag check in sctp_sf_violation")
---
 net/sctp/sm_statefuns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index fb3da4d8f4a3..77f3cd6c516e 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4669,7 +4669,7 @@ enum sctp_disposition sctp_sf_violation(struct net *net,
 {
 	struct sctp_chunk *chunk = arg;
 
-	if (!sctp_vtag_verify(chunk, asoc))
+	if (asoc && !sctp_vtag_verify(chunk, asoc))
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 
 	/* Make sure that the chunk has a valid length. */
-- 
2.7.4

