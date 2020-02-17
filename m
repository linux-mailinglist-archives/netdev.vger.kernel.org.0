Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FD8161CE0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 22:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730012AbgBQVlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 16:41:06 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54029 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgBQVlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 16:41:04 -0500
Received: by mail-wm1-f67.google.com with SMTP id s10so763333wmh.3;
        Mon, 17 Feb 2020 13:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8ARFrFQV0qlOU9GqIKhHr+/9GQBmGgiD3Q14CXHt7ws=;
        b=P2pROcebCz0VgM4B3LjbRdt53mGMZJ/572Gmh4gxcuOtve3Ct3epgxq7xh7KTreJtW
         /V5E7sOGSWIZHly56Cxa1xz+BNNowmsdbc8FIlN4ky5yLPFBEs898w+025l6/4Tk0Twx
         5SUJCnMdposybv9NE9NZhh5Uz/vi5MGeWuOLVvYHL+Mqxh8m5mkDotvyg8b2d7DBnYsx
         hVEeBmtkxilP+P2U09JxFSHlz9BY5v1ITvVps8CePC3jXN8okjttoOSP9WndTPQRgPDV
         q4JO5deQGtiZ1Ne83CEt8J+P+DvA05DLbQyGTAqbpzAysRQCBzR9Id5atMGYT0C36u57
         tQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8ARFrFQV0qlOU9GqIKhHr+/9GQBmGgiD3Q14CXHt7ws=;
        b=VDtdk2Fs8eKaQX9uy0mXdWXIq7LBfGKSbHeb0BTMRUO+bIgWDrNz9wff29lr5h0wJY
         uSsEpQ6JhCiyRNhadtvjJUsepuWpTBc+uJg6sPyYm67zd4z098uwrRVdx8UvprhMJ7xZ
         xlqEHP8o4ePyFV77VAahLggegjaczc02VAexjZv1B5OyJouTYK8kCgKlDYQKEq4QoopX
         Ew6PWtnmoTcduvCkEq2T0fLTKUUkA9NNfXqQh+Azv7772TT5NsH7gata2RxEXwLcQE1o
         J+OetXcqOkHWq5YTJZ6Qz8KFMawRgX1vgbNlUSqaYVI0xIFJdDbjt0eL8PIf+vuv0jzB
         98AA==
X-Gm-Message-State: APjAAAX9e3GoHVgwHIxgHrsrC2djZRhUFlK46SM8M1rYokxChtOSMaj2
        1a5/sz6haZOqqtAdQbgycTcIrmZCuzk=
X-Google-Smtp-Source: APXvYqx/0EaWmdS7wPEFj0nevtLwqqPVhFUkYYkYkfo7PcJf/rCTyqMxBRSRGx5iAmbPndkQ5E9t1g==
X-Received: by 2002:a1c:7fd7:: with SMTP id a206mr900534wmd.171.1581975662156;
        Mon, 17 Feb 2020 13:41:02 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id t187sm916530wmt.25.2020.02.17.13.41.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 13:41:01 -0800 (PST)
Subject: [PATCH net-next 2/3] r8169: use new helper tcp_v6_gso_csum_prep
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
Message-ID: <02ea88e7-1a79-f779-d58c-bb1dced0b3b4@gmail.com>
Date:   Mon, 17 Feb 2020 22:40:59 +0100
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

Simplify the code by using new helper tcp_v6_gso_csum_prep.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 26 ++---------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5a9143b50..75ba10069 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4108,29 +4108,6 @@ static bool rtl_test_hw_pad_bug(struct rtl8169_private *tp, struct sk_buff *skb)
 	return skb->len < ETH_ZLEN && tp->mac_version == RTL_GIGA_MAC_VER_34;
 }
 
-/* msdn_giant_send_check()
- * According to the document of microsoft, the TCP Pseudo Header excludes the
- * packet length for IPv6 TCP large packets.
- */
-static int msdn_giant_send_check(struct sk_buff *skb)
-{
-	const struct ipv6hdr *ipv6h;
-	struct tcphdr *th;
-	int ret;
-
-	ret = skb_cow_head(skb, 0);
-	if (ret)
-		return ret;
-
-	ipv6h = ipv6_hdr(skb);
-	th = tcp_hdr(skb);
-
-	th->check = 0;
-	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
-
-	return ret;
-}
-
 static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
@@ -4163,9 +4140,10 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 			break;
 
 		case htons(ETH_P_IPV6):
-			if (msdn_giant_send_check(skb))
+			if (skb_cow_head(skb, 0))
 				return false;
 
+			tcp_v6_gso_csum_prep(skb, false);
 			opts[0] |= TD1_GTSENV6;
 			break;
 
-- 
2.25.0


