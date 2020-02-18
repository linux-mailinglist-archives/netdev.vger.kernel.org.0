Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315821632C4
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgBRUQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:25 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55208 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726875AbgBRUQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:22 -0500
Received: by mail-wm1-f65.google.com with SMTP id n3so1904082wmk.4;
        Tue, 18 Feb 2020 12:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P04rn9lFXpmxUOEq7MJs3reKsxv52XdBYh7sLajh3CY=;
        b=FW4MonpJa2N0pddv7lUanWtAX779jwjYA7p5umStKtEpH7S74naMUfR9GiKJB6oT70
         /EXBZ5Nr2ETHlbAvkiU3ExXuhEkN3dVYdB7TsCvnS+pgGIoooWTdOc2hZfmqNKB9x65k
         lxc8OX6KOlNDO1ibspOIXe3ihI2ccVLOZZNIoaxxgtk2R/d19BzWP4xeWTiZhqHuwQT1
         3doutBf8dp/LcvleJCppISFwTLlgCEkOwCDuXX5FFZaTsDJyhEYQEfOI9RCgeV0y+1HF
         qyLJtoOr7upsCTUSDiJ/XsBHX8m6WfoG5b7glrxAESk4dHXLDvFAjbiX4GWmtOrpKvMC
         yPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P04rn9lFXpmxUOEq7MJs3reKsxv52XdBYh7sLajh3CY=;
        b=HZR3JUaFMEQGfmL17OVyoIFnoDqHqmrPvrDd+XT2C51DkhaVA5P8od+A6U5vULFY2r
         xT6ZwgbOkxQU9u0j1A+RPk95ra4MAmwYHlwWj3yciEnoZlkolyXZEkIhMdhffrAnQx4k
         88uc663OEl244rWwURMOeeLwSr/XDmPvLlf89KgpsgVzjhoWzVJ3IPm7Mq+8J5OJcq/L
         12Z/t6BzA4upT8G3Ko/uY77pMSdrktPqZI06oHacm4AuIDwmf55h+VzT83P3z02RsWol
         xHOQnLcAEJ55RtT4I5GY5vU+0rBLUzqJ2o+kVpL5xogiQCXOPqtLj7pLzLCjiXudBjO8
         8S1g==
X-Gm-Message-State: APjAAAWZLw3ITXsbuxriYt1ycsoL0xeJycInxIwXM6I0b4obEtPeApqt
        eeM4Ei6D1Vq6HHb2XrnWXWO0iGOO
X-Google-Smtp-Source: APXvYqxWxx3vX4zkRPsVLD6wkEKUHPEBac8V27LgRCjAP9sRfDhzHOQQ/cKZrdyd4rt60fN/4Kcr2A==
X-Received: by 2002:a05:600c:291d:: with SMTP id i29mr5098417wmd.39.1582056979539;
        Tue, 18 Feb 2020 12:16:19 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id t9sm7890993wrv.63.2020.02.18.12.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:19 -0800 (PST)
Subject: [PATCH net-next v2 11/13] hv_netvsc: use new helper
 tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <52eb76b1-5acd-9d88-1496-889504b60e92@gmail.com>
Date:   Tue, 18 Feb 2020 21:11:43 +0100
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
---
 drivers/net/hyperv/netvsc_drv.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 65e12cb07..5ee282b20 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -638,10 +638,7 @@ static int netvsc_xmit(struct sk_buff *skb, struct net_device *net, bool xdp_tx)
 		} else {
 			lso_info->lso_v2_transmit.ip_version =
 				NDIS_TCP_LARGE_SEND_OFFLOAD_IPV6;
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr, 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb);
 		}
 		lso_info->lso_v2_transmit.tcp_header_offset = skb_transport_offset(skb);
 		lso_info->lso_v2_transmit.mss = skb_shinfo(skb)->gso_size;
-- 
2.25.1


