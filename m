Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8B93ACC5D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 15:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhFRNiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 09:38:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20829 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233934AbhFRNhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 09:37:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624023343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xNf5vH386FO3DWWUo5p1LYSZTTqClAjh9OQpi5Mkgi4=;
        b=Jq91v4f5UvacvR7GsMM3sLv0iITkFirI8IMr63spbaUwOEoQcLmFdzhGwpatYlhq2BEqY/
        f9av+XeK1deI7PTB3BD0rHfLLR1U46vN7I+x/J+W8ImTdgEu7uZD19yEMICtw5L2caXhw6
        yEQnHeWIltGV4ENKA8ibeP4o3tbfmq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-bIgTEk-2MLa1Sv1-0Ih9yA-1; Fri, 18 Jun 2021 09:35:39 -0400
X-MC-Unique: bIgTEk-2MLa1Sv1-0Ih9yA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E391100C661;
        Fri, 18 Jun 2021 13:35:38 +0000 (UTC)
Received: from steredhat.lan (ovpn-115-127.ams2.redhat.com [10.36.115.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A7A9410023B5;
        Fri, 18 Jun 2021 13:35:34 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Arseny Krasnov <arseny.krasnov@kaspersky.com>, kvm@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] vsock: rename vsock_has_data()
Date:   Fri, 18 Jun 2021 15:35:24 +0200
Message-Id: <20210618133526.300347-2-sgarzare@redhat.com>
In-Reply-To: <20210618133526.300347-1-sgarzare@redhat.com>
References: <20210618133526.300347-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vsock_has_data() is used only by STREAM and SEQPACKET sockets,
so let's rename it to vsock_connectible_has_data(), using the same
nomenclature (connectible) used in other functions after the
introduction of SEQPACKET.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 67954afef4e1..de8249483081 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -860,7 +860,7 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
 
-static s64 vsock_has_data(struct vsock_sock *vsk)
+static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
 {
 	struct sock *sk = sk_vsock(vsk);
 
@@ -1880,7 +1880,7 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
 	err = 0;
 	transport = vsk->transport;
 
-	while ((data = vsock_has_data(vsk)) == 0) {
+	while ((data = vsock_connectible_has_data(vsk)) == 0) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
 
 		if (sk->sk_err != 0 ||
-- 
2.31.1

