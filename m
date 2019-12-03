Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720C910F8BD
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 08:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727511AbfLCHcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 02:32:24 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:21147 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727472AbfLCHcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 02:32:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575358341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I8wShJUZhIPRvHwuVROe4jfsRpfx1Wn6vaFNLNcy50o=;
        b=YX6E9bvb8p4mIGoJVYo3yuUkWdtqVNHLGYI1Qd8hKHjPbnuhJaKx8qId/FXTZRLCzyJDeV
        R1P+fMNY34YgdZd8LRygRUs+3eyVCi/m9SkvOZoRCO+5UrFOD8CFI67jQdmcN7/gYRwN3t
        BiH8+YBh5+nAkNXI5BfjYFt/lS0VRy0=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-246-HcIJgP7aMguqhP9po0PumA-1; Tue, 03 Dec 2019 02:32:20 -0500
Received: by mail-qt1-f197.google.com with SMTP id u9so1824532qte.5
        for <netdev@vger.kernel.org>; Mon, 02 Dec 2019 23:32:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jwSFHekH13o2QJMVsrxXSIHF6QQ380ubnLoCLySwb1o=;
        b=qvoNm8Z44vm8FOlLzuW5PPHeDA9ZoTGVHmsP1WGzciioCfCAyHnXZxSmWs05nKhNLN
         Dba0+VpHK7baSoMlATU/qbdctUXjE2ZQKR6tSfgZZp1oP6Bbc9deG6DiwnUJvfztmFsG
         Ed7RAFWDJ7SI/agpxxFdHgD3hWPoFrCu9Pm7H5ZrNlTmX4/BHB04AHz/8O4yiKPXZJOQ
         w9mKtwG2pgHdShYVv/mBpN5NLwbSEeDcWqJyYX+f9QPw1fk8fNvq+WE6OJ0EZzk/zC4F
         660t4H+EAV+vOvNsm3VFgQg+3ej9IUVNCKxQ+XYyNHLu1hJDWBg97NYGLey5geAZpXUD
         R4ow==
X-Gm-Message-State: APjAAAVZbY/31+bQCvhdelIzsZLuLXmXmWXfNuqGYZG/Wua4Is4ybeBz
        xnPxgIh6tGr/TV1d+PdhaG/0touzIxVZZIHLBmwLFMVXbta0Ggq6Q8zpFzwv+/eG+2Cv3e2Wix9
        23IRAAs7VujFoKI+a
X-Received: by 2002:a37:404c:: with SMTP id n73mr3711278qka.292.1575358339504;
        Mon, 02 Dec 2019 23:32:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyPaIxtXBZQ4fHmWb1RYGKoL1DTAUuB7vZrs880mGPQQ0Qr4coSTbpggTuqOoohiw8W26zU9w==
X-Received: by 2002:a37:404c:: with SMTP id n73mr3711260qka.292.1575358339311;
        Mon, 02 Dec 2019 23:32:19 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id 132sm1285704qkh.14.2019.12.02.23.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 23:32:18 -0800 (PST)
Date:   Tue, 3 Dec 2019 02:32:14 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Subject: [PATCH RFC v7 net-next 3/1] netronome: use the new txqueue timeout
 argument
Message-ID: <20191203072757.429125-2-mst@redhat.com>
References: <20191203071101.427592-1-mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20191203072757.429125-1-mst@redhat.com>
X-Mailer: git-send-email 2.22.0.678.g13338e74b8
X-Mutt-Fcc: =sent
X-MC-Unique: HcIJgP7aMguqhP9po0PumA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

untested

 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/=
net/ethernet/netronome/nfp/nfp_net_common.c
index 41a808b14d76..26f1fb19d0aa 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1323,13 +1323,8 @@ nfp_net_tx_ring_reset(struct nfp_net_dp *dp, struct =
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
+=09nn_warn(nn, "TX timeout on ring: %d\n", txqueue);
 =09nn_warn(nn, "TX watchdog timeout\n");
 }
=20
--=20
MST

