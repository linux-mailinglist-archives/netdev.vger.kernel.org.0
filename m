Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224D116536E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgBTARt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:17:49 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49350 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgBTARt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:17:49 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 954A215BCF421;
        Wed, 19 Feb 2020 16:17:48 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:17:48 -0800 (PST)
Message-Id: <20200219.161748.303311549500621079.davem@davemloft.net>
To:     poros@redhat.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, ivecera@redhat.com
Subject: Re: [PATCH net-next] phy: avoid unnecessary link-up delay in
 polling mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218093555.948922-1-poros@redhat.com>
References: <20200129101308.74185-1-poros@redhat.com>
        <20200218093555.948922-1-poros@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:17:48 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Oros <poros@redhat.com>
Date: Tue, 18 Feb 2020 10:35:55 +0100

> commit 93c0970493c71f ("net: phy: consider latched link-down status in
> polling mode") removed double-read of latched link-state register for
> polling mode from genphy_update_link(). This added extra ~1s delay into
> sequence link down->up.
> Following scenario:
>  - After boot link goes up
>  - phy_start() is called triggering an aneg restart, hence link goes
>    down and link-down info is latched.
>  - After aneg has finished link goes up. In phy_state_machine is checked
>    link state but it is latched "link is down". The state machine is
>    scheduled after one second and there is detected "link is up". This
>    extra delay can be avoided when we keep link-state register double read
>    in case when link was down previously.
> 
> With this solution we don't miss a link-down event in polling mode and
> link-up is faster.
> 
> Details about this quirky behavior on Realtek phy:
> Without patch:
> T0:    aneg is started, link goes down, link-down status is latched
> T0+3s: state machine runs, up-to-date link-down is read
> T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        here i read link-down (BMSR_LSTATUS==0),
> T0+5s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        up-to-date link-up is read (BMSR_LSTATUS==1),
>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
> 
> With patch:
> T0:    aneg is started, link goes down, link-down status is latched
> T0+3s: state machine runs, up-to-date link-down is read
> T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        first BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==0,
>        second BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==1,
>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
> 
> Signed-off-by: Petr Oros <poros@redhat.com>

Applied, thank you.
