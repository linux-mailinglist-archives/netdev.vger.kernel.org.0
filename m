Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4435322883F
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 20:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgGUSbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 14:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgGUSbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 14:31:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99720206E9;
        Tue, 21 Jul 2020 18:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595356308;
        bh=rPjY4i771aJzKwZate0z9FOnwTEyldQYkxXoWS2Ivhc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mEUbDruzvMKQBuXnvNqbt6NipVZh2xwn7TFTf6QIvL0+LEGBdhPm/eTFwf4lp/vA0
         /VlADnfa96X/ESALeJTW3yCR8BGBK/Jt5BYqMgKZ9CvuB07Uk9IKzAyRE59eTDEPWL
         PnxZGVj7QMF7iZWrO4xhg71HAO9Ljza/5+62xdDU=
Date:   Tue, 21 Jul 2020 11:31:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Alice Michael <alice.michael@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com, Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [net-next v4 06/15] iecm: Implement mailbox functionality
Message-ID: <20200721113145.43c24155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
References: <20200721003810.2770559-1-anthony.l.nguyen@intel.com>
        <20200721003810.2770559-7-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jul 2020 17:38:01 -0700 Tony Nguyen wrote:
> +	struct iecm_adapter *adapter = vport->adapter;
> +	netdev_features_t dflt_features;
> +	netdev_features_t offloads = 0;
> +	struct iecm_netdev_priv *np;
> +	struct net_device *netdev;
> +	int err;
> +
> +	netdev = alloc_etherdev_mqs(sizeof(struct iecm_netdev_priv),
> +				    IECM_MAX_Q, IECM_MAX_Q);
> +	if (!netdev)
> +		return -ENOMEM;
> +	vport->netdev = netdev;
> +	np = netdev_priv(netdev);
> +	np->vport = vport;

> +	/* register last */
> +	err = register_netdev(netdev);
> +	if (err)
> +		return err;

aren't you leaking the netdev here?

> +	return 0;
