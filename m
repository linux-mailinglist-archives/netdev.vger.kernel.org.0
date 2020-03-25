Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769D8193474
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 00:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727547AbgCYXSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 19:18:03 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36712 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727389AbgCYXSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 19:18:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so5648052wrs.3
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 16:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wJLaxZjvwz4ZmEf5AEc/TkUdJ6JAI3SX3VvTrU2wpJs=;
        b=ppKsJNmTyqjSr6Y+ClNzWj9OX7/k3ATDMC9xoyy3qZ1fbX+LyuIyPzUjCoLnB/xQmm
         QD4YDORSe5/MCn/ymYuS3Qm9Hys5B02s6/Bfrk8p6dOa5DLMiVtcDBZuKNlLWfWCo3Oh
         y6879ypgqnQP0VQNiGNyAZT1modqkaHDJ+uolitUHlKi7DScPfrkUvHu4H5hhl2/Bna6
         sqOkpIGTOBNC4ef/UCUwAy02RhXmZRI+ZozjEFqQda+4KDZU6b0QqIE+SiElX6CbLurE
         nHlmQfv1zqi1mbSOvhTzh0ykirklVnPUP697c7mKQBO+Z54XWKX3gDQYFcLdG8w9rQjU
         NA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wJLaxZjvwz4ZmEf5AEc/TkUdJ6JAI3SX3VvTrU2wpJs=;
        b=eVxUjkmfuhwZEyeH3MTm7Zwqv0ElLywgqMrYy/AV6X+u8UfACuPh+7b5mMjJ5gzloG
         T0NfozWUZE8T4ZRRkD+q6hnI90/nr5nm2TMbCwXOcgplAUe73I22hlnAaIbw9qegN/1g
         zqfvV4N4U8PPozylmigHb8LZgqcnJ0Xe8lnT+ha4Ogtvtf51RaLXKhhRSuAK/AnTV1Y0
         7Sml4Qdtpc701NxG0Z/aFn9sxrRblHOLqRUbYcsYsU1doNae/ipB9iZF+ngvZ04o09or
         RIdK+LMrKCWg5QdVODQfEB4os28rSuwmyl6+o+rzap9R2lBQhIVUU3lKIQaPVsEIr4WF
         PEPQ==
X-Gm-Message-State: ANhLgQ14zNHOFr7EudX2TICipVTeqWm+i13dwU0vd8I4Bh44iSJvYhSe
        UiBhJQczWQOhkIFNhoCwvc5I3n+0
X-Google-Smtp-Source: ADFU+vuIKcmBW7DdG9k2MWBZih9nrr8Z/kgyGPfTACKh9SRsb8jOnpraDLQaVl2qsy4OZG8W1++oGw==
X-Received: by 2002:adf:e48c:: with SMTP id i12mr5894314wrm.173.1585178280119;
        Wed, 25 Mar 2020 16:18:00 -0700 (PDT)
Received: from [10.230.1.220] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id h81sm871796wme.42.2020.03.25.16.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 16:17:59 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <8d2d819c-328c-9b2a-d25b-dccc85b93735@gmail.com>
Date:   Wed, 25 Mar 2020 16:17:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325152209.3428-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 8:22 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In the initial attempt to add MTU configuration for DSA:
> 
> https://patchwork.ozlabs.org/cover/1199868/
> 
> Florian raised a concern about the bridge MTU normalization logic (when
> you bridge an interface with MTU 9000 and one with MTU 1500). His
> expectation was that the bridge would automatically change the MTU of
> all its slave ports to the minimum MTU, if those slaves are part of the
> same hardware bridge. However, it doesn't do that, and for good reason,
> I think. What br_mtu_auto_adjust() does is it adjusts the MTU of the
> bridge net device itself, and not that of any slave port.  If it were to
> modify the MTU of the slave ports, the effect would be that the user
> wouldn't be able to increase the MTU of any bridge slave port as long as
> it was part of the bridge, which would be a bit annoying to say the
> least.
> 
> The idea behind this behavior is that normal termination from Linux over
> the L2 forwarding domain described by DSA should happen over the bridge
> net device, which _is_ properly limited by the minimum MTU. And
> termination over individual slave device is possible even if those are
> bridged. But that is not "forwarding", so there's no reason to do
> normalization there, since only a single interface sees that packet.
> 
> The real problem is with the offloaded data path, where of course, the
> bridge net device MTU is ignored. So a packet received on an interface
> with MTU 9000 would still be forwarded to an interface with MTU 1500.
> And that is exactly what this patch is trying to prevent from happening.
> 
> Florian's idea was that all hardware ports having the same
> netdev_port_same_parent_id should be adjusted to have the same MTU.
> The MTU that we attempt to configure the ports to is the most recently
> modified MTU. The attempt is to follow user intention as closely as
> possible and not be annoying at that.
> 
> So there are 2 cases really:
> 
> ip link set dev sw0p0 master br0
> ip link set dev sw0p1 mtu 1400
> ip link set dev sw0p1 master br0
> 
> The above sequence will make sw0p0 inherit MTU 1400 as well.
> 
> The second case:
> 
> ip link set dev sw0p0 master br0
> ip link set dev sw0p1 master br0
> ip link set dev sw0p0 mtu 1400
> 
> This sequence will make sw0p1 inherit MTU 1400 from sw0p0.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/bridge/br.c         |  1 +
>  net/bridge/br_if.c      | 93 +++++++++++++++++++++++++++++++++++++++++
>  net/bridge/br_private.h |  1 +
>  3 files changed, 95 insertions(+)
> 
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index b6fe30e3768f..5f05380df1ee 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -57,6 +57,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
>  
>  	switch (event) {
>  	case NETDEV_CHANGEMTU:
> +		br_mtu_normalization(br, dev);

I do not remember if you are allowed to sleep in a netdevice notifier, I
believe not, so you may need to pass a gfp_t to br_mtu_normalization for
allocations to be GFP_ATOMIC when called from that context, and
GFP_KERNEL from br_add_if().

It would be nice if we could avoid doing these allocations when called
from the netdev notifier though, could we just keep the information
around since the br_hw_port follows the same lifetime as the
net_bridge_port structure. Other than that, this looks good to me, thanks!
-- 
Florian
