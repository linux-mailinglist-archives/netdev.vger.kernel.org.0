Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF9E03374BA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 14:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhCKNx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 08:53:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35466 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233811AbhCKNxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 08:53:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615470791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/SLu3G915tlJOckjof4gpfwcAaXUH6EnQojMQamSVhA=;
        b=KasVUpER+EvVmTTOlrNUDG5YBr08jkf9am3ybjzTPof0XvuudRAKsE39rOb6EOa3gSlLfi
        wu5KsLNF39bz92bp5nMS7jqZkZrjsGxuj3c/vjFqaDuHdLPqIHPxTMwdqgJWgDKeBwUfyl
        OhS4DhDMPwK85jNy8m81MxA68VADlhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-2UF2uV0rPn6GuFfzEiwXzw-1; Thu, 11 Mar 2021 08:53:09 -0500
X-MC-Unique: 2UF2uV0rPn6GuFfzEiwXzw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAE518030DB;
        Thu, 11 Mar 2021 13:53:07 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-113-146.ams2.redhat.com [10.36.113.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D923196E3;
        Thu, 11 Mar 2021 13:53:06 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 2/2] vhost-vdpa: set v->config_ctx to NULL if eventfd_ctx_fdget() fails
Date:   Thu, 11 Mar 2021 14:52:57 +0100
Message-Id: <20210311135257.109460-3-sgarzare@redhat.com>
In-Reply-To: <20210311135257.109460-1-sgarzare@redhat.com>
References: <20210311135257.109460-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_vdpa_set_config_call() if eventfd_ctx_fdget() fails the
'v->config_ctx' contains an error instead of a valid pointer.

Since we consider 'v->config_ctx' valid if it is not NULL, we should
set it to NULL in this case to avoid to use an invalid pointer in
other functions such as vhost_vdpa_config_put().

Fixes: 776f395004d8 ("vhost_vdpa: Support config interrupt in vdpa")
Cc: lingshan.zhu@intel.com
Cc: stable@vger.kernel.org
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 drivers/vhost/vdpa.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 00796e4ecfdf..f9ecdce5468a 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -331,8 +331,12 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 	if (!IS_ERR_OR_NULL(ctx))
 		eventfd_ctx_put(ctx);
 
-	if (IS_ERR(v->config_ctx))
-		return PTR_ERR(v->config_ctx);
+	if (IS_ERR(v->config_ctx)) {
+		long ret = PTR_ERR(v->config_ctx);
+
+		v->config_ctx = NULL;
+		return ret;
+	}
 
 	v->vdpa->config->set_config_cb(v->vdpa, &cb);
 
-- 
2.29.2

