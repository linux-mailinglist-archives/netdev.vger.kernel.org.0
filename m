Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCBE249143
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgHRW61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgHRW60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:58:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF58C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:58:26 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7029B127E56E5;
        Tue, 18 Aug 2020 15:41:39 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:58:24 -0700 (PDT)
Message-Id: <20200818.155824.2292310502481809055.davem@davemloft.net>
To:     jwiesner@suse.com
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, kuba@kernel.org, Andreas.Taschner@suse.com,
        mkubecek@suse.cz
Subject: Re: [PATCH net] bonding: fix active-backup failover for current
 ARP slave
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200816185244.GA31426@incl>
References: <20200816185244.GA31426@incl>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Aug 2020 15:41:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Wiesner <jwiesner@suse.com>
Date: Sun, 16 Aug 2020 20:52:44 +0200

> When the ARP monitor is used for link detection, ARP replies are
> validated for all slaves (arp_validate=3) and fail_over_mac is set to
> active, two slaves of an active-backup bond may get stuck in a state
> where both of them are active and pass packets that they receive to
> the bond. This state makes IPv6 duplicate address detection fail. The
> state is reached thus:
> 1. The current active slave goes down because the ARP target
>    is not reachable.
> 2. The current ARP slave is chosen and made active.
> 3. A new slave is enslaved. This new slave becomes the current active
>    slave and can reach the ARP target.
> As a result, the current ARP slave stays active after the enslave
> action has finished and the log is littered with "PROBE BAD" messages:
>> bond0: PROBE: c_arp ens10 && cas ens11 BAD
> The workaround is to remove the slave with "going back" status from
> the bond and re-enslave it. This issue was encountered when DPDK PMD
> interfaces were being enslaved to an active-backup bond.
> 
> I would be possible to fix the issue in bond_enslave() or
> bond_change_active_slave() but the ARP monitor was fixed instead to
> keep most of the actions changing the current ARP slave in the ARP
> monitor code. The current ARP slave is set as inactive and backup
> during the commit phase. A new state, BOND_LINK_FAIL, has been
> introduced for slaves in the context of the ARP monitor. This allows
> administrators to see how slaves are rotated for sending ARP requests
> and attempts are made to find a new active slave.
> 
> Fixes: b2220cad583c9 ("bonding: refactor ARP active-backup monitor")
> Signed-off-by: Jiri Wiesner <jwiesner@suse.com>

Applied and queued up for -stable, thanks Jiri.
