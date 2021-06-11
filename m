Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B233A4916
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhFKTEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:04:45 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:46700 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbhFKTEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:04:43 -0400
Received: by mail-ej1-f46.google.com with SMTP id he7so5965671ejc.13
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jn3EImVRxWyaYVvh92Ahskv7sahljZi63Smtg7XTVHk=;
        b=bTEUoFx/wCrKm2Gl4XxtM+3Ag5fFBKhe/K6oi8JKDt1gD6ot9VMK0qTZGyJjm8pfyh
         sz333XDsnYRylgWTe/Zsw2MHZFYTP1c8Ukghx0acOwS8vN5TSFJ0CmdFY9gw0+B60qxS
         WQlRUzHAGrlYyyIeWQOVNTz1E+B6C60bzG6EkzscWs8bf72vbB82xYGHxOhTOcMKyDz7
         6Cd0jcc0hLetLzsJgvFflq8VovaZMP5LqwQXFn/XpOkjqwGeR1ElzTIIHqdw/fQDwCZA
         KaY75Tn04jYE3XSIzD1l0qJccIxszb5f356PNG99VSmSxIG9XtdAx6qtEPiAVpsHmiuj
         7kIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jn3EImVRxWyaYVvh92Ahskv7sahljZi63Smtg7XTVHk=;
        b=i4srKFEMzAUGb/qZ5or4KK5Rn76segu5DlCsvCylM//i/OyJrWvdGs4JuP4KtHN+vy
         OY+H6arnCsiD3ieCxv+hiczNnCT4vbg8efCELIlJYAP01ffTQph6qHypwQ1fZ+mpffO3
         xxtbHQAbZ5590lcrFKAh0WsO9crZk1xPLZaY2vaLYRRsIIKmd/RotxF1j2k0CSzp4paC
         sFrpXjRrLyRzoPDQffDraqcJ2XUiCxtctu2IL75GvkCj0BkWv7T+uH5g6Rv9TQ7ioxlW
         WAplSn+13A2ZhOR+VtkcTaSFbGCd5lY3LC5t6NgclT0qtp3J5/rCA5OOmqziUFn5ncsN
         jwaw==
X-Gm-Message-State: AOAM531FL+hJvs0AQqRtJGyqT0sFTb+ktRh83ezfomMDMYZ+ihM8hudl
        Ah/oXOk8o4KFve3vIQjra8s=
X-Google-Smtp-Source: ABdhPJwlbdNx/Z+7K844KY1lqRrKG11edf4al88dNRW8YkEInQ9425xVLESjvM0mbuGGCRpdIc5Vdw==
X-Received: by 2002:a17:906:fcbb:: with SMTP id qw27mr4890733ejb.478.1623438104829;
        Fri, 11 Jun 2021 12:01:44 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 01/10] net: dsa: sja1105: enable the TTEthernet engine on SJA1110
Date:   Fri, 11 Jun 2021 22:01:22 +0300
Message-Id: <20210611190131.2362911-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

As opposed to SJA1105 where there are parts with TTEthernet and parts
without, in SJA1110 all parts support it, but it must be enabled in the
static config. So enable it unconditionally. We use it for the tc-taprio
and tc-gate offload.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/dsa/sja1105/sja1105_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3b031864ad74..de132a7a4a7a 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -673,6 +673,8 @@ static int sja1105_init_general_params(struct sja1105_private *priv)
 		 */
 		.tpid = ETH_P_SJA1105,
 		.tpid2 = ETH_P_SJA1105,
+		/* Enable the TTEthernet engine on SJA1110 */
+		.tte_en = true,
 	};
 	struct dsa_switch *ds = priv->ds;
 	struct sja1105_table *table;
-- 
2.25.1

