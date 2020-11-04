Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7282A6E63
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 20:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730788AbgKDT4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 14:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727013AbgKDT4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 14:56:14 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A296FC0613D3
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 11:56:14 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id x13so17453541pgp.7
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 11:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=dlWR8rXO8RJ2Um8n7DA+PW+7Z257b+9h7LCZ9VZ9/3I=;
        b=XenlT/EwY2KhvEIx6YEnBS1Vb8S18pkpjo3tstceq+L7X1+XSzA5MKPHYhdwCr0yAA
         l8Z93m9FVx+yzqeapFJq4AP6wgw9qGzsbpNdH5II8ys34gX5nKDAftgoerv7Z7K1bWFr
         y4EpryjDuo2juEaJJiuPHhhsFg8qZ4EaAPCCznUmQecETXeSlxe8h/iWNxMwxs3Zd+2u
         m6OAwvv7yU6XVUsy+xU8jAKOLGkV8xk3TEO5KoANZ/zyKc/y32TDSxp4feW5QZ88MH8K
         oLm4GEsG4UXBn7Gsls+7YVNIZe/tJxHdIG33PfkYiS8HEA9UR2894gTGjFt8eDErYxEr
         I1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dlWR8rXO8RJ2Um8n7DA+PW+7Z257b+9h7LCZ9VZ9/3I=;
        b=Cel7JSXQDJfkEq+BspKHimxl6HVTb8LNQkoCjYFpPYjTGFFmPBlBsjvwQuB215UCAg
         otW2r8xLOTmE1WTConZ15eVgp9Z5rRC0s8nsVQVCdws88LKYezOdNGyWV68cvig3kknH
         ZqjNb0eRREyYb4daFwBkrNQ52pXarNc8WZsXu63wa8bmVfEeB5glUoBFB2ccMSwK0Kyi
         fl0dBEYxyNY0p7ofy/FL762E7TY7EIupokeGbkog/VZstuEPeUIyyFq4epZK6na624hP
         ic0MtFzFv2jsi9p+EqveQTgdTyDJqkqe9p7HmEu3FcGim4taDIEDJ+7Z715j5HofYV2p
         VN2w==
X-Gm-Message-State: AOAM533Yl8MYgiAMa3mJIZksJdqn6pavwOWKizrgLz8tUGK7CmrXrC14
        6CJCxowhZ1fmqyM6jwWG06F8/13XOE20Jg==
X-Google-Smtp-Source: ABdhPJwlkHj41XKJFyFv6C1YuVyBFecol7ZYmphPwUcyEp0xCd6B24lBOqF+TKPkUAtsRLhEg/6EiA==
X-Received: by 2002:a17:90a:4a15:: with SMTP id e21mr5716533pjh.130.1604519773836;
        Wed, 04 Nov 2020 11:56:13 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t5sm2904359pjq.7.2020.11.04.11.56.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 11:56:13 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: check port ptr before use
Date:   Wed,  4 Nov 2020 11:56:06 -0800
Message-Id: <20201104195606.61184-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check for corner case of port_init failure before using
the port_info pointer.

Fixes: 4d03e00a2140 ("ionic: Add initial ethtool support")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index ed9808fc743b..35c72d4a78b3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -126,6 +126,11 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
 
 	ethtool_link_ksettings_zero_link_mode(ks, supported);
 
+	if (!idev->port_info) {
+		netdev_err(netdev, "port_info not initialized\n");
+		return -EOPNOTSUPP;
+	}
+
 	/* The port_info data is found in a DMA space that the NIC keeps
 	 * up-to-date, so there's no need to request the data from the
 	 * NIC, we already have it in our memory space.
-- 
2.17.1

