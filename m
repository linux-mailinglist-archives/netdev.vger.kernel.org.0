Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D33C33C214
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhCOQft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:35:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232371AbhCOQfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWEeA/FAS/KigzjoSRKMocKAAwvw80uXLY8wO5EAzzw=;
        b=QPLWHUIZ+DbMzwD9xI2tMgYKg0cVoPd6WhQSC3XYJWESNsHt6iRzkGCghIRK254Hodldw0
        mAngwBTcqhC1l+f3yR+1EpadKxSj81OoMACbTf1+3Sn1URYjfPVlMcr72manG7I1SSNdpb
        1j/+Tok8qY4d0Tv1Erq+YuJRD39ZkU8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-MK1OfIRxP2On-Rg_H_soRQ-1; Mon, 15 Mar 2021 12:35:09 -0400
X-MC-Unique: MK1OfIRxP2On-Rg_H_soRQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E9FD80006E;
        Mon, 15 Mar 2021 16:35:08 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3CE819D7C;
        Mon, 15 Mar 2021 16:35:05 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 03/14] vringh: reset kiov 'consumed' field in __vringh_iov()
Date:   Mon, 15 Mar 2021 17:34:39 +0100
Message-Id: <20210315163450.254396-4-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__vringh_iov() overwrites the contents of riov and wiov, in fact it
resets the 'i' and 'used' fields, but also the 'consumed' field should
be reset to avoid an inconsistent state.

Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vringh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index f68122705719..bee63d68201a 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -290,9 +290,9 @@ __vringh_iov(struct vringh *vrh, u16 i,
 		return -EINVAL;
 
 	if (riov)
-		riov->i = riov->used = 0;
+		riov->i = riov->used = riov->consumed = 0;
 	if (wiov)
-		wiov->i = wiov->used = 0;
+		wiov->i = wiov->used = wiov->consumed = 0;
 
 	for (;;) {
 		void *addr;
-- 
2.30.2

