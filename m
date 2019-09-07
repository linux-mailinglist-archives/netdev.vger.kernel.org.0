Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43837AC933
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390111AbfIGUc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:32:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727307AbfIGUc7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 16:32:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kyvuyoHdxrydvH+51FKDEdWGnn1qLGsWLEYMBkR3bwU=; b=jVrdach9Cb1KnzKICxzQu72/E2
        ifF1wbMVskt5nTfbjgV4+jDqLg8xKuq3t7TxTDbFzNKfsrtcflp84Yajq1p1dxNmkN9AXXLFDtY6B
        oYxfXiJXzcV9YWts9v8yO3gcWs+Ia9saYC7uLggP6OPaADJYg5dU/excB9x2+T4JVWk4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6hOC-0005gy-Hz; Sat, 07 Sep 2019 22:32:56 +0200
Date:   Sat, 7 Sep 2019 22:32:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add RXNFC support
Message-ID: <20190907203256.GA18741@lunn.ch>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
 <20190907200049.25273-4-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907200049.25273-4-vivien.didelot@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv88e6xxx_policy_insert(struct mv88e6xxx_chip *chip, int port,
> +				   struct ethtool_rx_flow_spec *fs)
> +{
> +	struct ethhdr *mac_entry = &fs->h_u.ether_spec;
> +	struct ethhdr *mac_mask = &fs->m_u.ether_spec;
> +	enum mv88e6xxx_policy_mapping mapping;
> +	enum mv88e6xxx_policy_action action;
> +	struct mv88e6xxx_policy *policy;
> +	u16 vid = 0;
> +	u8 *addr;
> +	int err;
> +	int id;
> +
> +	if (fs->location != RX_CLS_LOC_ANY)
> +		return -EINVAL;
> +
> +	if (fs->ring_cookie == RX_CLS_FLOW_DISC)
> +		action = MV88E6XXX_POLICY_ACTION_DISCARD;
> +	else
> +		return -EOPNOTSUPP;
> +
> +	switch (fs->flow_type & ~FLOW_EXT) {
> +	case ETHER_FLOW:
> +		if (!is_zero_ether_addr(mac_mask->h_dest) &&
> +		    is_zero_ether_addr(mac_mask->h_source)) {
> +			mapping = MV88E6XXX_POLICY_MAPPING_DA;
> +			addr = mac_entry->h_dest;
> +		} else if (is_zero_ether_addr(mac_mask->h_dest) &&
> +		    !is_zero_ether_addr(mac_mask->h_source)) {
> +			mapping = MV88E6XXX_POLICY_MAPPING_SA;
> +			addr = mac_entry->h_source;
> +		} else {
> +			/* Cannot support DA and SA mapping in the same rule */
> +			return -EOPNOTSUPP;
> +		}
> +		break;
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if ((fs->flow_type & FLOW_EXT) && fs->m_ext.vlan_tci) {
> +		if (fs->m_ext.vlan_tci != 0xffff)
> +			return -EOPNOTSUPP;
> +		vid = be16_to_cpu(fs->h_ext.vlan_tci) & VLAN_VID_MASK;
> +	}
> +
> +	idr_for_each_entry(&chip->policies, policy, id) {
> +		if (policy->port == port && policy->mapping == mapping &&
> +		    policy->action == action && policy->vid == vid &&
> +		    ether_addr_equal(policy->addr, addr))
> +			return -EEXIST;
> +	}
> +
> +	policy = devm_kzalloc(chip->dev, sizeof(*policy), GFP_KERNEL);
> +	if (!policy)
> +		return -ENOMEM;

Hi Vivien

I think this might be the first time we have done dynamic memory
allocation in the mv88e6xxx driver. It might even be a first for a DSA
driver?

I'm not saying it is wrong, but maybe we should discuss it. 

I assume you are doing this because the ATU entry itself is not
sufficient?

How much memory is involved here, worst case? I assume one struct
mv88e6xxx_policy per ATU entry? Which you think is too much to
allocate as part of chip? I guess most users will never use this
feature, so for most users it would be wasted memory. So i do see the
point for dynamically allocating it.

Thanks
	Andrew
