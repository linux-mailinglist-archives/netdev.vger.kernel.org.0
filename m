Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF876C8D6A
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 12:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjCYL2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 07:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjCYL2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 07:28:37 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2066.outbound.protection.outlook.com [40.107.241.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5249EF6;
        Sat, 25 Mar 2023 04:28:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JpBFmgHbRDrccsU3qAiGCLWRmpSMshe+iwYdOJmLikj2GiIT44DI/ep8RDX6Aid+GWyWwmkFUm46MuD/tTD1aSgAQOBWm4zUr5NxfDvuFHzna3qNCyMeuyZA4hDDU8RQl4mivkEMlb0oX3iQ1nKyXqY8naFse/xBx0eTjNLe4QDGt7K6sajolikiJw8M4cU18Mws1lSr9qC7mjog0z49BWkEjpHqB08+Raw4CuXeeNDSIuwa/kAtkV4RVUYwrtxtMSNHA7vS4iqh3uyi9oCtRAEQDTxhgtuNBbuZ017U8ZfiQIhyzIadPKWEd4wPhvwljn+PdP3+J16jlEP58rlO8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LDhidm5a1xzhKuLwHZRH0DjXPSRZdvgUQZE4ZTu8YuI=;
 b=YkEysB/a01EZ1dpQvlNafRIT7QHHdBxQTjdUohBmLsNf13yrMFQgEmgjPljzwjt8GXa+y6zMWDLbPUb3FW2YLZQeQ2Eo7nPnUumAafSI9RlNjTUkSHm1vUSJYqkCh8WOe1d7aOPFZGAStUSLSq4Wt3oNbhjW6RcYEhScNWzt8zTnOk23RV2ntpGoPqD7qMMj/jBXTOopjUAtSXDJT2S08vV9xnH8YPLsH77oe3T4gypyPUTuzUCr00BcAqO3c2E0++VEI9x7BEyWDbD/dARKMhslE66yKGC/NpPRw7Q+40gN5dY56jrCwHfaSNuTsABDMi23W0uMwU92toPnO7RxbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LDhidm5a1xzhKuLwHZRH0DjXPSRZdvgUQZE4ZTu8YuI=;
 b=h3CkGKTorHAeGi94uv8UXx1WQTbkpQboWLjoGMFuyv/AvGdHmiNbSzeOOAesMEtI8ZDPdt0dNgZ4fMRkepoAv1xv8Sey3EuBlPVK5xFH9Y3Ov+2TsVeOG+Re6PYW7ZwlLBmJ1Xp7gWFLlTuX3qOx4gj490B5b/JKowykZT/l2hY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DU2PR04MB9066.eurprd04.prod.outlook.com (2603:10a6:10:2f1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 11:28:31 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.041; Sat, 25 Mar 2023
 11:28:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        "Tan, Tee Min" <tee.min.tan@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: stmmac: don't reject VLANs when IFF_PROMISC is set
Date:   Sat, 25 Mar 2023 13:28:15 +0200
Message-Id: <20230325112815.3053288-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0171.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DU2PR04MB9066:EE_
X-MS-Office365-Filtering-Correlation-Id: 002c3950-7214-4412-9583-08db2d240fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fw9B0W3YyVmvhclSy8zfQBtgAmg2ndAj6MyacgUaBYoPDR/4Qu6Uw6Kav/4olMv/m53/DMLUm3o3snftMBPpNuvhG+pM5DxoSxk+dJY0Wx4GN5aHqGFHy4qAc2hv++SZM1cE+2So3VfGL+hNetcsmp1nwPPDe4yssOIHq01QCqveKNZ5q1MQMf89mVxi+4QnsAAVU5poYqdM5szoeCKtfUBt8f0AjMBSVDacEfDXB+Qxk9tevrYHpIbHywgnO7M2gjEbvPQYZ2i+6q6D54epMX226Y5jlKI1kf3DO5FB/0xmeWpDMGy476Dveg8+S7dYhM7/b2eESMPYPyd4yjnfXP4UpZqLaQHHd92MS+0MuLXVhvQQBYbuTSGaqQSV/2zdY4M4KXagjAOWqiNBKe2kQo60jhUx1svBIJBpIWKzI2bmdEbdUYEAiI1ES3KMkC7kdYlhdn/ik2MYCe1YBoUKlPFXlxCYlwAIs87zmUGtnHRY8jWYHdJtZne1Rcf1NrrWH0hBExKpy7am12Kh/3E7IZQTvA8I1/bAwz5Ku+S7IpbVbcBSnBpFBU36ebUFPFI8tgt3stRMfVuSFvjWfdM4Nn9UG7ytUqiw1x4XkfUaDbo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(366004)(136003)(396003)(451199021)(86362001)(6486002)(966005)(38100700002)(38350700002)(52116002)(2906002)(83380400001)(5660300002)(6666004)(7416002)(30864003)(478600001)(44832011)(316002)(54906003)(36756003)(2616005)(1076003)(8936002)(41300700001)(6512007)(6506007)(4326008)(66556008)(6916009)(66476007)(26005)(66946007)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8/HdJS1FCre6fO8mKCDaSyZSXG6sqyQThD/tsI6lt6WgyR0ALW8lnIVyDJ/G?=
 =?us-ascii?Q?WNJnEHJToITZk0tp+JNu/5Qz6BMlwx2lRN0BC3T3UGoQSHnPkT6lHXTuXJ7a?=
 =?us-ascii?Q?acqoS9yc+LXLTvam8ojRjnnjkNFCPwWVe4yhqi6YpmMNpFNm0bujqfOzznfH?=
 =?us-ascii?Q?iAubxKloW9S01Oajl/vWK0CxN62puUrhtWleu1GIRXv6JVS+PsXGcJCq84tI?=
 =?us-ascii?Q?Dh8NcCTpXJr9sPgw6YGoTfjFHhjlhog2QIK9XuAnV4ZfIIF23HE+RAWsqkci?=
 =?us-ascii?Q?bm+PwHqWlDAm53ylb6rRG01ooma9WJPBXt2dPknucY4708g0BionOgT1xDbz?=
 =?us-ascii?Q?Ul9s/5uKnQZ8qTk6DJawNSvpnCCsPueDdA1ui3//R99VlS6sgn7mN+Jlyoza?=
 =?us-ascii?Q?5c0nFG/pWZemZR8pffQKXDW55GCQAjR3NsapWJfdaq5fp49dfO42/D/0Oubf?=
 =?us-ascii?Q?F/k+sPJ8DK7INZCcF7e12wUJPMH05TLz0gxadW+mabUe5c0N9fiX7GCMGFD7?=
 =?us-ascii?Q?02o2aI642sePHTpw1Dov/So3t6xaklDCWnoO7Lpgmc4EPB3Y+G1S9c+qx1nm?=
 =?us-ascii?Q?avOXMYwoKalqhzfEchAjUJVR2eA4QsT8oRZ3uI3Ro5RfDUd6Au5IGPaqkTw5?=
 =?us-ascii?Q?+R7MvS7nmKQbJ1WtAUBdq+jl5h/4xUkKCLqgsEDhP24VyFj/HPziWtW2La+h?=
 =?us-ascii?Q?3hkkQhkem+RJYn/UXQpYJV5mnDi4BTPxhjubw86b+MO743cGY00KVRkDdy5z?=
 =?us-ascii?Q?pF94y3HJHLHiavABNBqfyXsOaYAHIra5/uybIpGR1M5/PU//BDKOMZll2haY?=
 =?us-ascii?Q?xBKcLktwTMUbz09++B64ZGeTYjbMHTQcqV9aCQKYAc945UvpFR4JKKCZsR7E?=
 =?us-ascii?Q?WS/uqziuTu/0yYxMnTJdyY98t6ohNPdHMNg1tK+7jAF3vktqYPittqb0PiCB?=
 =?us-ascii?Q?Y7ondg3MDvF16CSuNCQ0SYY5PIkohyZSC3Xe8nCgJZQwKCJmmXgzuOA9nFWQ?=
 =?us-ascii?Q?ng+meCfUk3t9R7nVybV6FYALlueGMbhvcvpcI83KlOe2LWEravDgM4mx95ao?=
 =?us-ascii?Q?Ou3XUL/iUaOrt/Sx4WqsmEdcbNo8NFdrFEgyrhnrK23l5PzD3EDDc4M3CIfU?=
 =?us-ascii?Q?ibTOJpul8+nBXsI1eC7LmY7LlPKcTQINMw0RQpR54SfAg5gFCQl6KeuqpFA8?=
 =?us-ascii?Q?2W6XmLcoBUKeV5NEQkyr4FTjWo1kgPI5bvwzLsWqqhYsyU9BNHi/0i9B1jZi?=
 =?us-ascii?Q?S9r69wcq7CGOU6kDS7fJuVLckUozFsxwb34e9wIux0smWOMAukzlyNZwHd8p?=
 =?us-ascii?Q?PWL2B14iYpBYwPDhkVOd9YPcCTAEu8gP/YwlE05WkWbBr4sQi9YfbfyvgzNh?=
 =?us-ascii?Q?H7cOuVVQZKUOUGNqceAf3NZ85MGMT6WxMl1ttOryrHrj9hItcXsxcRvGPBLB?=
 =?us-ascii?Q?Xfp5Vk/QkfR/MJ4eiyriYMApw/ngM4Drfa6BHpsUk9IRZw+GiEAgvwRsZucl?=
 =?us-ascii?Q?mYmmmdg7yRaRlc4Hk1PdvFBfUmD34kkS0dK1pMRWEzgIoVoXYEafWupsPrKG?=
 =?us-ascii?Q?O6gIn9fOGE/n3j3MXaxjvHyUL8+hujimQorItwz6HH/VRJLZh3CNmkBb7tkB?=
 =?us-ascii?Q?+Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 002c3950-7214-4412-9583-08db2d240fe1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 11:28:31.4071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HZS4MBoKJfvQPF6PcA/Usp2UKbwz3K0nqC5bEv0K8KsznNw4DHQdm2q7i/MAscb6iFU1C6Psvc79IwnkAArahw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9066
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The blamed commit has introduced the following tests to
dwmac4_add_hw_vlan_rx_fltr(), called from stmmac_vlan_rx_add_vid():

	if (hw->promisc) {
		netdev_err(dev,
			   "Adding VLAN in promisc mode not supported\n");
		return -EPERM;
	}

"VLAN promiscuous" mode is keyed in this driver to IFF_PROMISC, and so,
vlan_vid_add() and vlan_vid_del() calls cannot take place in IFF_PROMISC
mode. I have the following 2 arguments that this restriction is.... hm,
how shall I put it nicely... unproductive :)

First, take the case of a Linux bridge. If the kernel is compiled with
CONFIG_BRIDGE_VLAN_FILTERING=y, then this bridge shall have a VLAN
database. The bridge shall try to call vlan_add_vid() on its bridge
ports for each VLAN in the VLAN table. It will do this irrespectively of
whether that port is *currently* VLAN-aware or not. So it will do this
even when the bridge was created with vlan_filtering 0.
But the Linux bridge, in VLAN-unaware mode, configures its ports in
promiscuous (IFF_PROMISC) mode, so that they accept packets with any
MAC DA (a switch must do this in order to forward those packets which
are not directly targeted to its MAC address).

As a result, the stmmac driver does not work as a bridge port, when the
kernel is compiled with CONFIG_BRIDGE_VLAN_FILTERING=y.

$ ip link add br0 type bridge && ip link set br0 up
$ ip link set eth0 master br0 && ip link set eth0 up
[ 2333.943296] br0: port 1(eth0) entered blocking state
[ 2333.943381] br0: port 1(eth0) entered disabled state
[ 2333.943782] device eth0 entered promiscuous mode
[ 2333.944080] 4033c000.ethernet eth0: Adding VLAN in promisc mode not supported
[ 2333.976509] 4033c000.ethernet eth0: failed to initialize vlan filtering on this port
RTNETLINK answers: Operation not permitted

Secondly, take the case of stmmac as DSA master. Some switch tagging
protocols are based on 802.1Q VLANs (tag_sja1105.c), and as such,
tag_8021q.c uses vlan_vid_add() to work with VLAN-filtering DSA masters.
But also, when a DSA port becomes promiscuous (for example when it joins
a bridge), the DSA framework also makes the DSA master promiscuous.

Moreover, for every VLAN that a DSA switch sends to the CPU, DSA also
programs a VLAN filter on the DSA master, because if the the DSA switch
uses a tail tag, then the hardware frame parser of the DSA master will
see VLAN as VLAN, and might filter them out, for being unknown.

Due to the above 2 reasons, my belief is that the stmmac driver does not
get to choose to not accept vlan_vid_add() calls while IFF_PROMISC is
enabled, because the 2 are completely independent and there are code
paths in the network stack which directly lead to this situation
occurring, without the user's direct input.

In fact, my belief is that "VLAN promiscuous" mode should have never
been keyed on IFF_PROMISC in the first place, but rather, on the
NETIF_F_HW_VLAN_CTAG_FILTER feature flag which can be toggled by the
user through ethtool -k, when present in netdev->hw_features.

In the stmmac driver, NETIF_F_HW_VLAN_CTAG_FILTER is only present in
"features", making this feature "on [fixed]".

I have this belief because I am unaware of any definition of promiscuity
which implies having an effect on anything other than MAC DA (therefore
not VLAN). However, I seem to be rather alone in having this opinion,
looking back at the disagreements from this discussion:
https://lore.kernel.org/netdev/20201110153958.ci5ekor3o2ekg3ky@ipetronik.com/

In any case, to remove the vlan_vid_add() dependency on !IFF_PROMISC,
one would need to remove the check and see what fails. I guess the test
was there because of the way in which dwmac4_vlan_promisc_enable() is
implemented.

For context, the dwmac4 supports Perfect Filtering for a limited number
of VLANs - dwmac4_get_num_vlan(), priv->hw->num_vlan, with a fallback on
Hash Filtering - priv->dma_cap.vlhash - see stmmac_vlan_update(), also
visible in cat /sys/kernel/debug/stmmaceth/eth0/dma_cap | grep 'VLAN
Hash Filtering'.

The perfect filtering is based on MAC_VLAN_Tag_Filter/MAC_VLAN_Tag_Data
registers, accessed in the driver through dwmac4_write_vlan_filter().

The hash filtering is based on the MAC_VLAN_Hash_Table register, named
GMAC_VLAN_HASH_TABLE in the driver and accessed by dwmac4_update_vlan_hash().
The control bit for enabling hash filtering is GMAC_VLAN_VTHM
(MAC_VLAN_Tag_Ctrl bit VTHM: VLAN Tag Hash Table Match Enable).

Now, the description of dwmac4_vlan_promisc_enable() is that it iterates
through the driver's cache of perfect filter entries (hw->vlan_filter[i],
added by dwmac4_add_hw_vlan_rx_fltr()), and evicts them from hardware by
unsetting their GMAC_VLAN_TAG_DATA_VEN (MAC_VLAN_Tag_Data bit VEN - VLAN
Tag Enable) bit. Then it unsets the GMAC_VLAN_VTHM bit, which disables
hash matching.

