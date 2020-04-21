Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641DA1B1CCB
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgDUD1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgDUD1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:27:54 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA11C061A0E;
        Mon, 20 Apr 2020 20:27:53 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id t12so5861138edw.3;
        Mon, 20 Apr 2020 20:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OxlH8eu4ISm7adGkmALzBWn5f6m60AmIDHyxCco5Bf4=;
        b=Ruy3nYTZJ1OtNxnPy9gP/A5YZ/wEM59TSVYW5Fxb+OxaltPgjimazMhLrhf9PwV5dP
         cA9Ri+1l5BRoGuxKgxu9tEEEzjF7OscgJOM3Tcq069TRf0C/Hzzgqk4LDbuJi5VQlKlh
         ZU4sr1qvBR4xrMRljAKhFmxMeUfX1aF8f9s2cVzqGuTqj2hfGKRsS4asVI+L2+w2w9dM
         uTkptBz0upjor0sQzwpVeS6dGoxK1zphvHwAcGj5rzgVirKUFAlGNERfC7D4E2LtxZfz
         6IYTjH3LIvDmL/4BvZo71uSsErB7wuIWIahWX+ECEBnrsrywMyRWWij+9ce6p7lu588N
         B7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OxlH8eu4ISm7adGkmALzBWn5f6m60AmIDHyxCco5Bf4=;
        b=URNBoto36S3I8Yf1JMeaHlpRCx74l0g/8M6IFqJquvHz0KhWc67RnHRBWPvG342dUx
         tGynIRciu1nw1cN5SenDfer1H2o+U6Li8b4hnggagCjs0dGyseZDmUn0jILQceUU5kz/
         zph5zbC0FApnTODIymFyobSN2at5+7A/nvEE4OO00FySvMZ3HHTwkkDy6yEaoJeWW7yx
         Bd2YtjmT1U3jrVBJV/toBo8cvU/G2AhNrAUNIvvQBCulxv8xQVyvRGQhAZPxBJxFK2rT
         BeSrbrJ9D+MKQgsHvSBmhLoQ1woERt64CZ+lHHc6LuFC2jouvMeCa2RG+81+i7Wm9VUz
         W96A==
X-Gm-Message-State: AGi0Puam4mWQqS/0Fck6rothFQcpQUtbNVDGMpiiQtYILnqFjQZrO9NO
        MF9/+dKbaLZbmxjWSXUnk92UUe8l
X-Google-Smtp-Source: APiQypLXglxtgrOEazz6Neu308092C/i8HOcuFMS3J57WJAVbzn6mBHqTw/FOw+jJpEvYeophb8Tqw==
X-Received: by 2002:aa7:db0b:: with SMTP id t11mr6044986eds.304.1587439672455;
        Mon, 20 Apr 2020 20:27:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9sm216836edl.67.2020.04.20.20.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 20:27:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net v2 1/5] net: dsa: b53: Lookup VID in ARL searches when VLAN is enabled
Date:   Mon, 20 Apr 2020 20:26:51 -0700
Message-Id: <20200421032655.5537-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032655.5537-1-f.fainelli@gmail.com>
References: <20200421032655.5537-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When VLAN is enabled, and an ARL search is issued, we also need to
compare the full {MAC,VID} tuple before returning a successful search
result.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 68e2381694b9..fa9b9aca7b56 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1505,6 +1505,9 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			continue;
 		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
 			continue;
+		if (dev->vlan_enabled &&
+		    ((mac_vid >> ARLTBL_VID_S) & ARLTBL_VID_MASK) != vid)
+			continue;
 		*idx = i;
 	}
 
-- 
2.17.1

