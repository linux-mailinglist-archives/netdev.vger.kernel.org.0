Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0190826EFAD
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgIRCha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbgIRCh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:37:29 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0962C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:37:28 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t14so2544836pgl.10
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 19:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yYR2R+jrLwblchQA0N7SRVqBFU0wjUR58z6fcxIT0uM=;
        b=g5gWNO41+ZP/ujQXWbh1cxw4T6IkBsjwnfRJsNZn5G68deVTEkrCjm9VGP2Qlg58qX
         gKW5Xn8EB+uZFDeOu7VqA0AHGvx/wevM9M3llFIa5lk6brJHWxEwRDBesF8yv+ZkTl2n
         BQ6z1xUO8TSlTZFBnOJA9Nn+IL6nwOGHH58WY5bCzKP1vsYhZ9BLwumH+ktxTYy0M7O/
         50VhEZmxiaGh8iH7cL1XhdSca0V+YotFDlFvej8Mq3oIwsFCtWzCKrHlJlixo+1zJjkO
         2LuFFIFdUDb1BBUkOBprQ1/zJmNrb3e/22Bk1rXbqO8kY8jnhguz11SG4dNAnF+tzLdp
         3rCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yYR2R+jrLwblchQA0N7SRVqBFU0wjUR58z6fcxIT0uM=;
        b=JViAG6pbiGEb39ki8i0RbNhm09GURvUlYPAVvdPasL84TLn/CF9N50fc2it/1n3N2w
         ibJrVNO5j5/JJqBjPv5z1yCeBtjGBeftmYRDJP17wfhNKwhAq5f8459zhG9I/64w6vUb
         8NTRaszVgsYODTY1MEmHW9lldSvLaNl4K0XPRIn8jld5I3oNIEvm1t+lbzPlYJgwT4Hj
         TcfiWrYA57BQwjuik/vR/QIuFGlz6zbeyVNPEv2lop9IzpZotVbPiZ5owtwrCxTFEcdR
         tgFMYwKt50T3NXid2jpPJi3mxNySL5dlvXVrgBNgPynazVvJH7/nzSPXcEc+V+2QELtI
         4Q6g==
X-Gm-Message-State: AOAM533mOBJQVz/2FgR9bZpuf80fX5vceDm/nRtxuc16KzG9QHUBcVhd
        By6PT50LD7yL4p0vne2Kw3o=
X-Google-Smtp-Source: ABdhPJywF1w1VhJOSaepnCrSi5ORPhqcZo9e6DdlFr4xpgeOf64+ydgHIF7j8vuQTZKtsyyOJBtmfw==
X-Received: by 2002:a63:ec54:: with SMTP id r20mr24484985pgj.430.1600396648258;
        Thu, 17 Sep 2020 19:37:28 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j4sm1086342pfd.101.2020.09.17.19.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 19:37:27 -0700 (PDT)
Subject: Re: [PATCH v2 net 2/8] net: mscc: ocelot: add locking for the port TX
 timestamp ID
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, kuba@kernel.org
References: <20200918010730.2911234-1-olteanv@gmail.com>
 <20200918010730.2911234-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <51c3dc0a-6433-185b-ec9a-1622879965c7@gmail.com>
Date:   Thu, 17 Sep 2020 19:37:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918010730.2911234-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 6:07 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The ocelot_port->ts_id is used to:
> (a) populate skb->cb[0] for matching the TX timestamp in the PTP IRQ
>      with an skb.
> (b) populate the REW_OP from the injection header of the ongoing skb.
> Only then is ocelot_port->ts_id incremented.
> 
> This is a problem because, at least theoretically, another timestampable
> skb might use the same ocelot_port->ts_id before that is incremented.
> Normally all transmit calls are serialized by the netdev transmit
> spinlock, but in this case, ocelot_port_add_txtstamp_skb() is also
> called by DSA, which has started declaring the NETIF_F_LLTX feature
> since commit 2b86cb829976 ("net: dsa: declare lockless TX feature for
> slave ports").  So the logic of using and incrementing the timestamp id
> should be atomic per port.
> 
> The solution is to use the global ocelot_port->ts_id only while
> protected by the associated ocelot_port->ts_id_lock. That's where we
> populate skb->cb[0]. Note that for ocelot, ocelot_port_add_txtstamp_skb
> is called for the actual skb, but for felix, it is called for the skb's
> clone. That is something which will also be changed in the future.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
