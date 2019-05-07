Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC5216933
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfEGR2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 13:28:42 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37437 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfEGR2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 13:28:42 -0400
Received: by mail-lf1-f67.google.com with SMTP id h126so1297324lfh.4;
        Tue, 07 May 2019 10:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g2iUlVP64B2mzLY3euJhUyPC/WiAyczzIatnN26YIr4=;
        b=rBiraV4bY43nhAuKrEAKN6qbERrC5Fq3dLY/R6+/JYtmzEqLkeJD3AOzxDIxTYev3J
         TcFO7j0rlZIjByPFomGjkB2Hr+MIubYbVDUcFvEdZBrtOTgZ52bIUMjkK13KOXur9T4R
         ubmxwov172/40dUY9EN1k2pZcd+RAFGT+/6FXMpFzf7WMiniFUlGO0fOzN36EREl6oQd
         mdaX1+nJQendM9oBrLdgAtw9lbS6T6YM08P5yp7jnhLMlqQgmGHq9lHHbNUNbsFrY6sZ
         wCR0dwqc3j38tfcMv9O7xf++hC+bZ/2KfKvybXOJt3HmehhEF0xb6/RkDssYwKkzQ8Ax
         4QGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g2iUlVP64B2mzLY3euJhUyPC/WiAyczzIatnN26YIr4=;
        b=Gh4+LNQoFBVKLDVF8zl92X46Im5jYfarvEEhvfjNoSv2E1UVTzPuC+dhjS1V6iDSBt
         3mZuHQgzMonA+NVQ4yGjtoQBXr+QQYLIrdZXs9n66RxOz8ZFCH6wDLXp0Off4TL+Dxm5
         9AIJv2k5BLvjvsC0k++s4Bw5W3VhIatjbsr8MUD/Q8SAWokri3r+ejX9A7nRWf+MUvNQ
         /DRZjNQpE5cWbpKBAYSmHs6iicNMyHG3yC6Hb71Tb5EzTaQTRao5CZKymqpJe3X+RMnO
         WMbimAmDnWhkANrf5TsZowvyZJCNc4Won4Uwk1WQskZSagQD2XoVZG89e+bdPluMIAcw
         rhGg==
X-Gm-Message-State: APjAAAVOdEH3uEdLMLZQedlgDPOrH875eyvpexMqCUmWdsw2ujZiwipk
        UGAnteg1X72PSnf+c0EZCYc=
X-Google-Smtp-Source: APXvYqx1J8055B/Ne5M/re5N3dRbayqXHyOtNQFtQy2INVNg5cpa46gnD5H+HrYMbw7/vUX+AXC2vA==
X-Received: by 2002:ac2:42d5:: with SMTP id n21mr13109582lfl.162.1557250119915;
        Tue, 07 May 2019 10:28:39 -0700 (PDT)
Received: from satellite.lan ([2001:470:b62f:eee0:5a2:17b3:c882:c86c])
        by smtp.gmail.com with ESMTPSA id k10sm3309500ljh.86.2019.05.07.10.28.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 10:28:38 -0700 (PDT)
From:   Maxim Mikityanskiy <maxtram95@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [PATCH net] wireless: Skip directory when generating certificates
Date:   Tue,  7 May 2019 20:28:15 +0300
Message-Id: <20190507172815.17773-1-maxtram95@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 715a12334764 ("wireless: don't write C files on failures") drops
the `test -f $$f` check. The list of targets contains the
CONFIG_CFG80211_EXTRA_REGDB_KEYDIR directory itself, and this check used
to filter it out. After the check was removed, the extra keydir option
no longer works, failing with the following message:

od: 'standard input': read error: Is a directory

This commit restores the check to make extra keydir work again.

Fixes: 715a12334764 ("wireless: don't write C files on failures")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
---
 net/wireless/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 72a224ce8..2eee93985 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -39,6 +39,7 @@ $(obj)/extra-certs.c: $(CONFIG_CFG80211_EXTRA_REGDB_KEYDIR:"%"=%) \
 	@(set -e; \
 	  allf=""; \
 	  for f in $^ ; do \
+	      test -f $$f || continue;\
 	      # similar to hexdump -v -e '1/1 "0x%.2x," "\n"' \
 	      thisf=$$(od -An -v -tx1 < $$f | \
 	                   sed -e 's/ /\n/g' | \
-- 
2.21.0

