Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC611ED8A
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 23:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLMWIE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 13 Dec 2019 17:08:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:6005 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbfLMWIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 17:08:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 14:08:04 -0800
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; 
   d="scan'208";a="204451135"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.201])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 14:08:03 -0800
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191127094517.6255-1-Po.Liu@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
Cc:     "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Po Liu <po.liu@nxp.com>
From:   Andre Guedes <andre.guedes@linux.intel.com>
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
To:     "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>, Po Liu <po.liu@nxp.com>
Message-ID: <157603276975.18462.4638422874481955289@pipeline>
User-Agent: alot/0.8.1
Date:   Tue, 10 Dec 2019 18:52:49 -0800
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

Quoting Po Liu (2019-11-27 01:59:18)
> IEEE Std 802.1Qbu standard defined the frame preemption of port
> traffic classes. This patch introduce a method to set traffic
> classes preemption. Add a parameter 'preemption' in struct
> ethtool_link_settings. The value will be translated to a binary,
> each bit represent a traffic class. Bit "1" means preemptable
> traffic class. Bit "0" means express traffic class.  MSB represent
> high number traffic class.
> 
> If hardware support the frame preemption, driver could set the
> ethernet device with hw_features and features with NETIF_F_PREEMPTION
> when initializing the port driver.
> 
> User can check the feature 'tx-preemption' by command 'ethtool -k
> devname'. If hareware set preemption feature. The property would
> be a fixed value 'on' if hardware support the frame preemption.
> Feature would show a fixed value 'off' if hardware don't support
> the frame preemption.
> 
> Command 'ethtool devname' and 'ethtool -s devname preemption N'
> would show/set which traffic classes are frame preemptable.
> 
> Port driver would implement the frame preemption in the function
> get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.

In an early RFC series [1], we proposed a way to support frame preemption. I'm not
sure if you have considered it before implementing this other proposal based on
ethtool interface so I thought it would be a good idea to bring that up to your
attention, just in case.

In that initial proposal, Frame Preemption feature is configured via taprio
qdisc. For example:

$ tc qdisc add dev IFACE parent root handle 100 taprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      preemption 0 1 1 1 \
      base-time 10000000 \
      sched-entry S 01 300000 \
      sched-entry S 02 300000 \
      sched-entry S 04 400000 \
      clockid CLOCK_TAI

It also aligns with the gate control operations Set-And-Hold-MAC and
Set-And-Release-MAC that can be set via 'sched-entry' (see Table 8.7 from
802.1Q-2018 for further details.

Please share your thoughts on this.

Regards,

Andre
