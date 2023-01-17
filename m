Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE8D66E1EB
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbjAQPSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjAQPRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:17:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB9339BAF
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673968611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=smNNRaeV0+/HRXen5xw9CFj2kNpy5x+VFPv/e/OcsJU=;
        b=OuhR+DOnopXjqzZnmY+fCD2SppPf7mcv8LtkNHC1JFeHxOodbK0916mAS9xHO2yQQBzJDf
        mqLcJOu61TeQHlDRhEM73L1aqW3lFjcJZElrufSWQn1GvLUcuj8o9O89lZOai051I65FZo
        Xa3z668idU2cIVHmoN4xonUUlj0qhRM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-494-5HCBiZ2QOC-SunYOPDLNSw-1; Tue, 17 Jan 2023 10:16:40 -0500
X-MC-Unique: 5HCBiZ2QOC-SunYOPDLNSw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 297E82804158;
        Tue, 17 Jan 2023 15:15:22 +0000 (UTC)
Received: from qualcomm-amberwing-rep-06.khw4.lab.eng.bos.redhat.com (qualcomm-amberwing-rep-06.khw4.lab.eng.bos.redhat.com [10.19.240.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCFA640C6EC4;
        Tue, 17 Jan 2023 15:15:21 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, mst@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     peterx@redhat.com, lvivier@redhat.com
Subject: [PATCH 0/2] vhost/net: Clear the pending messages when the backend is removed
Date:   Tue, 17 Jan 2023 10:15:16 -0500
Message-Id: <20230117151518.44725-1-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the vhost iotlb is used along with a guest virtual iommu
and the guest gets rebooted, some MISS messages may have been
recorded just before the reboot and spuriously executed by
the virtual iommu after the reboot. This is due to the fact
the pending messages are not cleared.

As vhost does not have any explicit reset user API,
VHOST_NET_SET_BACKEND looks a reasonable point where to clear
the pending messages, in case the backend is removed (fd = -1).

This version is a follow-up on the discussions held in [1].

The first patch removes an unused 'enabled' parameter in
vhost_init_device_iotlb().

Best Regards

Eric

History:
[1] RFC: [RFC] vhost: Clear the pending messages on vhost_init_device_iotlb()
https://lore.kernel.org/all/20221107203431.368306-1-eric.auger@redhat.com/

Eric Auger (2):
  vhost: Remove the enabled parameter from vhost_init_device_iotlb
  vhost/net: Clear the pending messages when the backend is removed

 drivers/vhost/net.c   | 5 ++++-
 drivers/vhost/vhost.c | 5 +++--
 drivers/vhost/vhost.h | 3 ++-
 3 files changed, 9 insertions(+), 4 deletions(-)

-- 
2.31.1

