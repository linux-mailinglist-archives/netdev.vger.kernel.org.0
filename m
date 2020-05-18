Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B19E1D7F51
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgERQ4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:56:08 -0400
Received: from mx.nsg.net.ru ([84.253.109.131]:47269 "EHLO nsg.net.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728150AbgERQ4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:56:08 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Mon, 18 May 2020 12:56:07 EDT
X-Spam-Status: No, hits=-1.0 required=5.0
Received: from [85.141.206.213] (account valjurin@nsg.net.ru HELO [192.168.1.193])
  by nsg.net.ru ( CommuniGate Pro SMTP on Linuserv )
  with ESMTPSA id 368260253 for netdev@vger.kernel.org; Mon, 18 May 2020 19:40:40 +0300
Subject: phydev control race condition while AUTONEG_DISABLE
References: <5c5ee244-d40c-4e34-8652-a3f82b453543@nsg.net.ru>
To:     netdev@vger.kernel.org
From:   Val Jurin <valjurin@nsg.net.ru>
X-Forwarded-Message-Id: <5c5ee244-d40c-4e34-8652-a3f82b453543@nsg.net.ru>
Message-ID: <0b91c527-0cc3-f37a-9ce7-4c33a19fb6c6@nsg.net.ru>
Date:   Mon, 18 May 2020 19:40:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <5c5ee244-d40c-4e34-8652-a3f82b453543@nsg.net.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Message-Boundary: <===================================================>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello  everybody.

This letter was sent to you because you are signed in as MAINTAINERS
  for  ETHERNET PHY LIBRARY topic.

Issue:
It seems I found "race condition" situation for PHY devices in 
AUTONEG_DISABLE mode.

Description:
I found this issue in my working kernel 4.11.7 but  I cloned git master 
from Linus' git master branch
and practically the same code is still in master. ( for now ver. 5.7.0-rc5 )

Please look at  the part of file
drivers/net/phy/phy.c
with my comments:

=== code ===
int phy_ethtool_ksettings_set(struct phy_device *phydev,
                               const struct ethtool_link_ksettings *cmd)
{

/*  THE PART OF THE CODE SKIPPED */

         phydev->autoneg = autoneg;

         phydev->speed = speed;

         linkmode_copy(phydev->advertising, advertising);

         linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
                          phydev->advertising, autoneg == AUTONEG_ENABLE);

         phydev->duplex = duplex;

/* LET'S MARK THIS CODE POINT AS THE "POINT 1" */

         phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;

         /* Restart the PHY */

/* AND WE ARE GOING TO phy_start_aneg */

         phy_start_aneg(phydev);

         return 0;
}
EXPORT_SYMBOL(phy_ethtool_ksettings_set);
=== EoF code ===

Now look at the beginning of phy_start_aneg:

=== code ===
int phy_start_aneg(struct phy_device *phydev)
{
         int err;

         if (!phydev->drv)
                 return -EIO;

/* LET'S MARK THIS CODE POINT AS THE "POINT 2" */
/* JUST BEFORE MUTEX LOCK */
         mutex_lock(&phydev->lock);

/* THE FOLLOWING CODE SKIPPED */
=== EoF code ===


The statement.

If the short code chain between "POINT 1" and "POINT 2" is running
and physical device is in AUTONEG_DISABLE mode
and one of the following asynchronous events occur between these points 
of code:

a)  phydev related status change interrupt (with following hi-prio tasklet);
b)  task rescheduling which may call phydev status POLL routine
(if phydev is in non-interrupt-driven mode);

the following fields in struct phy_device:

phydev->speed
phydev->duplex

will  be rewritten by phy_device  read_status function.

For example - genphy_read_status ( more strict by 
genphy_read_status_fixed in kernel v.5 )

and the command from ethtool will not set correct speed and duplex which
stays with old values of speed/duplex.

The probability of this event is vanishingly small and practically may never
occur because:
a) most of phy devices work in AUTONEG_ENABLE mode;
b) the affected code chain is too short. It's just a dozen of CPU commands
mostly for functions epilogue and prologue and the probability of incoming
async events for phydev status change is practically close to zero while
this code chain is running.

Anyway, it is a cause for race condition.

How to emulate:
Just inject something like
  phydev->drv->config_aneg(phydev)
in any place of the described code chain between "POINT 1" and "POINT 2"

How it was found :
I've got a card with MX6UL (NXP ARM SOC) with 2x FEC + micrel 8081 PHY.
The interrupt line of one of these PHY devices was tied low by adjusters :-E
and this caused high frequency interrupts + phy read_status call with 
interrupt rate
limited by interrupt controller or something else. But it was enough to see
that ethtool sets speed and duplex one time of three (or more) tries.
Elsewhere it may never occur and it will never be found :)

Possible solution:
Everything is normal in AUTONEG_ENABLE mode because the fields
"speed" and "duplex" are not used in ethtool command by config_aneg
which uses advertise fields as command data in this case.

It looks like the struct phy_device must have separated fields for command
and for status change:

phydev->speed
phydev->duplex

must be left for status
but, for example

phydev->speed_req
phydev->duplex_req

must be used for ethtool in phy_ethtool_ksettings_set  (*)
and then used as command data in phy_start_aneg or later
in appropriate  place _after_  phy_start_aneg locks phydev mutex.

(*) as you know this is the default, other drivers may use their own 
ethtool ksettings

I can not do patch/changes myself because this code is historically very 
old and
trusted and very important and can affect not only the functions 
described above.
I think you better know what to do or leave it "as is"  because the
probability is too low. But as I suspect and as I was taught ...
if probability is very very close to zero and it is not  still strictly zero
just find the way what needs to be done to fix it.
That was the reason to send you this letter.

Thank you for attention.

Regards,
Valentine Jurin,
         hardware support, kernel and boot maintenance,
         NSG Ltd. , http://www.nsg.ru

P.S Also we want to say respects to you and to all kernel team for your 
great job.
Thank you very much.
We like Linux.

