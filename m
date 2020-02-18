Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FCA1632DC
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBRUQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:11 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34802 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgBRUQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:11 -0500
Received: by mail-wr1-f68.google.com with SMTP id n10so23590979wrm.1;
        Tue, 18 Feb 2020 12:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bFMbK7LyKRnHu/ZMhuK+JeN3P8TImavRX9bgAiZfMtk=;
        b=QXTAl6KeEOAmHWG0qH4S6XmPJj4USYFkCIZ78dT/rmi09maEvpVOzZ//BmyS1kesW5
         XI0TPXmZ4qZ31jlmuQf0h92ss4SwkWJD0CejHK2mP4ontx77GV16UeS5NSj1hJT9DdLM
         7Jp/3ahcbfRwH6xUmZPVnPH/+DZFAaM5OFoXpCQUaqd7lr2KciD2f1UX97+D9esFaXeb
         MHqm3+rmkAeECR3RkLCiE3l94YF4S6XbViZ/ur1ZSwK6SZ4lbKgVBkwNoCkeZWI37kMC
         WmvS9n0GQIDsgnLwBpALegvqZ7pIl5NjrlFPcg6hlF7QDFnkxvHaaQKfgGjjT9VCyVBW
         ytag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bFMbK7LyKRnHu/ZMhuK+JeN3P8TImavRX9bgAiZfMtk=;
        b=EfB0TFcT1Y440VwWf/O2PCUs3cbQBmr5XoiW6Jg69qwiGoGb1LifHg5omOpVkFn1zT
         mbt1NwSbpLFFlgri3aiX8YiNktex5L5iOnsNvqeoHm1rYbnxsF1v9mIOD7t2BoEaAZq9
         Z5k6omMjPOiWsTIwZGF2KrPwqyFqYdYRJg+2TnBmB4IasF3EYZds+x6pt/5KJJ7HvxKG
         QzbVylhYfHWLLsZ9xU0EQEO9ww0dY10RLQeIGWbmWHMZdcOFgJr7E84YZNWBDaSf85An
         HVBtMik+zTH7X+TRvVbFhNoTYL/aaCZAUQqGjcjpXJmiixd3n3JHh7c/MzY7Ccv+VCCo
         jQHA==
X-Gm-Message-State: APjAAAUy7J+I4lg7sJ9avF+rqSVm3c2bnw9k1GNAOyfs/Ws7JP/C4C8L
        I7J4ZSOfvvyrcg18rihpVWhyjm5NVqQ=
X-Google-Smtp-Source: APXvYqx0o7TLaD/TAtGQo3xJ8sCR+Q65dDtECgJ0RmmNYCrQiqxI1MUf49p/dryUzt3jnppRFGzHDQ==
X-Received: by 2002:adf:f28f:: with SMTP id k15mr30535210wro.230.1582056968961;
        Tue, 18 Feb 2020 12:16:08 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id p26sm4590202wmc.24.2020.02.18.12.16.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:08 -0800 (PST)
Subject: [PATCH net-next v2 01/13] net: core: add helper tcp_v6_gso_csum_prep
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
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <82ba1653-6a88-edf2-b22f-938b64e46655@gmail.com>
Date:   Tue, 18 Feb 2020 20:56:41 +0100
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

Several network drivers for chips that support TSO6 share the same code
for preparing the TCP header, so let's factor it out to a helper.
A difference is that some drivers reset the payload_len whilst others
don't do this. This value is overwritten by TSO anyway, therefore
the new helper resets it in general.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/net/ip6_checksum.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/net/ip6_checksum.h b/include/net/ip6_checksum.h
index 7bec95df4..27ec612cd 100644
--- a/include/net/ip6_checksum.h
+++ b/include/net/ip6_checksum.h
@@ -76,6 +76,15 @@ static inline void __tcp_v6_send_check(struct sk_buff *skb,
 	}
 }
 
+static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb)
+{
+	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	struct tcphdr *th = tcp_hdr(skb);
+
+	ipv6h->payload_len = 0;
+	th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
+}
+
 #if IS_ENABLED(CONFIG_IPV6)
 static inline void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb)
 {
-- 
2.25.1


