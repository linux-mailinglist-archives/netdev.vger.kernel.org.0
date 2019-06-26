Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAF6564FC
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 10:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfFZI6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 04:58:54 -0400
Received: from mail.us.es ([193.147.175.20]:45618 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbfFZI6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 04:58:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 59CAFBAEEF
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 10:58:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A6391150B5
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 10:58:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3F1E1114D70; Wed, 26 Jun 2019 10:58:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CBA72DA4D0;
        Wed, 26 Jun 2019 10:58:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 10:58:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9C4F24265A32;
        Wed, 26 Jun 2019 10:58:46 +0200 (CEST)
Date:   Wed, 26 Jun 2019 10:58:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: ethtool: Allow parsing ETHER_FLOW types
 when using flow_rule
Message-ID: <20190626085846.ax277ojvyp5k3abt@salvia>
References: <20190626084403.17749-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626084403.17749-1-maxime.chevallier@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 10:44:03AM +0200, Maxime Chevallier wrote:
> When parsing an ethtool_rx_flow_spec, users can specify an ethernet flow
> which could contain matches based on the ethernet header, such as the
> MAC address, the VLAN tag or the ethertype.
> 
> Only the ethtype field is specific to the ether flow, the MAC and vlan
> fields are processed using the special FLOW_EXT and FLOW_MAC_EXT flags.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
>  net/core/ethtool.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 4d1011b2e24f..01ceba556341 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -2883,6 +2883,18 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
>  	match->mask.basic.n_proto = htons(0xffff);
>  
>  	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS)) {
> +	case ETHER_FLOW: {
> +		const struct ethhdr *ether_spec, *ether_m_spec;
> +
> +		ether_spec = &fs->h_u.ether_spec;
> +		ether_m_spec = &fs->m_u.ether_spec;
> +
> +		if (ether_m_spec->h_proto) {
> +			match->key.basic.n_proto = ether_spec->h_proto;
> +			match->mask.basic.n_proto = ether_m_spec->h_proto;
> +		}

I see some drivers in the tree also interpret the h_source and h_dest
fields?

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/sfc/falcon/ethtool.c#L1182

Probably good to address this in this patch too?

Thanks.
