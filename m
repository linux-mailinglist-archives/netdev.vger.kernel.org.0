Return-Path: <netdev+bounces-12268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A37736F30
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 16:52:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D5222811FD
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 14:52:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86267168B6;
	Tue, 20 Jun 2023 14:52:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AF5168AC
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 14:52:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEAA71712
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 07:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687272721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ELfQweYC/8dcGoZH9AqfrEpzRTMlTZCKvStu6Pf4W0w=;
	b=JAHZBpZtwQcDC4stNsHUgS/EVlrg9nhkh3QeVE0Vk7r2pkaLEdaiiigpJSVwp0siwQzzKV
	tvNDGns/E+AyT7WK2VLSX0YsPxqPJL4IQqdSo9cYSHzJUuZPQbs4riPm3AyC+v2GL6+mn/
	7Z4UasUcKbrL7By3SOkSZefLXYBM5d4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-bNBdKun_PNWBBkWTQYd94g-1; Tue, 20 Jun 2023 10:51:56 -0400
X-MC-Unique: bNBdKun_PNWBBkWTQYd94g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B55B1104459E;
	Tue, 20 Jun 2023 14:48:57 +0000 (UTC)
Received: from p1.luc.cera.cz (unknown [10.43.2.89])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 895012166B26;
	Tue, 20 Jun 2023 14:48:56 +0000 (UTC)
From: Ivan Vecera <ivecera@redhat.com>
To: netdev@vger.kernel.org
Cc: Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] bnxt_en: Link representors to PCI device
Date: Tue, 20 Jun 2023 16:48:55 +0200
Message-Id: <20230620144855.288443-1-ivecera@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Link VF representors to parent PCI device to benefit from
systemd defined naming scheme.

Without this change the representor is visible as ethN.

Signed-off-by: Ivan Vecera <ivecera@redhat.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 2f1a1f2d2157..1467b94a6427 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -468,6 +468,7 @@ static void bnxt_vf_rep_netdev_init(struct bnxt *bp, struct bnxt_vf_rep *vf_rep,
 	struct net_device *pf_dev = bp->dev;
 	u16 max_mtu;
 
+	SET_NETDEV_DEV(dev, &bp->pdev->dev);
 	dev->netdev_ops = &bnxt_vf_rep_netdev_ops;
 	dev->ethtool_ops = &bnxt_vf_rep_ethtool_ops;
 	/* Just inherit all the featues of the parent PF as the VF-R
-- 
2.39.3


