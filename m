Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7764A4ADF
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379817AbiAaPrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379802AbiAaPrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:47:08 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BCBC06173E
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:08 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id q127so20020867ljq.2
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=tWF6c50iluk3gJWzzn2nu1IXzyQw+e+0Zhpcp6dcL3w=;
        b=Jbk3gukCnhxmdiZU+9xzA2ljkZcm/ma0pywuYYKWI5RpsI4ovcscKufG87o9Kn2lFJ
         N865G2uzR/dppRp/HI/2iSR3PVLurIEEwohkhHZeMzYcgDBNANwl3MXLrFT3quQmvdua
         qVX+Pp5THkUSnhYbFccV1r1jzW8Ol0qkxJFU1toE8SskLLmy3R3M1AVMnVeqAYzHHopm
         COZcN+Pzsa1BHbbpcJWSkvWwARiVfOveX1OuIItjPRpjZ8MN/6/WgsRPmMxuYdYdy11F
         1zbCPjzj+Gy50xL8vTSTqWkxE8BIXUGJuTelZ9U1eqK8nIjAxqAGHN6Tn5Ftejcy5NAs
         Sf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=tWF6c50iluk3gJWzzn2nu1IXzyQw+e+0Zhpcp6dcL3w=;
        b=MA46mka0oaV0puYhxtD5cGSThEOV50ghwOJPznZE7I85WsmWwq2zIPTPHW/uKJKwvU
         RTbSIYlIsMl5qH5UejMP9R+Um38u+SpfBj3E3/Q15GaKAqWbYPgP31U/PfItFE+fi13A
         dpAV7fdh80wKhbWi/7Y4/BnXW/nCkb0w8zcPFsJlkmjkpvIq4U8FkIPh1NDDW6tWI+0H
         EEZImDNStVU3HD0xVEVu8bvz6hL7MpsSbtRPwRwJUh1Zw8acJM8U12/csCw5M1F4xHx2
         f0ySCLOkEICEegX8WQgY53qtQ8yN7ZthfGcxIFG2TgUzVt1BDymMId3gkrX2BuQ6+rgt
         JZjg==
X-Gm-Message-State: AOAM532jrC2saqQxKcFWmm4AGIvuBpItpQIfI5Mc2MnIfVkFqk6A/oUf
        k52vsuGLz6HTf6RtmuprjsPXdA==
X-Google-Smtp-Source: ABdhPJwh9KDovrHgZIc7eIf4hAso96TSKRmbgq3VRJLuec/AC/qFjvlNO4g/0e8OXTstuSKOxy8uvg==
X-Received: by 2002:a2e:2e16:: with SMTP id u22mr13549471lju.205.1643644026573;
        Mon, 31 Jan 2022 07:47:06 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id y36sm3374769lfa.82.2022.01.31.07.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:47:06 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Enable port policy support on 6097
Date:   Mon, 31 Jan 2022 16:46:53 +0100
Message-Id: <20220131154655.1614770-4-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220131154655.1614770-1-tobias@waldekranz.com>
References: <20220131154655.1614770-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This chip has support for the same per-port policy actions found in
later versions of LinkStreet devices.

Fixes: f3a2cd326e44 ("net: dsa: mv88e6xxx: introduce .port_set_policy")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dde6a8d0ca36..8896709b9103 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3652,6 +3652,7 @@ static const struct mv88e6xxx_ops mv88e6097_ops = {
 	.port_sync_link = mv88e6185_port_sync_link,
 	.port_set_speed_duplex = mv88e6185_port_set_speed_duplex,
 	.port_tag_remap = mv88e6095_port_tag_remap,
+	.port_set_policy = mv88e6352_port_set_policy,
 	.port_set_frame_mode = mv88e6351_port_set_frame_mode,
 	.port_set_ucast_flood = mv88e6352_port_set_ucast_flood,
 	.port_set_mcast_flood = mv88e6352_port_set_mcast_flood,
-- 
2.25.1

