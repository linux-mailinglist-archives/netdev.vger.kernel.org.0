Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 555EC33A0BC
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 20:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhCMTuu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 13 Mar 2021 14:50:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45803 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbhCMTum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 14:50:42 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lLAHW-0001Ql-AD; Sat, 13 Mar 2021 19:50:38 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 7D85F5FEE8; Sat, 13 Mar 2021 11:50:36 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 75524A0410;
        Sat, 13 Mar 2021 11:50:36 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jianlin Lv <Jianlin.Lv@arm.com>
cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, iecedge@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] bonding: Added -ENODEV interpret for slaves option
In-reply-to: <20210313140210.3940183-1-Jianlin.Lv@arm.com>
References: <20210313140210.3940183-1-Jianlin.Lv@arm.com>
Comments: In-reply-to Jianlin Lv <Jianlin.Lv@arm.com>
   message dated "Sat, 13 Mar 2021 22:02:10 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6675.1615665036.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Sat, 13 Mar 2021 11:50:36 -0800
Message-ID: <6676.1615665036@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianlin Lv <Jianlin.Lv@arm.com> wrote:

>After upgrading the kernel, the slave interface name is changed,
>Systemd cannot use the original configuration to create bond interface,
>thereby losing the connection with the host.
>
>Adding log for ENODEV will make it easier to find out such problem lies.

	To be clear, this specifically affects add/remove of interfaces
to/from the bond via the "slaves" sysfs interface.

	Please update your log to better describe this (that it affects
the sysfs API only) and resubmit.

	I'm sympathetic to the problem this is trying to solve, and the
message shouldn't spam the kernel log particularly, but the commit log
needs to more clearly describe what the problem is and how it's being
fixed.

	Thanks,

	-J

>Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
>---
> drivers/net/bonding/bond_options.c | 9 +++++++++
> 1 file changed, 9 insertions(+)
>
>diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>index 77d7c38bd435..c9d3604ae129 100644
>--- a/drivers/net/bonding/bond_options.c
>+++ b/drivers/net/bonding/bond_options.c
>@@ -640,6 +640,15 @@ static void bond_opt_error_interpret(struct bonding *bond,
> 		netdev_err(bond->dev, "option %s: unable to set because the bond device is up\n",
> 			   opt->name);
> 		break;
>+	case -ENODEV:
>+		if (val && val->string) {
>+			p = strchr(val->string, '\n');
>+			if (p)
>+				*p = '\0';
>+			netdev_err(bond->dev, "option %s: interface %s does not exist!\n",
>+				   opt->name, val->string);
>+		}
>+		break;
> 	default:
> 		break;
> 	}
>-- 
>2.25.1
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
