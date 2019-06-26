Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 665B55659A
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 11:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFZJXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 05:23:51 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44543 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfFZJXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 05:23:50 -0400
X-Originating-IP: 86.250.200.211
Received: from bootlin.com (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 65EECE0005;
        Wed, 26 Jun 2019 09:23:45 +0000 (UTC)
Date:   Wed, 26 Jun 2019 11:23:55 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     davem@davemloft.net, Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next] net: ethtool: Allow parsing ETHER_FLOW types
 when using flow_rule
Message-ID: <20190626112355.73a1e74f@bootlin.com>
In-Reply-To: <20190626085846.ax277ojvyp5k3abt@salvia>
References: <20190626084403.17749-1-maxime.chevallier@bootlin.com>
        <20190626085846.ax277ojvyp5k3abt@salvia>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pablo,

On Wed, 26 Jun 2019 10:58:46 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

>On Wed, Jun 26, 2019 at 10:44:03AM +0200, Maxime Chevallier wrote:
>> When parsing an ethtool_rx_flow_spec, users can specify an ethernet flow
>> which could contain matches based on the ethernet header, such as the
>> MAC address, the VLAN tag or the ethertype.
>> 
>> Only the ethtype field is specific to the ether flow, the MAC and vlan
>> fields are processed using the special FLOW_EXT and FLOW_MAC_EXT flags.
>> 
>> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
>> ---
>>  net/core/ethtool.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>> 
>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>> index 4d1011b2e24f..01ceba556341 100644
>> --- a/net/core/ethtool.c
>> +++ b/net/core/ethtool.c
>> @@ -2883,6 +2883,18 @@ ethtool_rx_flow_rule_create(const struct ethtool_rx_flow_spec_input *input)
>>  	match->mask.basic.n_proto = htons(0xffff);
>>  
>>  	switch (fs->flow_type & ~(FLOW_EXT | FLOW_MAC_EXT | FLOW_RSS)) {
>> +	case ETHER_FLOW: {
>> +		const struct ethhdr *ether_spec, *ether_m_spec;
>> +
>> +		ether_spec = &fs->h_u.ether_spec;
>> +		ether_m_spec = &fs->m_u.ether_spec;
>> +
>> +		if (ether_m_spec->h_proto) {
>> +			match->key.basic.n_proto = ether_spec->h_proto;
>> +			match->mask.basic.n_proto = ether_m_spec->h_proto;
>> +		}  
>
>I see some drivers in the tree also interpret the h_source and h_dest
>fields?

Ah yes you're right. I assumed these fields were specific to the
FLOW_MAC_EXT flags, but by looking into the ethtool code, it seems we
do need to handle the h_source and h_dest fields.

I'll respin with these fields added.

Thanks for the review,

Maxime
