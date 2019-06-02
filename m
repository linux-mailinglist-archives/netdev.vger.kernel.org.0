Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E0832502
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfFBVkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:40:35 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36374 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfFBVkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:40:33 -0400
Received: by mail-wm1-f67.google.com with SMTP id v22so9079336wml.1;
        Sun, 02 Jun 2019 14:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SPHXrT98d38k/TlFB66/F3KoZM0UfqZvX0L1Tz2/VVU=;
        b=KoPEandKediCPGpVvdpsdhYvddln6JH1ek2g9hQA2tE2Y83dueaB7mA9Stwq9LA8vF
         2lPNPQUjmbTyJf+LCMOzlgZs+ukxCf1rgvDqdsWceDAZu7WT9ze74yjgzj1tFcVfQkYm
         Z481x/LERtgKBEEAlyjpD5kRYUavrG2BfVR0/hwXjNdbmb6xCAbQ/2l6jgbDL0nzSdel
         3Xw7H6ZKz0sSOmvBxOGy31Vdr5RrFKL+zCBk69MoZwOjspcIDaNBqycH72ytZc+HU3BZ
         sesepPKV6sNL59IEktxZBL/a6AR/WB4HQitL6hor6Egru/60QfW+hfyyXgjeFsU2d1k3
         508Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SPHXrT98d38k/TlFB66/F3KoZM0UfqZvX0L1Tz2/VVU=;
        b=fkAvT0gIO6sshv+deYIi4qrbYI5zbcgGrbJxTsFhn3ctXH0+EAKcOm8hdRXmW0Gs5o
         gM0hh9cCxK7s5ofLSRINpjtduRxh6OkT/kjYuPTXKxlkGNHe74aJfHtRd/Uq2jXIA9fw
         2BB7MbWcI/FeI9piU09+tjV/+zwKMpWSJd4qE2zdwHh8afCMVbsbDh22ZxhppNWi6+1h
         52xxV45nxoR+F6WQ4nG8KlK2ETA8bmUU9ZXW6shagstJMxsDoLmBUcvCuiaoYBfXlnQI
         NILWXEmMP/EF839LoaqurMcSk3/Ogep9Vl2Z12TdMVZJC46x6unYRt/jFuwCHcmuFfIJ
         AIwg==
X-Gm-Message-State: APjAAAVutaB8alb3zvcnRU9mWCvV2XEGJ+275H8ueQ9IgNg5/6qtSoxk
        XeQz0oVPghkrcZUqySe7NxI=
X-Google-Smtp-Source: APXvYqxjvZidMwF9JCIkZJvvjEN3PqIiqRCzg4/kImw4f11tW+/fPV6mORdLQgfIfdnQS+/awvzJ3g==
X-Received: by 2002:a7b:c549:: with SMTP id j9mr152670wmk.114.1559511631652;
        Sun, 02 Jun 2019 14:40:31 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id 65sm26486793wro.85.2019.06.02.14.40.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:40:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 08/10] net: dsa: sja1105: Make sja1105_is_link_local not match meta frames
Date:   Mon,  3 Jun 2019 00:39:24 +0300
Message-Id: <20190602213926.2290-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
References: <20190602213926.2290-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although meta frames are configured to be sent at SJA1105_META_DMAC
(01-80-C2-00-00-0E) which is a multicast MAC address that would also be
trapped by the switch to the CPU, were it to receive it on a front-panel
port, meta frames are conceptually not link-local frames, they only
carry their RX timestamps.

The choice of sending meta frames at a multicast DMAC is a pragmatic
one, to avoid installing an extra entry to the DSA master port's
multicast MAC filter.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:

Patch is new.

 include/linux/dsa/sja1105.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index f3237afed35a..d64e56d6c521 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -31,6 +31,8 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 	const struct ethhdr *hdr = eth_hdr(skb);
 	u64 dmac = ether_addr_to_u64(hdr->h_dest);
 
+	if (ntohs(hdr->h_proto) == ETH_P_SJA1105_META)
+		return false;
 	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
 		    SJA1105_LINKLOCAL_FILTER_A)
 		return true;
-- 
2.17.1

