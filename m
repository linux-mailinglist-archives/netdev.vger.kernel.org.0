Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC6021DE10
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 18:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgGMQ7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 12:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730011AbgGMQ7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 12:59:02 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD65C061794
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:01 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id a1so18009781ejg.12
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 09:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R8iWV1fS5Laiwbg+2oWKD8nwlKsB9Ek/15b2jRz//kQ=;
        b=ATH0M5zTqMv5N3ln9iY6mpk0LY+tApim+JUrK31F8y4XjkWbAYXODkKBvVQdJ1YfVQ
         sNJ38UBWrxUG5rtmb35bd1rZ4ZFnLmNYKjMgStp3t2mny7sZHvrDXSH7fKvQRpspZM1n
         yCyMbBKmuajkTM3MCM9Xmafjs1onf3JjF3rOFicj53IPvCY3p5lbjQKV/wKwwOw2Xyzl
         ytOvMRUJ9bsvvlQpIfhEH25BcQocsHULq9CwdbL/z6ZzBSLKD/iqhcoQmW2Ba9z+y51l
         sIio+v89S+zbEuooVGu6ieGDom10dMLQg69btAJY9eSNLBox/bsjRlvfUe2DHFpRmIs6
         Poyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8iWV1fS5Laiwbg+2oWKD8nwlKsB9Ek/15b2jRz//kQ=;
        b=o6xzgACgB6cCDsfvaDfFvn8CFOGHytFMTc/SxEkUfXF8+8YrxW5gAEq+IkDV/ZD/l5
         9tLngUUWjtsB1xR8t8O2MdFQ75QDe4tRfAOPjj9Rgw+/JbWMAHVlSRSxsVtykUpiLcol
         sZ5v9YVKZJbw1QTXcNPYmLfwQwHWlZowC2Ldy3zoV8d+M9T80dOAhAcSt1eRlAvjv3Z6
         x0IqJnClkVHdslG+TZqUlS0DbCJ2yHke29EJZKpaY8uXTW09xMD5uuP3WH6A4NL8Tzgd
         g8RYbqS9jWE55gqyy6RwtCiHzFB5J0W6AcWNeU8K3YOiIi326+YKFfEEAtn57heKEtyw
         KZRQ==
X-Gm-Message-State: AOAM532HrUmz9Qv4zLXDvs5p91eKu1fBHeanI+m6/vl0YK1YzhL4wmgR
        qsNPon0m3mf55sqHFamfFfc=
X-Google-Smtp-Source: ABdhPJywEalLTz3r1MAaDv0kOrgwSOHKHEE99Dhh++BpsgJAvwCph57QOY1zcL1rWDjBekqxE+r8iQ==
X-Received: by 2002:a17:907:9c6:: with SMTP id bx6mr625774ejc.43.1594659540575;
        Mon, 13 Jul 2020 09:59:00 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id y1sm12986732ede.7.2020.07.13.09.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 09:59:00 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, antoine.tenart@bootlin.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        madalin.bucur@oss.nxp.com, radu-andrei.bulie@nxp.com,
        fido_max@inbox.ru
Subject: [PATCH v4 net-next 06/11] net: mscc: ocelot: disable flow control on NPI interface
Date:   Mon, 13 Jul 2020 19:57:06 +0300
Message-Id: <20200713165711.2518150-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713165711.2518150-1-olteanv@gmail.com>
References: <20200713165711.2518150-1-olteanv@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
None.

 drivers/net/ethernet/mscc/ocelot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index aca805b9c0b3..2a44305912d2 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1401,6 +1401,10 @@ void ocelot_configure_cpu(struct ocelot *ocelot, int npi,
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

