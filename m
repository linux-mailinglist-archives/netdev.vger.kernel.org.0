Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A911E8C52
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728566AbgE2Xu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728547AbgE2Xu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:50:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9DAC03E969
        for <netdev@vger.kernel.org>; Fri, 29 May 2020 16:50:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4225C1286A5D7;
        Fri, 29 May 2020 16:50:26 -0700 (PDT)
Date:   Fri, 29 May 2020 16:50:25 -0700 (PDT)
Message-Id: <20200529.165025.1840980240608138167.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: sja1105: avoid invalid state in
 sja1105_vlan_filtering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527172038.1142072-1-olteanv@gmail.com>
References: <20200527172038.1142072-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:50:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 27 May 2020 20:20:38 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Be there 2 switches spi/spi2.0 and spi/spi2.1 in a cross-chip setup,
> both under the same VLAN-filtering bridge, both in the
> SJA1105_VLAN_BEST_EFFORT state.
> 
> If we try to change the VLAN state of one of the switches (to
> SJA1105_VLAN_FILTERING_FULL) we get the following error:
> 
> devlink dev param set spi/spi2.1 name best_effort_vlan_filtering value
> false cmode runtime
> [   38.325683] sja1105 spi2.1: Not allowed to overcommit frame memory.
>                L2 memory partitions and VL memory partitions share the
>                same space. The sum of all 16 memory partitions is not
>                allowed to be larger than 929 128-byte blocks (or 910
>                with retagging). Please adjust
>                l2-forwarding-parameters-table.part_spc and/or
>                vl-forwarding-parameters-table.partspc.
> [   38.356803] sja1105 spi2.1: Invalid config, cannot upload
> 
> This is because the spi/spi2.1 switch doesn't support tagging anymore in
> the SJA1105_VLAN_FILTERING_FULL state, so it doesn't need to have any
> retagging rules defined. Great, so it can use more frame memory
> (retagging consumes extra memory).
> 
> But the built-in low-level static config checker from the sja1105 driver
> says "not so fast, you've increased the frame memory to non-retagging
> values, but you still kept the retagging rules in the static config".
> 
> So we need to rebuild the VLAN table immediately before re-uploading the
> static config, operation which will take care, based on the new VLAN
> state, of removing the retagging rules.
> 
> Fixes: 3f01c91aab92 ("net: dsa: sja1105: implement VLAN retagging for dsa_8021q sub-VLANs")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Applied, thanks.
