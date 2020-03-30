Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C42D1986B7
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgC3VjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33842 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbgC3VjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id 26so588514wmk.1
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TLSkwbkBmT9mvdGuUe/8YRoz6F0Zjj10CnTJyh7civM=;
        b=BjQhtIf13chJUOY9M790edfFWtH0pLW8dsehVzdjgxoTt4t4t9RSkXpcIEgXsMhy9W
         99nRegVKCkNdj2cNTR8WpR0AsoABUC/8Y8TF3S+w/o2NISMC7Ws+cVttV4iiVnYqGmJD
         mbLg1tkJ/Eko3bKj7z7uxmba3QfvbGVRg6VOSSxCYxDaimQ9vnVM2G3emsHu2jqJy2yI
         ej2pXW945548CnJPqYxh5rt+sNY3KRMAdG26HUSDV5jWvEhPvQAe6j34fwIktsmlG5yD
         P3RMtvo+SVmrdMeY8xDbW/UwIQ/7Vy+SNVimUuCkQBMc06Ppyr0ij6qOMNp1aexjCBFw
         PS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=TLSkwbkBmT9mvdGuUe/8YRoz6F0Zjj10CnTJyh7civM=;
        b=FPxSoe8S56IZp8m/Ppx+9s/zigU+9+m6vaS90G0f/mRvOiNoLbdam/ZcXS57/PoMUd
         UF+xBELNjK33RCxdSnrOgEN76xB686GdVeCS1m9/gKfFxZDRJCsjSngPVAzPErtDszjb
         uY9au1ybHgX8IaDATMDyu1slBU5VX0h7igaZtE+BZ2i1E27vS+OrnzaU1dG4SHQoMpzT
         Ut/xOGOWZ3UEfXznyqGptJs+Tm5vkBauuWyNzb8teHrGQEYwWZUYrb28uB9uCdeIH1qn
         yNrJfVachjC0er28VLk0TKV6sCVIHqqyHe7mKQHXz95MKJk9ESbcPuEObOqWPOdbZwUR
         UrUA==
X-Gm-Message-State: ANhLgQ3oqEdIJLaRGVAFR5QbcTXrHACG+HJIWykfy3iOzmVETgHKv+NG
        pZyVZpFV9M3QyNteYNR6zX3i/wpS
X-Google-Smtp-Source: ADFU+vtazTDFLeFjLvyR12r2nX95fLWkM9JLselUFE8G46okF7wlEufna5rIMqif9dhNGyE4GU356Q==
X-Received: by 2002:a7b:c205:: with SMTP id x5mr87312wmi.189.1585604348759;
        Mon, 30 Mar 2020 14:39:08 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:08 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 4/9] net: dsa: b53: Deny enslaving port 7 for 7278 into a bridge
Date:   Mon, 30 Mar 2020 14:38:49 -0700
Message-Id: <20200330213854.4856-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7278, port 7 connects to the ASP which should only receive frames
through the use of CFP rules, it is not desirable to have it be part of
a bridge at all since that would make it pick up unwanted traffic that
it may not even be able to filter or sustain.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 42c41b091682..68e2381694b9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1728,6 +1728,12 @@ int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br)
 	u16 pvlan, reg;
 	unsigned int i;
 
+	/* On 7278, port 7 which connects to the ASP should only receive
+	 * traffic from matching CFP rules.
+	 */
+	if (dev->chip_id == BCM7278_DEVICE_ID && port == 7)
+		return -EINVAL;
+
 	/* Make this port leave the all VLANs join since we will have proper
 	 * VLAN entries from now on
 	 */
-- 
2.17.1

