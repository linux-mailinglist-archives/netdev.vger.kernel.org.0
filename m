Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76770344AA0
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhCVQIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231559AbhCVQGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 12:06:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C49C061574;
        Mon, 22 Mar 2021 09:06:21 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x7-20020a17090a2b07b02900c0ea793940so10828014pjc.2;
        Mon, 22 Mar 2021 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SowZIcaJZhEed7YjVk5JGDpUaVc5E1KpdjlopzLh6mI=;
        b=Vf2RpsLhJ81z4wgKHc/itHt04mg45ujrA6xkjcJEecBUQdcXt5Or36E7aHif2FLaDd
         0HSw61pk9edeaJwgIQmixB/dGv/ffqFFludF+eBXtH+npHcCGnl4KqiJ5H+UbRyprrKo
         QXwKSj9460S7sjOtLi0EP+ZZvXH7YcD7cesk6sq+9xLzuce321T7f39UnWMEqnrg8uT8
         wAqNTR4NhRJVgrL3h1hKHdfUYdoZ96RARj+etL4ZcYY556aRlaoSM8zZ9KIMmGPEX2u3
         E3rPnyUP9wa8Fot6hu48Av7UB2VbXDR8dj8NtlXZZiw8LdzgXbVTawNha2q6CJp5vYYx
         /v0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SowZIcaJZhEed7YjVk5JGDpUaVc5E1KpdjlopzLh6mI=;
        b=l4rcbj2j2qYZxxm2tm2yA4wJOUPrNVln8lcmMXJVMRkAuePKH/WyWKTIrz2PTCDB+j
         rpL2czdkZA8qF/c0Qh6ohPb6qDOqLLjd3qWOJQooNtMvVCV+0lzbO0lpvWgaWjP/JxD2
         vBtlRYfUGPEbSeNlyz/7vZsUF5mwWUBi+UqYaXg9g/jp/0UmnWQ0Hs2zGLer3luy01Ys
         YSRsPm3rdOwKUyiDRVau1p8s8VyPA+ZeSS9V89OrXQvNK6E6dOl0m80XBtJevv/Qmj9Q
         XtqbXVYH55xFt9XCKfMI0tSQJDgGKOZ9rgyo6kEuXdxqtSNdJXzWQguwn9Ax3vjrYvMx
         3pZA==
X-Gm-Message-State: AOAM530IzDSzGl4Bc9uwTAe9Ma9VUgzjPNCP9GPl69PGy4dDbRntI/fW
        dDYN81m1e9eLApCOj1Dk20o=
X-Google-Smtp-Source: ABdhPJws+kSzU6djYSD76v4UsDTW83oAB/M1MEpcsMaHwqscU4XhPIidErY6653b/bu/+Vz/CIIZdg==
X-Received: by 2002:a17:902:70c5:b029:e6:cba1:5d94 with SMTP id l5-20020a17090270c5b02900e6cba15d94mr274867plt.84.1616429180778;
        Mon, 22 Mar 2021 09:06:20 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i13sm294731pgi.3.2021.03.22.09.06.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 09:06:20 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 14/16] net: dsa: don't set
 skb->offload_fwd_mark when not offloading the bridge
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
 <20210318231829.3892920-15-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0856e923-fdca-93cb-4fe3-4f5c5d811c3c@gmail.com>
Date:   Mon, 22 Mar 2021 09:06:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-15-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA has gained the recent ability to deal gracefully with upper
> interfaces it cannot offload, such as the bridge, bonding or team
> drivers. When such uppers exist, the ports are still in standalone mode
> as far as the hardware is concerned.
> 
> But when we deliver packets to the software bridge in order for that to
> do the forwarding, there is an unpleasant surprise in that the bridge
> will refuse to forward them. This is because we unconditionally set
> skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
> were already forwarded in hardware by us.
> 
> Since dp->bridge_dev is populated only when there is hardware offload
> for it, but not in the software fallback case, let's introduce a new
> helper that can be called from the tagger data path which sets the
> skb->offload_fwd_mark accordingly to zero when there is no hardware
> offload for bridging. This lets the bridge forward packets back to other
> interfaces of our switch, if needed.
> 
> Without this change, sending a packet to the CPU for an unoffloaded
> interface triggers this WARN_ON:
> 
> void nbp_switchdev_frame_mark(const struct net_bridge_port *p,
> 			      struct sk_buff *skb)
> {
> 	if (skb->offload_fwd_mark && !WARN_ON_ONCE(!p->offload_fwd_mark))
> 		BR_INPUT_SKB_CB(skb)->offload_fwd_mark = p->offload_fwd_mark;
> }
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
