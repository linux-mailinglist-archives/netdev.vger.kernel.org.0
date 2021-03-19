Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467CF34288E
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCSWNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231208AbhCSWNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:13:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77436C06175F;
        Fri, 19 Mar 2021 15:13:07 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so7363186pjq.5;
        Fri, 19 Mar 2021 15:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=33GaysFzsvQ+I5qDcEbkktJcZpgSkpOFw/5gMwE+F1A=;
        b=Pz594VkHIjxNggKhCc1UH1QbYbbJvH8LIbApFY6x6S8Yb84tXwAUWZkqtIfjhBf17v
         hPI3Hg4JkzHpKuZRjKAq+XzXHRhCmoHJOy3g0HZBTUuVb6v7/vjbcYt2/rr4crsZU7/o
         Qyf/cZYC7tLtOSY5GLEyqClHkGJ6efKqYSLOs+aCKR9lyh96DPOvXNfXRb0VwLYgJgKI
         0jrNG2XG4fVzKFhxvirMxIIKmznoN3hUoQB/uWIhCNy33cqk4KvF7nWoGwfOd04G0eb+
         L+PDy5BzA4smC90uyqX60WLrCP2mPbFPHuCzyyjsmoxTnoL2G4kDqjijdByEq0E+F2Zz
         BoJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=33GaysFzsvQ+I5qDcEbkktJcZpgSkpOFw/5gMwE+F1A=;
        b=UPoeloBk9J4b227ARB5FVbs1BaS6UxjoMPaYHpPKKy6j5EMagqtFScOBBwJHE3KJd7
         LhZYWIvsE4WjCCWD1tBUToHnLDTl0X+1o3bYo1hYip3dUTFVydva1k94MP/mikAi6Rw8
         I32sJfHlgcIW0SIHwTo0ePqno3dR4VczzaZ8/HmyyDWv9Ry+oHdGqbWqctsYvc7PJwyr
         5jGRsvE4Tuh7r3cfL13TaepgTU1JFw3T/7yAdStFs0WK469un/xfOaphF1bqzgYy66IY
         NYaKgB6mJEKkUvpuzTwdH/Lcdsil/9Mm0MTwSmmXD1gsM/+GU2s/3yGTIrjXHdRlli0N
         vpnQ==
X-Gm-Message-State: AOAM533a2n+LqfZ86JbfA0pbLdaTfZCqdluEj+LPwVxHqi/0OS+JJqeU
        G5tsUnRECOlVCHvetFbFk6s=
X-Google-Smtp-Source: ABdhPJycMC7igH4xxlokajLkAlJIkmXgVzFtb65bs2VuUyQGO/RViDP5U+tKFKT+uwC29618jtRVag==
X-Received: by 2002:a17:90a:d991:: with SMTP id d17mr583866pjv.229.1616191987008;
        Fri, 19 Mar 2021 15:13:07 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x190sm6421010pfx.60.2021.03.19.15.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:13:06 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 07/16] net: dsa: sync ageing time when
 joining the bridge
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
 <20210318231829.3892920-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7bc2c277-e75c-35e7-23d7-78616757177e@gmail.com>
Date:   Fri, 19 Mar 2021 15:13:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SWITCHDEV_ATTR_ID_BRIDGE_AGEING_TIME attribute is only emitted from:
> 
> sysfs/ioctl/netlink
> -> br_set_ageing_time
>    -> __set_ageing_time
> 
> therefore not at bridge port creation time, so:
> (a) drivers had to hardcode the initial value for the address ageing time,
>     because they didn't get any notification
> (b) that hardcoded value can be out of sync, if the user changes the
>     ageing time before enslaving the port to the bridge
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_stp.c       | 13 +++++++++++++
>  net/dsa/port.c            | 10 ++++++++++
>  3 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 920d3a02cc68..ebd16495459c 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -137,6 +137,7 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
>  void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
>  bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
>  u8 br_port_get_stp_state(const struct net_device *dev);
> +clock_t br_get_ageing_time(struct net_device *br_dev);
>  #else
>  static inline struct net_device *
>  br_fdb_find_port(const struct net_device *br_dev,
> @@ -160,6 +161,11 @@ static inline u8 br_port_get_stp_state(const struct net_device *dev)
>  {
>  	return BR_STATE_DISABLED;
>  }
> +
> +static inline clock_t br_get_ageing_time(struct net_device *br_dev)
> +{
> +	return 0;
> +}
>  #endif
>  
>  #endif
> diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
> index 86b5e05d3f21..3dafb6143cff 100644
> --- a/net/bridge/br_stp.c
> +++ b/net/bridge/br_stp.c
> @@ -639,6 +639,19 @@ int br_set_ageing_time(struct net_bridge *br, clock_t ageing_time)
>  	return 0;
>  }
>  
> +clock_t br_get_ageing_time(struct net_device *br_dev)
> +{
> +	struct net_bridge *br;
> +
> +	if (!netif_is_bridge_master(br_dev))
> +		return 0;
> +
> +	br = netdev_priv(br_dev);
> +
> +	return jiffies_to_clock_t(br->ageing_time);

Don't you want an ASSERT_RTNL() in this function as well?
-- 
Florian
