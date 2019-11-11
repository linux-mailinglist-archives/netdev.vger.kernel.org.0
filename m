Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC680F833C
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 00:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKKXGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 18:06:18 -0500
Received: from mail-qt1-f177.google.com ([209.85.160.177]:33965 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKKXGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 18:06:17 -0500
Received: by mail-qt1-f177.google.com with SMTP id i17so6003363qtq.1
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 15:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+rSLh56c+sCYCIjjBVItUNNfOrnKMOBIv3rJETuCigY=;
        b=kbvtAcUGTTHIt3VB6dUb8lgBTilxmuAFGbtrtx/JQy0QP+c8X4NhmTkKwQlMUta9dg
         PU3afb37cUZ/XafaDdQG9GTQ5d+wla9A75AQVf2yKXnlcsaZl1xqkFH4om0V9T8p3bXU
         PFAC2p+tBITBF1lyZ5R0UDxy2Rf8CKnnL6OyMMLdPBbBAsXVN+Iw+kSizZ3T5/NYiE1m
         eYn9dcC18VcVW8LZejMmLjGKymwT7ZIo0YOLZXcl0SNPmYpAi4F94A7GgdnTUxjgNTTX
         qaajwRiiYe46hpec5p4Ulb1ZzPObl4geFMMsKL/tZEfx0sSm4gglhqaXNFyE9XcamB8a
         kVUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+rSLh56c+sCYCIjjBVItUNNfOrnKMOBIv3rJETuCigY=;
        b=jTptzx1Jp06HVLbu/5fGOd7oypWAUukhLpwNt8tg9yGFFv/Lrei5iQmEGZMtPqGpye
         MOJidBHWy4YjsTkmHE4Je76vgCADEWI/NVp5HDGzJheZ/rtZZ9ougLpeJoXdzgXK0UAu
         9ExJJYamzj3HBabRMy+jXSiRX7BnPws/GCKqN8Rtzugr+CVSQTPHzbIfJK/cQCRzlhFG
         y37mdEg4vuFYio4Sh8E9vES0k9ASVyGEpti8I53nF7X0HMPNYyfplCAEdjZrmNcng9XC
         e+bVG63gLJE8/uQpPsrxQTCUhzsbOqhhu1bM8MFMdIPK/CmNRtDVTdMN9RQYYlPtQpzU
         ApUQ==
X-Gm-Message-State: APjAAAXQnkOSqTwUVA81H88tWL0xglA+GCwpg0QBZ+PsdtvtqIBuVvC1
        q2Sl3NWy0LwXHlgXtgho2tE=
X-Google-Smtp-Source: APXvYqyqXHxGxaIdoIwb4qlCfOjHJHrxnn9iSLEO5rH/Qe6vLv5rcIjyCxQsLv16iP59y7fkQYoh0A==
X-Received: by 2002:aed:3ee7:: with SMTP id o36mr28649988qtf.278.1573513576268;
        Mon, 11 Nov 2019 15:06:16 -0800 (PST)
Received: from localhost.localdomain ([64.94.121.131])
        by smtp.gmail.com with ESMTPSA id x133sm8428256qka.44.2019.11.11.15.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 15:06:15 -0800 (PST)
From:   Xiaodong Xu <stid.smth@gmail.com>
To:     steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     chenborfc@163.com, netdev@vger.kernel.org,
        Xiaodong Xu <stid.smth@gmail.com>
Subject: [PATCH v3] xfrm: release device reference for invalid state
Date:   Mon, 11 Nov 2019 15:05:46 -0800
Message-Id: <20191111230546.17105-1-stid.smth@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An ESP packet could be decrypted in async mode if the input handler for
this packet returns -EINPROGRESS in xfrm_input(). At this moment the device
reference in skb is held. Later xfrm_input() will be invoked again to
resume the processing.
If the transform state is still valid it would continue to release the
device reference and there won't be a problem; however if the transform
state is not valid when async resumption happens, the packet will be
dropped while the device reference is still being held.
When the device is deleted for some reason and the reference to this
device is not properly released, the kernel will keep logging like:

unregister_netdevice: waiting for ppp2 to become free. Usage count = 1

The issue is observed when running IPsec traffic over a PPPoE device based
on a bridge interface. By terminating the PPPoE connection on the server
end for multiple times, the PPPoE device on the client side will eventually
get stuck on the above warning message.

This patch will check the async mode first and continue to release device
reference in async resumption, before it is dropped due to invalid state.

v2: Do not assign address family from outer_mode in the transform if the
state is invalid

v3: Release device reference in the error path instead of jumping to resume

Fixes: 4ce3dbe397d7b ("xfrm: Fix xfrm_input() to verify state is valid when (encap_type < 0)")
Signed-off-by: Xiaodong Xu <stid.smth@gmail.com>
Reported-by: Bo Chen <chenborfc@163.com>
Tested-by: Bo Chen <chenborfc@163.com>
---
 net/xfrm/xfrm_input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 9b599ed66d97..2c86a2fc3915 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -480,6 +480,9 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			else
 				XFRM_INC_STATS(net,
 					       LINUX_MIB_XFRMINSTATEINVALID);
+
+			if (encap_type == -1)
+				dev_put(skb->dev);
 			goto drop;
 		}
 
-- 
2.24.0

