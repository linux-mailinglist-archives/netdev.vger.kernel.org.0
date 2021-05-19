Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F4438940E
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355400AbhESQsr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 May 2021 12:48:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36727 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231124AbhESQsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 12:48:41 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1ljPLo-0002HK-NM; Wed, 19 May 2021 16:47:16 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 5F8265FDD5; Wed, 19 May 2021 09:47:14 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 59812A040C;
        Wed, 19 May 2021 09:47:14 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH 4/4] bond_alb: put all slaves into promisc
In-reply-to: <20210518210849.1673577-5-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com> <20210518210849.1673577-5-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Tue, 18 May 2021 17:08:49 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27877.1621442834.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 19 May 2021 09:47:14 -0700
Message-ID: <27878.1621442834@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>ALB mode bonding can receive on all slaves, so it would seem to make sense
>that they're all in promisc, unlike other modes that have a primary
>interface and can only receive on that interface.

	When I first read the subject and this description, I thought
you meant that all of the alb slaves would be in promisc mode all the
time, not that enabling promisc on an alb bond would set promisc for all
slaves (instead of just the primary, the current behavior).

	Regardless, since in alb mode the expectation is that all of the
slaves will be on the same subnet (Ethernet broadcast domain), setting
all of the bonded interfaces to promisc instead of just one sounds like
a recipe for duplicate packets, as each would deliver multiple copies of
all "no longer filtered" traffic.  The bond_should_deliver_exact_match()
logic will still suppress broadcast and multicast frames to the
non-primary interface(s), but, e.g., unicast frames flooded to all
switch ports will be delivered once for each member of the bond.

	Unless you have a specific use case that this will improve, I
think this will cause more confusion that it will capture frames that
would have otherwise been missed.

	-J

>Cc: Jay Vosburgh <j.vosburgh@gmail.com>
>Cc: Veaceslav Falico <vfalico@gmail.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: "David S. Miller" <davem@davemloft.net>
>Cc: Jakub Kicinski <kuba@kernel.org>
>Cc: Thomas Davis <tadavis@lbl.gov>
>Cc: netdev@vger.kernel.org
>Signed-off-by: Jarod Wilson <jarod@redhat.com>
>---
> drivers/net/bonding/bond_main.c | 5 +++--
> 1 file changed, 3 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index d71e398642fb..93f57ff1c552 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -644,9 +644,10 @@ static int bond_check_dev_link(struct bonding *bond,
> static int bond_set_promiscuity(struct bonding *bond, int inc)
> {
> 	struct list_head *iter;
>-	int err = 0;
>+	int mode, err = 0;
> 
>-	if (bond_uses_primary(bond)) {
>+	mode = BOND_MODE(bond);
>+	if (mode == BOND_MODE_ACTIVEBACKUP || mode == BOND_MODE_TLB) {
> 		struct slave *curr_active = rtnl_dereference(bond->curr_active_slave);
> 
> 		if (curr_active)
>-- 
>2.30.2
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
