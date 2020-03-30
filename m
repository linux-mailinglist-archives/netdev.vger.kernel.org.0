Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5278198594
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 22:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgC3Uk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 16:40:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46801 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729285AbgC3Ukz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 16:40:55 -0400
Received: by mail-wr1-f68.google.com with SMTP id j17so23260415wru.13
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 13:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dDCxEQUMx7omsUPWXKxd3IbegM/d//gGYNCpsBduu7o=;
        b=aO0qjK0qVrhBTUXjPXLfO3/Znc5QD+VufQU9P3QpohSmsOSwFQsXp7yLOLmiR/osRt
         I56vVtcHak/yTkxhBEzcbMSIm6/EOY/rMAqdd8sYHOYimQ8skCUsqiBYrCtNYRusFvhZ
         YS2OQHEtvWw8lr5YwbFdhda6gi2B8Fv58DUQoAyqoT4N6c/1ZYytkNJRtgRSKAgxaPop
         AmigK+Z1Nn6CERFF1TaKmpr1qzok/mlT4rVYabepjtLmT+h/opcYluk9Z1yzSAhBg/8H
         cYQxg4AcqABTEUKuu0yO3U59A/4zvh3cwkmNRDJ68WYLVqaFdKSyoHFczk4H4RZLEUv9
         nbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dDCxEQUMx7omsUPWXKxd3IbegM/d//gGYNCpsBduu7o=;
        b=JKKrGS3vqUzO4YCYsp0NnrW11ujY2Tn7Z8fL9JOqoYOZTQz0O120lt2XzT9WXm2BCt
         P0IJSs+rVmnv52lrknqd2uTR6O57XiYV2bifoqIXkw3cnSF/wEC/9Sz36n1MJoCg/yC5
         OW5k4MfgI8+E0l5H5Rg8KBdVjb3EyYI8K9H7oFvAUhM50fHYUnORUQ9C9erNEWBrGt1f
         cHvIm9wDNW80yBInKUaLqgIlcopwjw15VvAinllATVpp57dUENGQlWbLOceQx9+KXu9j
         +w3dh9bpIeti0cJtCZjd2jLxtSHwK7Q4UnbTFilGewvk1qJLouCDcbo0I4JyntUT6Xav
         6RDw==
X-Gm-Message-State: ANhLgQ2TqxUKmSWi3ADN0wc2l6E4KqfnFSrgb2udB4ymDe3owezhFjXV
        oCEL5BWXgyq3CK5xGr9V8+tZVWyk
X-Google-Smtp-Source: ADFU+vvMYwn6ilqSfdgo2y9BcnF9dOCNJuW4yMRUKofSvcGDrsLUJpfibYOi62jOzFi2FC97lC/BYQ==
X-Received: by 2002:a5d:630e:: with SMTP id i14mr16774157wru.260.1585600853971;
        Mon, 30 Mar 2020 13:40:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o16sm23371109wrs.44.2020.03.30.13.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 13:40:53 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next 6/9] net: dsa: bcm_sf2: Check earlier for FLOW_EXT and FLOW_MAC_EXT
Date:   Mon, 30 Mar 2020 13:40:29 -0700
Message-Id: <20200330204032.26313-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330204032.26313-1-f.fainelli@gmail.com>
References: <20200330204032.26313-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We do not currently support matching on FLOW_EXT or FLOW_MAC_EXT, but we
were not checking for those bits being set in the flow specification.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index f9785027c096..6e26a9083d32 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -878,8 +878,8 @@ static int bcm_sf2_cfp_rule_set(struct dsa_switch *ds, int port,
 	int ret = -EINVAL;
 
 	/* Check for unsupported extensions */
-	if ((fs->flow_type & FLOW_EXT) && (fs->m_ext.vlan_etype ||
-	     fs->m_ext.data[1]))
+	if ((fs->flow_type & (FLOW_EXT || FLOW_MAC_EXT)) ||
+	    fs->m_ext.data[1])
 		return -EINVAL;
 
 	if (fs->location != RX_CLS_LOC_ANY &&
-- 
2.17.1

