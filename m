Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2137121E15
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 23:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfLPWeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 17:34:04 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37160 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLPWeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 17:34:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so9224227wru.4
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 14:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=th1e0p8FGxL7h0mubKKoB5RmIzjYmSmgKi+JRiplIlo=;
        b=OJIuaawVDPIauThoVASo+U8IGE/snQpf0l2CaJ76ZzK9jgeCehnb7Sfglvvbb4yWPT
         rQzBkg7exiYKyUf89+qnyFxuRlW24q7w1MFd1vR+1tKhXMerKWOe0FSJYcp2DFC0NvPV
         wWBR917q7iUYHAJojYlFVeypruJG42G4L72vmKYYJf2T6FrmIdGkZFKVkL9Uwx6li7xH
         gTkST9G3v2+91EQggn/zRbVJJjmdABKH/9fbnyjZklPk12C+TqJDAsJOlG2iC2nbHTPb
         ZlSVvRpdyY+VprjkFDfTODX4QWRJ4Z7QbTe2o+FJ+rZnJiNubI1rGQUt823Xr5PAL3DD
         eb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=th1e0p8FGxL7h0mubKKoB5RmIzjYmSmgKi+JRiplIlo=;
        b=VlKjITDDIIYHYveVJwcC2ZeCU5tcBTHF/HzMiBYXbKu+XfO4DDfwGKtojb+kF07lgj
         SK8i77asaNcU7vGi1Y/n0zOqI8kGFBtvjpkn0D1Aw3sYi/j5bEIOUD7yCr4xMT0qNzJv
         S3X6XNgZncF1qwHcYyPWhobMjTBTSrQbeqVtUa0hllUkLhxdZLjqYUXTayTEefqSgPwO
         qgd4o/XnpYo8potwrxFisvzOq3lrnhqD0sRg4pIIQxrrzVfuFBDI5HOM1GrZTwxeuPGs
         Ht+0r4ntTbfAW0K9PELqJji4yzmpKToOTq1dhsqdOfuCSB/hk2rXxq9n7JVdQ//zDa1e
         pEPQ==
X-Gm-Message-State: APjAAAXWfRPAjI7pfceeUZEFIWuzykUEuryBKrr2WP+UM13MEmFsJrAb
        iy43R1AbmRt8JfN5S/DgQxA=
X-Google-Smtp-Source: APXvYqwHB9STZe4vbVUqR6pUa0ywvTc9bZvY7vFcleeooOfKtIl+/hEwLJdkGEQ1hwADo7jlAh1ZYw==
X-Received: by 2002:a5d:4dc9:: with SMTP id f9mr2131964wru.297.1576535642514;
        Mon, 16 Dec 2019 14:34:02 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id b16sm23628386wrj.23.2019.12.16.14.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 14:34:01 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net] net: dsa: sja1105: Fix double delivery of TX timestamps to socket error queue
Date:   Tue, 17 Dec 2019 00:33:44 +0200
Message-Id: <20191216223344.2261-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On the LS1021A-TSN board, it can be seen that under rare conditions,
ptp4l gets unexpected extra data in the event socket error queue.

This is because the DSA master driver (gianfar) has TX timestamping
logic along the lines of:

1. In gfar_start_xmit:
	do_tstamp = (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
		    priv->hwts_tx_en;
	(...)
	if (unlikely(do_tstamp))
		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
2. Later in gfar_clean_tx_ring:
	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS))
		(...)
		skb_tstamp_tx(skb, &shhwtstamps);

That is to say, between the first and second check, it drops
priv->hwts_tx_en (it assumes that it is the only one who can set
SKBTX_IN_PROGRESS, disregarding stacked net devices such as DSA switches
or PTP-capable PHY drivers). Any such driver (like sja1105 in this case)
that would set SKBTX_IN_PROGRESS would trip up this check and gianfar
would deliver a garbage TX timestamp for this skb too, which can in turn
have unpredictable and surprising effects to user space.

In fact gianfar is by far not the only driver which uses
SKBTX_IN_PROGRESS to identify skb's that need special handling. The flag
used to have a historical purpose and is now evaluated in the networking
stack in a single place: in __skb_tstamp_tx, only on the software
timestamping path (hwtstamps == NULL) which is not relevant for us.

So do the wise thing and drop the unneeded assignment. Even though this
patch alone will not protect against all classes of Ethernet driver TX
timestamping bugs, it will circumvent those related to the incorrect
interpretation of this skb tx flag.

Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 54258a25031d..038c83fbd9e8 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -668,8 +668,6 @@ void sja1105_ptp_txtstamp_skb(struct dsa_switch *ds, int slot,
 	u64 ticks, ts;
 	int rc;
 
-	skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-
 	mutex_lock(&ptp_data->lock);
 
 	rc = sja1105_ptpclkval_read(priv, &ticks, NULL);
-- 
2.17.1

