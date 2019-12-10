Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0B311891A
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfLJNEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 08:04:54 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44398 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727296AbfLJNEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 08:04:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575983093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9e82RZxMOLIpTiokhMnuko25lsVYhsTU5bajYGHD3E0=;
        b=ASRy6q6VT6O0XvJzwC5HoQ+eB2ScLv9TTf/vs27bC6WJ5/nvYRFNUwtrBeCw9V1bjazf/O
        kJK5FDxDvpNHEbtxHAcjzPbIvBq+eGVpTirj6wdU7qh40ymA3aP/e3V4HQXwZhKjXRSgXx
        QoDt4z9Ra/FANrrqagT0WdQ2k79eszA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-369-4eQ4RvG4PXmQgiUndylJJg-1; Tue, 10 Dec 2019 08:04:52 -0500
Received: by mail-qk1-f198.google.com with SMTP id l7so4364742qke.8
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 05:04:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wrMmlrBt1X+KXyyzVL2v0JpYF8+uVnrQFFbGuDQ2s1k=;
        b=itnAPtkrB4TR6N1t9uAAsBhMO9IvKfJi5VqXlg6/sKbsLeaK6CeplDjTstM2M5pZSx
         UuxfR3UY36mLDjF2mkQ9COODtPGhlyKw0r69D0GRh7UYWnpmszvNPzEksm+BYobqZtJW
         Ac3z8O3gHjWCe5Kl/mDylON7VIf7A+WnN2qDjawRzOX8ErkDtKHNVVOMQdESHe/1Ostf
         rU+po1uhibZbhhClRa9BcN8Kh57xvyauNTwQI1uxwtssXb89bKGZ0RJ5p5VT7abRIm2y
         +2z4A0VmvL8C4IllXmkjXIkILS4r7uVmZpJ74ocufLW/LrkJm5+FcGZNIaZfIcY4+JDQ
         xrtA==
X-Gm-Message-State: APjAAAVcteIl1a20CtxgB0h/cNnl7/Imxw26i7/BMmiaZbO8CuEz8BPR
        ZG5RdYaq9PT5KcTvdE7oXezYrxQnoPRdcDv9WqdziE+dhprPkWNfBHGGSLKcTmtCLoK7N8D2eGi
        LCEw+P0DSqCP00X5f
X-Received: by 2002:ac8:24c3:: with SMTP id t3mr4913481qtt.297.1575983091843;
        Tue, 10 Dec 2019 05:04:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvRMy+oBS/dEnpWmTMEn7uoVJylDeK7fazqXG08ZonVvSCZh4f/q1+l6V4b3jvu8EyJI4OOg==
X-Received: by 2002:ac8:24c3:: with SMTP id t3mr4913348qtt.297.1575983090215;
        Tue, 10 Dec 2019 05:04:50 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id t38sm1070453qta.78.2019.12.10.05.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 05:04:49 -0800 (PST)
Date:   Tue, 10 Dec 2019 08:04:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org, Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        dnmendes76@gmail.com, Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next v10 3/3] netronome: use the new txqueue timeout
 argument
Message-ID: <20191210130014.47179-4-mst@redhat.com>
References: <20191210130014.47179-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191210130014.47179-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: 4eQ4RvG4PXmQgiUndylJJg-1
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


