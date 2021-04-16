Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB78361E2A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241808AbhDPKot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 06:44:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55802 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240748AbhDPKos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 06:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618569862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FFoO2JXibmen5m2q4F6Dm2vU1noYh/fkGf0uESyKfZs=;
        b=hL+rLGDmaCvPqgXt4g4QH+2oxjX5q9mYYBCOwk+vhmNKozs5gn6x5yn/mm8n7KOhyHKEn3
        dzmgXhoNAGODFpBDNtsfl2AoIPnv9Qy3oRahwoReIFnfTRABobueKsCiz5y8Asd/kltzYH
        vp2TD5mSMOYgzs1gZS7yPEbK9Ahij5c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-W1cml6eCNPq441_6VabwXg-1; Fri, 16 Apr 2021 06:44:20 -0400
X-MC-Unique: W1cml6eCNPq441_6VabwXg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 913CE8018A7;
        Fri, 16 Apr 2021 10:44:19 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-50.ams2.redhat.com [10.36.114.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA71F2B3CC;
        Fri, 16 Apr 2021 10:44:17 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Vishnu Dasa <vdasa@vmware.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>
Subject: [PATCH net] vsock/vmci: log once the failed queue pair allocation
Date:   Fri, 16 Apr 2021 12:44:16 +0200
Message-Id: <20210416104416.88997-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VMCI feature is not supported in conjunction with the vSphere Fault
Tolerance (FT) feature.

VMware Tools can repeatedly try to create a vsock connection. If FT is
enabled the kernel logs is flooded with the following messages:

    qp_alloc_hypercall result = -20
    Could not attach to queue pair with -20

"qp_alloc_hypercall result = -20" was hidden by commit e8266c4c3307
("VMCI: Stop log spew when qp allocation isn't possible"), but "Could
not attach to queue pair with -20" is still there flooding the log.

Since the error message can be useful in some cases, print it only once.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/vmci_transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 8b65323207db..1c9ecb18b8e6 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -568,8 +568,7 @@ vmci_transport_queue_pair_alloc(struct vmci_qp **qpair,
 			       peer, flags, VMCI_NO_PRIVILEGE_FLAGS);
 out:
 	if (err < 0) {
-		pr_err("Could not attach to queue pair with %d\n",
-		       err);
+		pr_err_once("Could not attach to queue pair with %d\n", err);
 		err = vmci_transport_error_to_vsock_error(err);
 	}
 
-- 
2.30.2

