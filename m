Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4A04E57B1
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343656AbiCWRiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343732AbiCWRiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:38:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8162F7E0A7
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:36:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648056996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=MzwRKwBdRCLittF2Yi0pCWERtTQbkRUJ2eaS0FEovlY=;
        b=OL6zTA3/ktFKBLuf+F8mXktoNAAhzzajSQKBFgZnWWzynjjRDxGDamiVyWzGzBcGgwQaxR
        6GmXjxDRWYSRp4LsLLWbgRiHAthZvh9WiY6jxoV4sAkaFIme3sPqwbsXZWHXT5A0ioYhfO
        QxUVJ2vj1owWF+D0gUsxMKAIJiPzD6A=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-Nph0K85HODabTUwdkRUx7Q-1; Wed, 23 Mar 2022 13:36:33 -0400
X-MC-Unique: Nph0K85HODabTUwdkRUx7Q-1
Received: by mail-qv1-f70.google.com with SMTP id p65-20020a0c90c7000000b004412a2a1a6cso1785535qvp.3
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:36:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MzwRKwBdRCLittF2Yi0pCWERtTQbkRUJ2eaS0FEovlY=;
        b=ylcqdyZfy3HNR4FvLaKQcRC1TKXbBLmI/v5cTtc8XRBU4kYloDgCAo3bOP8jWgOZKF
         MIiH433XyezCo9dAhCrAPBh1krCTHkgK+PvUY4S/Y90oUwTmYLzR4lqN0ae74vq1EOxD
         niAEY0I+9F7Rde62a3mvcac6MoqrhPuXoF5dg4xjycuK8XrkDezrBI3SVM4ma+tq9gpz
         +QlxOF8BpzU+DklP9MY9OOzeqDPg1Zik+YONQb8FqrXJvG/VptZmbtMZVJ+rhJvgxwEp
         frZDADawlbw82/Jjho6nDT8eQveNJ8wk6tBhCVdoI0HKp27lRiW/tQtvmOabzeSZ/Fx4
         HFYQ==
X-Gm-Message-State: AOAM533otUP7FT78HGcCXDoQCGJzOdTjJ3isVBJrTYQGP023r6MfdQ74
        MZVJOIsdBTo2M/0/Ef9XogsUsqf5ir1nPb9bxSrUYZg/tuukatY6AS11fx5EYx4L/eVsHH5pXuQ
        x8oEYwfqDfqZMbO2ozUHC8Mn8W6CqzJzIITjMMdahhtnRb6XjKXBPzj/+P6S8ABDDrRNT
X-Received: by 2002:a05:6214:2509:b0:435:7443:2dad with SMTP id gf9-20020a056214250900b0043574432dadmr938563qvb.47.1648056991904;
        Wed, 23 Mar 2022 10:36:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxeN8QDcW/nCBes+HF3p4Qa8YtXACGqrPDG30FPUtcA4s5rpDfAh0kaotVknOsyPTvs3/VKmw==
X-Received: by 2002:a05:6214:2509:b0:435:7443:2dad with SMTP id gf9-20020a056214250900b0043574432dadmr938508qvb.47.1648056991171;
        Wed, 23 Mar 2022 10:36:31 -0700 (PDT)
Received: from step1.redhat.com (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id h14-20020a05622a170e00b002e1a65754d8sm476127qtk.91.2022.03.23.10.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:36:30 -0700 (PDT)
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
Subject: [PATCH net v3 0/3] vsock/virtio: enable VQs early on probe and finish the setup before using them
Date:   Wed, 23 Mar 2022 18:36:22 +0100
Message-Id: <20220323173625.91119-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.35.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixes a virtio-spec violation. The other two patches
complete the driver configuration before using the VQs in the probe.

The patch order should simplify backporting in stable branches.

v3:
- re-ordered the patch to improve bisectability [MST]

v2: https://lore.kernel.org/netdev/20220323084954.11769-1-sgarzare@redhat.com/
v1: https://lore.kernel.org/netdev/20220322103823.83411-1-sgarzare@redhat.com/

Stefano Garzarella (3):
  vsock/virtio: initialize vdev->priv before using VQs
  vsock/virtio: read the negotiated features before using VQs
  vsock/virtio: enable VQs early on probe

 net/vmw_vsock/virtio_transport.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

-- 
2.35.1

