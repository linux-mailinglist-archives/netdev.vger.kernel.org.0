Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208BF1B5065
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 00:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgDVWgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 18:36:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:57248 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDVWgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 18:36:06 -0400
IronPort-SDR: LHsc9iv/8bwDmknEqnmFMV4cMpyqs3KjAgjr+QoiDthFSi4dmx4V8IlN3qb9GTi99VclTMKwTH
 5ynhVTM046dQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 15:36:05 -0700
IronPort-SDR: RC4SYtFwWSKEYNLmGBdfaV8kB7voxkMkI23nKjsS68H7zHjxMexPSC3qyho0LEFjeqY0mUxLjw
 FJCgQ5Wd/Wrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="244666844"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 22 Apr 2020 15:36:01 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jRNyK-0004px-Nw; Thu, 23 Apr 2020 06:36:00 +0800
Date:   Thu, 23 Apr 2020 06:35:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, idosch@idosch.org,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        alexandre.belloni@bootlin.com, antoine.tenart@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com
Subject: Re: [PATCH net-next 1/3] net: mscc: ocelot: support matching on
 EtherType
Message-ID: <202004230608.ERIsSgqQ%lkp@intel.com>
References: <20200420162743.15847-2-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420162743.15847-2-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]
[also build test WARNING on net/master linus/master v5.7-rc2 next-20200421]
[cannot apply to sparc-next/master]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Vladimir-Oltean/Ocelot-MAC_ETYPE-tc-flower-key-improvements/20200422-113906
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b6246f4d8d0778fd045b84dbd7fc5aadd8f3136e
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] @@    got resunsigned short [usertype] @@
>> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse:    expected unsigned short [usertype]
>> drivers/net/ethernet/mscc/ocelot_flower.c:184:54: sparse:    got restricted __be16 [usertype]

