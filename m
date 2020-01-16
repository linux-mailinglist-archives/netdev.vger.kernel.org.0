Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679E213F045
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395477AbgAPSTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:19:47 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33469 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395464AbgAPSTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 13:19:43 -0500
Received: by mail-wr1-f67.google.com with SMTP id b6so20205144wrq.0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 10:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iEG5nDterd5xVIKTUIokYoFGLbHhB+7NE7s1/y1cDo0=;
        b=K9riOl4PskHRC87P6qaVBgdIT10USn9mFOUbZUa7Cu2byhSFfu3WSLsDduor7AbCo0
         MKnG9WHZ6dUgelNe8pTs0O8D8iaxLY48t6/lDZidqVONuFVUXGjRE/OXhYr6djt6KPje
         3tgEYQMsvSfYAhld3hu7JM5dorYQmQPPYGsYgCk6BjvepwtYC3MKsfABTalmfWSUZ4dj
         GkIHZmTNIogEofy1oZrYm16SIkSwgXnIb9As93v8GLiWr2lUk2VzzfgMwTiKOdLBc98P
         lpmSYareOSCSJSEyu4bWbZuUQT7wN1e9mKJj9uP0086Rx7yeio6kXAAWbUQTULFh9+j+
         vdtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iEG5nDterd5xVIKTUIokYoFGLbHhB+7NE7s1/y1cDo0=;
        b=CnkKyZYcwWTJMK22fzKjFfBtY4nB4lAuMX17RapRCfRN4hrb6kwVZP77fhSh+YQdQz
         ipzZQRy76EyvF0z6Cut5QTNU8RP7Z47V4FU/pA6VOi9lmIaIH5OwX8JoJSXinnx8MT27
         1AMBGveu+Hphx/IHCVGflsG3763tVzSOBKkzA995I7m1Cs0byOB8G+vqUsOz/i0svmwF
         BKLyYst6Yfi1Csg3TYDlbjHShKZDDOrSFsN6o1d8n0t+FvasaF0JbUuuVFLPeLPoTja+
         EtL9MWAtxMGY+u3xpSlB9w30UlEeucQZgybFjOmq/DY0JvdZWmbCM3tfJXaZexD6v0+B
         Zi0Q==
X-Gm-Message-State: APjAAAUj4aiV32SRfc/CNcm3H24DBPXleewLkMPO9V4cOgbqwgEn0nf7
        qcDUEhCACr9sccTUvGNYBUM=
X-Google-Smtp-Source: APXvYqzw3DnCDkbyKbZWLewEuReEufrxmr3czDA7ou7aBw10C+1pswzyb9v0UFHprF9Wwa+fovFw9g==
X-Received: by 2002:a5d:6b47:: with SMTP id x7mr4692811wrw.277.1579198781336;
        Thu, 16 Jan 2020 10:19:41 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id g25sm1038148wmh.3.2020.01.16.10.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 10:19:40 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 2/2] net: dsa: felix: Allow PHY to AN 10/100/1000 with 2500 serdes link
Date:   Thu, 16 Jan 2020 20:19:33 +0200
Message-Id: <20200116181933.32765-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200116181933.32765-1-olteanv@gmail.com>
References: <20200116181933.32765-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Marginean <alexandru.marginean@nxp.com>

If the serdes link is set to 2500 using interfce type 2500base-X, lower
link speeds over on the line side should still be supported.
Rate adaptation is done out of band, in our case using AQR PHYs this is
done using flow control.

Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 46334436a8fe..8108aaef96f8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -172,11 +172,10 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, Pause);
 	phylink_set(mask, Asym_Pause);
-	if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
-		phylink_set(mask, 10baseT_Full);
-		phylink_set(mask, 100baseT_Full);
-		phylink_set(mask, 1000baseT_Full);
-	}
+	phylink_set(mask, 10baseT_Full);
+	phylink_set(mask, 100baseT_Full);
+	phylink_set(mask, 1000baseT_Full);
+
 	/* The internal ports that run at 2.5G are overclocked GMII */
 	if (state->interface == PHY_INTERFACE_MODE_GMII ||
 	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
-- 
2.17.1

