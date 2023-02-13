Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBBA4694712
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 14:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjBMNcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 08:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjBMNcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 08:32:50 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95FB1ABF3;
        Mon, 13 Feb 2023 05:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WfnC+oG7H1liXzVZT+FHK51tDwPsM5vOONmGvVct5/g=; b=E7GbKirLHmxm03B7GCg417Nf0h
        jMSD/eKkwkcEx1V661JfTIjS6zbv5RFTlvl+gNcv3mZ3O/0Zm60Ku8Fsz9zZYIXbl7J0eAdQfP1sk
        cBo1LL1zPqx7pX3j3UEMV0BQt8TT+c9r1g/NQ+Abhcs11EsrzjnrUO0YeEaIYgp3uEtI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pRYwR-004qF9-U7; Mon, 13 Feb 2023 14:32:23 +0100
Date:   Mon, 13 Feb 2023 14:32:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     wei.fang@nxp.com
Cc:     shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, simon.horman@corigine.com,
        linux-imx@nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next] net: fec: add CBS offload support
Message-ID: <Y+o75wT84f6RTohf@lunn.ch>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213092912.2314029-1-wei.fang@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 3. According to Andrew's comments, the speed may be equal to 0 when the
>    link is not up, so added a check to see if speed is equal to 0. In
>    addtion, the change in link speed also need to be taken into account.
>    Considering that the change of link speed has invalidated the original
>    configuration, so we just fall back to the default setting.

I don't think that is what you have actually implemented. A link
status change causes a fec_restart. And in fac_restart, you now
reprogram the hardware. So if the link speed is sufficient to support
the request, the hardware should be setup to support it.

What are the real uses cases here? VoIP? Video streaming? So 128kbps,
2Mbps. Both of those are fine over a 10Half limk. So i think you
should try to configure the hardware whenever possible, after link
change or any other condition which causes a reset of the hardware.

What i have not seen addresses here is my comment/question about what
tc shows when it is not possible to perform the request after a link
change? Did you look at how other drivers handle this? Maybe you need
to ask Jamal?

> +static int fec_enet_setup_tc_cbs(struct net_device *ndev, void *type_data)
> +{
> +	struct fec_enet_private *fep = netdev_priv(ndev);
> +	struct tc_cbs_qopt_offload *cbs = type_data;
> +	int queue = cbs->queue;
> +	int speed = fep->speed;
> +	int queue2;
> +
> +	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
> +		return -EOPNOTSUPP;
> +
> +	/* Queue 1 for Class A, Queue 2 for Class B, so the ENET must
> +	 * have three queues.
> +	 */
> +	if (fep->num_tx_queues != FEC_ENET_MAX_TX_QS)
> +		return -EOPNOTSUPP;
> +
> +	if (!speed) {
> +		netdev_err(ndev, "Link speed is 0!\n");
> +		return -ECANCELED;

ECANCLED? First time i've seen that one used. I had to go look it up
to see what it means. It does not really give the user any idea why it
failed. How about -ENETDOWN?

	Andrew
