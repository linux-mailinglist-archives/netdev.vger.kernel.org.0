Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8A922AD2E
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgGWLDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:13 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29132 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728414AbgGWLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+zZ2XD4tM47Syh3OsObdgACAqV0nmOysLCEGOwgtDE=;
        b=MWnkpkLRTO+dqz/c/W2Ry2G18LglilbsJiGYJgxunN92XqRbAfKogC1ZCqUM0UhPC5imxm
        2Ep4X0/o3MSCi38qx4K/vl0INu9qxTaepDkllumPBkXCRKqbFPPe8SFEuRgB04fauJqQAM
        eLaW/tE7EE2A4te03dXB+xU8tvw+ip4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-gNnKfgfvMnWUkBWlN8S7qw-1; Thu, 23 Jul 2020 07:03:09 -0400
X-MC-Unique: gNnKfgfvMnWUkBWlN8S7qw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35DD610059A4;
        Thu, 23 Jul 2020 11:03:08 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 399808BED5;
        Thu, 23 Jul 2020 11:03:06 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 6/8] subflow: explicitly check for plain tcp rsk
Date:   Thu, 23 Jul 2020 13:02:34 +0200
Message-Id: <3d0b2caefba40597d5678a4a94ac961a2db6db31.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When syncookie are in use, the TCP stack may feed into
subflow_syn_recv_sock() plain TCP request sockets. We can't
access mptcp_subflow_request_sock-specific fields on such
sockets. Explicitly check the rsk ops to do safe accesses.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 7f3ef1840df5..3ef445f59556 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -415,7 +415,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 	/* hopefully temporary handling for MP_JOIN+syncookie */
 	subflow_req = mptcp_subflow_rsk(req);
-	fallback_is_fatal = subflow_req->mp_join;
+	fallback_is_fatal = tcp_rsk(req)->is_mptcp && subflow_req->mp_join;
 	fallback = !tcp_rsk(req)->is_mptcp;
 	if (fallback)
 		goto create_child;
-- 
2.26.2

