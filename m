Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB71E6743
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404940AbgE1QSU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 28 May 2020 12:18:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33171 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404830AbgE1QSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:18:18 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jeLER-00083j-MH; Thu, 28 May 2020 16:18:12 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id D800E5FEE8; Thu, 28 May 2020 09:18:09 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id D082F9F851;
        Thu, 28 May 2020 09:18:09 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     wu000273@umn.edu
cc:     kjlu@umn.edu, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "sfeldma@cumulusnetworks.com" <sfeldma@cumulusnetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding: Fix reference count leak in bond_sysfs_slave_add.
In-reply-to: <20200528031029.11078-1-wu000273@umn.edu>
References: <20200528031029.11078-1-wu000273@umn.edu>
Comments: In-reply-to wu000273@umn.edu
   message dated "Wed, 27 May 2020 22:10:29 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2425.1590682689.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 28 May 2020 09:18:09 -0700
Message-ID: <2426.1590682689@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wu000273@umn.edu wrote:

>From: Qiushi Wu <wu000273@umn.edu>
>
>kobject_init_and_add() takes reference even when it fails.
>If this function returns an error, kobject_put() must be called to
>properly clean up the memory associated with the object. Previous
>commit "b8eb718348b8" fixed a similar problem.
>
>Fixes: 07699f9a7c8d ("bonding: add sysfs /slave dir for bond slave devices.")
>Signed-off-by: Qiushi Wu <wu000273@umn.edu>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_sysfs_slave.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_sysfs_slave.c b/drivers/net/bonding/bond_sysfs_slave.c
>index 007481557191..9b8346638f69 100644
>--- a/drivers/net/bonding/bond_sysfs_slave.c
>+++ b/drivers/net/bonding/bond_sysfs_slave.c
>@@ -149,8 +149,10 @@ int bond_sysfs_slave_add(struct slave *slave)
> 
> 	err = kobject_init_and_add(&slave->kobj, &slave_ktype,
> 				   &(slave->dev->dev.kobj), "bonding_slave");
>-	if (err)
>+	if (err) {
>+		kobject_put(&slave->kobj);
> 		return err;
>+	}
> 
> 	for (a = slave_attrs; *a; ++a) {
> 		err = sysfs_create_file(&slave->kobj, &((*a)->attr));
>-- 
>2.17.1
>
