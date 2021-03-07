Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF353330132
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 14:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhCGNY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 08:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhCGNXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 08:23:53 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485E4C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 05:23:53 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mj10so14616239ejb.5
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 05:23:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uI6Dnkf+UQJulENSpNHnUuItItXhz+lJcNOgII3EpWE=;
        b=SzwnD0rCVHD0QLZzVJwcx6gNhI+yAmWwzAibed8tzJe4eY+9ByBqUs+rQZEAfZApr+
         gG8ppQPznYk5vpbtgEQclDNUq2riyh7aceVmP/BIJ+YiD8lEdwt/jaRxlKuvik7dFz/M
         SItx2ppZbRNpBhbT+iXOFKZVdrL8VymL7p8QawmsFzFMNwoWxr17XwkYlHYMdB3kue7q
         /b6A7K7Z925XrncnIlPc1UuESIlYhVeBXy8lLeoZAKFJCBJ6SyNuSAUIUzb+WpUIBq1/
         3P78CQQqGnlbmaKDYN+VTa45KK5oqTHTg5NFTDPYYqZ7LfcmCgt5pacvY3+Qv8hv+Uxe
         +f0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uI6Dnkf+UQJulENSpNHnUuItItXhz+lJcNOgII3EpWE=;
        b=bV7xpZyf5HxV8haOGQe87ksA0/eA2rDypIw7r4KhQSNSaej9sFJXwkogE5GhAaK6rP
         Bq27Xtgi/RVZ1gsYCsbRY4iMQyr2KvZBFHVUq6WookiPI4ViSFfJqarZ6ywavlFG1Ipj
         dTsBE7xjXdE1RBfmKdY141H1qHBqgoHrRohOMLNBHUAR7iMTCpooZSsBrvomhhPPFpx1
         HVdpheK73B21IO5rK368rCIDVVoaAfh/GC+c/YFGXGmfdoWgIdGosbF0D0TYWQDAwt5P
         l1n4jEGNFOWtZ+98uZREwQrdioluaXewynx6iBMJ79UBiyHcuqxGlVDDUcb6iMhx8QE5
         6j0A==
X-Gm-Message-State: AOAM532GqWspYRb6EmKA3cT3BRvEbiHj+m+c5vgjqVz1KoPsCF8c40NA
        n5i7ighZ7VamBah5V/rXZ9A=
X-Google-Smtp-Source: ABdhPJwHVRclZetmPAizPJpqBe0UgJSwwb/LKQEVhpwGdDGu91mcWGFz4kQ+FKRCcwAIorbmj0PxBQ==
X-Received: by 2002:a17:906:f283:: with SMTP id gu3mr2937147ejb.91.1615123432027;
        Sun, 07 Mar 2021 05:23:52 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id gj26sm4168584ejb.67.2021.03.07.05.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 05:23:51 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH net 2/2] net: enetc: allow hardware timestamping on TX queues with tc-etf enabled
Date:   Sun,  7 Mar 2021 15:23:39 +0200
Message-Id: <20210307132339.2320009-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307132339.2320009-1-olteanv@gmail.com>
References: <20210307132339.2320009-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The txtime is passed to the driver in skb->skb_mstamp_ns, which is
actually in a union with skb->tstamp (the place where software
timestamps are kept).

Since commit b50a5c70ffa4 ("net: allow simultaneous SW and HW transmit
timestamping"), __sock_recv_timestamp has some logic for making sure
that the two calls to skb_tstamp_tx:

skb_tx_timestamp(skb) # Software timestamp in the driver
-> skb_tstamp_tx(skb, NULL)

and

skb_tstamp_tx(skb, &shhwtstamps) # Hardware timestamp in the driver

will both do the right thing and in a race-free manner, meaning that
skb_tx_timestamp will deliver a cmsg with the software timestamp only,
and skb_tstamp_tx with a non-NULL hwtstamps argument will deliver a cmsg
with the hardware timestamp only.

Why are races even possible? Well, because although the software timestamp
skb->tstamp is private per skb, the hardware timestamp skb_hwtstamps(skb)
lives in skb_shinfo(skb), an area which is shared between skbs and their
clones. And skb_tstamp_tx works by cloning the packets when timestamping
them, therefore attempting to perform hardware timestamping on an skb's
clone will also change the hardware timestamp of the original skb. And
the original skb might have been yet again cloned for software
timestamping, at an earlier stage.

So the logic in __sock_recv_timestamp can't be as simple as saying
"does this skb have a hardware timestamp? if yes I'll send the hardware
timestamp to the socket, otherwise I'll send the software timestamp",
precisely because the hardware timestamp is shared.
Instead, it's quite the other way around: __sock_recv_timestamp says
"does this skb have a software timestamp? if yes, I'll send the software
timestamp, otherwise the hardware one". This works because the software
timestamp is not shared with clones.

But that means we have a problem when we attempt hardware timestamping
with skbs that don't have the skb->tstamp == 0. __sock_recv_timestamp
will say "oh, yeah, this must be some sort of odd clone" and will not
deliver the hardware timestamp to the socket. And this is exactly what
is happening when we have txtime enabled on the socket: as mentioned,
that is put in a union with skb->tstamp, so it is quite easy to mistake
it.

Do what other drivers do (intel igb/igc) and write zero to skb->tstamp
before taking the hardware timestamp. It's of no use to us now (we're
already on the TX confirmation path).

Fixes: 0d08c9ec7d6e ("enetc: add support time specific departure base on the qos etf")
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 30d7d4e83900..09471329f3a3 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -344,6 +344,12 @@ static void enetc_tstamp_tx(struct sk_buff *skb, u64 tstamp)
 	if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) {
 		memset(&shhwtstamps, 0, sizeof(shhwtstamps));
 		shhwtstamps.hwtstamp = ns_to_ktime(tstamp);
+		/* Ensure skb_mstamp_ns, which might have been populated with
+		 * the txtime, is not mistaken for a software timestamp,
+		 * because this will prevent the dispatch of our hardware
+		 * timestamp to the socket.
+		 */
+		skb->tstamp = ktime_set(0, 0);
 		skb_tstamp_tx(skb, &shhwtstamps);
 	}
 }
-- 
2.25.1

