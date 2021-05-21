Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E810438CB77
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 19:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237750AbhEURCc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 May 2021 13:02:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50644 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbhEURCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 13:02:31 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lk8WE-00061Z-5Q; Fri, 21 May 2021 17:01:02 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 77D0A5FDD5; Fri, 21 May 2021 10:01:00 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 7069BA040C;
        Fri, 21 May 2021 10:01:00 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] bonding/balance-alb: put all slaves into promisc
In-reply-to: <20210521132756.1811620-5-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com> <20210521132756.1811620-1-jarod@redhat.com> <20210521132756.1811620-5-jarod@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Fri, 21 May 2021 09:27:56 -0400."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18878.1621616460.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 21 May 2021 10:01:00 -0700
Message-ID: <18879.1621616460@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>Unlike most other modes with a primary interface, ALB mode bonding can
>receive on all slaves. That includes traffic destined for a non-local MAC
>behind a bridge on top of the bond. Such traffic gets dropped if the
>interface isn't in promiscuous mode. Therefore, it would seem to make
>sense to put all slaves into promisc.

	I'm still confused by this description and the actual changes of
the patch; the description above reads to me as you're intending that
all slaves of an alb bond should be promisc all the time, but the patch
below doesn't do that (it causes all alb mode slaves to be set to
promisc when the bond itself is set to promisc mode).  Could you
clarify?

	Also, your phrasing that "it would seem to make sense" suggests
to me that this change is speculative.  Do you have a specific example
of when the prior behavior causes an issue?

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
>index 32785e9d0295..6d95f9e46059 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -647,9 +647,10 @@ static int bond_check_dev_link(struct bonding *bond,
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


---
	-Jay Vosburgh, jay.vosburgh@canonical.com
