Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7DA81171A7
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfLIQ3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:29:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726362AbfLIQ3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575908972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNvyL4Y9eRzqtb2H2E84LxRf2YADQJydGhMMLpn/rvY=;
        b=eKiT5CKGXYXTNvkjJWre2sGI9xoeT5Kq+kXrhSRxgD55Cw5lGTbtuVg2gmFUkAc0ZYQpf9
        ub6AzXx3tu/k9ZUWm44BBpKPmAb3XyUzMSEYke0k5Wa/iY6N1UzL33Km3AJwEZ01CstjgY
        6W9NQnHM+n13xyRm15HnhQ5kFr9p3pY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-vvClyGdEOS6ovMgt9BdY3Q-1; Mon, 09 Dec 2019 11:29:31 -0500
Received: by mail-qv1-f70.google.com with SMTP id d7so4917503qvq.12
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 08:29:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQxMVxgAtK5y0CyKs1BCEj6d5vwE3qN67Xvd5FZmfgk=;
        b=N38PBl7pn1500q+tYwsTyj1K/5D2pRlddeOP9BA5JG4zs7zJhL/ohK9F2GJZq2aRu0
         /iY3uExQKh3RAFKeT4MXsQ3CYpPrUEeChPXteqJxJYw928VUUjQsaa8VyNwR+T9sRKpa
         rEOQWOYYw3837+rp4X2vRwUr6oOOrRnpQRcVE040JbAyjnUFLpayrsYiZ5v7MbJWYwID
         Xm+ccEvGuRYwedicSxrpqF5MWk97kHrJm+cm34eZitOyhEYIUfRtufSTT86AlAR8ZVcT
         myaw/vYxhk1iqU9tRRHRqPw1kPuCWL4e2x3d/LuP6UFXCCzyd5VSx2Plfw/Rt5HfYVHR
         vkFA==
X-Gm-Message-State: APjAAAVkDMQmg4nYFRgKh0QYZ4kdMBbExPZ6GULdt/GODy4VsOah0gnk
        ZY+kbrd9dFOfprdg1DDGroX6FzusnetAigDehGQaogtJRurYqmTkiZqg2UMZLxdW3q23GiSR+1x
        cfTU0uxjZZq6uDfAd
X-Received: by 2002:a05:620a:899:: with SMTP id b25mr6205348qka.197.1575908971022;
        Mon, 09 Dec 2019 08:29:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqwFUcc6D6y2hR3oAFJBLyCpXqAb6UQCleKthwatt7HxCSSIjpA7ZaRTzyQmAILOaUj4yhzSHQ==
X-Received: by 2002:a05:620a:899:: with SMTP id b25mr6205322qka.197.1575908970851;
        Mon, 09 Dec 2019 08:29:30 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id f19sm420087qkk.69.2019.12.09.08.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 08:29:30 -0800 (PST)
Date:   Mon, 9 Dec 2019 11:29:25 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v9 3/3] netronome: use the new txqueue timeout
 argument
Message-ID: <20191209162727.10113-4-mst@redhat.com>
References: <20191209162727.10113-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191209162727.10113-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: vvClyGdEOS6ovMgt9BdY3Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index bd305fc6ed5a..d4eeb3b3cf35 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1324,14 +1324,8 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct =
nfp_net_tx_ring *tx_ring)
 static void nfp_net_tx_timeout(struct net_device *netdev, unsigned int txq=
ueue)
 {
 =09struct nfp_net *nn =3D netdev_priv(netdev);
-=09int i;
=20
-=09for (i =3D 0; i < nn->dp.netdev->real_num_tx_queues; i++) {
-=09=09if (!netif_tx_queue_stopped(netdev_get_tx_queue(netdev, i)))
-=09=09=09continue;
-=09=09nn_warn(nn, "TX timeout on ring: %d\n", i);
-=09}
-=09nn_warn(nn, "TX watchdog timeout\n");
+=09nn_warn(nn, "TX watchdog timeout on ring: %u\n", txqueue);
 }
=20
 /* Receive processing
--=20
MST

