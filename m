Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 936932B06D6
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgKLNiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:38:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728270AbgKLNit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:38:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605188327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=abUq5jbfG1UBROW4rb4tFxmNdN4AY+VydbRPLh7tSWA=;
        b=HSYDFT0hDgwufRsUacTOx2Ba/SxoyzX+pHPVtVLK46v7GyvKK3HQs0Kdr3H+DjAb642rw3
        CeNvu4GvR0zkEsi6U26SFffji0zezE8lW7r1NdwvmhXgadY8oVp8iOD7qYXTNEyJNwrjj4
        Rq4izby2SzZF2iM774V3R0LykXEbIIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-lN1BtpxjMNOzVIvKz_KENw-1; Thu, 12 Nov 2020 08:38:45 -0500
X-MC-Unique: lN1BtpxjMNOzVIvKz_KENw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54825103098D;
        Thu, 12 Nov 2020 13:38:44 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-255.ams2.redhat.com [10.36.113.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27FBD75139;
        Thu, 12 Nov 2020 13:38:37 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jorgen Hansen <jhansen@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Anthony Liguori <aliguori@amazon.com>,
        David Duncan <davdunc@amazon.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Alexander Graf <graf@amazon.de>
Subject: [PATCH net] vsock: forward all packets to the host when no H2G is registered
Date:   Thu, 12 Nov 2020 14:38:37 +0100
Message-Id: <20201112133837.34183-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit c0cfa2d8a788 ("vsock: add multi-transports support"),
if a G2H transport was loaded (e.g. virtio transport), every packets
was forwarded to the host, regardless of the destination CID.
The H2G transports implemented until then (vhost-vsock, VMCI) always
responded with an error, if the destination CID was not
VMADDR_CID_HOST.

From that commit, we are using the remote CID to decide which
transport to use, so packets with remote CID > VMADDR_CID_HOST(2)
are sent only through H2G transport. If no H2G is available, packets
are discarded directly in the guest.

Some use cases (e.g. Nitro Enclaves [1]) rely on the old behaviour
to implement sibling VMs communication, so we restore the old
behavior when no H2G is registered.
It will be up to the host to discard packets if the destination is
not the right one. As it was already implemented before adding
multi-transport support.

Tested with nested QEMU/KVM by me and Nitro Enclaves by Andra.

[1] Documentation/virt/ne_overview.rst

Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Dexuan Cui <decui@microsoft.com>
Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reported-by: Andra Paraschiv <andraprs@amazon.com>
Tested-by: Andra Paraschiv <andraprs@amazon.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index b4d7b8aba003..d10916ab4526 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -438,7 +438,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	case SOCK_STREAM:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
-		else if (remote_cid <= VMADDR_CID_HOST)
+		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g)
 			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
-- 
2.26.2

