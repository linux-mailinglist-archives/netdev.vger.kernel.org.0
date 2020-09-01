Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7CF25A0FC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgIAVwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727833AbgIAVwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E88DC061245
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x10so2663955ybj.19
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=YBDBTYJyAAyHSIMfe7u64IQoZsgba0wVm0w4On0MyKI=;
        b=hB3MqYsBs7cw/1Ipshxwo2lyNYatyRkdhq/cgNhag9zfjGsHTfzQVndgM7pF/RHhE7
         BZ/yHS19zCQJ8hXCk6m6mfl55T/GQClu56RJtzi+y5l3i6rEjeV8+8lh84iWXcvo1YaZ
         RYhxvYyFYogxqRAmlIbzpR9u3XNK0bqGRZ4B0ikukCzQ2sbxrzulflng/KZq7ioDycZM
         xfdYd97akpmbmWkPAm1jIJ7cY/GMyWOZvh7HJzlsdDxvsQ1ls1NAf9g+XT+pl4nTQgzd
         UKI1fryC51bRCA5l9FSRjbVDDZCx18N6LxtbF9TMrQlQ7dc+enad15zwqKYX5PddhIf1
         YUkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YBDBTYJyAAyHSIMfe7u64IQoZsgba0wVm0w4On0MyKI=;
        b=pGtMd91MSO2zD6pAf6ESQFnpSc+1GtkdQZAKxMWLAAJadv1Ru3We7ZWyyJk4CZAqQN
         0xgALGT8yjjOJ6O080mQAFuZLuwyZTSJ2Wng/KGpJGAQ2araqlM+LZuEynZpSeX2tku/
         Jqji+mD79FjnCnwyw4tIVzC8Juc3zM597+9CIeYNDYMN6Xlp+2lM4mqJL4hS0ooYKU+i
         Fv0+48MX0xV3KcBgrZrh7KIOnJrOKt6uPOTud0EMV7/JenbIvNN2wY+wSeOCml9LBph9
         xgkhDbJQ0PvJvpdMPrk8JL1T6mb/4yAkbUL1FJPmeGoOlsmAMS/AuDUGxf5c2CIWoFij
         vkkQ==
X-Gm-Message-State: AOAM533cEEzQhg+Aj3N7dMNpdBgmihJBE9/DjzfrrQFJWwe7NSkQ7Trn
        kGyPbTc9/Iu8ZcvQgmoJM1W5mMA+mFF9edDpumeQkEfgpobZOsI8nPFOdF3CgsN9+cFmPt9dD0+
        uxScZLkn8bwwSj1XUKDLYtioH+WZ3TCauO3GPKi8aFj9vmEt7H9r0O8cJk/+nhOOmkuS0DQQX
X-Google-Smtp-Source: ABdhPJyf4yi7uQ4xUkuRMAoPEU+A59shwoVs9toIGPiSMbCERQemo5tki7J0Ngsh5KLxzvjL/+rlOiWnaFF18jxv
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:5755:: with SMTP id
 l82mr6008189ybb.175.1598997118828; Tue, 01 Sep 2020 14:51:58 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:41 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 1/9] gve: Get and set Rx copybreak via ethtool
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
2.28.0.402.g5ffc5be6b7-goog

