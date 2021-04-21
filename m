Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07140367182
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243043AbhDURk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243027AbhDURk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 13:40:27 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE26C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 10:39:54 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id i3-20020a4ad3830000b02901ef20f8cae8so2069966oos.11
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 10:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2NIvDL/pnxWG/XSWH6ctMJRwrsiMqVjZJOoDaRoJS8c=;
        b=gOY34zMKpKy19sMBflS95m2MN3RgmXslX4/+ftWEiEVP1DHf+TSCC3zUfL4ROg23v+
         9b3/+vRixP/giuz63hBEzXMciraTCQLIP7sMBwZc+bR/LBhqKDMNQiElzOgwKRSsnHNY
         pHBIt8Jm4t4VOz9NC4qeX8ALH7ClGgjZFNpxCj0ykypTE4fuRxx+3DAKHmUIJ2DZHPjh
         a9IeSzoKfhGotdS/TkbrXIQzwMPmfRn4jHDlOAy0rt+AdslndDxB6DvTjWHd0HzekQ77
         zZh5bUv/SUye4oycQS0cgYTkQs3n+ZRKtvoVtgRZHmmRfoImqqF5XjCYAczktkeYD5HP
         cjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2NIvDL/pnxWG/XSWH6ctMJRwrsiMqVjZJOoDaRoJS8c=;
        b=hol0kwBZbHKhvioYk/s9cKtTPjJ4aLzqn5rOqD2LpVd46KNnp+VKMyS79qkN+zzw4f
         mn5e8bcvyUBsjBgfPz7mAfaEZI4j7LW+HGgjLlaDAdz1CPuVXBmMKspXzLEbrY7YsIGq
         1rrUC8UTApByJPqnreXnzJUtaB8jqvqK6wReHJKSQKi7rIa6mlBwnx9tw9o4/Yre0xSq
         95ZlKuolechROK9wg5qC74Vw/yr2ih6olt1hQMpJE/Sf9U+4Q2aw1OVefC/tPYtSFeSJ
         +1Y40YRJi45o9GxwdCcWh88HXvp44u+R+Tx7fNikG9rzdaDn6igy84uKOB5EudjOqxFN
         0dIA==
X-Gm-Message-State: AOAM532Vmxsl5woZ79ToD0D5mXKvGgesVC9qLMqO7IlOPs5PCePRq9EI
        8EkXhmez7AwpkGHgyNb+Lrt67tNxqX2F8Q==
X-Google-Smtp-Source: ABdhPJx8BGLlHmozMfXwtB99k0C+w4yPut6QtEKNm6JL+RYogkPpgrqX1bIqExM1XjlhrOA9ZvY7nQ==
X-Received: by 2002:a4a:dc11:: with SMTP id p17mr21288861oov.50.1619026793532;
        Wed, 21 Apr 2021 10:39:53 -0700 (PDT)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id q130sm595947oif.40.2021.04.21.10.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 10:39:53 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: qrtr: Avoid potential use after free in MHI send
Date:   Wed, 21 Apr 2021 10:40:07 -0700
Message-Id: <20210421174007.2954194-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that the MHI ul_callback will be invoked immediately
following the queueing of the skb for transmission, leading to the
callback decrementing the refcount of the associated sk and freeing the
skb.

As such the dereference of skb and the increment of the sk refcount must
happen before the skb is queued, to avoid the skb to be used after free
and potentially the sk to drop its last refcount..

Fixes: 6e728f321393 ("net: qrtr: Add MHI transport layer")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---
 net/qrtr/mhi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/qrtr/mhi.c b/net/qrtr/mhi.c
index 2bf2b1943e61..fa611678af05 100644
--- a/net/qrtr/mhi.c
+++ b/net/qrtr/mhi.c
@@ -50,6 +50,9 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	struct qrtr_mhi_dev *qdev = container_of(ep, struct qrtr_mhi_dev, ep);
 	int rc;
 
+	if (skb->sk)
+		sock_hold(skb->sk);
+
 	rc = skb_linearize(skb);
 	if (rc)
 		goto free_skb;
@@ -59,12 +62,11 @@ static int qcom_mhi_qrtr_send(struct qrtr_endpoint *ep, struct sk_buff *skb)
 	if (rc)
 		goto free_skb;
 
-	if (skb->sk)
-		sock_hold(skb->sk);
-
 	return rc;
 
 free_skb:
+	if (skb->sk)
+		sock_put(skb->sk);
 	kfree_skb(skb);
 
 	return rc;
-- 
2.29.2

