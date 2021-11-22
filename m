Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DCA45932C
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239717AbhKVQjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:39:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57594 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238407AbhKVQjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:39:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637599008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cCstxEhvvwRRHc2gpQNHM9jyHCtg2U6yhX+P/CPEdFU=;
        b=QIO9JU30n2csLg+9jW0HtMZzA128mP7kNAkdA9qzUtaa9dy7H4CBMdQJipSCITv8I6lglt
        lk/dgY33flWx1rIzWM45wElTBUf2XP5BEZKiyjO+3Pdu3VbywPcAJVVzWljy1BaJvufl3L
        TLdxdNE3VAEQMXaYuJtEgm/ZpZgNFUk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-jYJTi5e_MyKh8y2KEYZ-lQ-1; Mon, 22 Nov 2021 11:36:47 -0500
X-MC-Unique: jYJTi5e_MyKh8y2KEYZ-lQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDBCB1023F4E;
        Mon, 22 Nov 2021 16:36:45 +0000 (UTC)
Received: from steredhat.redhat.com (unknown [10.39.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44EA560C5F;
        Mon, 22 Nov 2021 16:36:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        Asias He <asias@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 1/2] vhost/vsock: fix incorrect used length reported to the guest
Date:   Mon, 22 Nov 2021 17:35:24 +0100
Message-Id: <20211122163525.294024-2-sgarzare@redhat.com>
In-Reply-To: <20211122163525.294024-1-sgarzare@redhat.com>
References: <20211122163525.294024-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "used length" reported by calling vhost_add_used() must be the
number of bytes written by the device (using "in" buffers).

In vhost_vsock_handle_tx_kick() the device only reads the guest
buffers (they are all "out" buffers), without writing anything,
so we must pass 0 as "used length" to comply virtio spec.

Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
Cc: stable@vger.kernel.org
Reported-by: Halil Pasic <pasic@linux.ibm.com>
Suggested-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 938aefbc75ec..4e3b95af7ee4 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -554,7 +554,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 			virtio_transport_free_pkt(pkt);
 
 		len += sizeof(pkt->hdr);
-		vhost_add_used(vq, head, len);
+		vhost_add_used(vq, head, 0);
 		total_len += len;
 		added = true;
 	} while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
-- 
2.31.1