This leaves the MAC, according to table "VLAN Match Status" from the
documentation, to always enter these data paths:

VID    |VLAN Perfect Filter |VTHM Bit |VLAN Hash Filter |Final VLAN Match
       |Match Result        |         |Match Result     |Status
-------|--------------------|---------|-----------------|----------------
VID!=0 |Fail                |0        |don't care       |Pass

So, dwmac4_vlan_promisc_enable() does its job, but by unsetting
GMAC_VLAN_VTHM, it conflicts with the other code path which controls
this bit: dwmac4_update_vlan_hash(), called through stmmac_update_vlan_hash()
from stmmac_vlan_rx_add_vid() and from stmmac_vlan_rx_kill_vid().
This is, I guess, why dwmac4_add_hw_vlan_rx_fltr() is not allowed to run
after dwmac4_vlan_promisc_enable() has unset GMAC_VLAN_VTHM: because if
it did, then dwmac4_update_vlan_hash() would set GMAC_VLAN_VTHM again,
breaking the "VLAN promiscuity".

It turns out that dwmac4_vlan_promisc_enable() is way too complicated
for what needs to be done. The MAC_Packet_Filter register also has the
VTFE bit (VLAN Tag Filter Enable), which simply controls whether VLAN
tagged packets which don't match the filtering tables (either perfect or
hash) are dropped or not. At the moment, this driver unconditionally
sets GMAC_PACKET_FILTER_VTFE if NETIF_F_HW_VLAN_CTAG_FILTER was detected
through the priv->dma_cap.vlhash capability bits of the device, in
stmmac_dvr_probe().

