Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656D51F2CFA
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgFIA3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:29:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbgFHXQI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2908120814;
        Mon,  8 Jun 2020 23:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658168;
        bh=A+2JaOpuAnOIT+qANT0NjlO+6c2TDnl9rdUJ6hBS1E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRMt6LsewQj/+j+L90xUsFbMLYo+9UiD69tvkvvxaGSMIZjSDw4amKhHPZTWZ+Iqe
         RUyQUT8NO10V2ulNKnXzTq1TG8+y+E7f6dZXK3csNoqMKWi/PqKuUH+iz06DzPQyfr
         qyjEX6HE8q//VbnxZ0Z6LGmHiD97v9a1QpgIIZTI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qiushi Wu <wu000273@umn.edu>, David Howells <dhowells@redhat.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 195/606] rxrpc: Fix a memory leak in rxkad_verify_response()
Date:   Mon,  8 Jun 2020 19:05:20 -0400
Message-Id: <20200608231211.3363633-195-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

commit f45d01f4f30b53c3a0a1c6c1c154acb7ff74ab9f upstream.

A ticket was not released after a call of the function
"rxkad_decrypt_ticket" failed. Thus replace the jump target
"temporary_error_free_resp" by "temporary_error_free_ticket".

Fixes: 8c2f826dc3631 ("rxrpc: Don't put crypto buffers on the stack")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/rxkad.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 098f1f9ec53b..52a24d4ef5d8 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1148,7 +1148,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	ret = rxkad_decrypt_ticket(conn, skb, ticket, ticket_len, &session_key,
 				   &expiry, _abort_code);
 	if (ret < 0)
-		goto temporary_error_free_resp;
+		goto temporary_error_free_ticket;
 
 	/* use the session key from inside the ticket to decrypt the
 	 * response */
@@ -1230,7 +1230,6 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 temporary_error_free_ticket:
 	kfree(ticket);
-temporary_error_free_resp:
 	kfree(response);
 temporary_error:
 	/* Ignore the response packet if we got a temporary error such as
-- 
2.25.1

