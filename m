Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3D3F0EE0
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 07:26:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbfKFG0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 01:26:30 -0500
Received: from f0-dek.dektech.com.au ([210.10.221.142]:33034 "EHLO
        mail.dektech.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728112AbfKFG0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 01:26:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.dektech.com.au (Postfix) with ESMTP id 1E5DD4AAC4;
        Wed,  6 Nov 2019 17:26:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dektech.com.au;
         h=content-transfer-encoding:mime-version:references:in-reply-to
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mail_dkim; t=1573021585; bh=aKuDm
        AAJbdKcZZ9OOtSSU+opMuerzV9Y+Kl9fUkR6eo=; b=iF2mVZ9ilvml9TETAHNbu
        2Qp+Wm0Vw0tvhzL6VCue7QcrfhdL9Svn/eHKEI823F/tA48ffpAgmRCPCX3wOekb
        iPNH14pS1MEteoRdYmyTuIrN4c/SfHzLzLUC/BOa88zBZpFO/l3WdxfbLW9cVQYh
        UnGUeHxO1/5pjhVbi4/ldQ=
X-Virus-Scanned: amavisd-new at dektech.com.au
Received: from mail.dektech.com.au ([127.0.0.1])
        by localhost (mail2.dektech.com.au [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9c1vEbRdsgyF; Wed,  6 Nov 2019 17:26:25 +1100 (AEDT)
Received: from mail.dektech.com.au (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPS id 047DA4AAC5;
        Wed,  6 Nov 2019 17:26:25 +1100 (AEDT)
Received: from dhost.dek-tpc.internal (unknown [14.161.14.188])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.dektech.com.au (Postfix) with ESMTPSA id 459354AAC4;
        Wed,  6 Nov 2019 17:26:24 +1100 (AEDT)
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jon.maloy@ericsson.com, maloy@donjonn.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [net-next 2/2] tipc: reduce sensitive to retransmit failures
Date:   Wed,  6 Nov 2019 13:26:10 +0700
Message-Id: <20191106062610.12039-2-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
References: <20191106062610.12039-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With huge cluster (e.g >200nodes), the amount of that flow:
gap -> retransmit packet -> acked will take time in case of STATE_MSG
dropped/delayed because a lot of traffic. This lead to 1.5 sec tolerance
value criteria made link easy failure around 2nd, 3rd of failed
retransmission attempts.

Instead of re-introduced criteria of 99 faled retransmissions to fix the
issue, we increase failure detection timer to ten times tolerance value.

Fixes: 77cf8edbc0e7 ("tipc: simplify stale link failure criteria")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 038861bad72b..2aed7a958a8c 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1087,7 +1087,7 @@ static bool link_retransmit_failure(struct tipc_lin=
k *l, struct tipc_link *r,
 		return false;
=20
 	if (!time_after(jiffies, TIPC_SKB_CB(skb)->retr_stamp +
-			msecs_to_jiffies(r->tolerance)))
+			msecs_to_jiffies(r->tolerance * 10)))
 		return false;
=20
 	hdr =3D buf_msg(skb);
--=20
2.20.1

