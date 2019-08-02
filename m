Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5569180108
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406033AbfHBTfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:35:06 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:43843 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406025AbfHBTfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:35:06 -0400
Received: by mail-qt1-f195.google.com with SMTP id w17so30769246qto.10
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yYJafEEydd/wIrDRcqnJ9QEXhch9JtaJwKbP3eBso64=;
        b=DHoGdhgPT2WZpbniRYKHWvDhNK/ur1Duvt4J+LkRGfKBZivlqzHWPzTFRfiGg92Odf
         JfjF1gwCD2rIcteAySCuqUMIJ2Ik0xc6AYYkfVZQFWLJy1DOTwVo2l9xgK5RlH0ecu3X
         mu6nYtzov2UeKb0njx1V6NWnyaisrgs6cCIA9f1hLhrPo+morV0GF0L2iLSbloNxYWRO
         lwO7zYHZS6dDZljyyJRDwIuPKiNAfuWjNW7t/fMUActZ62/9PiFbG3AYaHELrXavSMy4
         NYjQuOqneShAAI8IchJlTyBearqBoDwlE2p+dk/u79FUGa3AEbiylKLAajVRbOp8MIg9
         3JFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yYJafEEydd/wIrDRcqnJ9QEXhch9JtaJwKbP3eBso64=;
        b=TCPBZyU4TcBgz4mi8Lp90g+ZRhty4hgjv6CnjBmg+23izuOeMJsw3fmGKkOAVua0Uq
         dGz/4BLY2yQluyoJRW1phlxYsv0mj8vTExctL2nFz6xL2uxBotpIjRPex0xWHo7cq8aF
         Q9ohLRVt9S+g1uUPm0KztUM5K9W4HE3UM/LRe/tT5gK6xYINUkjW5SFJbLdmixigSzgW
         zTxyGOS9zozUjMW6o7ogGCW8r1U8Ds8psEDhAt96vyNCVi56eyDoIJdmwqppexGXdqka
         PVMgfKhaxRRT5tjr03vmn3Xl7549ULDvwdgvNusYDapgIYEn3ZAf8U12C4x0o4+t2Pnv
         +jXA==
X-Gm-Message-State: APjAAAUh5txnhmCvQ0h6hDqeFRLnvYtchA/MMlqneUKyrKgXMYV4Fbow
        CGTr1AvZuYHLGAnNGKRBvzJF2ulCW7M=
X-Google-Smtp-Source: APXvYqwHpmWeIej6MTtK9Q7W0Ts3E1npxN0lOkxrhwReZWl1+45eP5NyRzNF6QCGFfgEHxIVVxODIA==
X-Received: by 2002:a0c:acfb:: with SMTP id n56mr99025081qvc.87.1564774505187;
        Fri, 02 Aug 2019 12:35:05 -0700 (PDT)
Received: from localhost (modemcable184.147-23-96.mc.videotron.ca. [96.23.147.184])
        by smtp.gmail.com with ESMTPSA id c5sm34629993qkb.41.2019.08.02.12.35.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 12:35:04 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        linville@redhat.com, cphealy@gmail.com,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH ethtool] ethtool: dump nested registers
Date:   Fri,  2 Aug 2019 15:34:54 -0400
Message-Id: <20190802193455.17126-1-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usually kernel drivers set the regs->len value to the same length as
info->regdump_len, which was used for the allocation. In case where
regs->len is smaller than the allocated info->regdump_len length,
we may assume that the dump contains a nested set of registers.

This becomes handy for kernel drivers to expose registers of an
underlying network conduit unfortunately not exposed to userspace,
as found in network switching equipment for example.

This patch adds support for recursing into the dump operation if there
is enough room for a nested ethtool_drvinfo structure containing a
valid driver name, followed by a ethtool_regs structure like this:

    0      regs->len                        info->regdump_len
    v              v                                        v
    +--------------+-----------------+--------------+-- - --+
    | ethtool_regs | ethtool_drvinfo | ethtool_regs |       |
    +--------------+-----------------+--------------+-- - --+

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 ethtool.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index 05fe05a08..c0e2903c5 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1245,7 +1245,7 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
 
 	if (gregs_dump_raw) {
 		fwrite(regs->data, regs->len, 1, stdout);
-		return 0;
+		goto nested;
 	}
 
 	if (!gregs_dump_hex)
@@ -1253,7 +1253,7 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
 			if (!strncmp(driver_list[i].name, info->driver,
 				     ETHTOOL_BUSINFO_LEN)) {
 				if (driver_list[i].func(info, regs) == 0)
-					return 0;
+					goto nested;
 				/* This version (or some other
 				 * variation in the dump format) is
 				 * not handled; fall back to hex
@@ -1263,6 +1263,15 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
 
 	dump_hex(stdout, regs->data, regs->len, 0);
 
+nested:
+	/* Recurse dump if some drvinfo and regs structures are nested */
+	if (info->regdump_len > regs->len + sizeof(*info) + sizeof(*regs)) {
+		info = (struct ethtool_drvinfo *)(&regs->data[0] + regs->len);
+		regs = (struct ethtool_regs *)(&regs->data[0] + regs->len + sizeof(*info));
+
+		return dump_regs(gregs_dump_raw, gregs_dump_hex, info, regs);
+	}
+
 	return 0;
 }
 
-- 
2.22.0

