Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F57226672E
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgIKRjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgIKRi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:38:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7F9C061757
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:38:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g18so6547447pgl.10
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=gwz7yPhZCJpnHNY0LFwoLvBORHNmh+HYZR3EaauGY8w=;
        b=Ul6il7tiy5aJXut6xnT3uESAo3bbZCg54sWKR0/AEKhkmgUnD11GeA0K5QrMkI7CZ9
         l5RNHfj8b4tHuMNIKePLE1USJ/nW15/0LaXCruPq8JnDpSNzT/kamPluIzHj/K6d3mv/
         cxS9585H1g518285DoiWxNssMsmFDKmxaoqoA83fFEXTKbtvwt1PrgUyHhMGSrg++qBi
         8fLGkSeMvqpzV4uxi0fJzjNJmRpXeMDhtnIKHsoSScGUuPBBrX7mpG0bWpbCBaX/gaBB
         eCo+0kdQ7DS+/io+bQSx13PY8dqvm1RKjFOfhXa25BL7VNG9dEY5+L+n602QdNhSKUe8
         crpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gwz7yPhZCJpnHNY0LFwoLvBORHNmh+HYZR3EaauGY8w=;
        b=RuLHvPbKu8V7/ciN5ZfRqqwHqzfLaYvsIC5H8VBbtju40lGRbN9UTAFhgtsyAfLEof
         eKTvpnCDvS2oVyUZPG5bSYnpSod30Awc2wEb+KEH9lX5mvCd5DZDj2W6fKcE4e1YS+tr
         VbqeWDy79qtQHFMBuDMi2g3Q8QMms4D7vXPdUGnKbBTFtK/0TZvu8sx4VJXKQM0Z3Yqj
         6JvP9D/+zrFwLIPI0OKPDVAMcSJ9pmV19D6sPPUaodk9JrqtMAXbDN/0mznZys83yWCX
         VvL60NEIZ5woVwqgWBPAlLiK1Da3j6877eSEnWQRmEiZUh1CbVHvP1pWIJnSJwW5EPAq
         tPoA==
X-Gm-Message-State: AOAM530/S6VbSRlAZHr122COyLnTE85eaKvYZ67VJuEy/bPgOxmxQ6aR
        qkatCfZS7mL461ha9DMkPpOp+kV/UnzfrplgKO60gifTRWiFQN2WYmSv7DFEcA8cdPJAG2V6Hqd
        BIfojDEPsPCvHAL/rFvZ8NNcgYwxA0mhZ6Gh69+k8nuqBc0ZTpfPVAOL7jpwVu6sQKxqIQJPM
X-Google-Smtp-Source: ABdhPJwKQDbU5knfUxGnnQELZqlfPWz8ejNQzHYLieSJ0H0sW1yZlvvxSKzw1USC0AwBOlEH6L7SN+x2fjW64Nib
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:a605:b029:d0:cbe1:e714 with
 SMTP id u5-20020a170902a605b02900d0cbe1e714mr3324635plq.34.1599845936378;
 Fri, 11 Sep 2020 10:38:56 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:44 -0700
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
Message-Id: <20200911173851.2149095-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20200911173851.2149095-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 1/8] gve: Get and set Rx copybreak via ethtool
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
2.28.0.618.gf4bc123cb7-goog

