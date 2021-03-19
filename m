Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F4342879
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhCSWJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhCSWJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 18:09:04 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55221C06175F;
        Fri, 19 Mar 2021 15:08:53 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id f8so1171944pgi.9;
        Fri, 19 Mar 2021 15:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r6eY5ZOzAqwwciw96athK5PF+naRpfRhmF2rxJxUlYU=;
        b=QUN/5HoW1VUXOOJNyfv5vropavY3GbqNMpECUuLKZogZs2nTmhGqhuMNlNNtPi5Avg
         yF1mRpcNlZZPgWcfG2zL/ZXNuBsBh4/JnWEaLhfax/3pschWSPrAglrRTss7XxYrOQ1w
         GdPAjT0O/K+nsfi/YhySC5lsIiTqA1LyDpCe+BUhBAEqcgD1py9S+0yUPlo7WYGNNJGa
         3TTI/xD+uY+51tOaB4kPLme7RlxVWhv3mJaMxGPyfxjpQgnri5BWP+87BnGR2EtHyUal
         3fsW22m/uFE2KpUPB4zSZzstkuug1gvI3mV+B1rgPCAC8uoVnJ8/qXfWpRutwNfc54xX
         nqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r6eY5ZOzAqwwciw96athK5PF+naRpfRhmF2rxJxUlYU=;
        b=YTKSyNdFS8AZn2FzWHmk45WbFridX3/o7GXOMdP8ceymqZFDcURkZcOAxqHof2I/bm
         SN5f+7OW8GunNUnf477398EvsBMH8C/f0EKPyzDAtp1CWZnuSvgxxZ2uK4XVAq9QC0kB
         HnXEHgGtCdkAHYbrg5uL6fPwZP7GIECz1vp6rzaP/ht7TaCv+FyCqedoP3QaPioHkddy
         Og7nscAMIw4wuyeNKqab8SlkEq48xLz0HnV9KR7y+uigacnE2UuXfkcbozIBhgqLmage
         CEVgqIDX+QxRpbimUMfFpNlTkBbZqeBjReeh2wOQRTyZYZ5H2fLN3VYRd8nIg9ClM93O
         pKVg==
X-Gm-Message-State: AOAM532Mh60wWS94oGRNPDU4+MW+nSjR6+/c3IpjoDamZ2PnCacnmCQ9
        d41MaOTfLiKH9La9MEKhLRo=
X-Google-Smtp-Source: ABdhPJzDm7vZ/M5ygrnDOeAoRc37EVrpkF+rC/u9ahvIDeIvb0TXM6FmbhrylREd/m/6JRpjYzoNHQ==
X-Received: by 2002:a62:5c84:0:b029:1f2:a5f0:d12a with SMTP id q126-20020a625c840000b02901f2a5f0d12amr10851661pfb.36.1616191732763;
        Fri, 19 Mar 2021 15:08:52 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x19sm6154419pfi.220.2021.03.19.15.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 15:08:52 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 03/16] net: dsa: inherit the actual bridge
 port flags at join time
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
 <20210318231829.3892920-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2d10377e-88d0-6dea-ff12-469dab1aced0@gmail.com>
Date:   Fri, 19 Mar 2021 15:08:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210318231829.3892920-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 4:18 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> DSA currently assumes that the bridge port starts off with this
> constellation of bridge port flags:
> 
> - learning on
> - unicast flooding on
> - multicast flooding on
> - broadcast flooding on
> 
> just by virtue of code copy-pasta from the bridge layer (new_nbp).
> This was a simple enough strategy thus far, because the 'bridge join'
> moment always coincided with the 'bridge port creation' moment.
> 
> But with sandwiched interfaces, such as:
> 
>  br0
>   |
> bond0
>   |
>  swp0
> 
> it may happen that the user has had time to change the bridge port flags
> of bond0 before enslaving swp0 to it. In that case, swp0 will falsely
> assume that the bridge port flags are those determined by new_nbp, when
> in fact this can happen:
> 
> ip link add br0 type bridge
> ip link add bond0 type bond
> ip link set bond0 master br0
> ip link set bond0 type bridge_slave learning off
> ip link set swp0 master br0
> 
> Now swp0 has learning enabled, bond0 has learning disabled. Not nice.
> 
> Fix this by "dumpster diving" through the actual bridge port flags with
> br_port_flag_is_set, at bridge join time.
> 
> We use this opportunity to split dsa_port_change_brport_flags into two
> distinct functions called dsa_port_inherit_brport_flags and
> dsa_port_clear_brport_flags, now that the implementation for the two
> cases is no longer similar.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/port.c | 123 ++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 82 insertions(+), 41 deletions(-)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index fcbe5b1545b8..346c50467810 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -122,26 +122,82 @@ void dsa_port_disable(struct dsa_port *dp)
>  	rtnl_unlock();
>  }
>  
> -static void dsa_port_change_brport_flags(struct dsa_port *dp,
> -					 bool bridge_offload)
> +static void dsa_port_clear_brport_flags(struct dsa_port *dp,
> +					struct netlink_ext_ack *extack)
>  {
>  	struct switchdev_brport_flags flags;
> -	int flag;
>  
> -	flags.mask = BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_BCAST_FLOOD;
> -	if (bridge_offload)
> -		flags.val = flags.mask;
> -	else
> -		flags.val = flags.mask & ~BR_LEARNING;
> +	flags.mask = BR_LEARNING;
> +	flags.val = 0;
> +	dsa_port_bridge_flags(dp, flags, extack);

Would not you want to use the same for_each_set_bit() loop that
dsa_port_change_br_flags() uses, that would be a tad more compact.
-- 
Florian
