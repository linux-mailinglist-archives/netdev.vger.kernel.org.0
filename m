Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A922074FB
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391183AbgFXNzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 09:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389484AbgFXNzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 09:55:38 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4CEC0613ED
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:37 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id ga4so2512543ejb.11
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 06:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qtHmRs4fasylpJgy8RhVQIbNd6xEHvBLp01N4e1kqoY=;
        b=UV9YBI0P3+nNJS4oGeTWDmg7+xIrlWouUZKGeGyZCv+ppKkKDIA/DvpXWpwYAK9wnN
         GrSy0mCpDMYjI2IM62XlJT5vDSFna9OxPlyP+i0RCGj7Cgo3c8EdPO/QXzTShosofNov
         mnYLoPSAHy9vFLYLEAND27QInVZmXQUICmnrn31zUusWX+JX2Cb/BIIX8A8VQTSM6MAz
         8+7OhcEi72FTzqR08+otgbbswaKn9HuObzzl+C2M3TcLyHh8V43hElVHqDYb5uiT6HFx
         VXrGMfWbYFWG6ZTXgLNv4NvNdsay6F7u6q0+Ravdkt9OuVQDaymBMGNJYPYNj+xfDw9R
         YvIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qtHmRs4fasylpJgy8RhVQIbNd6xEHvBLp01N4e1kqoY=;
        b=kTvmCdZSbxNeALoA35A8i/wbWq9xx2S0lIGKDVQ9tajqS8Ka/7m6j27laZCrtoDP0/
         laE/VyOl/9NJBFUTibRVyh49H4YxWc6v2TAzqPUeW1yBZy7iQaaTyO3OL87Ctgx2lhrY
         VYnQ70tVKL/PZSry21N99UVotpQUtDlPaA1oKzqENxkGmzbmkLeaZxGHSF3GsPVu5Fvz
         bPLH5En8ei0RUgL/7F9Ziz9hVq6CEIFs3RG3iszuhKNvCLdfoEyvbyIvlKybJRluUtxX
         29vJnW4Vu1cwcbQ0A9T9LcZzrFVREIQvfiI3QwERwBhENFbDnpcCLINTcPvSg4bgtb6q
         4BHA==
X-Gm-Message-State: AOAM532Z5xQtv4DJ8SGQc040kwHPzpflnoBh+U7H0W2ZAFDLsaUsmpEF
        3i/RpnFcfoRefIeJXqMT1JnePMWD
X-Google-Smtp-Source: ABdhPJyTfdlSHOJuzYvxZMiSkZyc7Wt7a+r6VTaCNzyEozr8cX0qprzoqbpjr3+aItmFiTtgFl8TxQ==
X-Received: by 2002:a17:906:1c05:: with SMTP id k5mr7730571ejg.320.1593006936442;
        Wed, 24 Jun 2020 06:55:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id j5sm17756649edk.53.2020.06.24.06.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 06:55:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        po.liu@nxp.com, xiaoliang.yang_1@nxp.com, kuba@kernel.org
Subject: [PATCH net 4/4] net: dsa: sja1105: fix tc-gate schedule with single element
Date:   Wed, 24 Jun 2020 16:54:47 +0300
Message-Id: <20200624135447.3261002-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624135447.3261002-1-olteanv@gmail.com>
References: <20200624135447.3261002-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The sja1105_gating_cfg_time_to_interval function does this, as per the
comments:

/* The gate entries contain absolute times in their e->interval field. Convert
 * that to proper intervals (i.e. "0, 5, 10, 15" to "5, 5, 5, 5").
 */

To perform that task, it iterates over gating_cfg->entries, at each step
updating the interval of the _previous_ entry. So one interval remains
to be updated at the end of the loop: the last one (since it isn't
"prev" for anyone else).

But there was an erroneous check, that the last element's interval
should not be updated if it's also the only element. I'm not quite sure
why that check was there, but it's clearly incorrect, as a tc-gate
schedule with a single element would get an e->interval of zero,
regardless of the duration requested by the user. The switch wouldn't
even consider this configuration as valid: it will just drop all traffic
that matches the rule.

Fixes: 834f8933d5dd ("net: dsa: sja1105: implement tc-gate using time-triggered virtual links")
Reported-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index 8524e15fdc4f..ffc4042b4502 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -75,8 +75,7 @@ sja1105_gating_cfg_time_to_interval(struct sja1105_gating_config *gating_cfg,
 	}
 	last_e = list_last_entry(&gating_cfg->entries,
 				 struct sja1105_gate_entry, list);
-	if (last_e->list.prev != &gating_cfg->entries)
-		last_e->interval = cycle_time - last_e->interval;
+	last_e->interval = cycle_time - last_e->interval;
 }
 
 static void sja1105_free_gating_config(struct sja1105_gating_config *gating_cfg)
-- 
2.25.1

