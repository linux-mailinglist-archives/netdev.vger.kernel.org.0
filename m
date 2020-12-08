Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A14F2D345C
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 21:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728613AbgLHUhf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Dec 2020 15:37:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57202 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730934AbgLHUfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 15:35:41 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1kmjhE-0001pY-Lu; Tue, 08 Dec 2020 20:34:53 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id DAC085FEE7; Tue,  8 Dec 2020 12:34:50 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D2F0F9FAB0;
        Tue,  8 Dec 2020 12:34:50 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Mahesh Bandewar <maheshb@google.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net] bonding: reduce rtnl lock contention in mii monitor thread
In-reply-to: <20201205234354.1710-1-jarod@redhat.com>
References: <20201205234354.1710-1-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Sat, 05 Dec 2020 18:43:54 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11897.1607459690.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Tue, 08 Dec 2020 12:34:50 -0800
Message-ID: <11900.1607459690@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>I'm seeing a system get stuck unable to bring a downed interface back up
>when it's got an updelay value set, behavior which ceased when logging
>spew was removed from bond_miimon_inspect(). I'm monitoring logs on this
>system over another network connection, and it seems that the act of
>spewing logs at all there increases rtnl lock contention, because
>instrumented code showed bond_mii_monitor() never able to succeed in it's
>attempts to call rtnl_trylock() to actually commit link state changes,
>leaving the downed link stuck in BOND_LINK_DOWN. The system in question
>appears to be fine with the log spew being moved to
>bond_commit_link_state(), which is called after the successful
>rtnl_trylock(). I'm actually wondering if perhaps we ultimately need/want
>some bond-specific lock here to prevent racing with bond_close() instead
>of using rtnl, but this shift of the output appears to work. I believe
>this started happening when de77ecd4ef02 ("bonding: improve link-status
>update in mii-monitoring") went in, but I'm not 100% on that.

	We use RTNL not to avoid deadlock with bonding itself, but
because the "commit" side undertakes actions which require RTNL, e.g.,
various events will eventually call netdev_lower_state_changed.

	However, the RTNL acquisition is a trylock to avoid the deadlock
with bond_close.  Moving that out of line here (e.g., putting the commit
into another work queue event or the like) has the same problem, in that
bond_close needs to wait for all of the work queue events to finish, and
it holds RTNL.

	Also, a dim memory says that the various notification messages
were mostly placed in the "inspect" phase and not the "commit" phase to
avoid doing printk-like activities with RTNL held.  As a general
principle, I don't think we want to add more verbiage under RTNL.

>The addition of a case BOND_LINK_BACK in bond_miimon_inspect() is somewhat
>separate from the fix for the actual hang, but it eliminates a constant
>"invalid new link 3 on slave" message seen related to this issue, and it's
>not actually an invalid state here, so we shouldn't be reporting it as an
>error.

	Do you mean bond_miimon_commit here and not bond_miimon_inspect
(which already has a case for BOND_LINK_BACK)?

	In principle, bond_miimon_commit should not see _BACK or _FAIL
state as a new link state, because those states should be managed at the
bond_miimon_inspect level (as they are the result of updelay and
downdelay).  These states should not be "committed" in the sense of
causing notifications or doing actions that require RTNL.

	My recollection is that the "invalid new link" messages were the
result of a bug in de77ecd4ef02, which was fixed in 1899bb325149
("bonding: fix state transition issue in link monitoring"), but maybe
the RTNL problem here induces that in some other fashion.

	Either way, I believe this message is correct as-is.

	-J

>CC: Mahesh Bandewar <maheshb@google.com>
>CC: Jay Vosburgh <j.vosburgh@gmail.com>
>CC: Veaceslav Falico <vfalico@gmail.com>
>CC: Andy Gospodarek <andy@greyhouse.net>
>CC: "David S. Miller" <davem@davemloft.net>
>CC: Jakub Kicinski <kuba@kernel.org>
>CC: Thomas Davis <tadavis@lbl.gov>
>CC: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/net/bonding/bond_main.c | 26 ++++++----------------
> include/net/bonding.h           | 38 +++++++++++++++++++++++++++++++++
> 2 files changed, 44 insertions(+), 20 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 47afc5938c26..cdb6c64f16b6 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2292,23 +2292,13 @@ static int bond_miimon_inspect(struct bonding *bond)
> 			bond_propose_link_state(slave, BOND_LINK_FAIL);
> 			commit++;
> 			slave->delay = bond->params.downdelay;
>-			if (slave->delay) {
>-				slave_info(bond->dev, slave->dev, "link status down for %sinterface, disabling it in %d ms\n",
>-					   (BOND_MODE(bond) ==
>-					    BOND_MODE_ACTIVEBACKUP) ?
>-					    (bond_is_active_slave(slave) ?
>-					     "active " : "backup ") : "",
>-					   bond->params.downdelay * bond->params.miimon);
>-			}
>+
> 			fallthrough;
> 		case BOND_LINK_FAIL:
> 			if (link_state) {
> 				/* recovered before downdelay expired */
> 				bond_propose_link_state(slave, BOND_LINK_UP);
> 				slave->last_link_up = jiffies;
>-				slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
>-					   (bond->params.downdelay - slave->delay) *
>-					   bond->params.miimon);
> 				commit++;
> 				continue;
> 			}
>@@ -2330,19 +2320,10 @@ static int bond_miimon_inspect(struct bonding *bond)
> 			commit++;
> 			slave->delay = bond->params.updelay;
> 
>-			if (slave->delay) {
>-				slave_info(bond->dev, slave->dev, "link status up, enabling it in %d ms\n",
>-					   ignore_updelay ? 0 :
>-					   bond->params.updelay *
>-					   bond->params.miimon);
>-			}
> 			fallthrough;
> 		case BOND_LINK_BACK:
> 			if (!link_state) {
> 				bond_propose_link_state(slave, BOND_LINK_DOWN);
>-				slave_info(bond->dev, slave->dev, "link status down again after %d ms\n",
>-					   (bond->params.updelay - slave->delay) *
>-					   bond->params.miimon);
> 				commit++;
> 				continue;
> 			}
>@@ -2456,6 +2437,11 @@ static void bond_miimon_commit(struct bonding *bond)
> 
> 			continue;
> 
>+		case BOND_LINK_BACK:
>+			bond_propose_link_state(slave, BOND_LINK_NOCHANGE);
>+
>+			continue;
>+
> 		default:
> 			slave_err(bond->dev, slave->dev, "invalid new link %d on slave\n",
> 				  slave->link_new_state);
>diff --git a/include/net/bonding.h b/include/net/bonding.h
>index adc3da776970..6a09de9a3f03 100644
>--- a/include/net/bonding.h
>+++ b/include/net/bonding.h
>@@ -558,10 +558,48 @@ static inline void bond_propose_link_state(struct slave *slave, int state)
> 
> static inline void bond_commit_link_state(struct slave *slave, bool notify)
> {
>+	struct bonding *bond = slave->bond;
>+
> 	if (slave->link_new_state == BOND_LINK_NOCHANGE)
> 		return;
> 
>+	if (slave->link == slave->link_new_state)
>+		return;
>+
> 	slave->link = slave->link_new_state;
>+
>+	switch(slave->link) {
>+	case BOND_LINK_UP:
>+		slave_info(bond->dev, slave->dev, "link status up again after %d ms\n",
>+			   (bond->params.downdelay - slave->delay) *
>+			   bond->params.miimon);
>+		break;
>+
>+	case BOND_LINK_FAIL:
>+		if (slave->delay) {
>+			slave_info(bond->dev, slave->dev, "link status down for %sinterface, disabling it in %d ms\n",
>+				   (BOND_MODE(bond) ==
>+				    BOND_MODE_ACTIVEBACKUP) ?
>+				    (bond_is_active_slave(slave) ?
>+				     "active " : "backup ") : "",
>+				   bond->params.downdelay * bond->params.miimon);
>+		}
>+		break;
>+
>+	case BOND_LINK_DOWN:
>+		slave_info(bond->dev, slave->dev, "link status down again after %d ms\n",
>+			   (bond->params.updelay - slave->delay) *
>+			   bond->params.miimon);
>+		break;
>+
>+	case BOND_LINK_BACK:
>+		if (slave->delay) {
>+			slave_info(bond->dev, slave->dev, "link status up, enabling it in %d ms\n",
>+				   bond->params.updelay * bond->params.miimon);
>+		}
>+		break;
>+	}
>+
> 	if (notify) {
> 		bond_queue_slave_event(slave);
> 		bond_lower_state_changed(slave);
>-- 
>2.28.0
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
