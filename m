Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0169F118AC4
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbfLJO0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:26:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50647 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727178AbfLJO0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 09:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575987965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNvyL4Y9eRzqtb2H2E84LxRf2YADQJydGhMMLpn/rvY=;
        b=h49V75VZ40dKnG5xp4tG1GaLBqB0/z6nJ2AaK7dlpXNWfVa0gSFunPVbfpnRt4knKgtXKA
        etcAQwQIG166i5Qx/aboQJ81+c9qkjofMSVZ8xgId/Zt6xIBfbA+n7PdPQPT0rAu8vMav8
        JYv+iVYm2JHbAUJX3t1DPO75X6Lyq2M=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-415-c6PnrVq7NqWaKpRVuMs-MA-1; Tue, 10 Dec 2019 09:26:04 -0500
Received: by mail-wr1-f69.google.com with SMTP id c6so8965572wrm.18
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 06:26:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQxMVxgAtK5y0CyKs1BCEj6d5vwE3qN67Xvd5FZmfgk=;
        b=iYB/1LTVzCdw7pazqSkNoAUj1Z70LNXPucZkNvZGdwuhgakOVSVE01jGU2eo0tXRw7
         iOprfNOUhytSBSlgh7tjAD/Ki86HQCZNT3xRgc0YyXkgZdilNmeuu4NAOBegzi7a5eaP
         NkdmPNRTo5ppXurD4EwZbaj++K5KDrKk828r0LUgXHqEhiEHmKPxj4wOIfAwhFEIKeER
         IuDLq9wShcl2LsQnZAXP2v8JzAS5+Iy1P2luvVrsakql0J8pOT8vg4tHWSCKUT7PTk28
         Vn49yrZ5Z5kjrYAm9T4bnkq59HNlZYOBytONKrlt5pgcXMvetv/JnXwdVEnwPACQikhJ
         KA4Q==
X-Gm-Message-State: APjAAAXFizQfP5SwtrBYEVeYORyZs1Y8q2F0Fcjc+DbA1Rk56bCRje/i
        PmE2/FA3VvsV+SSGNE+My0y6LZJVR5JXtUBRpf+Qx5M2kX/yxJ+fRmV2G6U7/prp7H7G+bEWVCS
        u8ZSY7Y3JZg7DDyji
X-Received: by 2002:a1c:9e0d:: with SMTP id h13mr5613202wme.110.1575987963558;
        Tue, 10 Dec 2019 06:26:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqwf8mLK3UiBgavRy2zL8nuLvXVh2JCTOm4jCctkF/rAHV0Vm9bzgDEuAXksgE6XBUivzcDsTA==
X-Received: by 2002:a1c:9e0d:: with SMTP id h13mr5613179wme.110.1575987963411;
        Tue, 10 Dec 2019 06:26:03 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id u8sm3290027wmm.15.2019.12.10.06.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:26:02 -0800 (PST)
Date:   Tue, 10 Dec 2019 09:26:00 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v12 3/3] netronome: use the new txqueue timeout
 argument
Message-ID: <20191210142305.52171-4-mst@redhat.com>
References: <20191210142305.52171-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210142305.52171-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: c6PnrVq7NqWaKpRVuMs-MA-1
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