vim +184 drivers/net/ethernet/mscc/ocelot_flower.c

    48	
    49	static int ocelot_flower_parse(struct flow_cls_offload *f,
    50				       struct ocelot_ace_rule *ace)
    51	{
    52		struct flow_rule *rule = flow_cls_offload_flow_rule(f);
    53		struct flow_dissector *dissector = rule->match.dissector;
    54		u16 proto = ntohs(f->common.protocol);
    55		bool match_protocol = true;
    56	
    57		if (dissector->used_keys &
    58		    ~(BIT(FLOW_DISSECTOR_KEY_CONTROL) |
    59		      BIT(FLOW_DISSECTOR_KEY_BASIC) |
    60		      BIT(FLOW_DISSECTOR_KEY_PORTS) |
    61		      BIT(FLOW_DISSECTOR_KEY_VLAN) |
    62		      BIT(FLOW_DISSECTOR_KEY_IPV4_ADDRS) |
    63		      BIT(FLOW_DISSECTOR_KEY_IPV6_ADDRS) |
    64		      BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS))) {
    65			return -EOPNOTSUPP;
    66		}
    67	
    68		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
    69			struct flow_match_control match;
    70	
    71			flow_rule_match_control(rule, &match);
    72		}
    73	
    74		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
    75			struct flow_match_eth_addrs match;
    76	
    77			/* The hw support mac matches only for MAC_ETYPE key,
    78			 * therefore if other matches(port, tcp flags, etc) are added
    79			 * then just bail out
    80			 */
    81			if ((dissector->used_keys &
    82			    (BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
    83			     BIT(FLOW_DISSECTOR_KEY_BASIC) |
    84			     BIT(FLOW_DISSECTOR_KEY_CONTROL))) !=
    85			    (BIT(FLOW_DISSECTOR_KEY_ETH_ADDRS) |
    86			     BIT(FLOW_DISSECTOR_KEY_BASIC) |
    87			     BIT(FLOW_DISSECTOR_KEY_CONTROL)))
    88				return -EOPNOTSUPP;
    89	
    90			if (proto == ETH_P_IP ||
    91			    proto == ETH_P_IPV6 ||
    92			    proto == ETH_P_ARP)
    93				return -EOPNOTSUPP;
    94	
    95			flow_rule_match_eth_addrs(rule, &match);
    96			ace->type = OCELOT_ACE_TYPE_ETYPE;
    97			ether_addr_copy(ace->frame.etype.dmac.value,
    98					match.key->dst);
    99			ether_addr_copy(ace->frame.etype.smac.value,
   100					match.key->src);
   101			ether_addr_copy(ace->frame.etype.dmac.mask,
   102					match.mask->dst);
   103			ether_addr_copy(ace->frame.etype.smac.mask,
   104					match.mask->src);
   105			goto finished_key_parsing;
   106		}
   107	
   108		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
   109			struct flow_match_basic match;
   110	
   111			flow_rule_match_basic(rule, &match);
   112			if (ntohs(match.key->n_proto) == ETH_P_IP) {
   113				ace->type = OCELOT_ACE_TYPE_IPV4;
   114				ace->frame.ipv4.proto.value[0] =
   115					match.key->ip_proto;
   116				ace->frame.ipv4.proto.mask[0] =
   117					match.mask->ip_proto;
   118				match_protocol = false;
   119			}
   120			if (ntohs(match.key->n_proto) == ETH_P_IPV6) {
   121				ace->type = OCELOT_ACE_TYPE_IPV6;
   122				ace->frame.ipv6.proto.value[0] =
   123					match.key->ip_proto;
   124				ace->frame.ipv6.proto.mask[0] =
   125					match.mask->ip_proto;
   126				match_protocol = false;
   127			}
   128		}
   129	
   130		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS) &&
   131		    proto == ETH_P_IP) {
   132			struct flow_match_ipv4_addrs match;
   133			u8 *tmp;
   134	
   135			flow_rule_match_ipv4_addrs(rule, &match);
   136			tmp = &ace->frame.ipv4.sip.value.addr[0];
   137			memcpy(tmp, &match.key->src, 4);
   138	
   139			tmp = &ace->frame.ipv4.sip.mask.addr[0];
   140			memcpy(tmp, &match.mask->src, 4);
   141	
   142			tmp = &ace->frame.ipv4.dip.value.addr[0];
   143			memcpy(tmp, &match.key->dst, 4);
   144	
   145			tmp = &ace->frame.ipv4.dip.mask.addr[0];
   146			memcpy(tmp, &match.mask->dst, 4);
   147			match_protocol = false;
   148		}
   149	
   150		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS) &&
   151		    proto == ETH_P_IPV6) {
   152			return -EOPNOTSUPP;
   153		}
   154	
   155		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_PORTS)) {
   156			struct flow_match_ports match;
   157	
   158			flow_rule_match_ports(rule, &match);
   159			ace->frame.ipv4.sport.value = ntohs(match.key->src);
   160			ace->frame.ipv4.sport.mask = ntohs(match.mask->src);
   161			ace->frame.ipv4.dport.value = ntohs(match.key->dst);
   162			ace->frame.ipv4.dport.mask = ntohs(match.mask->dst);
   163			match_protocol = false;
   164		}
   165	
   166		if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_VLAN)) {
   167			struct flow_match_vlan match;
   168	
   169			flow_rule_match_vlan(rule, &match);
   170			ace->type = OCELOT_ACE_TYPE_ANY;
   171			ace->vlan.vid.value = match.key->vlan_id;
   172			ace->vlan.vid.mask = match.mask->vlan_id;
   173			ace->vlan.pcp.value[0] = match.key->vlan_priority;
   174			ace->vlan.pcp.mask[0] = match.mask->vlan_priority;
   175			match_protocol = false;
   176		}
   177	
   178	finished_key_parsing:
   179		if (match_protocol && proto != ETH_P_ALL) {
   180			/* TODO: support SNAP, LLC etc */
   181			if (proto < ETH_P_802_3_MIN)
   182				return -EOPNOTSUPP;
   183			ace->type = OCELOT_ACE_TYPE_ETYPE;
 > 184			*(u16 *)ace->frame.etype.etype.value = htons(proto);
   185			*(u16 *)ace->frame.etype.etype.mask = 0xffff;
   186		}
   187		/* else, a rule of type OCELOT_ACE_TYPE_ANY is implicitly added */
   188	
   189		ace->prio = f->common.prio;
   190		ace->id = f->cookie;
   191		return ocelot_flower_parse_action(f, ace);
   192	}
   193	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
