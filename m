Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E17633C223
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 17:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhCOQgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 12:36:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232755AbhCOQft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 12:35:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615826148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7g3riK+kiel5RnhV+7if+uZqH1INqufvdFTBxLL5Dg0=;
        b=fH+x3cy6BXEq7TGCG6hlohqvj8NkPDri1gj4pcEZdlq5fgOPBpHbPLJjeAuDYArX6EMIAG
        LDyZtpg5xHC8+f4O7pTaBBjUm80CyZaZ02dGj0qKIA7Q2Kz1qsy3PDwAK6Su4icQ6STO36
        96iLMjNnE4atdDtV7SAXA4rTTiLuf4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-6JebKSrBMpmgE_N9qgdnkw-1; Mon, 15 Mar 2021 12:35:44 -0400
X-MC-Unique: 6JebKSrBMpmgE_N9qgdnkw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1AF6108BD07;
        Mon, 15 Mar 2021 16:35:42 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-114-1.ams2.redhat.com [10.36.114.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABD952C169;
        Mon, 15 Mar 2021 16:35:40 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     netdev@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Wang <jasowang@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v4 06/14] vringh: add vringh_kiov_length() helper
Date:   Mon, 15 Mar 2021 17:34:42 +0100
Message-Id: <20210315163450.254396-7-sgarzare@redhat.com>
In-Reply-To: <20210315163450.254396-1-sgarzare@redhat.com>
References: <20210315163450.254396-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This new helper returns the total number of bytes covered by
a vringh_kiov.

Suggested-by: Jason Wang <jasowang@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/linux/vringh.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/vringh.h b/include/linux/vringh.h
index 755211ebd195..84db7b8f912f 100644
--- a/include/linux/vringh.h
+++ b/include/linux/vringh.h
@@ -199,6 +199,17 @@ static inline void vringh_kiov_cleanup(struct vringh_kiov *kiov)
 	kiov->iov = NULL;
 }
 
+static inline size_t vringh_kiov_length(struct vringh_kiov *kiov)
+{
+	size_t len = 0;
+	int i;
+
+	for (i = kiov->i; i < kiov->used; i++)
+		len += kiov->iov[i].iov_len;
+
+	return len;
+}
+
 void vringh_kiov_advance(struct vringh_kiov *kiov, size_t len);
 
 int vringh_getdesc_kern(struct vringh *vrh,
-- 
2.30.2

