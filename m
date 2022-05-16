Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF2C3527FE8
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 10:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241904AbiEPImh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 04:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241438AbiEPImd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 04:42:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31242B870
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 01:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652690542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=zsjSQ0E4x4apOOovvgvIeCzdF5L3Muj7tY5Ce1u0fFA=;
        b=fETIvEMNWNPYITmsLFpP5oAUXqxQIBsYX34NBd97UwTAt+FFuJPDCV060wcsPG5B1h6mpJ
        ehkIsMl6V/Zm5GTD8crIiHvPaPT8i79qFlbJAaDg3DfIZwb/oDgoH+xCq9DqBU8rro1XWe
        NSxQToJBAezWy6hPJfjaFPQduQFUsww=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-hrKwPFoVP6as52qPJiqDgw-1; Mon, 16 May 2022 04:42:20 -0400
X-MC-Unique: hrKwPFoVP6as52qPJiqDgw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A4BF29AB44D;
        Mon, 16 May 2022 08:42:20 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-125.pek2.redhat.com [10.72.13.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6111A7C52;
        Mon, 16 May 2022 08:42:16 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     viro@zeniv.linux.org.uk, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ebiggers@kernel.org, davem@davemloft.net
Subject: [PATCH] vhost_net: fix double fget()
Date:   Mon, 16 May 2022 16:42:13 +0800
Message-Id: <20220516084213.26854-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

Here's another piece of code assuming that repeated fget() will yield the
same opened file: in vhost_net_set_backend() we have

        sock = get_socket(fd);
        if (IS_ERR(sock)) {
                r = PTR_ERR(sock);
                goto err_vq;
        }

        /* start polling new socket */
        oldsock = vhost_vq_get_backend(vq);
        if (sock != oldsock) {
...
                vhost_vq_set_backend(vq, sock);
...
                if (index == VHOST_NET_VQ_RX)
                        nvq->rx_ring = get_tap_ptr_ring(fd);

with
static struct socket *get_socket(int fd)
{
        struct socket *sock;

        /* special case to disable backend */
        if (fd == -1)
                return NULL;
        sock = get_raw_socket(fd);
        if (!IS_ERR(sock))
                return sock;
        sock = get_tap_socket(fd);
        if (!IS_ERR(sock))
                return sock;
        return ERR_PTR(-ENOTSOCK);
}
and
static struct ptr_ring *get_tap_ptr_ring(int fd)
{
        struct ptr_ring *ring;
        struct file *file = fget(fd);

        if (!file)
                return NULL;
        ring = tun_get_tx_ring(file);
        if (!IS_ERR(ring))
                goto out;
        ring = tap_get_ptr_ring(file);
        if (!IS_ERR(ring))
                goto out;
        ring = NULL;
out:
        fput(file);
        return ring;
}

Again, there is no promise that fd will resolve to the same thing for
lookups in get_socket() and in get_tap_ptr_ring().  I'm not familiar
enough with the guts of drivers/vhost to tell how easy it is to turn
into attack, but it looks like trouble.  If nothing else, the pointer
returned by tun_get_tx_ring() is not guaranteed to be pinned down by
anything - the reference to sock will _usually_ suffice, but that
doesn't help any if we get a different socket on that second fget().

One possible way to fix it would be the patch below; objections?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28ef323882fb..0bd7d91de792 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1449,13 +1449,9 @@ static struct socket *get_raw_socket(int fd)
 	return ERR_PTR(r);
 }
 
-static struct ptr_ring *get_tap_ptr_ring(int fd)
+static struct ptr_ring *get_tap_ptr_ring(struct file *file)
 {
 	struct ptr_ring *ring;
-	struct file *file = fget(fd);
-
-	if (!file)
-		return NULL;
 	ring = tun_get_tx_ring(file);
 	if (!IS_ERR(ring))
 		goto out;
@@ -1464,7 +1460,6 @@ static struct ptr_ring *get_tap_ptr_ring(int fd)
 		goto out;
 	ring = NULL;
 out:
-	fput(file);
 	return ring;
 }
 
@@ -1551,8 +1546,12 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		r = vhost_net_enable_vq(n, vq);
 		if (r)
 			goto err_used;
-		if (index == VHOST_NET_VQ_RX)
-			nvq->rx_ring = get_tap_ptr_ring(fd);
+		if (index == VHOST_NET_VQ_RX) {
+			if (sock)
+				nvq->rx_ring = get_tap_ptr_ring(sock->file);
+			else
+				nvq->rx_ring = NULL;
+		}
 
 		oldubufs = nvq->ubufs;
 		nvq->ubufs = ubufs;
-- 
2.25.1

