Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBDDC1BD9ED
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgD2Km4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:42:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50989 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726560AbgD2Kmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:42:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588156975;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Esq3vy6x60H/MB/LkXUGeRLbe79YwcD/S4Vme7lpc1E=;
        b=WNENWN55GHbpV3MH+M2Bjz3UNVXRb2LjfEnExpI1B3I/DP3TxyJ1l2hrHLgvLrIrUjlsyE
        OrPVNp9uibQ8+IgF7ZoaxyCh/YFdih7GcXIjl7iDGUQPjqOHj9h7YjfP2dUHRCBY3IIotW
        Wd4m0LhhEyyWHqH0tVDpdZRweoGYz/4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-MXUzDrfOOWCfqas7OAeqWQ-1; Wed, 29 Apr 2020 06:42:29 -0400
X-MC-Unique: MXUzDrfOOWCfqas7OAeqWQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59B78107ACF3;
        Wed, 29 Apr 2020 10:42:28 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C115399D6;
        Wed, 29 Apr 2020 10:42:25 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net 4/5] mptcp: fix 'use_ack' option access.
Date:   Wed, 29 Apr 2020 12:41:48 +0200
Message-Id: <61be0e80aacd7d76da9cd27a29db10e8162455c6.1588156257.git.pabeni@redhat.com>
In-Reply-To: <cover.1588156257.git.pabeni@redhat.com>
References: <cover.1588156257.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mentioned RX option field is initialized only for DSS
packet, we must access it only if 'dss' is set too, or
the subflow will end-up in a bad status, leading to
RFC violations.

Fixes: d22f4988ffec ("mptcp: process MP_CAPABLE data option")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index ecf41d52d2fc..9486720c3256 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -695,7 +695,7 @@ static bool check_fully_established(struct mptcp_sock=
 *msk, struct sock *sk,
 	if (TCP_SKB_CB(skb)->seq !=3D subflow->ssn_offset + 1)
 		return subflow->mp_capable;
=20
-	if (mp_opt->use_ack) {
+	if (mp_opt->dss && mp_opt->use_ack) {
 		/* subflows are fully established as soon as we get any
 		 * additional ack.
 		 */
--=20
2.21.1

