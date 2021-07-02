Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AEF03BA4F6
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 23:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhGBVRH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Jul 2021 17:17:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46794 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhGBVRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 17:17:06 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lzQUT-0002oY-4X; Fri, 02 Jul 2021 21:14:25 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 5EE165FDD5; Fri,  2 Jul 2021 14:14:23 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 57427A040B;
        Fri,  2 Jul 2021 14:14:23 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Taehee Yoo <ap420073@gmail.com>
cc:     davem@davemloft.net, kuba@kernel.org, vfalico@gmail.com,
        andy@greyhouse.net, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, jarod@redhat.com,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net 6/8] bonding: disallow setting nested bonding + ipsec offload
In-reply-to: <20210702142648.7677-7-ap420073@gmail.com>
References: <20210702142648.7677-1-ap420073@gmail.com> <20210702142648.7677-7-ap420073@gmail.com>
Comments: In-reply-to Taehee Yoo <ap420073@gmail.com>
   message dated "Fri, 02 Jul 2021 14:26:46 -0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14148.1625260463.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 02 Jul 2021 14:14:23 -0700
Message-ID: <14149.1625260463@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> wrote:

>bonding interface can be nested and it supports ipsec offload.
>So, it allows setting the nested bonding + ipsec scenario.
>But code does not support this scenario.
>So, it should be disallowed.
>
>interface graph:
>bond2
> |
>bond1
> |
>eth0
>
>The nested bonding + ipsec offload may not a real usecase.
>So, disallowing this is fine.

	Is a stack like "bond1 -> VLAN.XX -> bond2 -> eth0" also a
problem?  I don't believe the change below will detect this
configuration.

	-J

>Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
>Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>---
> drivers/net/bonding/bond_main.c | 15 +++++++++------
> 1 file changed, 9 insertions(+), 6 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 7659e1fab19e..f268e67cb2f0 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -419,8 +419,9 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
> 	xs->xso.real_dev = slave->dev;
> 	bond->xs = xs;
> 
>-	if (!(slave->dev->xfrmdev_ops
>-	      && slave->dev->xfrmdev_ops->xdo_dev_state_add)) {
>+	if (!slave->dev->xfrmdev_ops ||
>+	    !slave->dev->xfrmdev_ops->xdo_dev_state_add ||
>+	    netif_is_bond_master(slave->dev)) {
> 		slave_warn(bond_dev, slave->dev, "Slave does not support ipsec offload\n");
> 		rcu_read_unlock();
> 		return -EINVAL;
>@@ -453,8 +454,9 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
> 
> 	xs->xso.real_dev = slave->dev;
> 
>-	if (!(slave->dev->xfrmdev_ops
>-	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
>+	if (!slave->dev->xfrmdev_ops ||
>+	    !slave->dev->xfrmdev_ops->xdo_dev_state_delete ||
>+	    netif_is_bond_master(slave->dev)) {
> 		slave_warn(bond_dev, slave->dev, "%s: no slave xdo_dev_state_delete\n", __func__);
> 		goto out;
> 	}
>@@ -479,8 +481,9 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
> 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
> 		return true;
> 
>-	if (!(slave_dev->xfrmdev_ops
>-	      && slave_dev->xfrmdev_ops->xdo_dev_offload_ok)) {
>+	if (!slave_dev->xfrmdev_ops ||
>+	    !slave_dev->xfrmdev_ops->xdo_dev_offload_ok ||
>+	    netif_is_bond_master(slave_dev)) {
> 		slave_warn(bond_dev, slave_dev, "%s: no slave xdo_dev_offload_ok\n", __func__);
> 		return false;
> 	}
>-- 
>2.17.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
