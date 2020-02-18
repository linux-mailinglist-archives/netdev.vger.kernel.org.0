Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF341632C1
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgBRUQT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:19 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:34486 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbgBRUQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:16 -0500
Received: by mail-wm1-f41.google.com with SMTP id s144so2976779wme.1;
        Tue, 18 Feb 2020 12:16:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VoDwB16SuE+XESOylFdFbMZhtyxQWDEo3Kn2cQMk/Ig=;
        b=XoWNbnGUmMt7KBVCcRP8yGX41WtBvXyiboHO/jy+N3jroImZcunKYAoAuJSra87Q3P
         j2VdKbgAwAqnw6B89KGRGq8M0vgWAsYh1liL1GbMzhZ0f70ywzJutu8dPXtH+kgQJkV4
         FFJxdCmE56e4tCORta8UcnK//R+EzxED0gPkTigLOmzvfuSm3k34HBFq6DtTWJ6ztKYn
         Tko81Rj4CK8oG4qiWLWw5I+A2R08QdV/cvS0cL+Z1ewxeiveY/Ad+mYi5V81DM6HFGBB
         r6iQ3tcDSltQOYu4GZqMN73d6fvb/G3oBDgwnkPoE7ze8eNubuO80ZG05Ajx14vv76p0
         LnnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VoDwB16SuE+XESOylFdFbMZhtyxQWDEo3Kn2cQMk/Ig=;
        b=SqBmGcRYd5SF43uu9uCD/26iRZtmWMQjgYmpCt13+oJSiKwn3AtmFAjbAeKG5B8HK4
         +HGWfcZQvhgZnp9j6wsWdYc/8GcZwoLZq7QPOf67So6j1AThcd1jPT8IlEZYg/umujcW
         w0LKn4xObWi0hLczbxp3Jf3m3867tIacrvklUreWmVf5xp4oWdM7qwqltj/ZMcHpkc9J
         agGocBzqOyTqIl3tuDovF3N0wweu9Txl8vgrrx+cz0qaqX0cNkCB143We1GZVJ7+7XkF
         ktk9Yw/mz28NJD6LcYmEO8LQLe4j8I65jgngkf9+jEMn4fTQYC2PIMC/FvxeQ8v4NrWG
         UceA==
X-Gm-Message-State: APjAAAVQqAmd+85j7nDjNvwK9ANq6NgXybmiQPfCMAX3xHp7EqkttcGD
        yUhOZhNTrOU15X+KGX+TYOvkQypc
X-Google-Smtp-Source: APXvYqz0iJyVWhzS3TWEjb0aiPmNZmsAU5SGBiGEo9x49CTL1lE3vcUUYblewvTLfkUE/5/XnzabnA==
X-Received: by 2002:a05:600c:114d:: with SMTP id z13mr460488wmz.105.1582056974499;
        Tue, 18 Feb 2020 12:16:14 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id f1sm7668322wro.85.2020.02.18.12.16.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:14 -0800 (PST)
Subject: [PATCH net-next v2 06/13] e1000(e): use new helper
 tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <47621909-1b75-e8d1-cf32-857c1601e0af@gmail.com>
Date:   Tue, 18 Feb 2020 21:05:02 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 6 +-----
 drivers/net/ethernet/intel/e1000e/netdev.c    | 5 +----
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 2bced34c1..f7103356e 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2715,11 +2715,7 @@ static int e1000_tso(struct e1000_adapter *adapter,
 			cmd_length = E1000_TXD_CMD_IP;
 			ipcse = skb_transport_offset(skb) - 1;
 		} else if (skb_is_gso_v6(skb)) {
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr,
-						 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb);
 			ipcse = 0;
 		}
 		ipcss = skb_network_offset(skb);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 0f02c7a5e..74379d2e9 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5461,10 +5461,7 @@ static int e1000_tso(struct e1000_ring *tx_ring, struct sk_buff *skb,
 		cmd_length = E1000_TXD_CMD_IP;
 		ipcse = skb_transport_offset(skb) - 1;
 	} else if (skb_is_gso_v6(skb)) {
-		ipv6_hdr(skb)->payload_len = 0;
-		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						       &ipv6_hdr(skb)->daddr,
-						       0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb);
 		ipcse = 0;
 	}
 	ipcss = skb_network_offset(skb);
-- 
2.25.1


