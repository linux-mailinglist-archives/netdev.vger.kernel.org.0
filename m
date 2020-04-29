Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B651BE658
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 20:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2Sia convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Apr 2020 14:38:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41526 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD2Si3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 14:38:29 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jTrbF-0002IP-03; Wed, 29 Apr 2020 18:38:25 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 35163630E4; Wed, 29 Apr 2020 11:38:23 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 2DA31AC1DB;
        Wed, 29 Apr 2020 11:38:23 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH] net/bonding: Do not transition down slave after speed/duplex check
In-reply-to: <1588183759-7659-1-git-send-email-tlfalcon@linux.ibm.com>
References: <1588183759-7659-1-git-send-email-tlfalcon@linux.ibm.com>
Comments: In-reply-to Thomas Falcon <tlfalcon@linux.ibm.com>
   message dated "Wed, 29 Apr 2020 13:09:19 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29483.1588185503.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 29 Apr 2020 11:38:23 -0700
Message-ID: <29484.1588185503@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thomas Falcon <tlfalcon@linux.ibm.com> wrote:

>The following behavior has been observed when testing logical partition
>migration of LACP-bonded VNIC devices in a PowerVM pseries environment.
>
>1. When performing the migration, the bond master detects that a slave has
>   lost its link, deactivates the LACP port, and sets the port's
>   is_enabled flag to false.
>2. The slave device then updates it's carrier state to off while it resets
>   itself. This update triggers a NETDEV_CHANGE notification, which performs
>   a speed and duplex update. The device does not return a valid speed
>   and duplex, so the master sets the slave link state to BOND_LINK_FAIL.
>3. When the slave VNIC device(s) are active again, some operations, such
>   as setting the port's is_enabled flag, are not performed when transitioning
>   the link state back to BOND_LINK_UP from BOND_LINK_FAIL, though the state
>   prior to the speed check was BOND_LINK_DOWN.

	Just to make sure I'm understanding correctly, in regards to
"the state prior to the speed check was BOND_LINK_DOWN," do you mean
that during step 1, the slave link is set to BOND_LINK_DOWN, and then in
step 2 changed from _DOWN to _FAIL?

>Affected devices are therefore not utilized in the aggregation though they
>are operational. The simplest way to fix this seems to be to restrict the
>link state change to devices that are currently up and running.

	This sounds similar to an issue from last fall; can you confirm
that you're running with a kernel that includes:

1899bb325149 bonding: fix state transition issue in link monitoring

	-J
	

>CC: Jay Vosburgh <j.vosburgh@gmail.com>
>CC: Veaceslav Falico <vfalico@gmail.com>
>CC: Andy Gospodarek <andy@greyhouse.net>
>Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
>---
> drivers/net/bonding/bond_main.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 2e70e43c5df5..d840da7cd379 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3175,7 +3175,8 @@ static int bond_slave_netdev_event(unsigned long event,
> 		 * speeds/duplex are available.
> 		 */
> 		if (bond_update_speed_duplex(slave) &&
>-		    BOND_MODE(bond) == BOND_MODE_8023AD) {
>+		    BOND_MODE(bond) == BOND_MODE_8023AD &&
>+		    slave->link == BOND_LINK_UP) {
> 			if (slave->last_link_up)
> 				slave->link = BOND_LINK_FAIL;
> 			else
>-- 
>2.18.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
