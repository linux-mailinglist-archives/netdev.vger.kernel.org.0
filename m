Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 292941986B6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 23:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgC3VjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 17:39:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:32987 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbgC3VjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 17:39:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id z14so592953wmf.0
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 14:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9l0Ih2VJwaJR/ECIPbrLbF6cSuvdlebPe9+sYSdSc1k=;
        b=Oj++YXXeSC+YIE9JXNEs1UlCBpe/RdP281rlBHXiXTlQBEle2z/r/RKFdGzORsRGSv
         0Fgvxz1ZNotK1YC0u0DBLXLE+H4te+/ZTgdpWO1OeoL2A6VylYXeaSTzldm/ZKeI523t
         26JQHMHtaF1475OD4Vxf/ACGJnqlc4HQhqPtSK41wf9Adtj65CkLntpAaHmSxzUK6fLx
         KaPV3zoC3Em+4QrSogZrGo9d21PI/U20HLINvlobGXZy8MantzbgJ5u1fgItRh0HXTf6
         ywpaA/dU/picIHHZviVVbpdvVAFM05OZ37/SeOCGwbLoaBt3jBUdAztjhe8P7mSSkTzA
         t+EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9l0Ih2VJwaJR/ECIPbrLbF6cSuvdlebPe9+sYSdSc1k=;
        b=bFTc7dtsQPnYlM5jxO1hvfii9tb/3hpXdETzwREScmEVs4SYEhKf9PRgdItynihj/l
         PS0yND0vdkF/ZyGlZNu6g8geBcKiuh20UV9BmIFYcA1kHQ12hKMCpG9cMYU+Z5gt4IJD
         Ep8A6GWyRCRs3UKFBPuQ3dcOlyf/caXC8ItC/cUejTG9qOIJjkL0R2gVG/F1AwQ3eT+6
         tDyLPg1Wl22wElZh13+IkzltzMyatAxDH51OB95CpefgXvbruldFs5uQSFJtoUwBtLxm
         1HzgZgoBAUjYS2uNDow/uJDx6gNuG1NsvoFlt7GGX1gim+juLUIZcXdN2FDOnPOVDwpn
         0Mgg==
X-Gm-Message-State: ANhLgQ2hC036zswbtx7FDmGnJ89IiS8wFaFdJ1B9UNtTcC1Aas0zjLON
        wF+mMGyrYbTzZjWnvaPqSXZB5mn7
X-Google-Smtp-Source: ADFU+vt+2/GUihvRgc+L0mNvbF2eE++7jsLQHc24/a5gF3wsyJk3YOTeLeerli1wrlldYoyfhqESTA==
X-Received: by 2002:a1c:dc8b:: with SMTP id t133mr92232wmg.99.1585604346472;
        Mon, 30 Mar 2020 14:39:06 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r17sm23600853wrx.46.2020.03.30.14.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 14:39:05 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        dan.carpenter@oracle.com
Subject: [PATCH net-next v2 3/9] net: dsa: b53: Prevent tagged VLAN on port 7 for 7278
Date:   Mon, 30 Mar 2020 14:38:48 -0700
Message-Id: <20200330213854.4856-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330213854.4856-1-f.fainelli@gmail.com>
References: <20200330213854.4856-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7278, port 7 of the switch connects to the ASP UniMAC which is not
capable of processing VLAN tagged frames. We can still allow the port to
be part of a VLAN entry, and we may want it to be untagged on egress on
that VLAN because of that limitation.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5cb678e8b9cd..42c41b091682 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1355,6 +1355,14 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	if ((is5325(dev) || is5365(dev)) && vlan->vid_begin == 0)
 		return -EOPNOTSUPP;
 
+	/* Port 7 on 7278 connects to the ASP's UniMAC which is not capable of
+	 * receiving VLAN tagged frames at all, we can still allow the port to
+	 * be configured for egress untagged.
+	 */
+	if (dev->chip_id == BCM7278_DEVICE_ID && port == 7 &&
+	    !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED))
+		return -EINVAL;
+
 	if (vlan->vid_end > dev->num_vlans)
 		return -ERANGE;
 
-- 
2.17.1

