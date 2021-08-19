Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0023F1FB9
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 20:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhHSSQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 14:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhHSSPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 14:15:49 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 460C5C061764;
        Thu, 19 Aug 2021 11:15:12 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id h9so14702673ejs.4;
        Thu, 19 Aug 2021 11:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QZeyn80AkA3R6umXDzeR1g+4aAh8ymRt/6Rb4eSHFWs=;
        b=r1ndwMAMQnxUrOKgNwAKYiBN7MlQDLZKEv0cewJoHvSni3A5CPwhbE6j8UBENjsRGb
         RdsTVrOHXfHdcPp5FVeijubn5mbnt97KQApJPKlrm9UpabqBM3PRJpM6lvZetnpDcogg
         9jXVFPtoOAdNtJErsmRDq/AUHeHruDSwRmCnPczlcp2EVz2ZpiS3dpVYVHfLFYhudgle
         xRQBx9OLi4WGVG7FferiNubK9+1fBvcLAS4Odieuff1529RIez7V/K4baws+NuJf4SdB
         //fVCqYQR068cwC0vcmpx6rs+HZIlO4a0qdlvztKBjN5+Ts4rAVEbIuiwXo+EfRIzZYy
         axLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QZeyn80AkA3R6umXDzeR1g+4aAh8ymRt/6Rb4eSHFWs=;
        b=JpX8LgXjf1FCd3UyqOreWdQoDD2gXC4nVHyZHHXvzIHpvd4MaNAtL9PqIbT2lyzgJV
         vibpeJRx3trCy/sxxSHYjT7bJ+lwg/GWqxHPIzuXxn8iZoS6r3ZB9URrL46AdugYQcTY
         JsMu1zPW3dpAMqfxffHAYFqfJauTMa67FSUeYmJfVuU+qsvkTKgyjTBeVyb3yjCd/jM9
         lcPLS9c5nDfdTek5FE0rQhcZCokHe6icY/jkImmBi5KdME5xG18v/ouPeCB8EhpUoHHW
         dCo34b+O20EvSIv4GdoWlDui5Gro1eJGmri3omUpx+5DtStGs45GK6tpO/IbQ+vgGs8b
         4+Ng==
X-Gm-Message-State: AOAM532FP+MSUbMah1GOOuVIPx0DFFrXmCI+IY46CQW3Z2JADuHGIYMQ
        /TkqrKVMll/3UINv+B/D6o8=
X-Google-Smtp-Source: ABdhPJwv3I7xzyNM8XRr6uNEKaPEy8KXIrhmMI6EC0i7o6eqmhKhpFLy6+2KFRKJB2tDVagZwNtCLg==
X-Received: by 2002:a17:906:dff3:: with SMTP id lc19mr17391652ejc.34.1629396910919;
        Thu, 19 Aug 2021 11:15:10 -0700 (PDT)
Received: from localhost.localdomain (185.239.71.98.16clouds.com. [185.239.71.98])
        by smtp.gmail.com with ESMTPSA id ks20sm1599314ejb.101.2021.08.19.11.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 11:15:10 -0700 (PDT)
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
To:     mani@kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        butt3rflyh4ck <butterflyhhuangxx@gmail.com>
Subject: [PATCH] net: qrtr: fix another OOB Read in qrtr_endpoint_post
Date:   Fri, 20 Aug 2021 02:14:58 +0800
Message-Id: <20210819181458.623832-1-butterflyhuangxx@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: butt3rflyh4ck <butterflyhhuangxx@gmail.com>

This check was incomplete, did not consider size is 0:

	if (len != ALIGN(size, 4) + hdrlen)
                    goto err;

if size from qrtr_hdr is 0, the result of ALIGN(size, 4)
will be 0, In case of len == hdrlen and size == 0
in header this check won't fail and

	if (cb->type == QRTR_TYPE_NEW_SERVER) {
                /* Remote node endpoint can bridge other distant nodes */
                const struct qrtr_ctrl_pkt *pkt = data + hdrlen;

                qrtr_node_assign(node, le32_to_cpu(pkt->server.node));
        }

will also read out of bound from data, which is hdrlen allocated block.

Fixes: 194ccc88297a ("net: qrtr: Support decoding incoming v2 packets")
Fixes: ad9d24c9429e ("net: qrtr: fix OOB Read in qrtr_endpoint_post")
Signed-off-by: butt3rflyh4ck <butterflyhhuangxx@gmail.com>
---
 net/qrtr/qrtr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/qrtr/qrtr.c b/net/qrtr/qrtr.c
index 171b7f3be6ef..0c30908628ba 100644
--- a/net/qrtr/qrtr.c
+++ b/net/qrtr/qrtr.c
@@ -493,7 +493,7 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 		goto err;
 	}
 
-	if (len != ALIGN(size, 4) + hdrlen)
+	if (!size || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
 	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
-- 
2.25.1

