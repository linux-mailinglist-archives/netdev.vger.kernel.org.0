Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 086333D5BF
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392065AbfFKSsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:48:06 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52204 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392060AbfFKSsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:48:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so4041832wma.1;
        Tue, 11 Jun 2019 11:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DxPgzH7JmzfidJ4UnyHoyfbbx6kdh98v9wymlp4AUqk=;
        b=LwLWaZmu5HuVedTxkD7GZN90TxdMTTacKvHGGUODRDIYPtxtbKlgmuQZxK1XEblKBH
         2H7mfrgZlAt/FztR69wqmzTv15Qc8lxM1R+UKrkz+u/lHD+G6oxjZuLFnsOZxWl2otZL
         ZnpA0pIEJLhKsUW+pXxJC2u3ihVC0W7AZI+3VjNlwI7XAK0lLhY7l7jYAIKqwwQRpTGJ
         vAnRkAJcHcvUhC7jFBXMQsHJQn1D6zlcK40d06mxPIKOF4HAHWVTyUh2DVvrfhJx/Um+
         39zFdlGQ1MSJNjVt7+qR1efrKgwEmtoOEwKkJz5U+0JAanuIiqtEknxwbXuqm646Kgfk
         O6QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DxPgzH7JmzfidJ4UnyHoyfbbx6kdh98v9wymlp4AUqk=;
        b=tHRRBCiX1PbHK3hzb/pXAuzzYVP1ZXA22RRHh4sPACMEat6Q/br2McCliqZ1+qtYTS
         43OkpHRx91r2spv0oxbeV2RyPxf4jZxTCo/KfvuCPFXXMEFJldZnrMF7hwjDdcdXcQ8c
         CcfLj+9knlB72EPUaL2mPED+N4e5djk0EmbfULxd0SjN3LRFniEv+uLtK4imYEpL4xUc
         Rv91BzlStrxzlfbsgkKCcAXKWOQV1mWinqv9oWSB+jJ2EDRG6tkGtdgzGwIs9wb1xkTN
         Xs7AWq6AWItrL6G7x9gA05pyPQ/kj8qDKR8JrQeyGLI8xnLWXhO3C6eEWHqQ+QMX6hMt
         Gh2w==
X-Gm-Message-State: APjAAAWm87zuCDeCx9VtVFz5LggsS0nkwc9egYRlL4SMgpWPg75j9J2y
        wf4o+mu3X7iFlgD1sEWAnHo=
X-Google-Smtp-Source: APXvYqwbyObToAW8Km9r5qKriKBBaEXn+rcKOuoHpcF2P3H1s7GPnB74jTzka0u6DteFTPMPMrvSXw==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr18811496wmj.155.1560278883705;
        Tue, 11 Jun 2019 11:48:03 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id x83sm3252909wmb.42.2019.06.11.11.48.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 11:48:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        rdunlap@infradead.org, sfr@canb.auug.org.au, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-next@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: tag_sja1105: Select CONFIG_PACKING
Date:   Tue, 11 Jun 2019 21:47:45 +0300
Message-Id: <20190611184745.6104-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packing facility is needed to decode Ethernet meta frames containing
source port and RX timestamping information.

The DSA driver selects CONFIG_PACKING, but the tagger did not, and since
taggers can be now compiled as modules independently from the drivers
themselves, this is an issue now, as CONFIG_PACKING is disabled by
default on all architectures.

Fixes: e53e18a6fe4d ("net: dsa: sja1105: Receive and decode meta frames")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
---
 net/dsa/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index d449f78c1bd0..6e942dda1bcd 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -106,6 +106,7 @@ config NET_DSA_TAG_LAN9303
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
 	select NET_DSA_TAG_8021Q
+	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
 	  NXP SJA1105 switch family. Both the native tagging protocol (which
-- 
2.17.1

