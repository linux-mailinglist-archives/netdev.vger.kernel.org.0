Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B15BF6CECFA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 17:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjC2Pdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 11:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjC2Pd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 11:33:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A6F4690
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4jtDd//KLM1/az8/LDt0TKRVf5SXIeJK6JOubZyXexo=; b=Z6aHOTEmhw/y6OkHLc0pdf0OqF
        PVq2sEnsDv+LT5AT69zsrOyc30xbx7owichltZyPc07b05kUXLXOcqzYw0i+n7N/AvtAnbTK78T74
        ci1BlN7QmT5kDntqpOkrxgUYPdWiaglLKmLUxnh/W8C2tZ739lO3PLuEh/yGo0wWDSl0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phXnR-008lye-7A; Wed, 29 Mar 2023 17:33:09 +0200
Date:   Wed, 29 Mar 2023 17:33:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        shiraz.saleem@intel.com, emil.s.tantilov@intel.com,
        willemb@google.com, decot@google.com, joshua.a.hay@intel.com,
        sridhar.samudrala@intel.com, Alan Brady <alan.brady@intel.com>,
        Alice Michael <alice.michael@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next 14/15] idpf: add ethtool
 callbacks
Message-ID: <53741774-bf50-4c17-9ea9-0c101ea21d52@lunn.ch>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-15-pavan.kumar.linga@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329140404.1647925-15-pavan.kumar.linga@intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int idpf_get_link_ksettings(struct net_device *netdev,
> +				   struct ethtool_link_ksettings *cmd)
> +{
> +	struct idpf_vport *vport = idpf_netdev_to_vport(netdev);
> +
> +	if (!vport)
> +		return -EINVAL;
> +
> +	ethtool_link_ksettings_zero_link_mode(cmd, supported);
> +	cmd->base.autoneg = AUTONEG_DISABLE;
> +	cmd->base.port = PORT_NONE;
> +	cmd->base.duplex = DUPLEX_FULL;
> +	cmd->base.speed = vport->link_speed_mbps;


No supported modes, yet it has a duplex and a link speed?

> +static void idpf_recv_event_msg(struct idpf_vport *vport)
> +{
> +	struct virtchnl2_event *v2e = NULL;
> +	bool link_status;
> +	u32 event;
> +
> +	v2e = (struct virtchnl2_event *)vport->vc_msg;
> +	event = le32_to_cpu(v2e->event);
> +
> +	switch (event) {
> +	case VIRTCHNL2_EVENT_LINK_CHANGE:
> +		vport->link_speed_mbps = le32_to_cpu(v2e->link_speed);
> +		link_status = v2e->link_status;
> +
> +		if (vport->link_up == link_status)
> +			break;
> +
> +		vport->link_up = link_status;
> +		if (vport->state == __IDPF_VPORT_UP) {
> +			if (vport->link_up) {
> +				netif_carrier_on(vport->netdev);
> +				netif_tx_start_all_queues(vport->netdev);
> +			} else {
> +				netif_tx_stop_all_queues(vport->netdev);
> +				netif_carrier_off(vport->netdev);
> +			}
> +		}

It has a link speed even when the carrier is off? This just makes me
think the link speed is bogus, and you would be better reporting
DUPLEX_UNKNOWN, SPEED_UNKNOWN. Or not even implementing ksettings,
since you don't have anything meaningful to report.

	Andrew
