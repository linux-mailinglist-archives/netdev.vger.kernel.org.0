Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2343018EC70
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 22:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCVVKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 17:10:05 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33711 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgCVVKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 17:10:05 -0400
Received: by mail-pg1-f196.google.com with SMTP id d17so5527204pgo.0;
        Sun, 22 Mar 2020 14:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aq4FnVl01/hvTTs/ATJP7CS4oa1ekOf/S+aCjinScts=;
        b=Tjm9B7R/KMxFo+ZJ+SufneEGcADrKGf9CNo0iymeISZh1ZKv0k9dNhXfxmTYW4/TJV
         3kw52OeFrdmzIEDxQZ1TZWd3/2k+5erdwYHWGSakFA5qJcTN35P/PKQArDBd3u3jmvKS
         YN8wGj0tc54xyfhso0rHkO1pBQ9yoLSMnp6+MKLla5uadMFx24+qaO7RHVBBkUWpycFi
         6UNxO0RM8MxGFon1riNCbIGyv89ouzQOhbUh7Zm75dahobM5YbCeVmXsEx4SXx1Xdlcd
         fS5gTdafJUhhqonHHNwJGJvKJ9B1wI4IDiPxi6vs/ZQxfb0s3KCjFOQ7Wlty1wKCl5Jm
         F9MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aq4FnVl01/hvTTs/ATJP7CS4oa1ekOf/S+aCjinScts=;
        b=IX3BH9KFEjIxsPWiNqdK3jMmTDDPVZ6CRCHVWq6MVYVsu7eXI9CVn7MBSnIGQcIg4d
         l9Q/eFnK/rbdKICSAhYYMFDOK9MHSaGFOJHuqsQ/3Y9RYfsiEKGDLEcVdwgR5rSGSCaz
         i/wArlqQmCeV2hVBGsgUJyLEuYe+XWCMx135Cz2PVmixSTj2LGl+p+vxIRERJx6RbRB1
         PEeiupMCvhsIAkSI4RjVnOwr1JdUsG4zYkvvpz7WcVsJySsK5NuqsO0X8lYEdCxafwYk
         GLhSSNfcazWDihEBZ9hgAwLhRL0wnnkVKPdianRTUotNmUwCiDnS83/YnjGmPZbedNX+
         U3nQ==
X-Gm-Message-State: ANhLgQ26GIDzfal4lHIGSmdZ5thgvUQG/fLEV96VM6s6S+xUICyRFnAp
        r8UdsywoH5UO6yH9PxpppNQOlp01
X-Google-Smtp-Source: ADFU+vvdxvFkQGTsZhqJHEYYlO0ymiiM+cEvuBG1R15bj+DJv/lYXqxVbMmFjZMURrTU3lAYO5KfQg==
X-Received: by 2002:a63:b60:: with SMTP id a32mr19442391pgl.417.1584911403937;
        Sun, 22 Mar 2020 14:10:03 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id a15sm11368359pfg.77.2020.03.22.14.10.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 14:10:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     alobakin@dlink.ru, olteanv@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: Implement flow dissection for tag_brcm.c
Date:   Sun, 22 Mar 2020 14:09:57 -0700
Message-Id: <20200322210957.3940-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Provide a flow_dissect callback which returns the network offset and
where to find the skb protocol, given the tags structure a common
function works for both tagging formats that are supported.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/tag_brcm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 9c3114179690..0d3f796d14a3 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -142,6 +142,27 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 
 	return skb;
 }
+
+static int brcm_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
+				 int *offset)
+{
+	/* We have been called on the DSA master network device after
+	 * eth_type_trans() which pulled the Ethernet header already.
+	 * Frames have one of these two layouts:
+	 * -----------------------------------
+	 * | MAC DA | MAC SA | 4b tag | Type | DSA_TAG_PROTO_BRCM
+	 * -----------------------------------
+	 * -----------------------------------
+	 * | 4b tag | MAC DA | MAC SA | Type | DSA_TAG_PROTO_BRCM_PREPEND
+	 * -----------------------------------
+	 * skb->data points 2 bytes before the actual Ethernet type field and
+	 * we have an offset of 4bytes between where skb->data and where the
+	 * payload starts.
+	 */
+	*offset = BRCM_TAG_LEN;
+	*proto = ((__be16 *)skb->data)[1];
+	return 0;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
@@ -177,6 +198,7 @@ static const struct dsa_device_ops brcm_netdev_ops = {
 	.xmit	= brcm_tag_xmit,
 	.rcv	= brcm_tag_rcv,
 	.overhead = BRCM_TAG_LEN,
+	.flow_dissect = brcm_tag_flow_dissect,
 };
 
 DSA_TAG_DRIVER(brcm_netdev_ops);
@@ -205,6 +227,7 @@ static const struct dsa_device_ops brcm_prepend_netdev_ops = {
 	.xmit	= brcm_tag_xmit_prepend,
 	.rcv	= brcm_tag_rcv_prepend,
 	.overhead = BRCM_TAG_LEN,
+	.flow_dissect = brcm_tag_flow_dissect,
 };
 
 DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
-- 
2.19.1

