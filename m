Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1CA1A018E
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 01:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgDFXUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 19:20:45 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37855 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgDFXUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 19:20:45 -0400
Received: by mail-pj1-f66.google.com with SMTP id k3so584529pjj.2
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 16:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BqQYduunpq6Ujf4VXP40OgW4fs01oYKVhjognoXU+do=;
        b=SdG7Q8ujisSh0czhWOEo+i+99qf6u7Q0BEMpbh0wU/PLJaB2/WaIV05Fxb1HWukzuC
         3Xe73yo23EpFoY/AL+ug+/aiHrFAv3JtQDEVtdNSO5zdrBoHMt73+RfPsMCPjNfZsPj6
         hyv5kTzJ6HbSrxwfMIRWFWCLUjK5ZmGkLGt7mYGtCybi4RZBfH9woonCUaV1GjQGBxx+
         gySuZ9OXRgoBB4tMXGdUyd8t/8tsZBqpZX29qilbQThJnD9ltaplcBotcD80OvU2ES9F
         JXEjZHcoXXzdp5YMGlBVR0DkFqZiuIXf5WA4nO0Ze9iR5xX4NBcHzpKPNHi/C4y79KoG
         t8Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BqQYduunpq6Ujf4VXP40OgW4fs01oYKVhjognoXU+do=;
        b=MiPTldTM9VIYwdIeoHbYUodSxid2V7SLCk/T8o4e0vOvdhQPlQy7DSIKLDeoSJnE6u
         PG6CAfBZD3gh9JBRFslpVlyAXZP3/2KJG30oPdrDNHvjEocLyDG1HvPrhhpYDbU4YvS4
         zRDbxgHHCW5ubpjaVoUX7ojXC/wBri5Xaz5TzWi6zjNldY6Yfc3DZfel7sKqyY8Tdh4l
         SBL+HT9oKiYYBYdKNCBgqoLe/PRH7J6fCDv5FEzrP+mSaBGOsqWeVV3TMaBFsgZryFLG
         o2sLZ8FBjuSwyO35uoVsqbARRnygmceywsXxuChcaTITjoUwsM4ujtYH8BW0AwkmfeXC
         mhFQ==
X-Gm-Message-State: AGi0PuZH9CLIay3OpHaaKN9lo8gs3KIbsduTDNxKb5hV1ZinPMzwyQw8
        HqFAVKsvrPPLsgxy2bCPLa4QjMtI
X-Google-Smtp-Source: APiQypL/aAtFUb77v7JIUSYhTWEy2fyYraAd+wBPRL8xrO9wIqwIrqz85EiWdsrDssb0BD069plkyA==
X-Received: by 2002:a17:90b:284:: with SMTP id az4mr1910620pjb.20.1586215243764;
        Mon, 06 Apr 2020 16:20:43 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x78sm12521674pfc.146.2020.04.06.16.20.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2020 16:20:42 -0700 (PDT)
Subject: Re: [PATCH net] r8169: fix multicast tx issue with macvlan interface
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Charles DAYMAND <charles.daymand@wifirst.fr>
Cc:     Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b3867109-d09c-768c-7210-74e6f76c12b8@gmail.com>
Date:   Mon, 6 Apr 2020 16:20:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <df776fc4-871d-d82c-a202-ba4f4d7bfb42@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/20 3:16 PM, Heiner Kallweit wrote:

> 
> In a similar context Realtek made me aware of a hw issue if IP header
> has the options field set. You mentioned problems with multicast packets,
> and based on the following code the root cause may be related.
> 
> br_ip4_multicast_alloc_query()
> -> iph->ihl = 6;
> 
> I'd appreciate if you could test (with HW tx checksumming enabled)
> whether this experimental patch fixes the issue with invalid/lost
> multicasts.
> 
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index e40e8eaeb..dd251ddb8 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -4319,6 +4319,10 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
>  		    rtl_chip_supports_csum_v2(tp))
>  			features &= ~NETIF_F_ALL_TSO;
>  	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
> +		if (ip_hdrlen(skb) > sizeof(struct iphdr)) {

Packet could be non IPv4 at this point. (IPv6 for instance)

> +			pr_info("hk: iphdr has options field set\n");
> +			features &= ~NETIF_F_CSUM_MASK;
> +		}
>  		if (skb->len < ETH_ZLEN) {
>  			switch (tp->mac_version) {
>  			case RTL_GIGA_MAC_VER_11:
> 
