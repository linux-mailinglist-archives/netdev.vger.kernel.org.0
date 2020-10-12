Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69BA28B001
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgJLIVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgJLIVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:21:44 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5461C0613CE;
        Mon, 12 Oct 2020 01:21:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lw21so21987481ejb.6;
        Mon, 12 Oct 2020 01:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XLSw4kk01QDTlGyCDpjTbXYryNnPNFLUaBj1auxatEE=;
        b=LduJxkBQrSrNHSKIi9bNM0SVbJKluwGhNNT2aFEdJAIcXQtnCSqfTLw3qowTIv7B0k
         Y2sdAA3ItnlB0Eyk9/Y+cX69aGW3HCYVWUtXlTAPogCWeG65EVyUOxvhsxvbLSgI/FXL
         1d2O6uk17pOmZozEIZASGi68BNeS0t94JAaVzmR0q7RaZTWdzRwxQ+2YVQ6SpOxOtYoa
         ogNJ3+MSqbpHQTIjYuj1zw3TFiNd4cDtzgkCvs8x6LTP/Cq33YL4P3S5oSfgqYivBiif
         gOykekdoeZpwX+yv2b5ceMCRDqgaPBLtKCCviCqQ/ZVVC+f568e5/iu/8ArkXLwT4h0I
         CsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XLSw4kk01QDTlGyCDpjTbXYryNnPNFLUaBj1auxatEE=;
        b=T7JyeEToPLM5G5iQLg64g39M/hgvhj/2HRminbH+G6f8NCO4i461NVwiNzDNYGa/ev
         kge2cYnDNm4Tj5gwlKeCesNJZPe/BJeEzzDUO6U41MvE5eZZtA3cosDyNi5/O90lzjZU
         DcR/iA0F63WAqV9Jk6MuSkVrm9e2RIS4pcsZlokRqtZk6Aw5aRqaeYW0eV7QkbwyWMvM
         a6U1DOPa2OmwqfRvP8WPLQzgii3RY4q4v5kFzGPfDcOzIvdrfoiqFjTEdf2UG6cyLbc2
         TDupCdpGpqHol6xqWfH1BgqPIGsZb4BOXhYzFIXev7RD50oYGIPMlhHGqj2yoloAPJXe
         H8FQ==
X-Gm-Message-State: AOAM531rKmmfWw+GYqIz+4/kKa+qrxBH+hEKl6qHhYQAIVJbcGG67Rww
        xOxJjX6KLDWPLUqkDMVuUAs=
X-Google-Smtp-Source: ABdhPJztw0xZvWbfVNUpz3P7tinaUOHzrkLOcdFj/n9SfGdrS0NBbEN2EP1ytjOc0wWKTJd8llR84Q==
X-Received: by 2002:a17:906:4e16:: with SMTP id z22mr20699549eju.527.1602490901540;
        Mon, 12 Oct 2020 01:21:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:f90c:2907:849f:701c? (p200300ea8f006a00f90c2907849f701c.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:f90c:2907:849f:701c])
        by smtp.googlemail.com with ESMTPSA id bu23sm10175810edb.69.2020.10.12.01.21.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 01:21:41 -0700 (PDT)
Subject: [PATCH net-next v2 01/12] net: add function dev_fetch_sw_netstats for
 fetching pcpu_sw_netstats
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Pravin B Shelar <pshelar@ovn.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        bridge@lists.linux-foundation.org
References: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
Message-ID: <6d16a338-52f5-df69-0020-6bc771a7d498@gmail.com>
Date:   Mon, 12 Oct 2020 10:01:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <d77b65de-1793-f808-66b5-aaa4e7c8a8f0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In several places the same code is used to populate rtnl_link_stats64
fields with data from pcpu_sw_netstats. Therefore factor out this code
to a new function dev_fetch_sw_netstats().

v2:
- constify argument netstats
- don't ignore netstats being NULL or an ERRPTR
- switch to EXPORT_SYMBOL_GPL

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a0df43b13..fa1d8d624 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4495,6 +4495,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 					struct rtnl_link_stats64 *storage);
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
+void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
+			   const struct pcpu_sw_netstats __percpu *netstats);
 
 extern int		netdev_max_backlog;
 extern int		netdev_tstamp_prequeue;
diff --git a/net/core/dev.c b/net/core/dev.c
index a146bac84..26bc10dec 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10319,6 +10319,40 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 }
 EXPORT_SYMBOL(dev_get_stats);
 
+/**
+ *	dev_fetch_sw_netstats - get per-cpu network device statistics
+ *	@s: place to store stats
+ *	@netstats: per-cpu network stats to read from
+ *
+ *	Read per-cpu network statistics and populate the related fields in @s.
+ */
+void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
+			   const struct pcpu_sw_netstats __percpu *netstats)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		const struct pcpu_sw_netstats *stats;
+		struct pcpu_sw_netstats tmp;
+		unsigned int start;
+
+		stats = per_cpu_ptr(netstats, cpu);
+		do {
+			start = u64_stats_fetch_begin_irq(&stats->syncp);
+			tmp.rx_packets = stats->rx_packets;
+			tmp.rx_bytes   = stats->rx_bytes;
+			tmp.tx_packets = stats->tx_packets;
+			tmp.tx_bytes   = stats->tx_bytes;
+		} while (u64_stats_fetch_retry_irq(&stats->syncp, start));
+
+		s->rx_packets += tmp.rx_packets;
+		s->rx_bytes   += tmp.rx_bytes;
+		s->tx_packets += tmp.tx_packets;
+		s->tx_bytes   += tmp.tx_bytes;
+	}
+}
+EXPORT_SYMBOL_GPL(dev_fetch_sw_netstats);
+
 struct netdev_queue *dev_ingress_queue_create(struct net_device *dev)
 {
 	struct netdev_queue *queue = dev_ingress_queue(dev);
-- 
2.28.0


