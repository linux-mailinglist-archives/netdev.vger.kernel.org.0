Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 629A5CC651
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731533AbfJDXOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:14:02 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38606 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:14:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id w8so3811763plq.5;
        Fri, 04 Oct 2019 16:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oExXo+oFzAkt4AzfUqMU/PahIsoL2UzkJn25Yvs0bak=;
        b=TnvMxUkv7UbZc9mloKnTFOe/XFMEGUh3Y3jeQ2fIRpi+SB6aMzNeY/B56s7OyYYZeP
         XCGWw8OlQDnfFvrhxa3Jwcnbl97QvBmjQK0LyPv9tv7FQFAzExtrz950MqWnnCH2VyJX
         kLQhw+JUgiZWysc3UgFVkDAp2pWbRejMAsGEny3uG6apZ1aRTp9854wToFlbtXYnayU9
         RcYEBPH8N8l0YdvBDv5EuIyG0awQWwM49tXjAyjotrFUv5/E75kQjSDilQfzl2DtqOr8
         XL/nkhzkkgExSjZndJcDouseIp13VDMMB+T3NdJlLPuY+Hkw1h13GH/OGVO9Ctp1COS8
         MncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oExXo+oFzAkt4AzfUqMU/PahIsoL2UzkJn25Yvs0bak=;
        b=DxSPCRgEcQRyDYEmtmHl3GZNqWcOs5hobaHcL8ggN8MSNYA9K+6cABc87hfO4011eV
         DR4EXD5xOnFfief2w8ApGCvf0qo7i6jSji6ccEJIyOIsAMAp7o8MInUNOS6VfXrep+SA
         BSh4Pz71B4/NPpcuyhHOu4JIUyTvmTlCVXZXyZNrbPRGYE5YRX2/h4fgTXAPqoFpt++D
         JHEYGlb/xVl95SrHnKRCeQhNEi1h/fHPbyonCkQ8cqdP5tz04b1iaAEAAIRXYiLtBKLP
         hKQ27OuEWQ2QSEpRIcLKpPYFQoFZFSC+swycFrI5xy7afptrxKsl6hBBDVuNDmjNVtZv
         gO9w==
X-Gm-Message-State: APjAAAUD6KVdB3BJL9yL938guhMEn4NRDQN3PhSbNGupTOXxXqoapGty
        luY9V0T9oRrNGX72z2+JKf0=
X-Google-Smtp-Source: APXvYqyzIPyjNy95CTiF4h+q4h/rKy4L5wAYeYYEzFrWa5ck3x6TIigtIhq/19UepQ5y9/74Mscw+A==
X-Received: by 2002:a17:902:820e:: with SMTP id x14mr17451183pln.223.1570230840493;
        Fri, 04 Oct 2019 16:14:00 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id y6sm9514353pfp.82.2019.10.04.16.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 16:13:58 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH 1/3] net: phylink: switch to using fwnode_gpiod_get_index()
Date:   Fri,  4 Oct 2019 16:13:54 -0700
Message-Id: <20191004231356.135996-2-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
In-Reply-To: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
References: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), but
works with arbitrary firmware node.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/net/phy/phylink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a5a57ca94c1a..c34ca644d47e 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -168,8 +168,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 			pl->link_config.pause |= MLO_PAUSE_ASYM;
 
 		if (ret == 0) {
-			desc = fwnode_get_named_gpiod(fixed_node, "link-gpios",
-						      0, GPIOD_IN, "?");
+			desc = fwnode_gpiod_get_index(fixed_node, "link", 0,
+						      GPIOD_IN, "?");
 
 			if (!IS_ERR(desc))
 				pl->link_gpio = desc;
-- 
2.23.0.581.g78d2f28ef7-goog

