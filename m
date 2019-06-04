Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E032634E5F
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfFDRIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:08:20 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40919 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728058AbfFDRIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:18 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so172803wmj.5;
        Tue, 04 Jun 2019 10:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FLAiDj+mXOnDSVqTmnzN/1DEYoCSfMYK/HuWzqPDcvs=;
        b=u27Ui1qN+Vn4HTnIxR7mm4be/B5y5a2Zd3XXgFQZpOr53PI/Dtg9LjPa8F/9AouFSA
         j3j5K7NMt5ewIEtTjy2JST0q9oLuKl+Au1j/WYdz1tt0hJqqdClUY46etBVTcygAEFal
         cVbGcKrd4Fq6u53FYeQCnNkfJR9rPBfGV0gWo6Qmz1cpRk8ImzNnP8G1Ucf14IeVELIr
         TFxB8HKohGnhTFartODCDXIZsH4pGVqCloDSVQweOPHpMUtKPG///cVwKaY3QTHoSmCt
         XN4ZG7QKE3WUqpWcGlC+FOQBncatMTqYeh44TY3LqzD8OFVYTPqkh0yTYPvO2N3VJUm0
         4TlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FLAiDj+mXOnDSVqTmnzN/1DEYoCSfMYK/HuWzqPDcvs=;
        b=Nvl9Q0UI0zBSXVAD1kGKbZ7Bunf4hTIuaRrl19RsBs+kbyDzIQgwNJAKRfhM8k2Fqi
         zJqD22isiCZS3fwN8ePRqXMgk/we792NBRMwanGHwvKnT8hxzatfVK9W4SOTyzUcEEPX
         xyzDqkJisin1aZa8An/AkopLhlFHGVkeFzWO2sL5BkRMeBBYDYBReuxii5ryPgmhS7w0
         X+KTRMGNtuvf4MY1rgt82HLaNJrSDIQxG8q1pWjrwN+xhEDaEHyq4/MQzsentb+9NfQ5
         hsniUxoUYBp7a7R1qVqiHc3FC3WBVVdWbjy3iR+PFKmR4t9zrvfyL90LcOH9qsqzHf6I
         k47Q==
X-Gm-Message-State: APjAAAUiSX0xvDseb5P24kxbw/pgRdrc1pUHKDofRWk41dkxuLsyDWzZ
        UIBoEWmQFmZlbzbe+nURkC8=
X-Google-Smtp-Source: APXvYqyqtFGcURcLGZfhnjbqdLBsX8mNG7PpPvAXLbDg+dVg+StDkaNwyixT4PJrvpgWFe/ObK1qQw==
X-Received: by 2002:a1c:1bd0:: with SMTP id b199mr4612888wmb.128.1559668096706;
        Tue, 04 Jun 2019 10:08:16 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:16 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 12/17] net: dsa: sja1105: Make sja1105_is_link_local not match meta frames
Date:   Tue,  4 Jun 2019 20:07:51 +0300
Message-Id: <20190604170756.14338-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
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
Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 include/linux/dsa/sja1105.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 4f09743b4713..b9619d9fca4c 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -43,6 +43,8 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 	const struct ethhdr *hdr = eth_hdr(skb);
 	u64 dmac = ether_addr_to_u64(hdr->h_dest);
 
+	if (ntohs(hdr->h_proto) == ETH_P_SJA1105_META)
+		return false;
 	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
 		    SJA1105_LINKLOCAL_FILTER_A)
 		return true;
-- 
2.17.1

