Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8FA1C39B9
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbgEDMof (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728079AbgEDMoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:44:21 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA79C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 05:44:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id i10so20721570wrv.10
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 05:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aMUeZPhAHahhEsEZ8yqPryuY729nsIpF6ZIBOZrog/E=;
        b=ozvX5ZbXg4DZPJm7JylT5zofJyeJoDfrI+Z4w2TqAW0DergchiK84yfy3rF+gKKbGI
         y+RDe2b2hiNLTc4cSW6NfdTuo9577enO0Z+o12VnvFs0uZNBzJIxJ+AFKd+8j+D5A/Mi
         1UtbB5yYOxFMUafrD1xlRLxtViEUwu5SDLhmP0DKuOXUW06EknxMceuWMFMmeRvwMDex
         wMgYnra6zMHOqZYBgzhehMXpc32BZn+6O1i9QyRVZ7jha20cFTJIuCEKTEjUknE4b85A
         F3MP6W8lc5Y6IYU828NQy5IfWZrzHpnH4R9PDtn8AVQYGByvryQWvjRUpdJdjzD8hnpC
         TDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aMUeZPhAHahhEsEZ8yqPryuY729nsIpF6ZIBOZrog/E=;
        b=nnvUMYtQnhfUu0D6lbfxEKo6eCgD5mHbnbWA+k4JTrTmRNvxfXWfzJd8IH/wVwG7tM
         GItbrtwcqR79Pvm2aRP4TP9sWXOuWCyScKRItN/iIYaV6r8A1KjWt+5lVyRbtosDvEf+
         LfUFGU+V2dsdW8c21ewaUNmOlSg5wfN+J1wR4GebKoJ+WaUHmlV1r2q1b49aOhSY4EkN
         aA3KkARq5kk6SZW7vibnJx4tbq4Jp6i4p8dLTGJ9kal/+XnQto5B+o5fp4MOl2I//jCM
         euP9giWiWCAwu+jFRA1S6Q+IRGIqdKSj0RYITn5FLO5pvjU66lR9s6Xi8opexWGmfdm8
         GZog==
X-Gm-Message-State: AGi0PuZfFdBle4HPdk6qMkYlbE33Kl21tRfxISnSyoJuc84Tm0PYBL62
        Psu+hsl4PpAdlHwDrwsp8zI=
X-Google-Smtp-Source: APiQypIuC/TbMrUmkyUT8ix9qZsNg7fPuf12hG3aVdWvW5Pi1PKtg7gZ+wOzpWWZc95eIBStRimTig==
X-Received: by 2002:adf:fe01:: with SMTP id n1mr7176445wrr.268.1588596260195;
        Mon, 04 May 2020 05:44:20 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 32sm17343670wrg.19.2020.05.04.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:44:19 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        georg.waibel@sensor-technik.de, o.rempel@pengutronix.de,
        christian.herber@nxp.com
Subject: [RFC 4/6] net: dsa: tag_8021q: skip disabled ports
Date:   Mon,  4 May 2020 15:43:23 +0300
Message-Id: <20200504124325.26758-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504124325.26758-1-olteanv@gmail.com>
References: <20200504124325.26758-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Not only is it not needed to program dsa_8021q VLANs into ports that are
not used, but it also makes validation impossible, given the fact that
port == dsa_upstream_port(ds, port) for a port that is disabled. So when
a user port wants to install its rx_vid into us (we the disabled port),
think that we are in fact the CPU port, so we want the flags to be
egress-tagged (which they aren't). So instead of trying to make
dsa_upstream_port return something more sensible for disabled ports,
skip this nonsense altogether.

Because we didn't have VID validation until now, there's no reason to
treat this patch as a bugfix.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_8021q.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 158584153e15..3958f426d60e 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -239,7 +239,7 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 	for (i = 0; i < ds->num_ports; i++) {
 		u16 flags;
 
-		if (i == upstream)
+		if (!dsa_is_user_port(ds, i))
 			continue;
 		else if (i == port)
 			/* The RX VID is pvid on this port */
@@ -302,6 +302,8 @@ int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
 		return -EPERM;
 
 	for (other_port = 0; other_port < ds->num_ports; other_port++) {
+		if (!dsa_is_user_port(ds, other_port))
+			continue;
 		if (vid == dsa_8021q_rx_vid(ds, other_port)) {
 			rx_vid_of = other_port;
 			break;
-- 
2.17.1

