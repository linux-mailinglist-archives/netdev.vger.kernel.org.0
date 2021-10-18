Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121554313A0
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 11:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbhJRJmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 05:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbhJRJmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 05:42:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2157C061765
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:29 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id a25so68570293edx.8
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 02:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pqrs.dk; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0aPy9wGzZ3Pl4PBVTp4VUwHgut4BXqjb7+83Il+Vpqc=;
        b=iySg41ikJdwkxoY+DWs5oW4n5zCZaKka8FVutO9jiGfoGG1i1zOhODezZisIwvd0dg
         GMffmZEyx/OW0iT/beP84lRS03U3KtRwfqGKvLvHcbscxTnsaHOaIqyc2wuiYxwonSTC
         pq7oVjTOwAJWBUfOpFZmpdaQNBb7j5BUv2Wvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0aPy9wGzZ3Pl4PBVTp4VUwHgut4BXqjb7+83Il+Vpqc=;
        b=crWc03pvyEmTUIVJu74YgH7FHxTdGq6ad/st6WN959Vg87BoPzQTY+f8fIvxImPn4K
         ro31vLhNQyhGqG6lQDcN6uixDmhubvcSRZCgCmn+yFOWQYmFRAPdjt4eGpjAsGxbkkt6
         nyX1sz4ABMbcivAN4/ng+wq3m1oeum/3SXPUXAQNMlIZllm8EEXd5PpMGabPhHByDKpP
         uHCb2dRdjhGtUBgvHK1wD4KV+Hq/CgjToZiqSZtnuPswZzWUM8gpZgz/4c5y0HCGB4oq
         B2wj4LlpC5tKH6XO0XA1qW0wsS2HtvmCuujHAtsSb2dU2vhhIyExZ6+Uh9gMfDOXRVO9
         QA9Q==
X-Gm-Message-State: AOAM530uYTNmCCGWwEUZGXkHddNjX6ZsCuyXfea9sO+VFDRUGnqA0xiV
        M3j5pmWtLHNcZQOuw1L2ipyqQA==
X-Google-Smtp-Source: ABdhPJwVZKZga0hTBngNYU/6AHPGlKP+40HkFfwe3tz7qz8cKk6gIkNsKDyZ0VU5sN1SIgF81o4eNA==
X-Received: by 2002:a17:907:9625:: with SMTP id gb37mr28508315ejc.432.1634550026907;
        Mon, 18 Oct 2021 02:40:26 -0700 (PDT)
Received: from capella.. ([80.208.66.147])
        by smtp.gmail.com with ESMTPSA id z1sm10134566edc.68.2021.10.18.02.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:40:26 -0700 (PDT)
From:   =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin@pqrs.dk>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     arinc.unal@arinc9.com,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 1/7] ether: add EtherType for proprietary Realtek protocols
Date:   Mon, 18 Oct 2021 11:37:56 +0200
Message-Id: <20211018093804.3115191-2-alvin@pqrs.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211018093804.3115191-1-alvin@pqrs.dk>
References: <20211018093804.3115191-1-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

Add a new EtherType ETH_P_REALTEK to the if_ether.h uapi header. The
EtherType 0x8899 is used in a number of different protocols from Realtek
Semiconductor Corp [1], so no general assumptions should be made when
trying to decode such packets. Observed protocols include:

  0x1 - Realtek Remote Control protocol [2]
  0x2 - Echo protocol [2]
  0x3 - Loop detection protocol [2]
  0x4 - RTL8365MB 4- and 8-byte switch CPU tag protocols [3]
  0x9 - RTL8306 switch CPU tag protocol [4]
  0xA - RTL8366RB switch CPU tag protocol [4]

[1] https://lore.kernel.org/netdev/CACRpkdYQthFgjwVzHyK3DeYUOdcYyWmdjDPG=Rf9B3VrJ12Rzg@mail.gmail.com/
[2] https://www.wireshark.org/lists/ethereal-dev/200409/msg00090.html
[3] https://lore.kernel.org/netdev/20210822193145.1312668-4-alvin@pqrs.dk/
[4] https://lore.kernel.org/netdev/20200708122537.1341307-2-linus.walleij@linaro.org/

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---

v3 -> v4: no change

v2 -> v3: no change; collect Reviewed-by from Florian

v1 -> v2: no change; collect Reviewed-by from Vladimir

RFC -> v1: this patch is new


 include/uapi/linux/if_ether.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 5f589c7a8382..5da4ee234e0b 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -86,6 +86,7 @@
 					 * over Ethernet
 					 */
 #define ETH_P_PAE	0x888E		/* Port Access Entity (IEEE 802.1X) */
+#define ETH_P_REALTEK	0x8899          /* Multiple proprietary protocols */
 #define ETH_P_AOE	0x88A2		/* ATA over Ethernet		*/
 #define ETH_P_8021AD	0x88A8          /* 802.1ad Service VLAN		*/
 #define ETH_P_802_EX1	0x88B5		/* 802.1 Local Experimental 1.  */
-- 
2.32.0

