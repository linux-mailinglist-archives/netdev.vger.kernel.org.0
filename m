Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 535381171AB
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfLIQ3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:29:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:53117 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726602AbfLIQ3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:29:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575908963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NNvyL4Y9eRzqtb2H2E84LxRf2YADQJydGhMMLpn/rvY=;
        b=OplCVjKrQSFLDMx/tmvrPsGWR7m0hGjhyqJ0G5TJ73BOQTEuNV+rxXwF87MkIL0jP46S2S
        GDltfyvLtnRarPiz42sRnEy0j41hE+ibyd27us4fB+KjX8PowXkqeDgiagb1EAoMsNb39I
        xeY4GH+iwxjBxDr4s8Qpyuv5XUmh1t0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-fR8IdduhMmGbI0LAGYKwcQ-1; Mon, 09 Dec 2019 11:29:22 -0500
Received: by mail-qt1-f200.google.com with SMTP id x8so11465121qtq.14
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 08:29:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wQxMVxgAtK5y0CyKs1BCEj6d5vwE3qN67Xvd5FZmfgk=;
        b=eCDjLLZ6ugspSPWByy9PARA9gr/m9fVYMasjcdA5ujsQwstNjksBlUZpZ0PqvSoPHy
         /TWM4E2Y70497pTYdxNWsCexyzHcdEp0fBkVkCFwum0uY3eq9nJ+incWKI646vs6fA9w
         l2sV+PTob6YUSDgCV9ls5/RpCxLdMvkHy//TnbP1m+HrCRXcPR+hueV/1GdIo8CQKm+C
         6NRmi+P/EkcfBjQ0RI8OE9uZN2ecqm24uHpWodF2TzUTLUN/X7NewXsISOfwMAR017RJ
         PIc36Nle3hbbVyIc2/jfpTs7Wmg1a/4tWqZ9DUU1dloy2eWdo66yty7CShkrOlgM0Hs3
         Me/Q==
X-Gm-Message-State: APjAAAUBnVfb6D/HDRp0v1y99lqkzFlgt5Malb7iYP1eLyfXxKQP9MbR
        pQtmaPz29SRPiOC5iSe0+LrR4oC2OVNy6Eo4v871p7vYlceKY6cm8ThscgIPGJ+Doo4jHWieO5e
        RL6UiQPUc0dYFXy19
X-Received: by 2002:ac8:7699:: with SMTP id g25mr14525703qtr.75.1575908962221;
        Mon, 09 Dec 2019 08:29:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqxBHx4JNZAzW5zOl78IJTl/Z39c+yCCpUqxZ1MccFYIr6NFhza1xXBFpnvMlezVfnTZjFAmuw==
X-Received: by 2002:ac8:7699:: with SMTP id g25mr14525689qtr.75.1575908962077;
        Mon, 09 Dec 2019 08:29:22 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id x19sm19777qtm.47.2019.12.09.08.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 08:29:21 -0800 (PST)
Date:   Mon, 9 Dec 2019 11:29:16 -0500
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
X-MC-Unique: fR8IdduhMmGbI0LAGYKwcQ-1
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

