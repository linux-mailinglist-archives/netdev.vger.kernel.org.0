Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C599454EFF
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240893AbhKQVJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240730AbhKQVIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:31 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54AC1C0613B9;
        Wed, 17 Nov 2021 13:05:32 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id r11so16915280edd.9;
        Wed, 17 Nov 2021 13:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UCSM6+D8ualFSitAGjm+mGVCLlZHTQ0xZ95gau5bkyA=;
        b=PRHZ6dN9XlRRqWlmuGc15k9QvpDTsHu4ihHGtka5zvywAq8QN0YDAu0fWzmy6Ov31A
         qwyc7rc8mqU/JFd2z3QjETxof8Eshr9xOmVKkKo5kQ1DKTP8aiJAcJxTi/kqmIfqjVBg
         4nAl3RoejW9JJtbmRqm0FRHuUxxhUWV20J5dIZuNcqc5vRlY/9He+8lT9lA0HeMLuO8Q
         XYVzmZ5rGHIncVDvhePPdiuBjJkzG19tBAN/dnD3xfvVL0oxecGr1oDWAOxN1uXWJojH
         jDSbudJx8uJRVcFxmouzw6IaBg94KxIwiRAHHBHfwaZnCpuIToBqPOHt073iG8jpD4wj
         7/yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UCSM6+D8ualFSitAGjm+mGVCLlZHTQ0xZ95gau5bkyA=;
        b=EuEtEYp29db2GKqtfRN0ikMyOC2LXIG4aTCx0/RFVhTlSbv2u80Ff4ZaNpcE2el5r4
         jt29s4p8h16OQyiOb5B2/EgGUN2WrzAq7b9/OrQ4BTWntAad33SIKFoSK75mpFbL/bYt
         Er5JMZAnxVG0ySY2e5f8Dw+Ku/tfs5nGuGFig11ylAMcHuaXgKyelqYAYlDdBbHOXvkf
         nJuuxrHqyy9oSjgTowCsK23oD07ZOoEPOFCjK+SvDG75IjJ2siwVWW7EJQSAGkrFF3xC
         dFcIa+EjM5twd+oa3Kw3cSfDJu/nD/mG066oj4KfCZiRDVcaNAb4D+SExHpMkxyldAIQ
         t7Pg==
X-Gm-Message-State: AOAM533AE/y2INqNc6hGeXt/oNBJx8QLxwt9tgzRkgQUKZmdtVMGTpMN
        fuDjZsmuTCcPfD6Jy6HKn24=
X-Google-Smtp-Source: ABdhPJyzmQEPjXZo8Fj5SxEpMSg1eqhAY3MOl9hJp/U/H0Tj2/fSgisxbf39d8mlQZ9C1f8c1Dr4kg==
X-Received: by 2002:a17:906:5653:: with SMTP id v19mr25744014ejr.360.1637183130841;
        Wed, 17 Nov 2021 13:05:30 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:30 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 13/19] net: dsa: qca8k: add min/max ageing time
Date:   Wed, 17 Nov 2021 22:04:45 +0100
Message-Id: <20211117210451.26415-14-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add min and max ageing value for qca8k switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 50f19549b97d..dda99263fe8c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1291,6 +1291,10 @@ qca8k_setup(struct dsa_switch *ds)
 	/* We don't have interrupts for link changes, so we need to poll */
 	ds->pcs_poll = true;
 
+	/* Set min a max ageing value supported */
+	ds->ageing_time_min = 7000;
+	ds->ageing_time_max = 458745000;
+
 	return 0;
 }
 
-- 
2.32.0

