Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E553125B88
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfEVBI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:08:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42663 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726466AbfEVBI4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 21:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8e0/LEnMoN5I+WzZ/E/RaYBTbLwsGWGykiX8u4+pbKc=; b=LCsXlbD7fDD+oU5EJmlT+mNX3k
        0FMlgcKhskw5dlD844or5NpQd8kUk+JRCabb3e8Ri+k0byAgvHmLmdxtwV/2i2um5G8P5T6pwE6zr
        YyNWd+yjCboJRb5R1RydcN4et2Y2RibJewHuZf0GClpaaI3zzCUv41gDU7hzs61vmxHw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTFkS-00005c-RZ; Wed, 22 May 2019 03:08:52 +0200
Date:   Wed, 22 May 2019 03:08:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 3/6] net: Add a layer for non-PHY MII time
 stamping drivers.
Message-ID: <20190522010852.GE6577@lunn.ch>
References: <20190521224723.6116-4-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521224723.6116-4-richardcochran@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct mii_timestamper *register_mii_timestamper(struct device_node *node,
> +						 unsigned int port)
> +{
> +	struct mii_timestamper *mii_ts = NULL;
> +	struct mii_timestamping_desc *desc;
> +	struct list_head *this;
> +
> +	mutex_lock(&tstamping_devices_lock);
> +	list_for_each(this, &mii_timestamping_devices) {
> +		desc = list_entry(this, struct mii_timestamping_desc, list);
> +		if (desc->device->of_node == node) {
> +			mii_ts = desc->ctrl->probe_channel(desc->device, port);
> +			if (mii_ts) {
> +				mii_ts->device = desc->device;
> +				get_device(desc->device);

> + * @probe_channel:	Callback into the controller driver announcing the
> + *			presence of the 'port' channel.  The 'device' field
> + *			had been passed to register_mii_tstamp_controller().
> + *			The driver must return either a pointer to a valid
> + *			MII timestamper instance or PTR_ERR.

Hi Richard

probe_channel returns an PTR_ERR. So if (mii_ts) should probably be
if (IS_ERR(mii_ts))

   Andrew