I would suggest deleting the unnecessarily complex logic from
dwmac4_vlan_promisc_enable(), and simply unsetting GMAC_PACKET_FILTER_VTFE
when becoming IFF_PROMISC, which has the same effect of allowing packets
with any VLAN tags, but has the additional benefit of being able to run
concurrently with stmmac_vlan_rx_add_vid() and stmmac_vlan_rx_kill_vid().

As much as I believe that the VTFE bit should have been exclusively
controlled by NETIF_F_HW_VLAN_CTAG_FILTER through ethtool, and not by
IFF_PROMISC, changing that is not a punctual fix to the problem, and it
would probably break the VFFQ feature added by the later commit
e0f9956a3862 ("net: stmmac: Add option for VLAN filter fail queue
enable"). From the commit description, VFFQ needs IFF_PROMISC=on and
VTFE=off in order to work (and this change respects that). But if VTFE
was changed to be controlled through ethtool -k, then a user-visible
change would have been introduced in Intel's scripts (a need to run
"ethtool -k eth0 rx-vlan-filter off" which did not exist before).

The patch was tested with this set of commands:

  ip link set eth0 up
  ip link add link eth0 name eth0.100 type vlan id 100
  ip addr add 192.168.100.2/24 dev eth0.100 && ip link set eth0.100 up
  ip link set eth0 promisc on
  ip link add link eth0 name eth0.101 type vlan id 101
  ip addr add 192.168.101.2/24 dev eth0.101 && ip link set eth0.101 up
  ip link set eth0 promisc off
  ping -c 5 192.168.100.1
  ping -c 5 192.168.101.1
  ip link set eth0 promisc on
  ping -c 5 192.168.100.1
  ping -c 5 192.168.101.1
  ip link del eth0.100
  ip link del eth0.101
  # Wait for VLAN-tagged pings from the other end...
  # Check with "tcpdump -i eth0 -e -n -p" and we should see them
  ip link set eth0 promisc off
  # Wait for VLAN-tagged pings from the other end...
  # Check with "tcpdump -i eth0 -e -n -p" and we shouldn't see them
  # anymore, but remove the "-p" argument from tcpdump and they're there.

