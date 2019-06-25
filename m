Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8718155C70
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfFYXkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35740 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726068AbfFYXkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:14 -0400
Received: by mail-wr1-f67.google.com with SMTP id f15so533332wrp.2
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Cdv7OB0kuTlUMdZQk67N3fYlXMSHNZN1SzgwkGWzLr0=;
        b=VC5EGcbdCk45mLelfpsgG6fALrhP/ys9Y9/ToCXVtP2QCwnmLOERC+HixWjpnXch2W
         xmAKN8T9ND+WaU1JSTfj3Onqgkz/a5rXKIRK+tZCM9ixIvnsslpcy4hsJue1Q3DVQRIW
         x92Ikz5eu9+6KzmFvUOxjfLp31rIkHZWU9w5ts7SXY5ZJQZ10ZdKloI6iy6xzZ5epIvO
         XnJY1W4A2vzQGeqEJ9cMIlVQi4EMOqrClb43hFCCRTcnh1YO0SNquFBIowLDdYES9EJ3
         tAW1+v05f5rCt0Cz3sTp9oaYcvrtM3sgM+iQAdcXHoaLIsjaxCFYUfEjvoQWlp0K8SUW
         jPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Cdv7OB0kuTlUMdZQk67N3fYlXMSHNZN1SzgwkGWzLr0=;
        b=M1+K1FCG4l6uqqun8HR1KpYzMo+Jw2yYZpk1HfPldWJ/AzZbOYSuzcn68FNP/k1Vep
         bbmQ4ziBMzZQKqjrPwYJfb6NHNjl2H5zP4qaHqX0E1ariult5Z+GbLjUhdAs512mqAwj
         tMmu53a9nBKkBRgkve0RA1R2TTbwha+SzDHFGEKE1NA41Rd3jJYTCwfixxf8i3S5C+XP
         3mrEBY0MoWsEwFlhzHxu1NCJbqhwm9TjzmxZQJFCNxErUPvlxctakx7vY7vVDarpyLBC
         dEFunnLeWvDpFIVW1+JJCrf4Rs/6P/ae4vKJLS3ZYBImNzAENJX7yV2Mbpr8+r1hf8NB
         JHnw==
X-Gm-Message-State: APjAAAXKBqaGp85RGMi62Z18tZoXLonwXaIHdEQG8ZmEzg9RkiEce04r
        SfrjlRqkrty/OKmnv0kELzw=
X-Google-Smtp-Source: APXvYqxNcidkuPknv07TqeQrs7XDD/YxkT6AMPn/HkSY3ImOwTX8KzyWsRZF4pN4IRm5z61lRLEo+w==
X-Received: by 2002:a5d:49c4:: with SMTP id t4mr487881wrs.318.1561506012929;
        Tue, 25 Jun 2019 16:40:12 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:12 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 10/10] net: dsa: sja1105: Implement is_static for FDB entries on E/T
Date:   Wed, 26 Jun 2019 02:39:42 +0300
Message-Id: <20190625233942.1946-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first generation switches don't tell us through the dynamic config
interface whether the dumped FDB entries are static or not (the LOCKEDS
bit from P/Q/R/S).

However, now that we're keeping a mirror of all 'bridge fdb' commands in
the static config, this is an opportunity to compare a dumped FDB entry
to the driver's private database.  After all, what makes an entry static
is that *we* added it.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index cadee7694935..caebf76eaa3e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1218,6 +1218,21 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 			continue;
 		u64_to_ether_addr(l2_lookup.macaddr, macaddr);
 
+		/* On SJA1105 E/T, the switch doesn't implement the LOCKEDS
+		 * bit, so it doesn't tell us whether a FDB entry is static
+		 * or not.
+		 * But, of course, we can find out - we're the ones who added
+		 * it in the first place.
+		 */
+		if (priv->info->device_id == SJA1105E_DEVICE_ID ||
+		    priv->info->device_id == SJA1105T_DEVICE_ID) {
+			int match;
+
+			match = sja1105_find_static_fdb_entry(priv, port,
+							      &l2_lookup);
+			l2_lookup.lockeds = (match >= 0);
+		}
+
 		/* We need to hide the dsa_8021q VLANs from the user. This
 		 * basically means hiding the duplicates and only showing
 		 * the pvid that is supposed to be active in standalone and
-- 
2.17.1

