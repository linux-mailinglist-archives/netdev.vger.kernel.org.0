Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE0D3AC44C
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 08:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhFRGzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 02:55:31 -0400
Received: from mx20.baidu.com ([111.202.115.85]:59418 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229580AbhFRGz2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 02:55:28 -0400
X-Greylist: delayed 153920 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2021 02:55:27 EDT
Received: from BC-Mail-EX02.internal.baidu.com (unknown [172.31.51.42])
        by Forcepoint Email with ESMTPS id B33C29B58FCA96F070F1;
        Fri, 18 Jun 2021 14:53:14 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-EX02.internal.baidu.com (172.31.51.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.10; Fri, 18 Jun 2021 14:53:14 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Fri, 18 Jun 2021 14:53:14 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <mst@redhat.com>, <jasowang@redhat.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] vhost-vdpa: fix bug-"v->vqs" and "v" don't free
Date:   Fri, 18 Jun 2021 14:53:07 +0800
Message-ID: <20210618065307.183-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"v->vqs" and "v" don't free when "cdev_device_add" returns error

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/vhost/vdpa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index fb41db3da611..6e5d5df5ee70 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1065,6 +1065,8 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 
 err:
        put_device(&v->dev);
+       kfree(v->vqs);
+       kfree(v);
        return r;
 }
 
-- 
2.22.0

