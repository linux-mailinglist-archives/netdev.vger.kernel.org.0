Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896123ED1B1
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbhHPKMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhHPKMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 06:12:19 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182F9C061764
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:48 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v2so15156047edq.10
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 03:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hom66D7QlF74ZChwS4t+afVi3WhkjTNJBXj7NjSNFVM=;
        b=tzWe0JAh41Gch5AiXUler1lJGHcqpdBUfWCEMcGGoBuvpGARlOm/fBp4GAqpPZr/eg
         /v2jlAxpf4/MDN2h3VP8hyxcd76IvPO8N2VDN+JgQ3qg0xKxraMsW6v0VrIrxEOClZ8a
         nEffjvCvE2bsllavHYmQd1SPwBRHushTPBFjxy3vRyWhv48f8+xx/apSuijmabUtsO1q
         a/1Tt1jyHBRpsXnr5I5bPhh/uYU2JqkQrh8qp0VwurSmfVGPN3tRdTYU39bkgc1El1ip
         RU7F1RPlIBqriUWYGtNhHP0hr49wbmP57GjqDvgCoSdnb84jZ34lWjhMkdaxKlgHwQE3
         ykIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hom66D7QlF74ZChwS4t+afVi3WhkjTNJBXj7NjSNFVM=;
        b=uSId2J+Ylx4mH6adZnL63q/MAJsKmQ92rRElwRavViwFhawxdnK6EwXz61MeDo3nnH
         ggqh2vW33D+z6XMlcGimzHcWErXu/hc3DviQpQ955/YBiA7B2gpTOYJ1TQyKTcGtZWP2
         7fDHw6Id7YVqnZW3bf0qNkIi5Ni3j9dd20pMdSIO9Oz9GJ5fEah8XKRARB7lHeRkN2AO
         H2bq//qAPnEujxUl6AWSfHkab+tjsLUU680pLVH8oRdCbbizrW+w5pQMBpbbnxt/iDn+
         VUqX1WgS+aEYvt9ulomS1tSpEylA5RWvi0byJGIavxgMi39NUa+cu+Qf9s/TJIwcmUyK
         VUmQ==
X-Gm-Message-State: AOAM533Expeym/dSAkl/xUts6QWJIS9v5drgy+nRVcebb7WGGX5Z0M4e
        gz5yiuSWBKqocCSiCo2A5tflw7gyScYcXRl4
X-Google-Smtp-Source: ABdhPJw99vMmXDCLexrjgcOJFxMkdW98wBQ/KdlS/eX4xE1TFTFw04btcQSgI+FBUsmxRIGzKrUGag==
X-Received: by 2002:aa7:d896:: with SMTP id u22mr19052986edq.290.1629108706486;
        Mon, 16 Aug 2021 03:11:46 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id a60sm4673779edf.59.2021.08.16.03.11.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 03:11:46 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 3/3] net: bridge: mcast: account for ipv6 size when dumping querier state
Date:   Mon, 16 Aug 2021 13:11:34 +0300
Message-Id: <20210816101134.577413-4-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210816101134.577413-1-razor@blackwall.org>
References: <20210816101134.577413-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need to account for the IPv6 attributes when dumping querier state.

Fixes: 5e924fe6ccfd ("net: bridge: mcast: dump ipv6 querier state")
Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 76992ddac7e0..e411dd814c58 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -2931,7 +2931,13 @@ size_t br_multicast_querier_state_size(void)
 	return nla_total_size(0) +		/* nest attribute */
 	       nla_total_size(sizeof(__be32)) + /* BRIDGE_QUERIER_IP_ADDRESS */
 	       nla_total_size(sizeof(int)) +    /* BRIDGE_QUERIER_IP_PORT */
-	       nla_total_size_64bit(sizeof(u64)); /* BRIDGE_QUERIER_IP_OTHER_TIMER */
+	       nla_total_size_64bit(sizeof(u64)) + /* BRIDGE_QUERIER_IP_OTHER_TIMER */
+#if IS_ENABLED(CONFIG_IPV6)
+	       nla_total_size(sizeof(struct in6_addr)) + /* BRIDGE_QUERIER_IPV6_ADDRESS */
+	       nla_total_size(sizeof(int)) +		 /* BRIDGE_QUERIER_IPV6_PORT */
+	       nla_total_size_64bit(sizeof(u64)) +	 /* BRIDGE_QUERIER_IPV6_OTHER_TIMER */
+#endif
+	       0;
 }
 
 /* protected by rtnl or rcu */
-- 
2.31.1

