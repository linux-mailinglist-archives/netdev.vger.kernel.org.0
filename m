Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B95CCFD67
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbfJHPQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:16:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39518 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfJHPQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:16:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id v4so10944929pff.6
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 08:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=HpgMDO0y8NpLHlBoc1zHHS1hRFJIEnkYLrJIX17Y0cA=;
        b=HvhXXTRboE1ytKENW4aIJwsWx5nRKGe+IDGR9ldg+hthHG+jwg/uoLPGw3KAffAtWb
         LYhJeB9qeA+/gJHSN+JshUoCfP6bZ/HYM5vsNfVvGGcWAj4rNY7z6aPQDVxeX5V/mc2R
         EkV9VDzq0mMgfX4MXsRurK8+lKM4zzXZIb341HHMZnOt3Yc4CfxGQF1d+CTQKVdly/yh
         7JgK3yFA6l1jbutO5EtJnWRgNLG6WhoHFB9q2UdrxN4expBI120uEn3Lg9s/Y6IQ5wqV
         jqHy21SOYTZy2c5+TvL7UG1Gr/kEfrCDnRjnoPbk3dsBFvLavgqDDq79+8o0R16w6MrH
         XPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=HpgMDO0y8NpLHlBoc1zHHS1hRFJIEnkYLrJIX17Y0cA=;
        b=A+OcJvCwd89T+0Hkvrpd2A8hMkkEzPIYpfdZvwyV6vgte6VThKln/7Mz+mYTo80ajz
         u7J9yvEUTBQ/unApyQr3KYgTNaiNUnPnKGEZvGbubW9Y63IVC7YAlKDfr14u97vmxg5M
         XIqmpa08lzz/yV17TkgVegQiaNw7xcfp8Iw8KiG/BKxT1sog7WgXlRVM8kJjPHN9O6fJ
         05OiFJ4wTIQdD6wIHQApzQc+c6mItNY/s6vu671kAYXI9oCRvIIzSCi3/q9hTVbYIRFn
         D++1YKI/hsaiOXPkIdxiLpFCR7aqT23pxBVXIVchGx3o//Pzbe4eqAxlO5xmGQ0wHvjI
         ZxgA==
X-Gm-Message-State: APjAAAWYI6l3VJtCwtLfmcoSWLZXrlpWkuDk6yPugGbV2OPhHg8WDnCs
        EsZH6QuUrcypGzMbgxTyp0rYJPVo
X-Google-Smtp-Source: APXvYqzaNwrt8UQejIXorFC7Oun5AW7Uh6a0xKMhnw1OLbn6yN7blY5+g3ARwNQg/HT2zbxv2xiBZw==
X-Received: by 2002:a63:c449:: with SMTP id m9mr10828485pgg.159.1570547818324;
        Tue, 08 Oct 2019 08:16:58 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z2sm23397624pfq.58.2019.10.08.08.16.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 08:16:57 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jiri Benc <jbenc@redhat.com>,
        Thomas Graf <tgraf@suug.ch>, u9012063@gmail.com
Subject: [PATCHv2 net-next 4/6] vxlan: check tun_info options_len properly
Date:   Tue,  8 Oct 2019 23:16:14 +0800
Message-Id: <b870b739bf2819134a3de9f2a19132d978109e7a.1570547676.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <db1089611398f17980ddfb54568c95837928e5a9.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
 <d29fbb1833cea0e9aff96317b9e49f230ca6d3dc.1570547676.git.lucien.xin@gmail.com>
 <f73e560fafd61494146ff8f08bebead4b7ac6782.1570547676.git.lucien.xin@gmail.com>
 <db1089611398f17980ddfb54568c95837928e5a9.1570547676.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1570547676.git.lucien.xin@gmail.com>
References: <cover.1570547676.git.lucien.xin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to improve the tun_info options_len by dropping
the skb when TUNNEL_VXLAN_OPT is set but options_len is less
than vxlan_metadata. This can void a potential out-of-bounds
access on ip_tun_info.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 drivers/net/vxlan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 3d9bcc9..e0787286 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2487,9 +2487,11 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		vni = tunnel_id_to_key32(info->key.tun_id);
 		ifindex = 0;
 		dst_cache = &info->dst_cache;
-		if (info->options_len &&
-		    info->key.tun_flags & TUNNEL_VXLAN_OPT)
+		if (info->key.tun_flags & TUNNEL_VXLAN_OPT) {
+			if (info->options_len < sizeof(*md))
+				goto drop;
 			md = ip_tunnel_info_opts(info);
+		}
 		ttl = info->key.ttl;
 		tos = info->key.tos;
 		label = info->key.label;
-- 
2.1.0

