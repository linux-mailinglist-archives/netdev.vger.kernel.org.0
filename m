Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4AE1E4D11
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 20:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389082AbgE0SZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 14:25:59 -0400
Received: from mga07.intel.com ([134.134.136.100]:46126 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387581AbgE0SZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 14:25:59 -0400
IronPort-SDR: nerlTZuyxoUXUsiauNXKn7gvq+5hJPuMzE7fLzsOX/tbb+s7XXjUEZuABrwbyYgCqi6oj63tyV
 0dv4ixuRP9QQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 11:25:58 -0700
IronPort-SDR: ica+iV9WSJzyc2+UA/9A/vFHUDv7whvCsNpCA4vuWPGeYLFFZXPyNCr5LGGMmXNpuXsVcajTtD
 XOnsrkZOz78w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,442,1583222400"; 
   d="scan'208";a="468840087"
Received: from unknown (HELO ellie) ([10.212.136.193])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2020 11:25:57 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: offload the Credit-Based Shaper qdisc
In-Reply-To: <20200527165527.1085151-1-olteanv@gmail.com>
References: <20200527165527.1085151-1-olteanv@gmail.com>
Date:   Wed, 27 May 2020 11:25:57 -0700
Message-ID: <87v9khjkui.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Vladimir Oltean <olteanv@gmail.com> writes:

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> SJA1105, being AVB/TSN switches, provide hardware assist for the
> Credit-Based Shaper as described in the IEEE 8021Q-2018 document.
>
> First generation has 10 shapers, freely assignable to any of the 4
> external ports and 8 traffic classes, and second generation has 16
> shapers.
>
> We also need to provide a dummy implementation of mqprio qdisc offload,
> since this seems to be necessary for shaping any traffic class other
> than zero.
>
> The Credit-Based Shaper tables are accessed through the dynamic
> reconfiguration interface, so we have to restore them manually after a
> switch reset. The tables are backed up by the static config only on
> P/Q/R/S, and we don't want to add custom code only for that family,
> since the procedure that is in place now works for both.
>
> Tested with the following commands:
>
> data_rate_kbps=34000
> port_transmit_rate_kbps=1000000
> idleslope=$data_rate_kbps
> sendslope=$(($idleslope - $port_transmit_rate_kbps))
> locredit=$((-0x7fffffff))
> hicredit=$((0x7fffffff))
> tc qdisc add dev sw1p3 root handle 1: mqprio num_tc 8

This (and implementing the dummy mqprio offload callback) seem a bit
hackish: I am reading this is more a way to bypass mqprio parameter
validation (the priority to queue mapping) than anything else.

And I don't think that accepting any parameters without doing any
validation is really what you want.

Question:

$ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 1@2 \
      hw 0

$ tc qdisc replace dev $IFACE handle 200 parent 100:1 cbs \
      idleslope 100000 sendslope -900000 hicredit 150 locredit -1362 \
      offload 1

Why doesn't something like this work for your hardware?


Cheers,
-- 
Vinicius
