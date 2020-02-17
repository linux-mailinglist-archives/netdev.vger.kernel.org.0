Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A476161CDB
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 22:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgBQVkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 16:40:17 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43500 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgBQVkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 16:40:17 -0500
Received: by mail-wr1-f66.google.com with SMTP id r11so21446600wrq.10;
        Mon, 17 Feb 2020 13:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1aa7piJglqlHorzP0nTQ8z4WjoZxJmZqjfY8eaEkqu4=;
        b=tSRnrM/ojHaLMFsnjVlQrUwR6Gx/Zy6c3bJmmG8RXPmNT4t8iDXR01c5nf2DDk6Rra
         +95rTi2xqi2cvZgckQOl1A277GeLfG45IMp4aOLLygAN7UrkR3ZuNtOOTwygRv0HJunL
         ONfWQMrFYdki9B3gbYg3Fm1mXBY128L5Oj7GyobUsxXrRWefKBD1RPu1lvoYPOTqmz44
         G1PcXWLvX/H74ZNaUuGEmAhjvBM8gipj5LLiM+WAUR5HJVpZVyO6Z1fjY1XSqnW6bJLc
         bTzwRq5cYjFmw9kUwnECmPu6/tJDhu9H6sQD2ZGGSvyJ9g8KmqAhWP+dmUnTAEjI67Tu
         EK9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1aa7piJglqlHorzP0nTQ8z4WjoZxJmZqjfY8eaEkqu4=;
        b=q2dwkl+EMcFnzMfjO+hVJq1IqoCpm+98/LxUyE73jRuCI8c2UO67pCpsgcT/l3g6AM
         bAOm5LCJq6EoHWr+vjSaGnpegFEIWBCwf/nTBNDZHji2mNueBWVFG37pVC/ZLQHa49QY
         lNe8nId729TBDrLP0VALOYOkmoFSC4YznQ8wkL857s+uj39iia4MNQe6/A1yLTxpAacF
         +kXa0s8Dpp/T3oPWF6NwvR0Iug2HGErHWdS8p7LLe0KWThoyMZ+Qt8wp2suwY1oQvOJe
         V8pmUlvhBV1Af5Z0BG5Uyw2reyjnCneHoe6fnfbXC7TVPOLTQ7tPrhZOyaK1CebuJstV
         wDRg==
X-Gm-Message-State: APjAAAUkmI7fWEwsE9otnERKysZnlACXnIusbygLj2/mgrfp58JoZuOH
        3/6SQ2Fltfpl3b2rC53TTT06fPi/d0I=
X-Google-Smtp-Source: APXvYqxpDuP1Xx08lq2ks3CZNSNGM4Ym+opjJUePriCfoPQEobPoub64oafkq5C/kkZLur1HGJAXKA==
X-Received: by 2002:adf:e5c4:: with SMTP id a4mr25600402wrn.292.1581975612802;
        Mon, 17 Feb 2020 13:40:12 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id t9sm2955065wrv.63.2020.02.17.13.40.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 13:40:12 -0800 (PST)
Subject: [PATCH net-next 1/3] net: core: add helper tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Christian Benvenuti <benve@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Parvi Kaustubhi <pkaustub@cisco.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Guo-Fu Tseng <cooldavid@cooldavid.org>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Timur Tabi <timur@kernel.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        Ronak Doshi <doshir@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, linux-hyperv@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
References: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com>
Message-ID: <9fdc5f0c-fdf0-122e-48a5-43ff029cf8d9@gmail.com>
Date:   Mon, 17 Feb 2020 22:40:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <76cd6cfc-f4f3-ece7-203a-0266b7f02a12@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several network drivers for chips that support TSO6 share the same code
for preparing the TCP header. A difference is that some reset the
payload_len whilst others don't do this. Let's factor out this common
code to a new helper.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 include/net/ip6_checksum.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
index 7bec95df4..ef0130023 100644
--- a/include/net/ip6_checksum.h
+++ b/include/net/ip6_checksum.h
@@ -76,6 +76,18 @@ static inline void __tcp_v6_send_check(struct sk_buff *skb,
 	}
 }
 
+static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb,
+					bool clear_payload_len)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	struct tcphdr *th = tcp_hdr(skb);
+
+	if (clear_payload_len)
+		ipv6h->payload_len = 0;
+
+	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
+}
+
 #if IS_ENABLED(CONFIG_IPV6)
 static inline void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb)
 {
-- 
2.25.0


