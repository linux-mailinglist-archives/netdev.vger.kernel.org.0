Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0D321A184A
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 00:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgDGWko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 18:40:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45825 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDGWko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 18:40:44 -0400
Received: by mail-wr1-f65.google.com with SMTP id v5so5631692wrp.12
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 15:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k10jgGbYqkTndyv5IIaRsp+WP+wxIV5rccMvUT9I9OY=;
        b=c2mymi+fmL4MtaHqf81zhu5LHOpEFMZEy7fCUf3gIPpEDSWvf0p5Fidz+KKUT4z/2s
         YzEJW3rr+RMS0Si3nIvrqf+0nla2bkYM4NO1SM/ryWhExJUmyftSs1rV8D2L8AVIoYYX
         hRewwIT78Bx9xqjYMZ4ejELf8XRipaSyxOALpusyFS4a0U+ReltKnIxBz0erCMMgpVCi
         BZ0Z5sdJWnqO0qT5d7kR0QJVhKmcUC+7ET/mWw9Jzu2dqR/LSojrFYnFyIFYp+ebOolv
         9Yq5KlTZWzT91AVTClGhsgti7CDY1NMJFC6QTHzWjhP0x8k4YBFMf+C5ZaWgJRehY9GB
         GqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k10jgGbYqkTndyv5IIaRsp+WP+wxIV5rccMvUT9I9OY=;
        b=AH9mcz8dD6t6m3V2C7eo+MG762iL69GfYiP/v2nbMo/+nc2kbzR8/yOzhvNQMsFOUx
         0RM7Z6V16EOyUwmLgRUT1Bls3xUVO/+ttj+Gg+hHo/AIOS2FUZ2jGcS2ko102HGbh+lc
         rWkIFItKusK3Y9iKf1K9ip3CqNfxd+e1XWdsZJ33o8Xqw4de23Xbw2MuA37ogleBPvzg
         MfUdWBG/+2PZf2BmndYLzM3U/zM4XTSS/1Z/c+82VC0FsHrfiI4LQ95uc+1k2noOUjVH
         J7Gy0wULyYWF2pevkX6XpIf0DqFoB7JloOunfJD/vZ0AK9yLi7Z7487MXGqwXTTexKHQ
         ZeSQ==
X-Gm-Message-State: AGi0PuZlT+owBFwtTB46K4NWicJX9+zSUfexahEFMoWDiDdQyVHPbXdO
        hbSKzIRf1ctn8+syoPcu80Ev7Xh+
X-Google-Smtp-Source: APiQypJk0Qp6jZ4AGFR9fWH3UD0Rgi0mebyqp7ndu/CoEj2eOBoFzMuTpdzFFz/GTwJIGhak/qJpLw==
X-Received: by 2002:adf:ee8d:: with SMTP id b13mr5305888wro.251.1586299240036;
        Tue, 07 Apr 2020 15:40:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:21d6:ac8b:719c:fbba? (p200300EA8F29600021D6AC8B719CFBBA.dip0.t-ipconnect.de. [2003:ea:8f29:6000:21d6:ac8b:719c:fbba])
        by smtp.googlemail.com with ESMTPSA id v16sm4156389wml.30.2020.04.07.15.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 15:40:39 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Charles DAYMAND <charles.daymand@wifirst.fr>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20200327090800.27810-1-charles.daymand@wifirst.fr>
 <0bab7e0b-7b22-ad0f-2558-25602705e807@gmail.com>
 <d7a0eca8-15aa-10da-06cc-1eeef3a7a423@gmail.com>
 <CANn89iKA8k3GyxCKCJRacB42qcFqUDsiRhFOZxOQ7JCED0ChyQ@mail.gmail.com>
 <42f81a4a-24fc-f1fb-11db-ea90a692f249@gmail.com>
 <CANn89i+A=Mu=9LMscd2Daqej+uVLc3E6w33MZzTwpe2v+k89Mw@mail.gmail.com>
 <CAFJtzm03QpjGRs70tth26BdUFN_o8zsJOccbnA58ma+2uwiGcg@mail.gmail.com>
 <c02274b9-1ba0-d5e9-848f-5d6761df20f4@gmail.com>
 <CAFJtzm0H=pztSp_RQt_YNnPHQkq4N4Z5S-PqMFgE=Fp=Fo-G_w@mail.gmail.com>
 <df776fc4-871d-d82c-a202-ba4f4d7bfb42@gmail.com>
 <b3867109-d09c-768c-7210-74e6f76c12b8@gmail.com>
 <d9c6ba82-4f3e-0f7e-e1f8-516da25e1fe4@gmail.com>
Message-ID: <fe30ab8d-2915-e049-ef30-760960f5efdc@gmail.com>
Date:   Wed, 8 Apr 2020 00:40:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <d9c6ba82-4f3e-0f7e-e1f8-516da25e1fe4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.2020 08:22, Heiner Kallweit wrote:
> On 07.04.2020 01:20, Eric Dumazet wrote:
>>
>>
>> On 4/6/20 3:16 PM, Heiner Kallweit wrote:
>>
>>>
>>> In a similar context Realtek made me aware of a hw issue if IP header
>>> has the options field set. You mentioned problems with multicast packets,
>>> and based on the following code the root cause may be related.
>>>
>>> br_ip4_multicast_alloc_query()
>>> -> iph->ihl = 6;
>>>
>>> I'd appreciate if you could test (with HW tx checksumming enabled)
>>> whether this experimental patch fixes the issue with invalid/lost
>>> multicasts.
>>>
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index e40e8eaeb..dd251ddb8 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -4319,6 +4319,10 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>>>  		    rtl_chip_supports_csum_v2(tp))
>>>  			features &= ~NETIF_F_ALL_TSO;
>>>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
>>> +		if (ip_hdrlen(skb) > sizeof(struct iphdr)) {
>>
>> Packet could be non IPv4 at this point. (IPv6 for instance)
>>
> Right, I should have mentioned it:
> This experimental patch is for IPv4 only. In a final version (if it indeed
> fixes the issue) I had to extend the condition and check for IPv4.
> 
>>> +			pr_info("hk: iphdr has options field set\n");
>>> +			features &= ~NETIF_F_CSUM_MASK;
>>> +		}
>>>  		if (skb->len < ETH_ZLEN) {
>>>  			switch (tp->mac_version) {
>>>  			case RTL_GIGA_MAC_VER_11:
>>>
> 

Here comes an updated version of the experimental patch that checks for IPv4.
It's part of a bigger experimental patch here, therefore it's not fully
optimized.


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e40e8eaeb..69e35da6c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4307,6 +4307,23 @@ static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_BUSY;
 }
 
+static netdev_features_t rtl8168evl_features_check(struct sk_buff *skb,
+						   netdev_features_t features)
+{
+	__be16 proto = vlan_get_protocol(skb);
+
+	if (skb->ip_summed == CHECKSUM_PARTIAL) {
+		if (proto == htons(ETH_P_IP)) {
+			if (ip_hdrlen(skb) > sizeof(struct iphdr)) {
+				pr_info("hk: iphdr has options field set\n");
+				features &= ~NETIF_F_CSUM_MASK;
+			}
+		}
+	}
+
+	return features;
+}
+
 static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 						struct net_device *dev,
 						netdev_features_t features)
@@ -4314,6 +4331,9 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 	int transport_offset = skb_transport_offset(skb);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
+	if (tp->mac_version == RTL_GIGA_MAC_VER_34)
+		features = rtl8168evl_features_check(skb, features);
+
 	if (skb_is_gso(skb)) {
 		if (transport_offset > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-- 
2.26.0


