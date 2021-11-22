Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A99045913F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbhKVP1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbhKVP1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:23 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6C0C061574;
        Mon, 22 Nov 2021 07:24:16 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id w1so78683905edc.6;
        Mon, 22 Nov 2021 07:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G9Oeu4w7CCeJEHsV63ctLhXs9xoEWLbalzVGTnjwJRY=;
        b=BzBsM6myq9+DSFrVrmZjiSj8dS1+eX420x/y8NSH7y5stCkxZljATqBPBc18qtqKHg
         Smam3ZpNWtfHWgK4LP11W73L6ALHRS1lB/4ZxH3KMMUAfBNfJg2PyypF/DiltIN8h+Y/
         QXgIqfEv20rMVkfHU2ItfCZpK1YWnw/mqg9NiHb0x65S+vp9X0sbrL9WL0uXc+ZSnkJe
         eovDdgSCfjD8hHtXbPbgvnAiDO1V0Y5zypd0sjLcDPXwDWvV1bKmGwaarX3itAKI19wl
         ftTDqjPdnTGyguvv2YBJ5TM+W3gIz8YrgzSPIkJzEjsr2KcloKnvuxOzyPSSUKmOxTla
         G0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G9Oeu4w7CCeJEHsV63ctLhXs9xoEWLbalzVGTnjwJRY=;
        b=3XxuQmycXBdYuKzBpCj6MLtVlphjiIrPHjhXcKNumoyDjTTpEHZNi028ZhaweDA/bI
         1McjeXe8DEAaODxP0i1GIavd/dMD0h0qxkcWHvBQH/lgNEhR9+79Z4F+mNsqsYdIMGML
         5maE+jFYeUbz+pI0IQeh2bCPz+0m1/7aiiyjo3ND0O8Z165ikPpEnDPreSRKtgkIFbUy
         XF3UhQPvFEExFvn/QBAKIr6A7CKjDp7PZ3G/djUHoIJbk/D9/LEFq3DFOTbFJH05lmiC
         yWNMMMn0dHEn6peMINOoZLNdsEl9NAs9NxRFnRQEnE7RTE+QXGF/CyEyJXCC6H04cMj/
         qQhQ==
X-Gm-Message-State: AOAM532x6hNBdJ9od9FkWhBd/CWOkXU+hMvouA3rFw/V+JXZ1WgTLslo
        27++aic3qWYQb+Mzb3oACNGJf0XRF4Q=
X-Google-Smtp-Source: ABdhPJwqeiLcgrMPrb4m8bvf8kFi5CkHX2bBAadZZkACWV5SKFv29b46pNSKMAK/FfLQsrwDLBjecQ==
X-Received: by 2002:a17:906:7310:: with SMTP id di16mr40417552ejc.92.1637594653175;
        Mon, 22 Nov 2021 07:24:13 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:12 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [net-next PATCH v3 1/9] net: dsa: qca8k: remove redundant check in parse_port_config
Date:   Mon, 22 Nov 2021 16:23:40 +0100
Message-Id: <20211122152348.6634-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The very next check for port 0 and 6 already makes sure we don't go out
of bounds with the ports_config delay table.
Remove the redundant check.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a429c9750add..bfffc1fb7016 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -983,7 +983,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 	u32 delay;
 
 	/* We have 2 CPU port. Check them */
-	for (port = 0; port < QCA8K_NUM_PORTS && cpu_port_index < QCA8K_NUM_CPU_PORTS; port++) {
+	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
 		/* Skip every other port */
 		if (port != 0 && port != 6)
 			continue;
-- 
2.32.0

