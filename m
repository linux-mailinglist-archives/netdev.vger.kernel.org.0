Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4953450BB
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:28:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhCVU1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCVU1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 16:27:20 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E216C061574;
        Mon, 22 Mar 2021 13:27:19 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id z15so14483821oic.8;
        Mon, 22 Mar 2021 13:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8EdwlC6mjQMaPh/szmT93V5gJUSuLrIXnwc5sVFVX2c=;
        b=cZn/TvmaDITh0NMd2xAfoLOOj9lF76COeqeLSVCRlOsmlijzvxwrPY6I2xUjNQRfhg
         jqDYt/TvG+RB77Z6YV3cj7LnCAlV8m26r69jUor/FXVvXVl+s9zHo7rNPci4wrg7bzQU
         0bte99M+b+tDWfuif6181aUxZytGrEQm3rokTqSusiib8WvROJxVkU01DjPaTTilmMOQ
         NDXaQXo3NeDCGa4PnZ8qN3dISUPLHVrjvSF35YMES7P2M83Gx98GzLa++xmsS4ibqJ18
         KHTWSV1neD6DYIU1AD0mW/NpKlrb0wGM2j1/csMPWK9NWkGX36BLsPtOG+U81wV8evvX
         mtJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8EdwlC6mjQMaPh/szmT93V5gJUSuLrIXnwc5sVFVX2c=;
        b=L6y5RiX67AyjIccrffSXHcqTeXYqtgJxIXgRs98bseiQ/DH8y3/+OPtK5ndfX5woOK
         q1qoinMvA9sCQx5ugclHmedXo8tQHXzC1ybstxDU3ascM3WrI9Kqlt08yURv7zw3399Z
         tXnTbsHbDgelQj8hvzIrbE0f8IBGyO3mo9J98ZkUCgSjHi4wM2gf/+UppnN0LGXNv71c
         DaIv2gX32gRTeKCsnRwH8cyuy9DlB2x2wIpOK6RyOMZyqfcLn50lkxzCHaH347T+pZoD
         qzTHgDwJcjsLw51ix8qyA89EKN+b5U6tN/RhtdKVY4YEVIOjC173+4jLMT8DyPOyA4N4
         rv7A==
X-Gm-Message-State: AOAM530NNxsersXqKWIatUdNWsXkaW2j6a1oO5+gfsr2TxAGONClOAZm
        YZ1giFL7brTzrcVFSLLVqNKbxLEYJH5m
X-Google-Smtp-Source: ABdhPJzsMGenVsSc28CsH9Rxxaz/tDxVMOUqbp2XOQfj8nMnhZeHw6gldvTAgGU96TmI/ofhhre/MQ==
X-Received: by 2002:aca:ef84:: with SMTP id n126mr612731oih.84.1616444838977;
        Mon, 22 Mar 2021 13:27:18 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id x3sm3462766oif.22.2021.03.22.13.27.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Mar 2021 13:27:18 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net] net: dsa: don't assign an error value to tag_ops
Date:   Mon, 22 Mar 2021 15:26:50 -0500
Message-Id: <20210322202650.45776-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a temporary variable to hold the return value from
dsa_tag_driver_get() instead of assigning it to dst->tag_ops. Leaving
an error value in dst->tag_ops can result in deferencing an invalid
pointer when a deferred switch configuration happens later.

Fixes: 357f203bb3b5 ("net: dsa: keep a copy of the tagging protocol in the DSA switch tree")

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 net/dsa/dsa2.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index eb709d988c54..8f9e35e1aa89 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1068,6 +1068,7 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
+	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol tag_protocol;
 
 	tag_protocol = dsa_get_tag_protocol(dp, master);
@@ -1082,14 +1083,16 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master)
 		 * nothing to do here.
 		 */
 	} else {
-		dst->tag_ops = dsa_tag_driver_get(tag_protocol);
-		if (IS_ERR(dst->tag_ops)) {
-			if (PTR_ERR(dst->tag_ops) == -ENOPROTOOPT)
+		tag_ops = dsa_tag_driver_get(tag_protocol);
+		if (IS_ERR(tag_ops)) {
+			if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
 				return -EPROBE_DEFER;
 			dev_warn(ds->dev, "No tagger for this switch\n");
 			dp->master = NULL;
-			return PTR_ERR(dst->tag_ops);
+			return PTR_ERR(tag_ops);
 		}
+
+		dst->tag_ops = tag_ops;
 	}
 
 	dp->master = master;
-- 
2.11.0