Fixes: c89f44ff10fd ("net: stmmac: Add support for VLAN promiscuous mode")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 -
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 61 +------------------
 2 files changed, 3 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6b5d96bced47..51e2a23e26f0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -531,7 +531,6 @@ struct mac_device_info {
 	unsigned int xlgmac;
 	unsigned int num_vlan;
 	u32 vlan_filter[32];
-	unsigned int promisc;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
 };
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 8c7a0b7c9952..36251ec2589c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -472,12 +472,6 @@ static int dwmac4_add_hw_vlan_rx_fltr(struct net_device *dev,
 	if (vid > 4095)
 		return -EINVAL;
 
-	if (hw->promisc) {
-		netdev_err(dev,
-			   "Adding VLAN in promisc mode not supported\n");
-		return -EPERM;
-	}
-
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		/* For single VLAN filter, VID 0 means VLAN promiscuous */
@@ -527,12 +521,6 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 {
 	int i, ret = 0;
 
-	if (hw->promisc) {
-		netdev_err(dev,
-			   "Deleting VLAN in promisc mode not supported\n");
-		return -EPERM;
-	}
-
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		if ((hw->vlan_filter[0] & GMAC_VLAN_TAG_VID) == vid) {
@@ -557,39 +545,6 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 	return ret;
 }
 
-static void dwmac4_vlan_promisc_enable(struct net_device *dev,
-				       struct mac_device_info *hw)
-{
-	void __iomem *ioaddr = hw->pcsr;
-	u32 value;
-	u32 hash;
-	u32 val;
-	int i;
-
-	/* Single Rx VLAN Filter */
-	if (hw->num_vlan == 1) {
-		dwmac4_write_single_vlan(dev, 0);
-		return;
-	}
-
-	/* Extended Rx VLAN Filter Enable */
-	for (i = 0; i < hw->num_vlan; i++) {
-		if (hw->vlan_filter[i] & GMAC_VLAN_TAG_DATA_VEN) {
-			val = hw->vlan_filter[i] & ~GMAC_VLAN_TAG_DATA_VEN;
-			dwmac4_write_vlan_filter(dev, hw, i, val);
-		}
-	}
-
-	hash = readl(ioaddr + GMAC_VLAN_HASH_TABLE);
-	if (hash & GMAC_VLAN_VLHT) {
-		value = readl(ioaddr + GMAC_VLAN_TAG);
-		if (value & GMAC_VLAN_VTHM) {
-			value &= ~GMAC_VLAN_VTHM;
-			writel(value, ioaddr + GMAC_VLAN_TAG);
-		}
-	}
-}
-
 static void dwmac4_restore_hw_vlan_rx_fltr(struct net_device *dev,
 					   struct mac_device_info *hw)
 {
@@ -709,22 +664,12 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	}
 
 	/* VLAN filtering */
-	if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
+	if (dev->flags & IFF_PROMISC && !hw->vlan_fail_q_en)
+		value &= ~GMAC_PACKET_FILTER_VTFE;
+	else if (dev->features & NETIF_F_HW_VLAN_CTAG_FILTER)
 		value |= GMAC_PACKET_FILTER_VTFE;
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
-
-	if (dev->flags & IFF_PROMISC && !hw->vlan_fail_q_en) {
-		if (!hw->promisc) {
-			hw->promisc = 1;
-			dwmac4_vlan_promisc_enable(dev, hw);
-		}
-	} else {
-		if (hw->promisc) {
-			hw->promisc = 0;
-			dwmac4_restore_hw_vlan_rx_fltr(dev, hw);
-		}
-	}
 }
 
 static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
-- 
2.34.1

