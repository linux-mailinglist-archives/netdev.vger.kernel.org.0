Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92946B80CC
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjCMSdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjCMSdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:33:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF9E85B21;
        Mon, 13 Mar 2023 11:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60BC661484;
        Mon, 13 Mar 2023 18:30:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA3AC433EF;
        Mon, 13 Mar 2023 18:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678732256;
        bh=sdMhGh/v0S4uLhhMgXoZcxTftjLcVbQ0JldvEDTZ1yE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/hI9tL/g1oKZX9SamcN3M5/Phk2olRLoatPJFm31YFAUcAsHgxSUO3k5HrcUFBGR
         oTFlhpdu5AzaDPUsg8JPv2FLzqxqaON2iQZQPmb/f7IuSBmUXQAln9+7wnXBsgdkfo
         ujvYCBIj/MpDkfXQafdJ925ZIXxw9Js6vvSnB+k8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     rafael@kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH 31/36] vhost-vdpa: vhost_vdpa_alloc_domain() should be using a const struct bus_type *
Date:   Mon, 13 Mar 2023 19:29:13 +0100
Message-Id: <20230313182918.1312597-31-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230313182918.1312597-1-gregkh@linuxfoundation.org>
References: <20230313182918.1312597-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1408; i=gregkh@linuxfoundation.org; h=from:subject; bh=sdMhGh/v0S4uLhhMgXoZcxTftjLcVbQ0JldvEDTZ1yE=; b=owGbwMvMwCRo6H6F97bub03G02pJDCn82TUvbDoStjD0i/1v+vmN+6FAU3bEc8GDO0VEeJmnK n3uEcvoiGVhEGRikBVTZPmyjefo/opDil6Gtqdh5rAygQxh4OIUgIlE/mOYp+sx9Tebv8y3yUbr ta71fL9koRnIzzDfQ/VD509tq8Db9tk3zRNct9fM6dcHAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function, vhost_vdpa_alloc_domain(), has a pointer to a struct
bus_type, but it should be constant as the function it passes it to
expects it to be const, and the vhost code does not modify it in any
way.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Note, this is a patch that is a prepatory cleanup as part of a larger
series of patches that is working on resolving some old driver core
design mistakes.  It will build and apply cleanly on top of 6.3-rc2 on
its own, but I'd prefer if I could take it through my driver-core tree
so that the driver core changes can be taken through there for 6.4-rc1.

 drivers/vhost/vdpa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index dc12dbd5b43b..08c7cb3399fc 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1140,7 +1140,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	struct device *dma_dev = vdpa_get_dma_dev(vdpa);
-	struct bus_type *bus;
+	const struct bus_type *bus;
 	int ret;
 
 	/* Device want to do DMA by itself */
-- 
2.39.2

