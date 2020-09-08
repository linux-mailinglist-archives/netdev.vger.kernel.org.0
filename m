Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3404261AC8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbgIHSkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:40:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731592AbgIHSjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 14:39:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5B9C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 11:39:16 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 129so16477937ybn.15
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 11:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=dkWUm4Z0tPUdm1BlajKFR9QJuD0pRExfBk1ntYkPfzE=;
        b=A2e1TcWKCEhIjeNfrGhmTGCl3KOZZvCVhRZu+HD+XUL28XMZ7Xsb3TL+ebnZL8erYP
         cyNntMLsN963n7+j1GXYPPdv0/zrwgBdptYYGzSWtXCIcQ2waK3OgGpjc0AuNi7LfMRZ
         MyW0z/E8x6JPx6krRPG6UOxodC2WXXRSPAVGpP6fPHrNEFXJu/pHw/LZn3adYjFtSEx6
         QJLhBUusXT+kKtCAkom6S8i7mAoFoRDvPVnbRhMV35ZfX8U9zV3V/+m1TTpz8Eqaglyl
         +MErsW9aGUr1Ud8QqWUzKwFdj8HhxoP9zfcarQ83Pv90A/2Cmwu+1e2d/Q/9i5oCEYo0
         X1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dkWUm4Z0tPUdm1BlajKFR9QJuD0pRExfBk1ntYkPfzE=;
        b=O2gY8KL5/qYNgoc/2LJcEZCopDmrEx+YsXRockd3nAS6HlZhAvTJm84KlJYkU4zDcn
         aj1o7fQexYzAEBnuScGNfR+BqhLqVKzGJVYyCCHgg0Vsq0yYFOOJDT6xMlZx4o9GbPEM
         Fg7hO93DQcG6Z//UiiYeZj0Ly0U1SbbROhw8qB1F1VmZ03aqtmJmNOvrZIB9Lp9jQIcX
         MKMhAasKhc3s13q00/XJM6GVdPyP5fpABFwNxsgF9bLYolbxKXmJFo6PJhuIXZRL8G6S
         jO5p+j1MS6wRZlSlB9G+NetYuhs6038SJ5n8NiZVQkdW9r5smiCnAcpK10HDPlSRI6Dm
         6M3g==
X-Gm-Message-State: AOAM533Ydd0h4wZEe+LgKGWzYFy6FznkuXOObPYoARkzm5IeFGZ4Kk9e
        C9mi7hqWa4Gs9UIAoLWsGtzAHnT3x37WBHUDQ1vEIWBEWMIMiab6UuIDHaSMRo4zSyqQFcUClnV
        gR/73LIzK4WHkgT4JZamtkjs1KFJxjQTaN2GsjGEdtQwSzG5D4zCspkE3HbZ5G+yo98DOXEGv
X-Google-Smtp-Source: ABdhPJyqi0MIinSbuv8i0p6umna0XmFg564ymQFRNit3Ng2/6/svO8EF6KRebyzeD2WdrW0Eejvkz4ZkSmH60CVc
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a05:6902:50a:: with SMTP id
 x10mr256265ybs.397.1599590355088; Tue, 08 Sep 2020 11:39:15 -0700 (PDT)
Date:   Tue,  8 Sep 2020 11:39:01 -0700
In-Reply-To: <20200908183909.4156744-1-awogbemila@google.com>
Message-Id: <20200908183909.4156744-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20200908183909.4156744-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH net-next v3 1/9] gve: Get and set Rx copybreak via ethtool
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Kuo Zhao <kuozhao@google.com>, Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuo Zhao <kuozhao@google.com>

This adds support for getting and setting the RX copybreak
value via ethtool.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Kuo Zhao <kuozhao@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve_ethtool.c | 34 +++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index d8fa816f4473..1a80d38e66ec 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -230,6 +230,38 @@ static int gve_user_reset(struct net_device *netdev, u32 *flags)
 	return -EOPNOTSUPP;
 }
 
+static int gve_get_tunable(struct net_device *netdev,
+			   const struct ethtool_tunable *etuna, void *value)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+
+	switch (etuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		*(u32 *)value = priv->rx_copybreak;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int gve_set_tunable(struct net_device *netdev,
+			   const struct ethtool_tunable *etuna, const void *value)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	u32 len;
+
+	switch (etuna->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		len = *(u32 *)value;
+		if (len > PAGE_SIZE / 2)
+			return -EINVAL;
+		priv->rx_copybreak = len;
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 const struct ethtool_ops gve_ethtool_ops = {
 	.get_drvinfo = gve_get_drvinfo,
 	.get_strings = gve_get_strings,
@@ -242,4 +274,6 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = gve_get_ringparam,
 	.reset = gve_user_reset,
+	.get_tunable = gve_get_tunable,
+	.set_tunable = gve_set_tunable,
 };
-- 
2.28.0.526.ge36021eeef-goog

