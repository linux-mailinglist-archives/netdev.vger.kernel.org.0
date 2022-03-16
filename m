Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21F54DB583
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 17:00:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347092AbiCPQBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 12:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiCPQBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 12:01:15 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0373DDFD;
        Wed, 16 Mar 2022 09:00:00 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id p15so5161893ejc.7;
        Wed, 16 Mar 2022 09:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CxBlO0C502y1jpeWHAj0rnF5IMS/Z4EuROWhss7SnWs=;
        b=JGMB0dsPB1GrxAi6JpNXgtS72jVkFOHljY4TZdBg6Vn985GUp5yWutHNgiB/ymSvVz
         Ns4YRhE+2mtfwFWgMAyS/l1Wv204oLxxxtjNiDBISwvIdmYli7Zxg30TxJf2PSpo5qD7
         KVfluv9AKpsQtstRO6ImY9Nr9cU8pKn2N/kRRgB8eLUCRZIrBIV0PbtUr9LeS64c/qtO
         HrnYfue7by4ulT6m/17L1358uDPQKiQovIzEpGgnQnQvJG0r3hSGEMZWhZEEirlEVsG9
         Y4cN05Y5px1OY1rXeHVqkf5WjSUfemS6aKqRBK4VBmdC3AkobI4kJakUHp7qgQSVthjH
         CuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CxBlO0C502y1jpeWHAj0rnF5IMS/Z4EuROWhss7SnWs=;
        b=7LvJhdGbiP5QjC9moz3umAiCOJgtRo8ehk+QrZzj6G+GbFkfqlTnDBDnr8s9+3b/bc
         2d3YmxDTh2mGArf88PYUb8xhJ1CdTaplPj3cc4TGa4gEUdRzRmtuiOWcUK8eKox+j92P
         d6iuMHgU/c3Md5FMOsxdtc5yvK5EkT/uM+zS2+5eIs2wVhdgrC7GjmVEw4eMc8ynvJWS
         Je5fb/EBLMUvYf8WnPZ840GM6/fbCxFl+crbouQSD6QTMkuuytJGml88+g/ERThxa/kU
         D/j7LTyedPe7lRBAN9f3QckWCsrCy9SWr68Tmmw1hVD2M+0H5bgZ0oUcMHBkPH5/oZ1x
         GpWA==
X-Gm-Message-State: AOAM530oEy7erSrAHLqd/i7KO2tPb9IDO3xcZ384FvUI41i7dBbsUnrX
        Vg50VtRmxeTZxjKOCXlBox8=
X-Google-Smtp-Source: ABdhPJwcOThT7DlE2zS9uYNLym4QBIYFoyqVObijFN6e4+Cjci/GkcPa4xgC79NQo5C1dAplVRFVlA==
X-Received: by 2002:a17:906:2699:b0:6d0:9f3b:a6a7 with SMTP id t25-20020a170906269900b006d09f3ba6a7mr510974ejc.397.1647446398797;
        Wed, 16 Mar 2022 08:59:58 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id w19-20020a05640234d300b00416baf4cdcasm1218527edc.48.2022.03.16.08.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:59:58 -0700 (PDT)
Date:   Wed, 16 Mar 2022 17:59:56 +0200
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
Subject: Re: [PATCH v5 net-next 10/15] net: dsa: Validate hardware support
 for MST
Message-ID: <20220316155956.swin6lhz5r4fn5ef@skbuf>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-11-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316150857.2442916-11-tobias@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 04:08:52PM +0100, Tobias Waldekranz wrote:
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

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

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
> +
>  int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
>  			      struct switchdev_brport_flags flags,
>  			      struct netlink_ext_ack *extack)
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index f9cecda791d5..2e8f62476ce9 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -464,6 +464,12 @@ static int dsa_slave_port_attr_set(struct net_device *dev, const void *ctx,
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

