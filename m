Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 097E51D1C79
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 19:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389793AbgEMRlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 13:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732670AbgEMRlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 13:41:53 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE2CC061A0C;
        Wed, 13 May 2020 10:41:53 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x10so119163plr.4;
        Wed, 13 May 2020 10:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BcoMiaIrgROxQQJ2oZxeMA292wuTYKidHK+IlTOejF4=;
        b=rSmPoANZeSRk4ooAxIlJSkoOs+hph40jeKlh9rpgQKLYs8/qPS8nUAq0NhiBKNYsGD
         qt9lPAbUyv2fadWiVwFsw+E17H6rZIT3/Ym5LUD1mE1ZrA/IbI+ki76tx356qLcwgUn+
         MusExHMXe4N5aGFJOm8elAMNFPnRGTlLtt47lKjT8edQIFDuHa9uPjwiieQq8vm/jlRw
         s1e4obtuCdwCiesL6AA0EnL+ai9ClYLkKa2n9Gfur3l+ZH5T6P+uSsR21VRAjYpQ1fLC
         NQ0I5rMura9MZrlFMIszmBT3Ylbt5X8aq8mYJzuHreqEeYfr9EPJfptw6/i9Q7YM/VXA
         Qf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BcoMiaIrgROxQQJ2oZxeMA292wuTYKidHK+IlTOejF4=;
        b=bGNPdO5cfEKo7+gsZ9TfAZJDe0bsaFRvK4P4/2U3mQwVhu1zK0bkBhJ1B2svJlBQ9s
         +P5xzH3SXlFPaCNXxwi2Ts4Ez3/cx2n7R7ChHa1hYkMN6WNBkuGYpBGb3xrniuSBjQQV
         q89WIcXL8RRUoJ7BQXXF0EWhBQbE/2anjgghhLDZw8Wa9ORGZ05g6jRYDHyRXfYyHOwZ
         44a8hezF0/q2eTF42NK3C0Ph9B9dtJGsWqjGSN97U+0PtgaNAayJbMUDQla2lyWBoJAA
         QLt4Ti1HVqJ7TMlhzvhHdgxxoXmFsFGJd2xxVJSR9mtLMDliAeV0+//ju3l6pBhF2Sga
         rEbA==
X-Gm-Message-State: AOAM531u/AEEJpvjgsqKty8bvBX8U3gshO3GUL72Lae/mcFYAnW9eAXz
        vvoo9iA/SffNb6PoACZ3S6IkuipI
X-Google-Smtp-Source: ABdhPJw4rMDbcL8hQLD3Uxi9x5rGqyKGm6H1G6lfVGvmG/wQJAxVdgsTkxV0cuSImM39UTnxByiLQQ==
X-Received: by 2002:a17:902:c281:: with SMTP id i1mr250246pld.327.1589391712366;
        Wed, 13 May 2020 10:41:52 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d4sm274835pgk.2.2020.05.13.10.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 10:41:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, gregkh@linuxfoundation.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH stable-5.4.y] net: dsa: Do not make user port errors fatal
Date:   Wed, 13 May 2020 10:41:45 -0700
Message-Id: <20200513174145.10048-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit 86f8b1c01a0a537a73d2996615133be63cdf75db upstream

Prior to 1d27732f411d ("net: dsa: setup and teardown ports"), we would
not treat failures to set-up an user port as fatal, but after this
commit we would, which is a regression for some systems where interfaces
may be declared in the Device Tree, but the underlying hardware may not
be present (pluggable daughter cards for instance).

Fixes: 1d27732f411d ("net: dsa: setup and teardown ports")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/dsa/dsa2.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 716d265ba8ca..0f7f38c29579 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -461,18 +461,12 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
 
 			err = dsa_port_setup(dp);
 			if (err)
-				goto ports_teardown;
+				continue;
 		}
 	}
 
 	return 0;
 
-ports_teardown:
-	for (i = 0; i < port; i++)
-		dsa_port_teardown(&ds->ports[i]);
-
-	dsa_switch_teardown(ds);
-
 switch_teardown:
 	for (i = 0; i < device; i++) {
 		ds = dst->ds[i];
-- 
2.17.1

