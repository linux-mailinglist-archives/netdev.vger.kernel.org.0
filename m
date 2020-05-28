Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 831061E68FA
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391329AbgE1SBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388240AbgE1SBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:01:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90EEC08C5C6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 11:01:44 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2827512959C76;
        Thu, 28 May 2020 11:01:44 -0700 (PDT)
Date:   Thu, 28 May 2020 11:01:43 -0700 (PDT)
Message-Id: <20200528.110143.484059305091482290.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org, vinicius.gomes@intel.com
Subject: Re: [PATCH v3 net-next] net: dsa: sja1105: offload the
 Credit-Based Shaper qdisc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200528002758.2499588-1-olteanv@gmail.com>
References: <20200528002758.2499588-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 28 May 2020 11:01:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Thu, 28 May 2020 03:27:58 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> SJA1105, being AVB/TSN switches, provide hardware assist for the
> Credit-Based Shaper as described in the IEEE 8021Q-2018 document.
> 
> First generation has 10 shapers, freely assignable to any of the 4
> external ports and 8 traffic classes, and second generation has 16
> shapers.
> 
> The Credit-Based Shaper tables are accessed through the dynamic
> reconfiguration interface, so we have to restore them manually after a
> switch reset. The tables are backed up by the static config only on
> P/Q/R/S, and we don't want to add custom code only for that family,
> since the procedure that is in place now works for both.
> 
> Tested with the following commands:
> 
> data_rate_kbps=67000
> port_transmit_rate_kbps=1000000
> idleslope=$data_rate_kbps
> sendslope=$(($idleslope - $port_transmit_rate_kbps))
> locredit=$((-0x80000000))
> hicredit=$((0x7fffffff))
> tc qdisc add dev swp2 root handle 1: mqprio hw 0 num_tc 8 \
>         map 0 1 2 3 4 5 6 7 \
>         queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7
> tc qdisc replace dev swp2 parent 1:1 cbs \
>         idleslope $idleslope \
>         sendslope $sendslope \
>         hicredit $hicredit \
>         locredit $locredit \
>         offload 1
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thank you.
