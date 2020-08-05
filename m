Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9E323D015
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbgHET3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:29:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30569 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728598AbgHERL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nsePUp5bwDzPkeGMt9DhuoyzhxlPvsYKTxQ+QKtzY8M=;
        b=L00RFt4hyZphKEkzOLKgLtwumDIYN0ka0yiSzXi3Lxkxo0DUCDZZ6eKg3TGRf6zfhXvtWR
        7gKepz9QStTnZtbGqHcA+9dtlFWmw3DOgS1X9FDgfroL9Vz2G3Aanpvhw7LL70/NH0wb8d
        n/mECgc9MFl+7dZNNT+mCUELluNK8hg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-qscwDMTNOmCEsQrWhgXJcA-1; Wed, 05 Aug 2020 09:45:04 -0400
X-MC-Unique: qscwDMTNOmCEsQrWhgXJcA-1
Received: by mail-wm1-f70.google.com with SMTP id p23so2475591wmc.2
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 06:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nsePUp5bwDzPkeGMt9DhuoyzhxlPvsYKTxQ+QKtzY8M=;
        b=k0ZTpWXBcGmIDA1vJi6lLFnDozhwl8YePO2XNlM8apuriAYzTu6az4rkLMuzeGNm0g
         vc+Tl/1ZzUjo4b8fJAFrWw6LbV4s1Vgh+Fhg2dtApBe4RmTzSp+L8alkqkpL4ONncb7R
         AyuZ0eXnsS0SmOXJ3TIF0MAQYCyenDh2W8mN0btEJ+V0ic4VwtfB3MRGx+BcFsMbeqFB
         Fap+VgoTonx4qlbhtDtD9kzx6k7GTKY8s5X3zXqcovLdVDC2YiHe6SNUQT/1SjfmjHzV
         hPHb2FXM/ScmL4DoB7XqoYwAcn7rZ7eaMQGcS0VBaQgPO7cnfiiNQAklbV9NiwJZk9wS
         hWRw==
X-Gm-Message-State: AOAM5309s6FaF8kt940pHxOItxclOX4McPv4HgBXUQxaeTU1EKJT8eBr
        wm7Mks3JBVC7I3hmSYvhLTMifBmj132PkdG70Ez59a8tUaoZejbfBlo6sGOu8oXN5yR95LZRKFN
        KIOPyhdy29ZLDiKWP
X-Received: by 2002:a1c:96c5:: with SMTP id y188mr3540958wmd.72.1596635102978;
        Wed, 05 Aug 2020 06:45:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhLoRx7IzuivQlViG9F0fDgIgMdjMVV9PC0dBe4LfMZpIiYNNk/XwHbeS7FyfdebXIBXrqkg==
X-Received: by 2002:a1c:96c5:: with SMTP id y188mr3540940wmd.72.1596635102770;
        Wed, 05 Aug 2020 06:45:02 -0700 (PDT)
Received: from redhat.com (bzq-79-178-123-8.red.bezeqint.net. [79.178.123.8])
        by smtp.gmail.com with ESMTPSA id e16sm2907812wrx.30.2020.08.05.06.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 06:45:02 -0700 (PDT)
Date:   Wed, 5 Aug 2020 09:45:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v3 38/38] virtio_net: use LE accessors for speed/duplex
Message-ID: <20200805134226.1106164-39-mst@redhat.com>
References: <20200805134226.1106164-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805134226.1106164-1-mst@redhat.com>
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

