Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E91694B3120
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240497AbiBKXD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:03:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiBKXD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:03:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E1DD53
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 15:03:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B60E618C8
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 23:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB07C340E9;
        Fri, 11 Feb 2022 23:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644620633;
        bh=hgLEu+kctMQMT9j+wS4czvwf3p/j+RHTs20WQerEncI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uw1+BWRRahpp+gyFzexJHyiJzuDAtQGFGshNmxSmOj2mo3j+ZiqZeeRwGY1NYvXtt
         TPgVY0U0cRgV7MGFBcKlxjnzEsqZPFboV51+34Do+9zQcJoBZM8wiuOU0wdXPMXV42
         5s3vJgWOipU95jSYHoi95MOxNh0JNirOCOvvKEKFC0dFWGyCeMd6HDLxFXJsIeCo0s
         GpBVbIFyUVCNkF+Fvt/mf9mo2oiVBXA6/R5Z9IhnCQEJ9D4ZD9ZuxmwKD1viP15QPm
         lEJ5t9QFXy21BuEKiiXnP//JXc92mGZg2+0WHmLiEmqSsbRTBThQPN0atVozsZpdfy
         OkZmb280aQxHA==
Date:   Fri, 11 Feb 2022 15:03:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v2 net-next 11/12] net: dsa: support FDB events on
 offloaded LAG interfaces
Message-ID: <20220211150352.548530ae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220210125201.2859463-12-vladimir.oltean@nxp.com>
References: <20220210125201.2859463-1-vladimir.oltean@nxp.com>
        <20220210125201.2859463-12-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 14:52:00 +0200 Vladimir Oltean wrote:
> +static int
> +dsa_lag_fdb_event(struct net_device *lag_dev, struct net_device *orig_dev,
> +		  unsigned long event, const void *ctx,
> +		  const struct switchdev_notifier_fdb_info *fdb_info)
> +{
> +	struct dsa_switchdev_event_work *switchdev_work;
> +	bool host_addr = fdb_info->is_local;
> +	struct net_device *slave;
> +	struct dsa_switch *ds;
> +	struct dsa_port *dp;
> +
> +	/* Skip dynamic FDB entries, since the physical ports beneath the LAG
> +	 * should have learned it too.
> +	 */
> +	if (netif_is_lag_master(orig_dev) &&
> +	    switchdev_fdb_is_dynamically_learned(fdb_info))
> +		return 0;
> +
> +	/* FDB entries learned by the software bridge should be installed as
> +	 * host addresses only if the driver requests assisted learning.
> +	 */
> +	if (switchdev_fdb_is_dynamically_learned(fdb_info) &&
> +	    !ds->assisted_learning_on_cpu_port)
> +		return 0;
> +
> +	/* Get a handle to any DSA interface beneath the LAG */
> +	slave = switchdev_lower_dev_find(lag_dev, dsa_slave_dev_check,
> +					 dsa_foreign_dev_check);
> +	dp = dsa_slave_to_port(slave);
> +	ds = dp->ds;

clang says:

net/dsa/slave.c:2650:7: warning: variable 'ds' is uninitialized when used here [-Wuninitialized]
           !ds->assisted_learning_on_cpu_port)
            ^~

It also suggests:

net/dsa/slave.c:2636:23: note: initialize the variable 'ds' to silence this warning
       struct dsa_switch *ds;
                            ^
                             = NULL

but that's perhaps for comedic purposes.
