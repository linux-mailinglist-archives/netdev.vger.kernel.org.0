Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512F329152A
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 02:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440040AbgJRAhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 20:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440036AbgJRAhO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Oct 2020 20:37:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F394C061755
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 17:37:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g29so3759938pgl.2
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 17:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6/OqblgYlHjeyLJVIz+oLApVRzmVuT9dOzbgWQ2wQPY=;
        b=oZnIn3AutD5Xl83g4NVZtdti802aipvM1v83NnrmnLkAkyf7UV/le8uPCf9JqQmqzx
         TUkBwDrdGXywTLSmApIgvj0RSY5Aw2guhYbCQ0VlG+k+Pzf7zMGG/VDi9wRpwUj+CEdk
         P6oCX6QcMulMart1uO7w5i2mBD/Uwoiw/U8XlJ1VjCJpEityomqmVLlYrfnPRkkY9BN1
         ZPR/tgv0JdZ6TXO3sdcc+iJOJPwfzDTbk1OHw4Nnr0kOu7BQgtHooAGw+lbMbmsbb3wQ
         D04h5D8X1WTsyq7FPcJlv5NfSL7iASnBk4Bwd85dg3UjD62c8VCBUqzthSWayc3jTnpN
         p+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6/OqblgYlHjeyLJVIz+oLApVRzmVuT9dOzbgWQ2wQPY=;
        b=oymZHl5Cl32A8iMspSZlzUQ9xxXlhpKSSgSFwX1P4DuD8yoQH8Odge1NS9XtepB/lk
         tOkG2mN6KlHp7uWkkFo6/MVcRzJdczJa6k8TphokoHDVgzC2vfQECOUPh/OKNO10X5cQ
         kgwrbi+KkVbBYowsae/xmO6rQzu9r5hMLq4kiGsUeE4EUy4ABrB1Vj18skyI/TZxEsZi
         3yUwnHpQwNx7O+rUiX6GWnLd9UJ6uwWDIpQkaZr/6f48qXrIgaW7xKd+g2ATYyf02Q1K
         1YlA+bex66EJojISvAKi6j+vEj7LrCmSVZ4fb3RGAURh44qaFXK8lYzsteCkBn+b+iUn
         nEjA==
X-Gm-Message-State: AOAM533LY3Hnbmg8aq03brys8mZZrOLnRc7emMV5hepPpJrpwHB7X7yH
        /q47WH/ORyKcxt/yGDkvA20VXWGLqR0=
X-Google-Smtp-Source: ABdhPJxBAZNtwVwapXsrGLl1OTjPnoZFPUosfBpVmJLCwIp6vy4FkSbt5yOW/8JkyOyCDT1B1ABQaQ==
X-Received: by 2002:a63:cc42:: with SMTP id q2mr9224082pgi.216.1602981433809;
        Sat, 17 Oct 2020 17:37:13 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s187sm7250561pgb.54.2020.10.17.17.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Oct 2020 17:37:12 -0700 (PDT)
Subject: Re: [RFC PATCH 02/13] net: dsa: implement a central TX reallocation
 procedure
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-3-vladimir.oltean@nxp.com>
 <20201017220104.wejlxn2a4seefkfv@skbuf>
 <d2578c4b-7da6-e25d-5dde-5ec89b82aeef@gmail.com>
 <20201017221736.hjehr64y7nwc2ru6@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <af11fa94-a62e-62c3-9fe2-8bb47b26eabe@gmail.com>
Date:   Sat, 17 Oct 2020 17:37:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201017221736.hjehr64y7nwc2ru6@skbuf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/2020 3:17 PM, Vladimir Oltean wrote:
> On Sat, Oct 17, 2020 at 03:11:52PM -0700, Florian Fainelli wrote:
>>> 	slave_dev->needed_headroom += master->needed_headroom;
>>> 	slave_dev->needed_tailroom += master->needed_tailroom;
>>
>> Not positive you need that because you may be account for more head or tail
>> room than necessary.
>>
>> For instance with tag_brcm.c and systemport.c we need 4 bytes of head room
>> for the Broadcom tag and an additional 8 bytes for pushing the transmit
>> status block descriptor in front of the Ethernet frame about to be
>> transmitted. These additional 8 bytes are a requirement of the DSA master
>> here and exist regardless of DSA being used, but we should not be
>> propagating them to the DSA slave.
> 
> And that's exactly what I'm trying to do here, do you see any problem
> with it? Basically I'm telling the network stack to allocate skbs with
> large enough headroom and tailroom so that reallocations will not be
> necessary for its entire TX journey. Not in DSA and not in the
> systemport either. That's the exact reason why the VLAN driver does this
> too, as far as I understand. Doing this trick also has the benefit that
> it works with stacked DSA devices too. The real master has a headroom
> of, say, 16 bytes, the first-level switch has 16 bytes, and the
> second-level switch has 16 more bytes. So when you inject an skb into
> the second-level switch (the one with the user ports that applications
> will use), the skb will be reallocated only once, with a new headroom of
> 16 * 3 bytes, instead of potentially 3 times (incrementally, first for
> 16, then for 32, then for 48). Am I missing something?
> 

That is fine with me, given that we can resolve most of the TX path 
ahead of time, I suppose we should indeed take advantage of that 
knowledge. Thanks!
-- 
Florian
