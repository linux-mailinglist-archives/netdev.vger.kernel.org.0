Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B023AEC7E
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhFUPfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:35:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28280 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230332AbhFUPf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 11:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624289592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WcPOkG/uZ9akoELvnm75VfGTCa7/v/yG9GvmoQeB8L0=;
        b=EF0bhyEW6Hf66FNlbCO4HdHe/8kJ8A8bi41okYSxHJQ+5RGD9KL5SDhn2Gd+k+XFcwcrDS
        IH+8qnltzwc7JftmaJ14X9pzsT9glJYLMIuTvgenwlqF6EJ2eX1mgnDououKuGlyLqSuu6
        Xy7zCC5zjbj2hDwTRQNtwSuXV4xU4d4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-uAYA_aCcPRaVDlRse1-mJg-1; Mon, 21 Jun 2021 11:33:10 -0400
X-MC-Unique: uAYA_aCcPRaVDlRse1-mJg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1F2218D6A35;
        Mon, 21 Jun 2021 15:33:05 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11C5C2C00F;
        Mon, 21 Jun 2021 15:33:03 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ihuguet@redhat.com, ivecera@redhat.com
Subject: [PATCH 4/4] sfc: avoid duplicated code in ef10_sriov
Date:   Mon, 21 Jun 2021 17:32:38 +0200
Message-Id: <20210621153238.13147-4-ihuguet@redhat.com>
In-Reply-To: <20210621153238.13147-1-ihuguet@redhat.com>
References: <20210621153238.13147-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fail path of efx_ef10_sriov_alloc_vf_vswitching is identical to the
full content of efx_ef10_sriov_free_vf_vswitching, so replace it for a
single call to efx_ef10_sriov_free_vf_vswitching.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index f8f8fbe51ef8..752d6406f07e 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -206,9 +206,7 @@ static int efx_ef10_sriov_alloc_vf_vswitching(struct efx_nic *efx)
 
 	return 0;
 fail:
-	efx_ef10_sriov_free_vf_vports(efx);
-	kfree(nic_data->vf);
-	nic_data->vf = NULL;
+	efx_ef10_sriov_free_vf_vswitching(efx);
 	return rc;
 }
 
-- 
2.31.1

