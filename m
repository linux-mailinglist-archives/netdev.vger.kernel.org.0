Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB98323CCEA
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:12:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgHERLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:11:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32429 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728412AbgHERJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:09:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=nsePUp5bwDzPkeGMt9DhuoyzhxlPvsYKTxQ+QKtzY8M=;
        b=Kbd4MUPyz5KLtsirjxwE9j/1dddSQL9UdrLzbAZQPAQL0nC3jDbOl942DZhhLjm7V+yjLI
        WURrq+rBxiNMHXU3bIx9aR0aGuvpEX2WwNPElxXlo/tgUnFhl6eegzOVbY1Qyv50Bnf3ud
        zdlvdjJEqDC6sPd3bkGL2SBwB+NFKgM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-506-CNfQ2Ng_MzSp9DNYaN_vig-1; Wed, 05 Aug 2020 09:38:54 -0400
X-MC-Unique: CNfQ2Ng_MzSp9DNYaN_vig-1
Received: by mail-wr1-f71.google.com with SMTP id z1so13573568wrn.18
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 06:38:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=nsePUp5bwDzPkeGMt9DhuoyzhxlPvsYKTxQ+QKtzY8M=;
        b=RUYzmgTP6CDS3yOKzYcAzEfhTHCp4a3HMGy09QINMhomhNwRcu3uFLQ9M8rMDUziw+
         wUu1npGA/45bn3vCEJw2+L+slzubWzqXbfWdN9R9xPOQb2/NTSnRkCLVIaEE9GIM8oGg
         BbBcy3+BJfzqCp+wfFLCr31aYYbxxn6NmRypZ4m9R72Tkv1MbJYOfPU+EXE7fNSfEpzC
         4eE9DcwoPt/AxPwbbOdR8PbNB/njpX5Vvi6F2DBBLb+FU/DvXDW1X6e7FM8JKKjO3btX
         T1nITurvB/02ZsDrRi/5RHct1yK+92QfmHRKJJcF+jcsT3waFcTvqrtKMoXUHS3dAXXI
         foOg==
X-Gm-Message-State: AOAM531CLM2qiL9/0ZvM4aqfjBruRIncnN2W+bXzXL2rmha1E0kl00am
        mfhXbzp9fvv9UakmZbwSKbE1OrzJ/o48Vao8JQB7Pq6AIGr5EjcMpXhtsSYCHLyMFxDxiigRAMj
        CPohkabSltL/ISvUZ
X-Received: by 2002:adf:f486:: with SMTP id l6mr2832112wro.265.1596634733652;
        Wed, 05 Aug 2020 06:38:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyrJHbiAkvwUZChxw62cK2kQ+h4SfhhoyHmbeMJJ3IoB9ua448nhQGhAU9Dt58uSQD6O7qCdw==
X-Received: by 2002:adf:f486:: with SMTP id l6mr2832102wro.265.1596634733486;
        Wed, 05 Aug 2020 06:38:53 -0700 (PDT)
Received: from redhat.com ([192.117.173.58])
        by smtp.gmail.com with ESMTPSA id w1sm2855531wmc.18.2020.08.05.06.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 06:38:52 -0700 (PDT)
Date:   Wed, 5 Aug 2020 09:38:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] virtio_net: use LE accessors for speed/duplex
Message-ID: <20200805133843.1105808-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Speed and duplex config fields depend on VIRTIO_NET_F_SPEED_DUPLEX
which being 63>31 depends on VIRTIO_F_VERSION_1.

Accordingly, use LE accessors for these fields.

Reported-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c        | 9 +++++----
 include/uapi/linux/virtio_net.h | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba38765dc490..0934b1ec5320 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2264,12 +2264,13 @@ static void virtnet_update_settings(struct virtnet_info *vi)
 	if (!virtio_has_feature(vi->vdev, VIRTIO_NET_F_SPEED_DUPLEX))
 		return;
 
-	speed = virtio_cread32(vi->vdev, offsetof(struct virtio_net_config,
-						  speed));
+	virtio_cread_le(vi->vdev, struct virtio_net_config, speed, &speed);
+
 	if (ethtool_validate_speed(speed))
 		vi->speed = speed;
-	duplex = virtio_cread8(vi->vdev, offsetof(struct virtio_net_config,
-						  duplex));
+
+	virtio_cread_le(vi->vdev, struct virtio_net_config, duplex, &duplex);
+
 	if (ethtool_validate_duplex(duplex))
 		vi->duplex = duplex;
 }
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 27d996f29dd1..3f55a4215f11 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -99,7 +99,7 @@ struct virtio_net_config {
 	 * speed, in units of 1Mb. All values 0 to INT_MAX are legal.
 	 * Any other value stands for unknown.
 	 */
-	__virtio32 speed;
+	__le32 speed;
 	/*
 	 * 0x00 - half duplex
 	 * 0x01 - full duplex
-- 
MST

