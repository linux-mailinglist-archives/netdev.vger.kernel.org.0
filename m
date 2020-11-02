Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDAB2A26B0
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 10:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgKBJKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 04:10:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20390 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727806AbgKBJKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 04:10:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604308207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=r+eDDBMatADtLLZMPiYICSJlCiS/LZH3NpAk/ns15Mw=;
        b=bZjMaX+Q6ED7DuzieFMdABhezlKFlxa3HlI9+LQHq8sPGMlkUwNdCHoW66ANUpsn5+wrfX
        oztw2iMoSdz8mUxUqm5BFgB106RP9BUVpx5gk8KMMJG8xpYqwp0e/F4bKzryjzE1vnU6FC
        RLrMnu9MwhPeY1R+g0RCOH4lxCmC094=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-CBjkQLVbM3232Me0Ls0hMw-1; Mon, 02 Nov 2020 04:10:01 -0500
X-MC-Unique: CBjkQLVbM3232Me0Ls0hMw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0C68107ACF8;
        Mon,  2 Nov 2020 09:10:00 +0000 (UTC)
Received: from new-host-6.redhat.com (unknown [10.40.193.194])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A738D5C1A3;
        Mon,  2 Nov 2020 09:09:59 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     mptcp@lists.01.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] mptcp: token: fix unititialized variable
Date:   Mon,  2 Nov 2020 10:09:49 +0100
Message-Id: <49e20da5d467a73414d4294a8bd35e2cb1befd49.1604308087.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc complains about use of uninitialized 'num'. Fix it by doing the first
assignment of 'num' when the variable is declared.

Fixes: 96d890daad05 ("mptcp: add msk interations helper")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/token.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index 8b47c4bb1c6b..feb4b9ffd462 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -291,7 +291,7 @@ struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_slot,
 {
 	struct mptcp_sock *ret = NULL;
 	struct hlist_nulls_node *pos;
-	int slot, num;
+	int slot, num = 0;
 
 	for (slot = *s_slot; slot <= token_mask; *s_num = 0, slot++) {
 		struct token_bucket *bucket = &token_hash[slot];
-- 
2.26.2

