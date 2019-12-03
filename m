Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7A11105D7
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 21:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfLCUSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 15:18:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54645 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727297AbfLCUSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 15:18:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575404332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QzfchXBORmVAXVWCchalHt0Yn1js9G37mDNvONQ3Wls=;
        b=Q93Yu96MRrYKzquLVFVrzUV9vd7b04wSRTZLFz0eRwD+DB2mVrQm3y5EQUyCBxh0wU+fRq
        ErI9i1KXs3MUSBd26osdOTd4auQ9bo5CIfB8/ifCqLLBZgre0F13IKbrsn8q8gqm9HxsmW
        Qv+jt9VoeXvBBJAzlrFlyXggD97segc=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-tJf2-By8M52cYqgEIkkEmg-1; Tue, 03 Dec 2019 15:18:49 -0500
Received: by mail-qv1-f70.google.com with SMTP id n11so149929qvp.15
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 12:18:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1eT8WcO+phWqOZ5pmGdX1qqI1UY1VLfXJPwN7V6jCjo=;
        b=eMnavKFCLAkzFgwU+MJqyoZlO2If8UeDi6lu/Tos4LkS/tbCzUOE7c1EV9FDAie+97
         iaC5ydffc6pWmKExr5PgmhHbK8XtUObzGIjzcRXMd9us++FOOkcrkUdbiRHANYka9TVR
         yS718qzqHn5ZfLDqUMZ9TLc627Ol47p5bbdJzkRdmQdzVhm1svpZJO5yERbiIfqCYWGk
         fBBGRjTRf7F3YyciWRgpcc3luiP7FsJi+1KRU1Wg4yJVsoRXubgH1oknX6QKbXTbvSm3
         ZY+N4F1FpWBdAaCX2FgmDHzm4j7Wrl+tQepr6a+n1aUiFKsruGIKwg/MeRbaZnf55hm/
         NLkg==
X-Gm-Message-State: APjAAAWm0FtxX+dgYT/ih2fNq7y5AcQaZXqK20yS75X1mpHtSYRAsbRg
        2P85OngWeWxSRk7XxPJvhk4qQPZcIqTkMM58WYkaEZnN014WpIF9ZM3ExLQQ5THbF2C15fWzC6t
        xuN4t9BqVGBu1U6gi
X-Received: by 2002:ae9:e30e:: with SMTP id v14mr6993487qkf.344.1575404329218;
        Tue, 03 Dec 2019 12:18:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqysczwdd3R/V/nqPtkylMkEJge0arlFCdi6l3hYYdJyHzUT6UlaH9W1E/8BHEBhaPjqmCAnFg==
X-Received: by 2002:ae9:e30e:: with SMTP id v14mr6993469qkf.344.1575404329019;
        Tue, 03 Dec 2019 12:18:49 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id s127sm2357687qkc.44.2019.12.03.12.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 12:18:48 -0800 (PST)
Date:   Tue, 3 Dec 2019 15:18:43 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH RFC net-next v8 3/3] netronome: use the new txqueue timeout
 argument
Message-ID: <20191203201804.662066-4-mst@redhat.com>
References: <20191203201804.662066-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191203201804.662066-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: tJf2-By8M52cYqgEIkkEmg-1
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

Changes from v7:
=09combine two warnings into one

 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index 41a808b14d76..eb1f9bed4833 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1323,14 +1323,8 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct =
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

