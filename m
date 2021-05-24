Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B6F38E739
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 15:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhEXNQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 09:16:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbhEXNQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 09:16:19 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327DEC061756
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id a25so31890266edr.12
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 06:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MUTbtxOtQ/6z77dwQCG2+h1G+nVZENByOptkDcJd1rA=;
        b=lYrCWXbWHF4cW9LtgpxJx9cI0SsrYtXIHdou6AXnliJPzBM83yTRcSuKS5mHIOFxFV
         1Z6RxFdGG5aUaEJ61lDgSnurzVTUWnuYu9oRFmBvyS6L4+i/PLiZWOrgrzw5YVpHtlAZ
         jcoO7YRHvZm5LVqqcVq0PQt2FLzWGZl5DQ0WqS0QAtlnkvqzl2eA0P5emxqnJ1RXqM+/
         pXv5eCxjTHS6WBro7nh2fG/zmSN3kuae+jsGUD/dPPez65X2lcewp4gIRj2afIz63hF3
         fpxvEcmkr+eci8kxy8pQK91PMJDfdkmgr0vwfm89/8HFSzT7eoEqwgzj8Zf+MzjFZU/c
         c4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MUTbtxOtQ/6z77dwQCG2+h1G+nVZENByOptkDcJd1rA=;
        b=C8NwHrqJjMKrhBqpMNVBeYpp//FPCMYOV4VeyGJarZ2xKeakw4A2+zZZECh87UtWVr
         l0ijelTtmWq6yuK6gzZGuM9W15zkyLC+6GOlVP+QOUtBeGlh5TS1s/5+FOa81e9VvTpz
         oFBDd7Rz7aRRlj9bspKgrL+el6wbFP0ApuZZhzzJNkQHhkrzcQNh4TSyi1rDV6X788sb
         KsLbZbMWbrlim8ekWN0+Ffsxs8hvUYb2jXBRSwAM4SD5wrizdQ9KPVw4b1Z+Dv6ondVG
         c9oL2/fD9rISXlLXfWmYDCfAZva6LGOvRk5CXde34jSJZ0m/kmUPzKLF7A6TMZFtQrUK
         ROHQ==
X-Gm-Message-State: AOAM532D9aTnSzUDNTodUJVWn6uB7+opqxbsEMW6gg1D2T2qqJdi4ZKt
        pCWcCvIyiXok+7dL1ZlNgoU=
X-Google-Smtp-Source: ABdhPJxuV2ChrHg24j2XlmSj2/tZPTIatVYHFyGpuQnUmUHDPI+Whui4/0NY+OPz87orLLtwkP752Q==
X-Received: by 2002:aa7:d550:: with SMTP id u16mr23821211edr.72.1621862088862;
        Mon, 24 May 2021 06:14:48 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm8009139ejz.24.2021.05.24.06.14.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 06:14:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 8/9] net: dsa: sja1105: configure the multicast policers, if present
Date:   Mon, 24 May 2021 16:14:20 +0300
Message-Id: <20210524131421.1030789-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524131421.1030789-1-olteanv@gmail.com>
References: <20210524131421.1030789-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 policer array is similar in layout with SJA1105, except it
contains one multicast policer per port at the end.

Detect the presence of multicast policers based on the maximum number of
supported L2 Policing Table entries, and make those policers have a
shared index equal to the port's default policer. Letting the user
configure these policers is not supported at the moment.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 937cbdb89686..6850f03be1f3 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -719,12 +719,16 @@ static int sja1105_init_l2_policing(struct sja1105_private *priv)
 
 	/* Setup shared indices for the matchall policers */
 	for (port = 0; port < ds->num_ports; port++) {
+		int mcast = (ds->num_ports * (SJA1105_NUM_TC + 1)) + port;
 		int bcast = (ds->num_ports * SJA1105_NUM_TC) + port;
 
 		for (tc = 0; tc < SJA1105_NUM_TC; tc++)
 			policing[port * SJA1105_NUM_TC + tc].sharindx = port;
 
 		policing[bcast].sharindx = port;
+		/* Only SJA1110 has multicast policers */
+		if (mcast <= table->ops->max_entry_count)
+			policing[mcast].sharindx = port;
 	}
 
 	/* Setup the matchall policer parameters */
-- 
2.25.1

