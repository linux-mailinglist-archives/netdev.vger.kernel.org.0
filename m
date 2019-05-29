Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411312E203
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfE2QJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:09:45 -0400
Received: from mail.us.es ([193.147.175.20]:54566 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726311AbfE2QJp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 12:09:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 23CADC328D
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 18:09:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15485DA706
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 18:09:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED02CDA70E; Wed, 29 May 2019 18:09:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAFD5DA704;
        Wed, 29 May 2019 18:09:40 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 18:09:40 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 90D8D4265A31;
        Wed, 29 May 2019 18:09:40 +0200 (CEST)
Date:   Wed, 29 May 2019 18:09:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net v2] ethtool: Drop check for vlan etype and vlan tci
 when parsing flow_rule
Message-ID: <20190529160940.k2hnuoauaa4y2rga@salvia>
References: <20190529151344.31267-1-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529151344.31267-1-maxime.chevallier@bootlin.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 05:13:44PM +0200, Maxime Chevallier wrote:
> When parsing an ethtool flow spec to build a flow_rule, the code checks
> if both the vlan etype and the vlan tci are specified by the user to add
> a FLOW_DISSECTOR_KEY_VLAN match.
> 
> However, when the user only specified a vlan etype or a vlan tci, this
> check silently ignores these parameters.
> 
> For example, the following rule :
> 
> ethtool -N eth0 flow-type udp4 vlan 0x0010 action -1 loc 0
> 
> will result in no error being issued, but the equivalent rule will be
> created and passed to the NIC driver :
> 
> ethtool -N eth0 flow-type udp4 action -1 loc 0
> 
> In the end, neither the NIC driver using the rule nor the end user have
> a way to know that these keys were dropped along the way, or that
> incorrect parameters were entered.
> 
> This kind of check should be left to either the driver, or the ethtool
> flow spec layer.
> 
> This commit makes so that ethtool parameters are forwarded as-is to the
> NIC driver.
> 
> Since none of the users of ethtool_rx_flow_rule_create are using the
> VLAN dissector, I don't think this qualifies as a regression.
> 
> Fixes: eca4205f9ec3 ("ethtool: add ethtool_rx_flow_spec to flow_rule structure translator")
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V2: Added Fixes: tag, targetted to -net.
> 
>  net/core/ethtool.c | 31 ++++++++++++++-----------------
>  1 file changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
> index 4a593853cbf2..2fe86893e9b5 100644
> --- a/net/core/ethtool.c
> +++ b/net/core/ethtool.c
> @@ -3010,26 +3010,23 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
>  		const struct ethtool_flow_ext *ext_h_spec = &fs->h_ext;
>  		const struct ethtool_flow_ext *ext_m_spec = &fs->m_ext;
>  
> -		if (ext_m_spec->vlan_etype &&
> -		    ext_m_spec->vlan_tci) {
> -			match->key.vlan.vlan_tpid = ext_h_spec->vlan_etype;
> -			match->mask.vlan.vlan_tpid = ext_m_spec->vlan_etype;
> +		match->key.vlan.vlan_tpid = ext_h_spec->vlan_etype;
> +		match->mask.vlan.vlan_tpid = ext_m_spec->vlan_etype;

Could you just check for ext_m_spec->vlan_etype, then set vlan_tpid
accordingly? ie.

        if (ext_m_spec->vlan_etype) {
		match->key.vlan.vlan_tpid = ext_h_spec->vlan_etype;
		match->mask.vlan.vlan_tpid = ext_m_spec->vlan_etype;
        }
        if (ext_m_spec->vlan_tci) {
                match->key.vlan.vlan_id = ...;
                match->mask.vlan.vlan_id = ...;
                match->key.vlan.vlan_priority = ...;
                match->mask.vlan.vlan_priority = ...;
        }

        if (ext_m_spec->vlan_etype ||
            ext_m_spec->vlan_tci) {
		match->dissector.used_keys |=
			BIT(FLOW_DISSECTOR_KEY_VLAN);
		match->dissector.offset[FLOW_DISSECTOR_KEY_VLAN] =
			offsetof(struct ethtool_rx_flow_key, vlan);
        }

Something like this above.
