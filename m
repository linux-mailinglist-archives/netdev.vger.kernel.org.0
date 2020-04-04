Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB2D19E1E5
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgDDAVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:21:50 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46958 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgDDAVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:21:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id j17so10481362wru.13
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=MmHLepJOHx6MqjIR9dHWnxcWeICMt0CpI/MV4ZG9UaI=;
        b=QskivtY/pU1YUvAyNoZs0hlA4pjzb2v70pL/gwt7WKik3k9N5muapw4gd2Ok3o3zzb
         fqTGuKOiGt0UTcSKv0tV0wC4g8xOwx1W9GwKsCcrva/19DIESypXaqnI3heWpsY1KgaP
         cntf2aHaMt9GvE7MtGO988swQg87WEhCD3KMoasrKEzAMUk6tD3du+91mzqSDROYbKds
         ikghjvZGmahLHbkcclYdk4111Y1iaBOgmcXaI43zNcWwbHL6VkORd3wVSkZMmgr3gDck
         YqPxVOUsE/7WlToLmsLzOOalaYQJUuOTS5lF2S828CKPmWMDEe0hn+D0MJnXcdiu1EPy
         yL8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MmHLepJOHx6MqjIR9dHWnxcWeICMt0CpI/MV4ZG9UaI=;
        b=hMZiZDPS457oTgIaoBR0J4QvOZq0FlZ3CWPt2707aUtO4jqeKiqZ7CPdhEYqEydXud
         x9urbBXp13FoD8SQ8WKDcMrB3QRBMzfrtl3CJOqN8yFqhR2kfXjs/SCAHxPZC4ge4ehL
         +xXkfVjls/yd0cT1ZsRT98xt3VCtq6RxBnb9Nr00I3sES2eFHTXbSzick4stGPkpXYrq
         DthU4kYEIAo0MAG3qNv7xvLVk2EV2EftaBlm8nNajDRj9rXzeSXLYCSWIhmxNwO9lPA+
         HAtXrTbqyFF7XdYA3KwCQA3b5g5Xza1E3RMsRezG2DxLgofm+eczGHS4tKcePIRCFeca
         O7Kg==
X-Gm-Message-State: AGi0PuYdQhVK2VUu8eLc7py/ttfeL77tAhNB3HEw8gM56Q1tw912KFgV
        TWR1yLbIckm7MEfU2PmNe6EdTHFH
X-Google-Smtp-Source: APiQypKb9QGqWHCOnECkRvQBgLqEwzFPBaUQnqTVUk4J4oItn9nhpbpSk04DoBG5JnF1KUbQ1W48pA==
X-Received: by 2002:adf:904a:: with SMTP id h68mr10773598wrh.291.1585959706066;
        Fri, 03 Apr 2020 17:21:46 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s127sm13484116wmf.28.2020.04.03.17.21.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 17:21:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, linville@tuxdriver.com, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH] ethtool.c: Report transceiver correctly
Date:   Fri,  3 Apr 2020 17:21:35 -0700
Message-Id: <1585959695-26523-1-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the transition to the extended link settings ioctl API, the
kernel, up until commit 9b3004953503462a4fab31b85e44ae446d48f0bd
("ethtool: drop get_settings and set_settings callbacks") would support
the legacy link settings operation and report the transceiver type.
After this commit, we lost that information although the Linux PHY
library populates it correctly even with get_link_ksettings() method.

Ensure that we report the transceiver type correctly for such cases.

Fixes: 33133abf3b77 ("ethtool.c: add support for ETHTOOL_xLINKSETTINGS ioctls")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ethtool.c b/ethtool.c
index 1b4e08b6e60f..21748fc909eb 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -2497,8 +2497,8 @@ do_ioctl_glinksettings(struct cmd_context *ctx)
 	if (link_usettings == NULL)
 		return NULL;
 
-	/* keep transceiver 0 */
 	memcpy(&link_usettings->base, &ecmd.req, sizeof(link_usettings->base));
+	link_usettings->deprecated.transceiver = ecmd.req.transceiver;
 
 	/* copy link mode bitmaps */
 	u32_offs = 0;
-- 
2.7.4

