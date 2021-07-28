Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2983D8712
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 07:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhG1FN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 01:13:58 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48212
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229752AbhG1FN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 01:13:57 -0400
Received: from famine.localdomain (1.general.jvosburgh.us.vpn [10.172.68.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id A78F2402C2;
        Wed, 28 Jul 2021 05:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627449235;
        bh=8svXSp3hdKJmyVBs5oNMWBFqCE47CuYsPgYWZ8llyl0=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=nMX/oEt4+3njSOrgEdfpi+7Pk8QqMXAiHYM+H+I3fK7I3oJj0gPOtNvNdoTacK4yF
         idV5aEr25l0h2+flADpPAwUDu54Le8HvI7/82rb4FwPXczdojLXIBrf+STOlPJJUHR
         v5MRXeGB8OEuWQ9SkSb4OtyLtW4YkzJXmm7/eDhwLSp5sTAfCw4usTDHl4/2AWYcBy
         QeMh41zXguCy9WXApluDx+yb74yZ5U8kWzaBiXSizJlx3frnC56e/muElIdLh/rkkX
         89kSwJZ415VDpi6bCSiIJt31AnYTGXcl1Ub9vV81r4k14n+fYYXWPFo17wPan//6o0
         /DajrM6YXabbw==
Received: by famine.localdomain (Postfix, from userid 1000)
        id B1FA35FBC4; Tue, 27 Jul 2021 22:13:48 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id ACB38A040B;
        Tue, 27 Jul 2021 22:13:48 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Yufeng Mo <moyufeng@huawei.com>
cc:     davem@davemloft.net, kuba@kernel.org, jiri@resnulli.us,
        netdev@vger.kernel.org, shenjian15@huawei.com,
        lipeng321@huawei.com, yisen.zhuang@huawei.com,
        linyunsheng@huawei.com, zhangjiaran@huawei.com,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        salil.mehta@huawei.com, linuxarm@huawei.com, linuxarm@openeuler.org
Subject: Re: [PATCH RFC net-next] bonding: 3ad: fix the conflict between __bond_release_one and bond_3ad_state_machine_handler
In-reply-to: <1627025171-18480-1-git-send-email-moyufeng@huawei.com>
References: <1627025171-18480-1-git-send-email-moyufeng@huawei.com>
Comments: In-reply-to Yufeng Mo <moyufeng@huawei.com>
   message dated "Fri, 23 Jul 2021 15:26:11 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10702.1627449228.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 27 Jul 2021 22:13:48 -0700
Message-ID: <10703.1627449228@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yufeng Mo <moyufeng@huawei.com> wrote:

>Some time ago, I reported a calltrace issue
>"did not find a suitable aggregator", please see[1].
>After a period of analysis and reproduction, I find
>that this problem is caused by concurrency.
>
>Before the problem occurs, the bond structure is like follows:
>
>bond0 - slaver0(eth0) - agg0.lag_ports -> port0 - port1
>                      \
>                        port0
>      \
>        slaver1(eth1) - agg1.lag_ports -> NULL
>                      \
>                        port1
>
>If we run 'ifenslave bond0 -d eth1', the process is like below:
>
>excuting __bond_release_one()
>|
>bond_upper_dev_unlink()[step1]
>|                       |                       |
>|                       |                       bond_3ad_lacpdu_recv()
>|                       |                       ->bond_3ad_rx_indication(=
)
>|                       |                       ->ad_rx_machine()
>|                       |                       ->__record_pdu()[step2]
>|                       |                       |
>|                       bond_3ad_state_machine_handler()
>|                       ->ad_port_selection_logic()
>|                       ->try to find free aggregator[step3]
>|                       ->try to find suitable aggregator[step4]
>|                       ->did not find a suitable aggregator[step5]
>|                       |
>|                       |
>bond_3ad_unbind_slave() |
>
>step1: already removed slaver1(eth1) from list, but port1 remains
>step2: receive a lacpdu and update port0
>step3: port0 will be removed from agg0.lag_ports. The struct is
>       "agg0.lag_ports -> port1" now, and agg0 is not free. At the
>       same time, slaver1/agg1 has been removed from the list by step1.
>       So we can't find a free aggregator now.
>step4: can't find suitable aggregator because of step2
>step5: cause a calltrace since port->aggregator is NULL
>
>To solve this concurrency problem, the range of bond->mode_lock
>is extended from only bond_3ad_unbind_slave() to both
>bond_upper_dev_unlink() and bond_3ad_unbind_slave().
>
>[1]https://lore.kernel.org/netdev/10374.1611947473@famine/
>
>Signed-off-by: Yufeng Mo <moyufeng@huawei.com>

	This looks good to me, and explains the previously reported
issue.  If Jakub or Davem are comfortable applying this even though it
was posted as RFC (it applies cleanly to today's net-next, although I
did not build it) I'm fine with that; otherwise, please repost and
include:

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J


>---
> drivers/net/bonding/bond_3ad.c  | 7 +------
> drivers/net/bonding/bond_main.c | 3 +++
> 2 files changed, 4 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_3ad.c b/drivers/net/bonding/bond_3a=
d.c
>index 6908822..f0f5adb 100644
>--- a/drivers/net/bonding/bond_3ad.c
>+++ b/drivers/net/bonding/bond_3ad.c
>@@ -2099,15 +2099,13 @@ void bond_3ad_unbind_slave(struct slave *slave)
> 	struct list_head *iter;
> 	bool dummy_slave_update; /* Ignore this value as caller updates array *=
/
> =

>-	/* Sync against bond_3ad_state_machine_handler() */
>-	spin_lock_bh(&bond->mode_lock);
> 	aggregator =3D &(SLAVE_AD_INFO(slave)->aggregator);
> 	port =3D &(SLAVE_AD_INFO(slave)->port);
> =

> 	/* if slave is null, the whole port is not initialized */
> 	if (!port->slave) {
> 		slave_warn(bond->dev, slave->dev, "Trying to unbind an uninitialized p=
ort\n");
>-		goto out;
>+		return;
> 	}
> =

> 	slave_dbg(bond->dev, slave->dev, "Unbinding Link Aggregation Group %d\n=
",
>@@ -2239,9 +2237,6 @@ void bond_3ad_unbind_slave(struct slave *slave)
> 		}
> 	}
> 	port->slave =3D NULL;
>-
>-out:
>-	spin_unlock_bh(&bond->mode_lock);
> }
> =

> /**
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_m=
ain.c
>index 0ff7567..00a501c 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -2129,6 +2129,8 @@ static int __bond_release_one(struct net_device *bo=
nd_dev,
> 	/* recompute stats just before removing the slave */
> 	bond_get_stats(bond->dev, &bond->bond_stats);
> =

>+	/* Sync against bond_3ad_state_machine_handler() */
>+	spin_lock_bh(&bond->mode_lock);
> 	bond_upper_dev_unlink(bond, slave);
> 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
> 	 * for this slave anymore.
>@@ -2137,6 +2139,7 @@ static int __bond_release_one(struct net_device *bo=
nd_dev,
> =

> 	if (BOND_MODE(bond) =3D=3D BOND_MODE_8023AD)
> 		bond_3ad_unbind_slave(slave);
>+	spin_unlock_bh(&bond->mode_lock);
> =

> 	if (bond_mode_can_use_xmit_hash(bond))
> 		bond_update_slave_arr(bond, slave);
>-- =

>2.8.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
