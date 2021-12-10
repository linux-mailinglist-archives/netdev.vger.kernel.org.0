Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2581470788
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243840AbhLJRni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:43:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbhLJRni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:43:38 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B98C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:40:02 -0800 (PST)
Received: from p200300c1f70a1fec5527cb4e6f286342.dip0.t-ipconnect.de ([2003:c1:f70a:1fec:5527:cb4e:6f28:6342] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1mvjsG-0000Zq-EC; Fri, 10 Dec 2021 18:40:00 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
In-Reply-To: <87y24t1fvk.fsf@waldekranz.com>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com>
Date:   Fri, 10 Dec 2021 18:39:59 +0100
Message-ID: <87y24s9x5c.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: text/plain
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1639158003;5b1ab1b1;
X-HE-SMSGID: 1mvjsG-0000Zq-EC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Dec 10 2021, Tobias Waldekranz wrote:
> On Thu, Dec 09, 2021 at 18:33, Kurt Kanzenbach <kurt@kmk-computers.de> wrote:
>> A time aware switch should trap PTP traffic to the management CPU. User space
>> daemons such as ptp4l will process these messages to implement Boundary (or
>> Transparent) Clocks.
>>
>> At the moment the mv88e6xxx driver for mv88e6341 doesn't trap these messages
>> which leads to confusion when multiple end devices are connected to the
>> switch. Therefore, setup PTP traps. Leverage the already implemented policy
>> mechanism based on destination addresses. Configure the traps only if
>> timestamping is enabled so that non time aware use case is still functioning.
>
> Do we know how PTP is supposed to work in relation to things like STP?
> I.e should you be able to run PTP over a link that is currently in
> blocking? It seems like being able to sync your clock before a topology
> change occurs would be nice. In that case, these addresses should be
> added to the ATU as MGMT instead of policy entries.

Given the fact that the l2 p2p address is already considered as
management traffic (see mv88e6390_g1_mgmt_rsvd2cpu()) maybe all PTP
addresses could be treated as such.

[snip]

>> +static int mv88e6341_setup_ptp_traps(struct mv88e6xxx_chip *chip, int port,
>> +				     bool enable)
>> +{
>> +	static const u8 ptp_destinations[][ETH_ALEN] = {
>> +		{ 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 }, /* L2 PTP */
>> +		{ 0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e }, /* L2 P2P */
>> +		{ 0x01, 0x00, 0x5e, 0x00, 0x01, 0x81 }, /* IPv4 PTP */
>> +		{ 0x01, 0x00, 0x5e, 0x00, 0x00, 0x6b }, /* IPv4 P2P */
>> +		{ 0x33, 0x33, 0x00, 0x00, 0x01, 0x81 }, /* IPv6 PTP */
>> +		{ 0x33, 0x33, 0x00, 0x00, 0x00, 0x6b }, /* IPv6 P2P */
>
> How does the L3 entries above play together with IGMP/MLD? I.e. what
> happens if, after launching ptp4l, an IGMP report comes in on lanX,
> requesting that same group? Would the policy entry not be overwritten by
> mv88e6xxx_port_mdb_add?

Just tested this. Yes it is overwritten without any detection or
errors. Actually I did test UDP as well and didn't notice it. It
obviously depends on the order of events.

>
> Eventually I think we will have many interfaces to configure static
> entries in the ATU:
>
> 1. MDB entries from a bridge (already in place)
> 2. User-configured entries through ethtool's rxnfc (already in place)
> 3. Driver-internal consumers (this patch, MRP, etc.)
> 4. User-configured entries through TC.
>
> Seems to me like we need to start tracking the owners for these to stop
> them from stomping on one another.

Agreed. Some mechanism is required. Any idea how to implement it? In
case of PTP the management/policy entries should take precedence.

>
>> +	};
>> +	int ret, i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(ptp_destinations); ++i) {
>> +		struct mv88e6xxx_policy policy = { };
>> +
>> +		policy.mapping	= MV88E6XXX_POLICY_MAPPING_DA;
>> +		policy.action	= enable ? MV88E6XXX_POLICY_ACTION_TRAP :
>> +			MV88E6XXX_POLICY_ACTION_NORMAL;
>> +		policy.port	= port;
>> +		policy.vid	= 0;
>> +		ether_addr_copy(policy.addr, ptp_destinations[i]);
>> +
>> +		ret = mv88e6xxx_policy_apply(chip, port, &policy);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {
>>  	.clock_read = mv88e6165_ptp_clock_read,
>>  	.global_enable = mv88e6165_global_enable,
>> @@ -419,6 +450,34 @@ const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
>>  	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
>>  };
>>  
>> +const struct mv88e6xxx_ptp_ops mv88e6341_ptp_ops = {
>> +	.clock_read = mv88e6352_ptp_clock_read,
>> +	.ptp_enable = mv88e6352_ptp_enable,
>> +	.ptp_verify = mv88e6352_ptp_verify,
>> +	.event_work = mv88e6352_tai_event_work,
>> +	.port_enable = mv88e6352_hwtstamp_port_enable,
>> +	.port_disable = mv88e6352_hwtstamp_port_disable,
>> +	.setup_ptp_traps = mv88e6341_setup_ptp_traps,
>
> Is there any reason why this could not be added to the existing ops for
> 6352 instead? Their ATU's are compatible, IIRC.

No particular reason except that I don't have access to a 6352 device to
test it.

Thanks,
Kurt
