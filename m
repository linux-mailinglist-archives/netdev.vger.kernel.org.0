Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 711101632C0
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBRUQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:18 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42445 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbgBRUQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:15 -0500
Received: by mail-wr1-f68.google.com with SMTP id k11so25506900wrd.9;
        Tue, 18 Feb 2020 12:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uCOvUqXndu0FXRimsvIZXqxdLu4CTTZ92HjAKcokS0g=;
        b=UK8w573eUVjtwrWFsyz+LRkruPH1ZBEFG92oeS90NlT2H9eI86fHr+n42dWQwzuwkq
         K1L/tvXNu4okKMwz1PdlBzJIRoIfHCBXmYBAVSKviCEpdTFZHhht9QqeWBYfKNkM9Gwv
         FaMPp6JgMBIZviyMpe59eFnStTn6AgVzxpiAKWnHbPRu6tDgDla/c3HDymmu59AVH5rx
         /K07yVjVpP244IAWXLmhOzbX9xuJs1CPwl9cy5NJ+Iu/t1itOj4XtSNvH5SIWaHDg5d2
         Ja/YqDtFLp60T4EszVW16eRm9lluQ9WtUNS2hgI6w/L8rOCGjh1Svg1Rb6EwM8Zcj1Yg
         /Drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uCOvUqXndu0FXRimsvIZXqxdLu4CTTZ92HjAKcokS0g=;
        b=Kk6f7rX/P00/eLNyKEuAMtCdi373H/GFX1ikmhH13nb59x6+FtIT2ia0Eh1jrcuGen
         qM4tIo04JIzilLYf0VgANEgimB7QCW3n9fwf5E9dR0zBZ6plnzARb52CfyufgBk41Lmi
         xe/QHeizBnWySAl3AWUpvJuyVIHpwG+4hCmRO29SKexfeITKKu1qdP+XgUCChil+apYf
         mnAmMfpAbKh8P70qEWXSSV88+Mi7Jaaw5/XmE9YzdqL7LsBAIqYiFfDMJ5+X2YdGozqQ
         IME5gZXyXZo86Ac3XTb7NPW/4vaKcTX17xRlhVPtG+JMpdhD5tqKkFopiC6SMRayZ8k6
         8xsA==
X-Gm-Message-State: APjAAAU2gwG34v8+VcAuS7x2o26p7O22DsKgpRnbzoXq8S7Vui2G9nti
        Oz+eko8SOSpFvAKALIMsiUFbYxv4
X-Google-Smtp-Source: APXvYqygRztvLJ4KgoREMpd3P1KMgN7wV0tLI3gbOARfAosvcRH5DEZHla6u1s7G53VyLEaAsnL++A==
X-Received: by 2002:a5d:62d1:: with SMTP id o17mr31684406wrv.9.1582056973305;
        Tue, 18 Feb 2020 12:16:13 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id o77sm4907924wme.34.2020.02.18.12.16.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:12 -0800 (PST)
Subject: [PATCH net-next v2 05/13] enic: use new helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <f5b68c9f-ecdc-004d-b493-e0a7009ab5dd@gmail.com>
Date:   Tue, 18 Feb 2020 21:02:26 +0100
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
 drivers/net/ethernet/cisco/enic/enic_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index ddf60dc9a..3fc858b2c 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -696,8 +696,7 @@ static void enic_preload_tcp_csum(struct sk_buff *skb)
 		tcp_hdr(skb)->check = ~csum_tcpudp_magic(ip_hdr(skb)->saddr,
 			ip_hdr(skb)->daddr, 0, IPPROTO_TCP, 0);
 	} else if (skb->protocol == cpu_to_be16(ETH_P_IPV6)) {
-		tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-			&ipv6_hdr(skb)->daddr, 0, IPPROTO_TCP, 0);
+		tcp_v6_gso_csum_prep(skb);
 	}
 }
 
-- 
2.25.1


