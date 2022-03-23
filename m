Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A106C4E57B0
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343671AbiCWRiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239664AbiCWRiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:38:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D03B17E0A7
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648057003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=badQ4iNux1pPz/7wSA5tFhWc+QQEkhPUp5sQLckQMkQ=;
        b=RNMluBOK2QIn8XJRtFsM28fsA+xO0J3SwSJFVRKCoWnDLKH7PJfUXGGmNBOtqylORwyJos
        XO/OTOT+/mOGJK8fjXuC8/2d8E45OOq62CK6jGQ5wTC2eirlJiOmFs+O0E7iYu+sFCEO+i
        LCILXKH0MmkTtviW2u7Gz1m4Mald3uE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-DX-Gm5rzPJ6V3i56sSJAbg-1; Wed, 23 Mar 2022 13:36:40 -0400
X-MC-Unique: DX-Gm5rzPJ6V3i56sSJAbg-1
Received: by mail-qk1-f200.google.com with SMTP id i2-20020a05620a248200b0067b51fa1269so1454748qkn.19
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=badQ4iNux1pPz/7wSA5tFhWc+QQEkhPUp5sQLckQMkQ=;
        b=7lfMWw7Vho+/NOxo5drcKyHttZStAkQZWq/z0D9+0fIOFmVzfYDxFZUwfMjNUoWsfC
         BhCVhHNK+PTt1FeUTrU5scsi4YvXVB5SMxifQNAxdiz2/pwr9dgIx7W74t0++KhQc427
         m6+jSpxft6skXP3Mp/koz09xVydXNBcV6MmrUTQPbrcni97lRRuU+oqWbLm6S7qyqE74
         uJuChntBBwZrfRu0rkq92wFVFptMU9gDKmbZOPiOALvGXkT6LlPGvvlw7AYtBuC4pYJY
         ewQDmvHshGI8OohMv2svK8ddIOBZVSE8jPkTxLeRg5rv53B+rPW+D8CB/haP9STPmTYr
         +1cA==
X-Gm-Message-State: AOAM53094sU5LMDVKzSyspjSNKxPIrrAH637r/F4N5I4NxCPOPjqwqlx
        HHCKTGmKlRvkKEcHuTjz5KefKmpYR5kv4+f4XM3aEpS6XXptzg79gP2Ny3doqIbIF8gix7f+zKV
        nvrfqpRbozPGZmAdNzt0NouBjZbJSnR4DrVlM6oRLpzdPT7yeQRYEcOp8xcCDpLM+qN5z
X-Received: by 2002:ae9:ed96:0:b0:67e:c89e:480a with SMTP id c144-20020ae9ed96000000b0067ec89e480amr718890qkg.274.1648056999515;
        Wed, 23 Mar 2022 10:36:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydhjsyMjk7m4UHfPJYXhDmCRpm61QiwyPkqiHwWTFXbdWyL3aM7kxuaIS4gs2HZKKewMIaMg==
X-Received: by 2002:ae9:ed96:0:b0:67e:c89e:480a with SMTP id c144-20020ae9ed96000000b0067ec89e480amr718839qkg.274.1648056998815;
        Wed, 23 Mar 2022 10:36:38 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id h14-20020a05622a170e00b002e1a65754d8sm476127qtk.91.2022.03.23.10.36.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:36:38 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Stefano Garzarella <sgarzare@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net v3 2/3] vsock/virtio: read the negotiated features before using VQs
Date:   Wed, 23 Mar 2022 18:36:24 +0100
Message-Id: <20220323173625.91119-3-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323173625.91119-1-sgarzare@redhat.com>
References: <20220323173625.91119-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Complete the driver configuration, reading the negotiated features,
before using the VQs in the virtio_vsock_probe().

Fixes: 53efbba12cc7 ("virtio/vsock: enable SEQPACKET for transport")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 3e5513934c9f..3954d3be9083 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -622,6 +622,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
 
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
 	vdev->priv = vsock;
 
 	mutex_lock(&vsock->tx_lock);
@@ -638,9 +641,6 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 	vsock->event_run = true;
 	mutex_unlock(&vsock->event_lock);
 
-	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
-		vsock->seqpacket_allow = true;
-
 	rcu_assign_pointer(the_virtio_vsock, vsock);
 
 	mutex_unlock(&the_virtio_vsock_mutex);
-- 
2.35.1

