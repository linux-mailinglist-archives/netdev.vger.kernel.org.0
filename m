Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25DC4467EE
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 18:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhKERd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 13:33:29 -0400
Received: from mail.ispras.ru ([83.149.199.84]:37044 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231844AbhKERd2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 13:33:28 -0400
Received: from localhost.localdomain (unknown [109.252.87.51])
        by mail.ispras.ru (Postfix) with ESMTPSA id 3B3C040D3BFF;
        Fri,  5 Nov 2021 17:30:46 +0000 (UTC)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] sctp: remove unreachable code from sctp_sf_violation_chunk()
Date:   Fri,  5 Nov 2021 20:30:27 +0300
Message-Id: <1636133427-3990-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <CADvbK_fTmu4MWdwk5uTd_FEnny=_=OD=iqrq-3McQ5mgw1JnKg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sctp_sf_violation_chunk() is not called with asoc argument equal to NULL,
but if that happens it would lead to NULL pointer dereference
in sctp_vtag_verify().

The patch removes code that handles NULL asoc in sctp_sf_violation_chunk().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Proposed-by: Xin Long <lucien.xin@gmail.com>
---
 net/sctp/sm_statefuns.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index fb3da4d8f4a3..ec8561dd7e76 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -4893,9 +4893,6 @@ static enum sctp_disposition sctp_sf_violation_chunk(
 {
 	static const char err_str[] = "The following chunk violates protocol:";
 
-	if (!asoc)
-		return sctp_sf_violation(net, ep, asoc, type, arg, commands);
-
 	return sctp_sf_abort_violation(net, ep, asoc, arg, commands, err_str,
 				       sizeof(err_str));
 }
-- 
2.7.4

