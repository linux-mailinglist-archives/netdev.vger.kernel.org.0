Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB124733C4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhLMSR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:17:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241811AbhLMSRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 13:17:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639419442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=r/BNW7lY/fdE5Ha8QgWy6aKjJc7IPxrIGL6wb9Vu0/8=;
        b=VpwxTabniR8cXim6nLGiSHJGJh1Ny0gpUfGsO1jBabM9vlJZA1tYs40FTw0frbA+lkV/3G
        OjRHPJvPST74PL0qX7zpZqxUPCrieLpm86uds4E9B0yaj6JNAMNA7CI1FpOTU2WB82FNw9
        WSfEqZBGwSsrxCUd+lZhvCYEQliu8Qw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-mC-hPMaVNvqDqvUMET2NHQ-1; Mon, 13 Dec 2021 13:17:20 -0500
X-MC-Unique: mC-hPMaVNvqDqvUMET2NHQ-1
Received: by mail-wm1-f70.google.com with SMTP id l6-20020a05600c4f0600b0033321934a39so6776799wmq.9
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 10:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=r/BNW7lY/fdE5Ha8QgWy6aKjJc7IPxrIGL6wb9Vu0/8=;
        b=e5ljmHdAPS/4teUifJvLNqXdpjPB16Wsgbbp+BRSAx7YZhC/XP4BHBvxSLCVSWdO1w
         6z52wdG+6CiGZhGndDLUbdzbPRy/IQ8ZXNsAhb4f6x/cq6I6WBTDC22lbCH7IYGE5WSf
         J8dArQiT19QwcY1wA+Hg9Qy4sDpii3kfq6wNvtze0yZU+djfgNnS3vSubiwwAjZ4vvYa
         Y6x3dMSicAs2TsDXFytf0WJT6uXmlcraWfs+H1pw2hguMCftTLutvNDIXMslvmFcb9uq
         hCxlQVsO2e8hmHdmDoJul/6bBCX/suGaDXkCgYeYwQEv9ZWlaHnZ06QjpfRbwI1bakw3
         A5Sw==
X-Gm-Message-State: AOAM530hekmOlfaiAzrgCboQPExlt0QjHV8gORcb8TZfYIyOzvxyivgl
        nhJZORm7zxEuKvaLdCYPc/TLiSouADXsdb4BiwYC77MD/b87S44vB08QHh/yRqpDQ7WA5AAsBoi
        5zBVRbCWnwv+kI5Cc
X-Received: by 2002:a5d:6351:: with SMTP id b17mr122186wrw.151.1639419439534;
        Mon, 13 Dec 2021 10:17:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzTAIhsOvA3bAM9dZ1CDP7K84x/dYsjPQ+pXDjibZfFmk5Ri4yXA0kOnpJQVcJHd6pdl3aLTQ==
X-Received: by 2002:a5d:6351:: with SMTP id b17mr122170wrw.151.1639419439377;
        Mon, 13 Dec 2021 10:17:19 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n184sm7774046wme.2.2021.12.13.10.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 10:17:18 -0800 (PST)
Date:   Mon, 13 Dec 2021 19:17:17 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next] bareudp: Add extack support to bareudp_configure()
Message-ID: <1cb1c14b1423222550601004a3053722c9200f6f.1639417012.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add missing extacks for common configuration errors.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 drivers/net/bareudp.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index f80330361399..ba587e5fc24f 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -609,7 +609,8 @@ static struct bareudp_dev *bareudp_find_dev(struct bareudp_net *bn,
 }
 
 static int bareudp_configure(struct net *net, struct net_device *dev,
-			     struct bareudp_conf *conf)
+			     struct bareudp_conf *conf,
+			     struct netlink_ext_ack *extack)
 {
 	struct bareudp_net *bn = net_generic(net, bareudp_net_id);
 	struct bareudp_dev *t, *bareudp = netdev_priv(dev);
@@ -618,13 +619,17 @@ static int bareudp_configure(struct net *net, struct net_device *dev,
 	bareudp->net = net;
 	bareudp->dev = dev;
 	t = bareudp_find_dev(bn, conf);
-	if (t)
+	if (t) {
+		NL_SET_ERR_MSG(extack, "Another bareudp device using the same port already exists");
 		return -EBUSY;
+	}
 
 	if (conf->multi_proto_mode &&
 	    (conf->ethertype != htons(ETH_P_MPLS_UC) &&
-	     conf->ethertype != htons(ETH_P_IP)))
+	     conf->ethertype != htons(ETH_P_IP))) {
+		NL_SET_ERR_MSG(extack, "Cannot set multiproto mode for this ethertype (only IPv4 and unicast MPLS are supported)");
 		return -EINVAL;
+	}
 
 	bareudp->port = conf->port;
 	bareudp->ethertype = conf->ethertype;
@@ -671,7 +676,7 @@ static int bareudp_newlink(struct net *net, struct net_device *dev,
 	if (err)
 		return err;
 
-	err = bareudp_configure(net, dev, &conf);
+	err = bareudp_configure(net, dev, &conf, extack);
 	if (err)
 		return err;
 
-- 
2.21.3

