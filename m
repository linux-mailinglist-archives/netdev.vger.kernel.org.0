Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D0D2F2664
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbhALCsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:48:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727237AbhALCsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 21:48:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610419617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Nd9vrsLoQ4eNomWd4y4aPcW+GO4/2gg4PZxpPi0r3GU=;
        b=U06+F5sJ+tXkb03krdulczKhOpuxD+zn1EiLapz++a2yn0mICbuJwKvnIhdzT8qOhLrORr
        EJerUc8NQHH5/nsg6RsF+n6Vj3jm752cyXjMjQDqy15SZSUmuxk+DF8P79V612x/WveNEN
        2WaMaR1AhT+syIDeQ1lM51gmNndNrwc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-FNMRMh49NGeqp52gcwiGEw-1; Mon, 11 Jan 2021 21:46:55 -0500
X-MC-Unique: FNMRMh49NGeqp52gcwiGEw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B14F107ACF8;
        Tue, 12 Jan 2021 02:46:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F71A5B693;
        Tue, 12 Jan 2021 02:46:51 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        lingshan.zhu@intel.com
Subject: [PATCH v1] vhost_vdpa: fix the problem in vhost_vdpa_set_config_call
Date:   Tue, 12 Jan 2021 10:46:48 +0800
Message-Id: <20210112024648.31428-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in vhost_vdpa_set_config_call, the cb.private should be vhost_vdpa.
this cb.private will finally use in vhost_vdpa_config_cb as
vhost_vdpa.Fix this issue

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index ef688c8c0e0e..3fbb9c1f49da 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -319,7 +319,7 @@ static long vhost_vdpa_set_config_call(struct vhost_vdpa *v, u32 __user *argp)
 	struct eventfd_ctx *ctx;
 
 	cb.callback = vhost_vdpa_config_cb;
-	cb.private = v->vdpa;
+	cb.private = v;
 	if (copy_from_user(&fd, argp, sizeof(fd)))
 		return  -EFAULT;
 
-- 
2.21.3

