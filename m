Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD252000B4
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbgFSDVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgFSDVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:21:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFBEC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:21:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7008C120ED49C;
        Thu, 18 Jun 2020 20:21:16 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:21:15 -0700 (PDT)
Message-Id: <20200618.202115.504529114183357474.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net 0/3] Fix VLAN checks for SJA1105 DSA tc-flower
 filters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200616235843.756413-1-olteanv@gmail.com>
References: <20200616235843.756413-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:21:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 17 Jun 2020 02:58:40 +0300

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This fixes a ridiculous situation where the driver, in VLAN-unaware
> mode, would refuse accepting any tc filter:
> 
> tc filter replace dev sw1p3 ingress flower skip_sw \
> 	dst_mac 42:be:24:9b:76:20 \
> 	action gate (...)
> Error: sja1105: Can only gate based on {DMAC, VID, PCP}.
> 
> tc filter replace dev sw1p3 ingress protocol 802.1Q flower skip_sw \
> 	vlan_id 1 vlan_prio 0 dst_mac 42:be:24:9b:76:20 \
> 	action gate (...)
> Error: sja1105: Can only gate based on DMAC.
> 
> So, without changing the VLAN awareness state, it says it doesn't want
> VLAN-aware rules, and it doesn't want VLAN-unaware rules either. One
> would say it's in Schrodinger's state...
> 
> Now, the situation has been made worse by commit 7f14937facdc ("net:
> dsa: sja1105: keep the VLAN awareness state in a driver variable"),
> which made VLAN awareness a ternary attribute, but after inspecting the
> code from before that patch with a truth table, it looks like the
> logical bug was there even before.
> 
> While attempting to fix this, I also noticed some leftover debugging
> code in one of the places that needed to be fixed. It would have
> appeared in the context of patch 3/3 anyway, so I decided to create a
> patch that removes it.

Series applied, thanks.
