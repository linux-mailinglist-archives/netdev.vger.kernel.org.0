Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEDA12B017
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 02:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfL0BEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 20:04:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38888 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbfL0BEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 20:04:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id y17so24893772wrh.5
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SJavRKYLQJoieNyJqH2ZNFzEMrxnkIJspMuxMmHhtyU=;
        b=fNW22+uyjAh24iOrAvHjJeKF4XvXojnscPsjvJM2FOJj4b/JOMPGXegR4ibXhOE9pO
         99tMFz8pjT51iHvvQbopi+VqMQ1kh9QTTnUrbKFvpgROCSD3Vfpc3ryT+IYN2/sdaeL/
         ZcXiIsYSd71i3STZIt1xCDYkOmE8LNPJZwDrWt4EbTew8tv81MqlmUOqxqQ4gwcEgFMZ
         qNDLaWqn8e4CBsOn9oxy51U6sUZp+Xi5hBqcEtln3bnVcB3oPLFTbdrSofNobjJtHnE2
         JZ/B9Ed1sm53MBKvZXXcY9dNyi3t0J23Zr54JK+mn4882/cFuQDCGrh7mSGirwDqiUKg
         J5Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SJavRKYLQJoieNyJqH2ZNFzEMrxnkIJspMuxMmHhtyU=;
        b=O2QzboiDJAlDXRU4Pjkyjw8Z2GRYh8mVHwYCGdpfJepdfiQ+WnUnegeZgyC3HDjKaB
         +snVguhpR73ONm401j1DJdFUXcY3jEyTbcuUDJgscEf+5rx4lLNtHYReX9t6NPtfkgM9
         Y2axCSdsGvnT7roo/4DlJTGk8n7FXIv3Eio9ndzDvbmxCwTtaT6Oc2La0WOAVgDx3mrU
         U0AM728Mykc7SSJbJ/hLKR120FMWocMF3K01UJkiqUK0xjv6Wbt5uchkb0KHtnE0rSQH
         CmsdjgIJCtlyVbmPOlLVo/XcG0J2D35RNF/DaZUWqzWRTEG7hH4r44y6UcfDFenzsA4m
         P2DA==
X-Gm-Message-State: APjAAAUlcfNkrNLcIZa1shWWexhmZB6sJ4SE6c9xW+xrjWsXgoTVyThw
        4a01QOjFacTKgJyXL+dxvOE=
X-Google-Smtp-Source: APXvYqxZZ5/24joLxUh7wPZyUK4QU71HYcdkAEjf1zfDb4uKNe+sV1obiiIyaXC8e3dCs9J6Vxnaww==
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr45955025wrw.327.1577408642830;
        Thu, 26 Dec 2019 17:04:02 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id o1sm32929826wrn.84.2019.12.26.17.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 17:04:02 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, vinicius.gomes@intel.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: Remove restriction of zero base-time for taprio offload
Date:   Fri, 27 Dec 2019 03:03:54 +0200
Message-Id: <20191227010354.26826-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check originates from the initial implementation which was not based
on PTP time but on a standalone clock source. In the meantime we can now
program the PTPSCHTM register at runtime with the dynamic base time
(actually with a value that is 200 ns smaller, to avoid writing DELTA=0
in the Schedule Entry Points Parameters Table). And we also have logic
for moving the actual base time in the future of the PHC's current time
base, so the check for zero serves no purpose, since even if the user
will specify zero, that's not what will end up in the static config
table where the limitation is.

Fixes: 86db36a347b4 ("net: dsa: sja1105: Implement state machine for TAS with PTP clock source")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_tas.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index 26b925b5dace..fa6750d973d7 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -477,11 +477,6 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 	if (admin->cycle_time_extension)
 		return -ENOTSUPP;
 
-	if (!ns_to_sja1105_delta(admin->base_time)) {
-		dev_err(ds->dev, "A base time of zero is not hardware-allowed\n");
-		return -ERANGE;
-	}
-
 	for (i = 0; i < admin->num_entries; i++) {
 		s64 delta_ns = admin->entries[i].interval;
 		s64 delta_cycles = ns_to_sja1105_delta(delta_ns);
-- 
2.17.1

