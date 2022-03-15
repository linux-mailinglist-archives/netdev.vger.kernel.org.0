Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B979F4DA0EB
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 18:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343734AbiCORM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 13:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237673AbiCORM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 13:12:27 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939F34B431;
        Tue, 15 Mar 2022 10:11:12 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id b24so25033668edu.10;
        Tue, 15 Mar 2022 10:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nsOPoTjYO31xmcYiR0Z53NdVcW3nQ8I9RxXyOBwrxLo=;
        b=ogie58XbyC044aIOIW7cMm2s63cnnv5pxF5kNRlnpnJKw98K03gVDIgH9dnxdDzcYW
         tk6BAoWrdf0iGYtJGuMKek3O6WPX/2om4NDj02C4LpSB6prgmdvnUOLjfT9Wy4K8sKFg
         2ty+1TbryeKQa6/VGQ0JN/nTlUuCauLN96fU7HFjxgkzpbw8v/ukaVQZF3o1lcgUjQWt
         9rpa3jil6wCyxfa0xy0SDGcPAe0VwhQm4zZ5+2Xj7MQZx09De0ZzimgGkS5A5MhJQste
         hFKSbv2qjwZ5zz7nTZtX1CU+AqkOcrIyz7BO3GiPz7j+FReCrmRuhpck0ezzDnvUz90C
         kAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nsOPoTjYO31xmcYiR0Z53NdVcW3nQ8I9RxXyOBwrxLo=;
        b=AbDRqU2o5qKTfsm3m90BU6+TOEv3gWi9Zt7L4CJJZsIK+Z24xoOZ5VRhESRjn6JS4T
         T5jOSe5PDvLXkSpYNyJ0HZZYEHw+qxLSwsG4QsTtreQiKalcI6fEr+vBpWX139OQLyiw
         G8Owda6UxfkZrmAzB/tw+3Cttcrj7Vc/tOU2a+9vMPPPE28m5Cigm87TnL7TNvpumcJU
         0ulunMx0xhhe75gAeS1Ou+NSkW6F2CHW38RzmQyvUhMzsy5doUWh/UgWfrbOENQVaCYR
         ICZlI3eYYAky3LEj7nMGFKKxw53aPXr/ZRCuzKPshE/6evCrC+lUV+N1UgOMu2jfk/F7
         gVnA==
X-Gm-Message-State: AOAM533ziCN209wU2CcSMmb5O/KS7/kwsWRS0wp4l4iWmYlTsUb+/w1Z
        SbfUFcKG9AYF8udaxPgn/5E=
X-Google-Smtp-Source: ABdhPJyMcbCrSunj00vOXb1Hq01GHRtHoWByyACgxX4bA92KobNxwMQ6UKuM7oMOJiphuGX0C80tXg==
X-Received: by 2002:aa7:c948:0:b0:413:2bed:e82e with SMTP id h8-20020aa7c948000000b004132bede82emr26286184edt.394.1647364271058;
        Tue, 15 Mar 2022 10:11:11 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id v10-20020a170906380a00b006a68610908asm8412244ejc.24.2022.03.15.10.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 10:11:10 -0700 (PDT)
Date:   Tue, 15 Mar 2022 19:11:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: Re: [PATCH v4 net-next 10/15] net: dsa: Validate hardware support
 for MST
Message-ID: <20220315171108.ameddbqv2sehq3pp@skbuf>
References: <20220315002543.190587-1-tobias@waldekranz.com>
 <20220315002543.190587-11-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315002543.190587-11-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 01:25:38AM +0100, Tobias Waldekranz wrote:
> When joining a bridge where MST is enabled, we validate that the
> proper offloading support is in place, otherwise we fallback to
> software bridging.
> 
> When then mode is changed on a bridge in which we are members, we
> refuse the change if offloading is not supported.
> 
> At the moment we only check for configurable learning, but this will
> be further restricted as we support more MST related switchdev events.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  net/dsa/dsa_priv.h |  2 ++
>  net/dsa/port.c     | 22 ++++++++++++++++++++++
>  net/dsa/slave.c    |  6 ++++++
>  3 files changed, 30 insertions(+)
> 
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index f20bdd8ea0a8..2aba420696ef 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -234,6 +234,8 @@ int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
>  			    struct netlink_ext_ack *extack);
>  bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
>  int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock);
> +int dsa_port_mst_enable(struct dsa_port *dp, bool on,
> +			struct netlink_ext_ack *extack);
>  int dsa_port_mtu_change(struct dsa_port *dp, int new_mtu,
>  			bool targeted_match);
>  int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index 58291df14cdb..02214033cec0 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -321,6 +321,11 @@ static void dsa_port_bridge_destroy(struct dsa_port *dp,
>  	kfree(bridge);
>  }
>  
> +static bool dsa_port_supports_mst(struct dsa_port *dp)
> +{
> +	return dsa_port_can_configure_learning(dp);
> +}
> +
>  int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>  			 struct netlink_ext_ack *extack)
>  {
> @@ -334,6 +339,9 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
>  	struct net_device *brport_dev;
>  	int err;
>  
> +	if (br_mst_enabled(br) && !dsa_port_supports_mst(dp))
> +		return -EOPNOTSUPP;
> +
>  	/* Here the interface is already bridged. Reflect the current
>  	 * configuration so that drivers can program their chips accordingly.
>  	 */
> @@ -735,6 +743,20 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
>  	return 0;
>  }
>  
> +int dsa_port_mst_enable(struct dsa_port *dp, bool on,
> +			struct netlink_ext_ack *extack)
> +{
> +	if (!on)
> +		return 0;
> +
> +	if (!dsa_port_supports_mst(dp)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}

Experimenting a bit... maybe this looks tidier? We make the "if" condition
have the same basic structure as the previous "if (br_mst_enabled(br) &&
!dsa_port_supports_mst(dp))", albeit transformed using De Morgan's rules.

{
	if (!on || dsa_port_supports_mst(dp))
		return 0;

	NL_SET_ERR_MSG_MOD(extack, "Hardware does not support MST");
	return -EINVAL;
}

> +
>  int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
>  			      struct switchdev_brport_flags flags,
>  			      struct netlink_ext_ack *extack)
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 647adee97f7f..879d18cc99cb 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -463,6 +463,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
>  
>  		ret = dsa_port_ageing_time(dp, attr->u.ageing_time);
>  		break;
> +	case SWITCHDEV_ATTR_ID_BRIDGE_MST:
> +		if (!dsa_port_offloads_bridge_dev(dp, attr->orig_dev))
> +			return -EOPNOTSUPP;
> +
> +		ret = dsa_port_mst_enable(dp, attr->u.mst, extack);
> +		break;
>  	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
>  		if (!dsa_port_offloads_bridge_port(dp, attr->orig_dev))
>  			return -EOPNOTSUPP;
> -- 
> 2.25.1
> 

