Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F921E90FA
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgE3Lwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 07:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728989AbgE3Lw1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 07:52:27 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3F0C08C5D1
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:27 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id n24so4708663ejd.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 04:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1OjqTFedoPpvY5fbZv+fAEsftZgTzh1DekeK6w9Deg=;
        b=gYIXnL1k+pNhOIFmR4zBR1ZYPhHpKo0upsbug+CV07MdYFoJP8IlLl1nH6+1jNCbCF
         ozUc/tpSeW3wd8u6BzPz6Pn8N2yJXijR5pXPujMRMi3wuWrS4CnWmU3Q6IWGNmx9dhBL
         cEe7YWxEcc8wa9DXEYfl9QqkVoH8E857H4XuLrbhc8bCfdWKwpJyukdnc8/CBPFnQ8Ga
         EkiUH/cX2btDnzyWIuqgNgKJOH4F2ETJM1CVPkhJNdwJsyjTsH0GgGYlWQZ8BhidZyuz
         dRnAD8TTjOxsrw+cFjIrjC9G6rn3/PZJiYHma/vIfUnP2AJOrl/6TUyssIxDKiMNcnpi
         ezcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1OjqTFedoPpvY5fbZv+fAEsftZgTzh1DekeK6w9Deg=;
        b=dQftem6W9hW6DsxOobwtznCaQnYmuhZiZeuPH/WBsE8mHL0oUo+1qGiSdGbXhysCh/
         SifJeQ2s1ttq7RTMqQguxp2ErkOFhAFZ3MbhVuCTkuRHWNaA9y77d2RtvP+ULrEFLr+B
         3rP97wBJdN87GaK2IESqAaoJAQ1j5mKAMQzeGuG+/RvBD0Np5xN/ZqQdaqeXEDEXaP5f
         2HA21WSNYNi6f+/KNx3V3OHtCl3zxjQ42xHo2qI6WoVT2YdRFWuuTdEQgT3ns5IETmgz
         5XrkB2EQOmH1QKh+cy6p8CvxHsKvrd+Qwd8YC6HqCi3GqFZrkVPzHY4482jFockfSnZz
         /hYw==
X-Gm-Message-State: AOAM5333fvBcrzUQ+kbnAv8uaqTpnU3nWGpq10cuQX2dQOcOSOiT7Wjs
        DZxHu4lklAEHN4xeIAv7tT0=
X-Google-Smtp-Source: ABdhPJzNMz/UwqlIx3LPy+LgXe6CpOmW5owGIk3LfbCnlQlsFUCZPIEGWXJOhPr6AxXEtRy/j6vLVQ==
X-Received: by 2002:a17:906:404:: with SMTP id d4mr3780577eja.173.1590839546214;
        Sat, 30 May 2020 04:52:26 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id z14sm9625203ejd.37.2020.05.30.04.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 May 2020 04:52:25 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru, broonie@kernel.org
Subject: [PATCH v2 net-next 08/13] net: mscc: ocelot: disable flow control on NPI interface
Date:   Sat, 30 May 2020 14:51:37 +0300
Message-Id: <20200530115142.707415-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200530115142.707415-1-olteanv@gmail.com>
References: <20200530115142.707415-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The Ocelot switches do not support flow control on Ethernet interfaces
where a DSA tag must be added. If pause frames are enabled, they will be
encapsulated in the DSA tag just like regular frames, and the DSA master
will not recognize them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d9b0918080c5..c36d29974092 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -2202,6 +2202,10 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
 				    extraction);
 		ocelot_fields_write(ocelot, npi, SYS_PORT_MODE_INCL_INJ_HDR,
 				    injection);
+
+		/* Disable transmission of pause frames */
+		ocelot_rmw_rix(ocelot, 0, SYS_PAUSE_CFG_PAUSE_ENA,
+			       SYS_PAUSE_CFG, npi);
 	}
 
 	/* Enable CPU port module */
-- 
2.25.1

