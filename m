Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B1A4639BF
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245675AbhK3PXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:23:39 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42234 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244613AbhK3PXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 10:23:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE81ACE1A3C
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 15:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEA6C53FC7;
        Tue, 30 Nov 2021 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638285598;
        bh=ErGCTLyJa0xNkf7eOrpOLP1YCl8WmSRgeI6BdOXw5G0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jk9X5LlQBg6N8ucAdHrsWlmKc1SATEu88V9HJzyXa9Uj1PQ15r7Cd8CDAzekn+sC/
         m8LE5CPPJZAYxAWBMknzCDnLWCrjH+M76ZcfePBi3nsse04NRqZXk1drHvsfPpl7x6
         eZ292IW1dHOgHdto0X7zbSH4VgZF8Z0mK2Luv6E6H+BcsRzBBd14pRpBp+bGrWI/iU
         XDtx1qbJhSVc46jTS9hpgTEZyuXlqIUdfkR6yei1s+0lb13oCJC3sodcEty1E1FTv2
         i2CCYYf3YurFhafRLJeWxgzE56S5ZQo/zVKR0lbMLC14e8mJLkpgM1MOEl2U3CS3lX
         lpAcfnYyE6sWg==
Date:   Tue, 30 Nov 2021 07:19:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, davem@davemloft.net,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
Subject: Re: [PATCH net-next] bond: pass get_ts_info and SIOC[SG]HWTSTAMP
 ioctl to active device
Message-ID: <20211130071956.5ad2c795@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211130070932.1634476-1-liuhangbin@gmail.com>
References: <20211130070932.1634476-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Nov 2021 15:09:32 +0800 Hangbin Liu wrote:
> We have VLAN PTP support(via get_ts_info) on kernel, and bond support(by
> getting active interface via netlink message) on userspace tool linuxptp.
> But there are always some users who want to use PTP with VLAN over bond,
> which is not able to do with the current implementation.
> 
> This patch passed get_ts_info and SIOC[SG]HWTSTAMP ioctl to active device
> with bond mode active-backup/tlb/alb. With this users could get kernel native
> bond or VLAN over bond PTP support.
> 
> Test with ptp4l and it works with VLAN over bond after this patch:
> ]# ptp4l -m -i bond0.23
> ptp4l[53377.141]: selected /dev/ptp4 as PTP clock
> ptp4l[53377.142]: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
> ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> ptp4l[53377.143]: port 0: INITIALIZING to LISTENING on INIT_COMPLETE
> ptp4l[53384.127]: port 1: LISTENING to MASTER on ANNOUNCE_RECEIPT_TIMEOUT_EXPIRES
> ptp4l[53384.127]: selected local clock e41d2d.fffe.123db0 as best master
> ptp4l[53384.127]: port 1: assuming the grand master role

Does the Ethernet spec say something about PTP over bond/LACP?

What happens during failover? Presumably the user space daemon will
start getting HW stamps based on a different PHC than it's disciplining?
