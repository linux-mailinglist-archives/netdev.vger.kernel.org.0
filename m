Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B653428A5
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhCSWYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhCSWYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:24:44 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5713C061760;
        Fri, 19 Mar 2021 15:24:44 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id e33so4623369pgm.13;
        Fri, 19 Mar 2021 15:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D6Tu/wg6IZ1QbkLv7RywDYi5OUj38qXT4mDw8fzWwnM=;
        b=WkHigZsTftvvuUzbADDdaTAm4NX6Dpl2C4M8rM1ZD3PVuK6LoNv83LdAAHho8VmrH1
         09pnH8FGdeEMrqhs69y44qeSwcf+zxV84YM7/5aj7omqz3BGIaXiAr4Nq+DC64ln85/Y
         Ul2f0V9ZdhOwj5+vjNUDZ6L8TwJUky/qNguypLw5jlkCFogMShYNKQVGlmIw6YQk3rZF
         ENTmbwSDcaSX+ypKAxNWLLta2LDhvF6ogTcgUX1bfNzCNkvmMoleF/lV6ygB1AjNDzRs
         yzbeuu5YRCIAegrbjk34v/ou3nY9QsL4e6ozgc8fI08sO/j4b4FXcqQ8MWQPdsRZAzC1
         /1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6Tu/wg6IZ1QbkLv7RywDYi5OUj38qXT4mDw8fzWwnM=;
        b=A9BQeRlmvHcNjQoeJsCpq/YESiJsWz2e8rszlJ2NdJAlufVrnBZE1MOolzxrzt2P+u
         u1Ky4maReaXpBrFaGxaJUB4+fQMiPFknYPwji5rXNymdjSwcipFIuIiedpy6/QlN5os2
         FDShMz6C9x/aALXOqHcLkmIibYe3S5nfUPrHA/CKoNJWvY1tJqHDmsR9yyVQzITiW807
         QzLteq31B7lzGZDPN+MCH4zXT0CSxemti2Iyg+6r50IdSNPMpgOP41QzE8b/OWUJhlMQ
         HF76typucNbTuQhEhPzmsJte2ak2TjtoezocBalpPHvB680iAFAlrdBjo8lr1HplsmO0
         lo6A==
X-Gm-Message-State: AOAM53244xhnpNg2Owsmvxv7mwVoFf4IFqjypLN+/h+D4PrR+uL1UYSO
        ce2sY9EbWn0kA6hx6D7IP5I=
X-Google-Smtp-Source: ABdhPJwKqgb2pN/ayGfB+nlJBvSQo9qLRJYtiUARyxmSzuE9FrZzMBoN2CY/DhwZGrj0pRNko/DqcA==
X-Received: by 2002:a62:fc10:0:b029:1ef:141f:609 with SMTP id e16-20020a62fc100000b02901ef141f0609mr10956501pfh.78.1616192683987;
        Fri, 19 Mar 2021 15:24:43 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y7sm6573050pfq.70.2021.03.19.15.24.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:24:43 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 10/16] net: dsa: replay VLANs installed on
 port when joining the bridge
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
 <20210318231829.3892920-11-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8af0a24a-9599-93f2-0d69-d7d35a28286c@gmail.com>
Date:   Fri, 19 Mar 2021 15:24:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-11-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently this simple setup:
> 
> ip link add br0 type bridge vlan_filtering 1
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set swp0 master bond0
> 
> will not work because the bridge has created the PVID in br_add_if ->
> nbp_vlan_init, and it has notified switchdev of the existence of VLAN 1,
> but that was too early, since swp0 was not yet a lower of bond0, so it
> had no reason to act upon that notification.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/linux/if_bridge.h | 10 ++++++
>  net/bridge/br_vlan.c      | 71 +++++++++++++++++++++++++++++++++++++++
>  net/dsa/port.c            |  6 ++++
>  3 files changed, 87 insertions(+)
> 
> diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
> index 89596134e88f..ea176c508c0d 100644
> --- a/include/linux/if_bridge.h
> +++ b/include/linux/if_bridge.h
> @@ -111,6 +111,8 @@ int br_vlan_get_pvid_rcu(const struct net_device *dev, u16 *p_pvid);
>  int br_vlan_get_proto(const struct net_device *dev, u16 *p_proto);
>  int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  		     struct bridge_vlan_info *p_vinfo);
> +int br_vlan_replay(struct net_device *br_dev, struct net_device *dev,
> +		   struct notifier_block *nb, struct netlink_ext_ack *extack);
>  #else
>  static inline bool br_vlan_enabled(const struct net_device *dev)
>  {
> @@ -137,6 +139,14 @@ static inline int br_vlan_get_info(const struct net_device *dev, u16 vid,
>  {
>  	return -EINVAL;
>  }
> +
> +static inline int br_vlan_replay(struct net_device *br_dev,
> +				 struct net_device *dev,
> +				 struct notifier_block *nb,
> +				 struct netlink_ext_ack *extack)
> +{
> +	return -EINVAL;

Same comment as patch 8, CONFIG_BRIDGE_VLAN_FILTERING can be turned off
even if this does not really make practical sense with a hardware
switch. Should we return -EOPNOTSUPP instead?
-- 
Florian
