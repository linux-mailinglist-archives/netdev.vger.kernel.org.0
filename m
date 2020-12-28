Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEA902E6C00
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730480AbgL1Wzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729608AbgL1W1f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:27:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F98020829;
        Mon, 28 Dec 2020 22:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609194414;
        bh=zzXcS/voSL8xh/stF+PRvCY4adKxzk7/Qfd2xuMJbv4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PyYudmcwEhbVp5IyvQupjd6Sf0LirLTX7KAq8Wq54DL6u6lVHr/HL2DfY7fSywEfI
         HqonOK9lYCnQbekC1g3m1B1dVdroFfipPgMRbtUA8qFDOTmtUVxi2cJoj3r1aAeoY7
         tjxyXzgRgQRvYHa++GQM2AirKcaWF/6FS+2GpcInse8SIrk6WGoYxSKyADxi8vmdm0
         XlOadpwx0DSpCBtSsFb1Vp2PRJFeU391AmL5gbDcXhi+ZQBKBpzJIqIvKDSoNW7frG
         DSY7wIx922g0tTJ/45ahBnTzHLcd1AEFKHSCyY+OrcmLEW14tYB+rLZawXD0kMySAd
         19KvQHPg25n3w==
Date:   Mon, 28 Dec 2020 14:26:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 2/2] net: switchdev: don't set
 port_obj_info->handled true when -EOPNOTSUPP
Message-ID: <20201228142653.2987e42d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223144533.4145-3-rasmus.villemoes@prevas.dk>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
        <20201223144533.4145-3-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 15:45:33 +0100 Rasmus Villemoes wrote:
> It's not true that switchdev_port_obj_notify() only inspects the
> ->handled field of "struct switchdev_notifier_port_obj_info" if  
> call_switchdev_blocking_notifiers() returns 0 - there's a WARN_ON()
> triggering for a non-zero return combined with ->handled not being
> true. But the real problem here is that -EOPNOTSUPP is not being
> properly handled.
> 
> The wrapper functions switchdev_handle_port_obj_add() et al change a
> return value of -EOPNOTSUPP to 0, and the treatment of ->handled in
> switchdev_port_obj_notify() seems to be designed to change that back
> to -EOPNOTSUPP in case nobody actually acted on the notifier (i.e.,
> everybody returned -EOPNOTSUPP).
> 
> Currently, as soon as some device down the stack passes the check_cb()
> check, ->handled gets set to true, which means that
> switchdev_port_obj_notify() cannot actually ever return -EOPNOTSUPP.
> 
> This, for example, means that the detection of hardware offload
> support in the MRP code is broken - br_mrp_set_ring_role() always ends
> up setting mrp->ring_role_offloaded to 1, despite not a single
> mainline driver implementing any of the SWITCHDEV_OBJ_ID*_MRP. So
> since the MRP code thinks the generation of MRP test frames has been
> offloaded, no such frames are actually put on the wire.
> 
> So, continue to set ->handled true if any callback returns success or
> any error distinct from -EOPNOTSUPP. But if all the callbacks return
> -EOPNOTSUPP, make sure that ->handled stays false, so the logic in
> switchdev_port_obj_notify() can propagate that information.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Please make sure you CC the folks who may have something to say about
this - Jiri, Ivan, Ido, Florian, etc.
