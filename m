Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EED1BF8BC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726850AbgD3NCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:02:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47218 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726815AbgD3NCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:02:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588251743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Esq3vy6x60H/MB/LkXUGeRLbe79YwcD/S4Vme7lpc1E=;
        b=AtihINTH5zVkzeGhgWNqhBsBBGLYfPyUvqLmHSWrkpZ2l/U/89zj8+hC1ol9TqVCYEg2/8
        NwV0t3JwTUBJdF8ECgi3D9WBxlpMZZFw6nBfZRHMamjJWLI90nI1ocGmJ8qhdX3ReAvChu
        PY9ZZrh104AWSVudNuUBxrx84KAwm4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-9YQ5tuUtPqiceesecMxLUw-1; Thu, 30 Apr 2020 09:02:21 -0400
X-MC-Unique: 9YQ5tuUtPqiceesecMxLUw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 65EEA800D24;
        Thu, 30 Apr 2020 13:02:20 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25BB367656;
        Thu, 30 Apr 2020 13:02:17 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net v2 4/5] mptcp: fix 'use_ack' option access.
Date:   Thu, 30 Apr 2020 15:01:54 +0200
Message-Id: <c8b028f7471cb0a9ae2604a5e81eec2299e4d365.1588243786.git.pabeni@redhat.com>
In-Reply-To: <cover.1588243786.git.pabeni@redhat.com>
References: <cover.1588243786.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

