Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9A52DC3AB
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgLPQCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725287AbgLPQCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:02:31 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96845C0617B0
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:50 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id h205so6106297lfd.5
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 08:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :organization;
        bh=CDSPPbDzl+GjmvdNHS6ezrzR6soInLlysuZSc+VCHWA=;
        b=dv2wCrGhzpDFm31ON1omu/hUW0xvkWNSOSxh2b0h/DxOyemILQkLh4wX4COUUdf0aB
         Ljzp6iYkHl/ir1oczTZAjmyTteYRaKW39oYzCzZLH9qYDK6F+IB1z/y30ZrF5WRapqUJ
         NpW4Cm2eS+2Y7jmBSZuvNZGAsOm3fBFGUlmQahZVm5oDubQl5igwb9Ler1tKhKFlvpop
         a1He3Iqqe7pbzIhKhWR0bIslbdKi8ghGgz4t2u5vHFh4F19p42r5CyZoxpOgH8arj0mN
         CGkyjSzjlFVbvghsNfsyb0GSgpt+2pK5j7U1bYHwKivpBtTwBgncgqBSIJCyLOW3Hi99
         gJBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:organization;
        bh=CDSPPbDzl+GjmvdNHS6ezrzR6soInLlysuZSc+VCHWA=;
        b=RWbSpiProokXTJfEbQko4DU/lYo39eYehYt6sg9ajv2tA2d4oJw9bPLMIxsvitr10t
         xGaY5cYXdgZP7c/5qXlDOAmszk1crjMyt4UayVKfb0x7MqIi/OQvK/P2AQdLwEB6o94Q
         g8sntNfwims/12WXip1jE1K2Eqe0zw58H1CvZQnRJomtQNaZGLr78L2SfZs8ek/E2Tms
         /KCRr1RClCwr4s+k0kQvxCJ3spnFpKgPzEFBvhR1zY2TjKT0oxVZg3vSdRTkVnDCOAuv
         qAWMxrkaOV5VwE5H6NwciHPAPWUxm9cfDA34MpxrY4RjOuqdAGc8dRHhcM8iiE40BqY7
         Oxmw==
X-Gm-Message-State: AOAM532AWS4Pokpohnu8RgIJvC8kuGk2KByHemK2Nmuz19mGE6y4pc1v
        GxJay0ZmGhZxdO++Qz1fYT4/p9lxpv1psArl
X-Google-Smtp-Source: ABdhPJwXJ2oXtakSQdlrgbHrJXe6+iWR5w19ISbvlZc/iX4H54d7cZFvk/ddAAxHfif0je3aDZ8aXg==
X-Received: by 2002:ac2:4a6f:: with SMTP id q15mr9245882lfp.301.1608134507750;
        Wed, 16 Dec 2020 08:01:47 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e25sm275877lfc.40.2020.12.16.08.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 08:01:47 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org
Subject: [PATCH v4 net-next 2/5] net: dsa: Don't offload port attributes on standalone ports
Date:   Wed, 16 Dec 2020 17:00:53 +0100
Message-Id: <20201216160056.27526-3-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201216160056.27526-1-tobias@waldekranz.com>
References: <20201216160056.27526-1-tobias@waldekranz.com>
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In a situation where a standalone port is indirectly attached to a
bridge (e.g. via a LAG) which is not offloaded, do not offload any
port attributes either. The port should behave as a standard NIC.

Previously, on mv88e6xxx, this meant that in the following setup:

     br0
     /
  team0
   / \
swp0 swp1

If vlan filtering was enabled on br0, swp0's and swp1's QMode was set
to "secure". This caused all untagged packets to be dropped, as their
default VID (0) was not loaded into the VTU.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/slave.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..faae8dcc0849 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -274,6 +274,9 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int ret;
 
+	if (attr->orig_dev != dev)
+		return -EOPNOTSUPP;
+
 	switch (attr->id) {
 	case SWITCHDEV_ATTR_ID_PORT_STP_STATE:
 		ret = dsa_port_set_state(dp, attr->u.stp_state, trans);
-- 
2.17.1

