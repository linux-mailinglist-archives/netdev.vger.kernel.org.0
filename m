Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F0DDD04A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406167AbfJRUbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:31:22 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40866 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405935AbfJRUbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:31:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sR0WxNFiLQG1mNGsdN68Cy5Ew7xl7kJ+U4NsYq6Y5us=; b=AFXgvEX/oaixxW1nWWhuLUezU
        24b17AoJ7a7ZW16eOYeVzrvMvldAfKGBTReheDUQdW+rsxwtjEsNFD4LGqKczxK6n+IsV2CI06aKT
        z+8I1UL+OwF2CmjtTRkIjKj9soCIjnzf+ZuRMx3KeeWNikYomC0ELIr+YlWaYG5+YFHWH9gTY2D2a
        XqkLfGl71le4xOlmh39xnbXfW8uubnTKmmsm54qWSCNUoGUvKOAaaoEXlET7OrBO/wLPQzrZw9AjX
        wXhnte0N5FW0GVTUwoq/5dLVyWa9kxsux6B1dZXyaEXEK84YtlmycWYnbl2kIS26RCt2ZwkDuDvhd
        MP2w1TTcA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:48742 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iLYu2-0001Te-L4; Fri, 18 Oct 2019 21:31:14 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1iLYu1-0000sp-W5; Fri, 18 Oct 2019 21:31:14 +0100
From:   Russell King <rmk@armlinux.org.uk>
To:     netdev@vger.kernel.org
Cc:     linville@tuxdriver.com, andrew@lunn.ch, f.fainelli@gmail.com
Subject: [PATCH 1/3] ethtool: correctly interpret bitrate of 255
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1iLYu1-0000sp-W5@rmk-PC.armlinux.org.uk>
Date:   Fri, 18 Oct 2019 21:31:13 +0100
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

A bitrate of 255 is special, it means the bitrate is encoded in
byte 66 in units of 250MBaud.  Add support for parsing these bit
rates.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 sfpid.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/sfpid.c b/sfpid.c
index a1753d3a535f..71f0939c6282 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -328,11 +328,24 @@ void sff8079_show_all(const __u8 *id)
 {
 	sff8079_show_identifier(id);
 	if (((id[0] == 0x02) || (id[0] == 0x03)) && (id[1] == 0x04)) {
+		unsigned int br_nom, br_min, br_max;
+
+		if (id[12] == 0) {
+			br_nom = br_min = br_max = 0;
+		} else if (id[12] == 255) {
+			br_nom = id[66] * 250;
+			br_max = id[67];
+			br_min = id[67];
+		} else {
+			br_nom = id[12] * 100;
+			br_max = id[66];
+			br_min = id[67];
+		}
 		sff8079_show_ext_identifier(id);
 		sff8079_show_connector(id);
 		sff8079_show_transceiver(id);
 		sff8079_show_encoding(id);
-		sff8079_show_value_with_unit(id, 12, "BR, Nominal", 100, "MBd");
+		printf("\t%-41s : %u%s\n", "BR, Nominal", br_nom, "MBd");
 		sff8079_show_rate_identifier(id);
 		sff8079_show_value_with_unit(id, 14,
 					     "Length (SMF,km)", 1, "km");
@@ -348,8 +361,8 @@ void sff8079_show_all(const __u8 *id)
 		sff8079_show_ascii(id, 40, 55, "Vendor PN");
 		sff8079_show_ascii(id, 56, 59, "Vendor rev");
 		sff8079_show_options(id);
-		sff8079_show_value_with_unit(id, 66, "BR margin, max", 1, "%");
-		sff8079_show_value_with_unit(id, 67, "BR margin, min", 1, "%");
+		printf("\t%-41s : %u%s\n", "BR margin, max", br_max, "%");
+		printf("\t%-41s : %u%s\n", "BR margin, min", br_min, "%");
 		sff8079_show_ascii(id, 68, 83, "Vendor SN");
 		sff8079_show_ascii(id, 84, 91, "Date code");
 	}
-- 
2.7.4

