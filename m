Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C810722AD2D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgGWLDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:13 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49176 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728416AbgGWLDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+xUoABGrBl0VfC6+XTa5k5QXFM83Ut1En0a48ybks4E=;
        b=beW6ZgcOXsli2LB3YsqnWoW6e0/p1JARf+kFQWz92JqxI9BIrNrwWQB27wcLm0Z3xfSB6Y
        OWZ2HSrmXvBFYTqNeocV5BgE2aUTFgzBRemEIDj80iIhzZnjIdo4ycY9la0rJBjnmqNYuQ
        Ye+90yg79f7iBeLJtMuIBtd4oE5BTrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-f2wgcAMcMJqghDBY8jH7zQ-1; Thu, 23 Jul 2020 07:03:09 -0400
X-MC-Unique: f2wgcAMcMJqghDBY8jH7zQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9120A106B242;
        Thu, 23 Jul 2020 11:03:08 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 909BE8BED9;
        Thu, 23 Jul 2020 11:03:07 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 7/8] subflow: use rsk_ops->send_reset()
Date:   Thu, 23 Jul 2020 13:02:35 +0200
Message-Id: <a3d4154c2b5aede36cc6014edcffc086249b7381.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcp_send_active_reset() is more prone to transient errors
(memory allocation or xmit queue full): in stress conditions
the kernel may drop the egress packet, and the client will be
stuck.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3ef445f59556..ada04df6f99f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -524,9 +524,9 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 dispose_child:
 	subflow_drop_ctx(child);
 	tcp_rsk(req)->drop_req = true;
-	tcp_send_active_reset(child, GFP_ATOMIC);
 	inet_csk_prepare_for_destroy_sock(child);
 	tcp_done(child);
+	req->rsk_ops->send_reset(sk, skb);
 
 	/* The last child reference will be released by the caller */
 	return child;
-- 
2.26.2

