Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D47248EE0
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgHRTo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbgHRTo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:28 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B3B5C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y13so12830510plr.1
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YrXNuJTONk5BCI0nG5/yThoiPSPAH2FycFlnQuLaGqQ=;
        b=rV92R3CP9Rz6w+EIWEBcRKuXT4F3pMtyDnh3NYyh+a48EoZxKEtqv8/lkW81PGfkwZ
         bHh3BjmbH2ltbeDvxlXAkEuNds4t5lQYqtGhXAQSHZ2a3U10FYIQ5xjA5r/D6ZdSiugC
         iRSFSWqwvhS9g4qd5cO5tvjSiTj3CowMFczBdb1QEwyXjEvsb+c6ScWsTzYqN07+bR8N
         GEzU57hPlFZBmY6aInP/wdT23eGHxea/4lqs4mD0ZiCSHmVJX1VPm2a0F70NSDI9s2ad
         jOuViq35afA/qlprWThl+uXjKysrUrgAhbI2yXeyMQQsF/Bb+GpFqBtNm3+qVMewm6LA
         NXxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YrXNuJTONk5BCI0nG5/yThoiPSPAH2FycFlnQuLaGqQ=;
        b=iPF9Wg1fR31n+c+Y1MiPac6+ScDh+W8GZ+LDl3tTBdzoD7itjRtxa4IeW4ThgJTo1/
         SYgRR2Dk2RXusQP/PCVyE9KR/EXcsDJ7RHzgzPmFkTOviYu7M+iT2D9+qlNyHTD9Z2eZ
         YdgwcOM68vUCG5SdwUMkL5ZtgGr9JPUTRx0/qTod8hZW9DcB8lD2d2rb6pWQFihFAqMm
         1l13+Iwzm262L6lKpBPHPCRHypadkQepALWLWg+4WnXYQlSVKgnB9yoa3Kdko47JHo2u
         tulXoRZiayLQMcLtaLMm1W0dzzIfxfvuXCDiyVBnPen3+7/mCP2gGZQ0/g9eM6gaM8O/
         nSBw==
X-Gm-Message-State: AOAM530wT63au28mhxI/rN6mM898To5zm/C0wk5110xuTi3cpVNRgiDl
        vrZxPxsE9TiJpWI27z7H28Ney867DLmVrJQaj+ckoy9fNV1AVcLuvyxAPgw27AFZdeiph0uItCO
        ykCcujAMjNOAlhMz2xWXrEPqsB1sDSZDdJmAI5y9RdYzRdYcAq1aWB7yVNiKoNMg6CU2Gb7nO
X-Google-Smtp-Source: ABdhPJzynsyfSk6v46kqj/3TZWzbtNcRRZjmZC9cMQse1hEYI1xn3K+l1/m2USiT01gVl1waE8vRfniYPyWD/oQE
X-Received: by 2002:a17:90b:208:: with SMTP id fy8mr1136748pjb.131.1597779866394;
 Tue, 18 Aug 2020 12:44:26 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:00 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-2-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 01/18] gve: Get and set Rx copybreak via ethtool
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
index d8fa816f4473..469d3332bcd6 100644
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
+		return -EINVAL;
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
+		return -EINVAL;
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
2.28.0.220.ged08abb693-goog

