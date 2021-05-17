Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A8F38376D
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 17:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344209AbhEQPn1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 17 May 2021 11:43:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44266 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244961AbhEQPlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 11:41:22 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lifLd-0004dy-Nf; Mon, 17 May 2021 15:40:01 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id F28E35FDD5; Mon, 17 May 2021 08:39:59 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id ECAD7A040C;
        Mon, 17 May 2021 08:39:59 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Johannes Berg <johannes@sipsolutions.net>
cc:     netdev@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Johannes Berg <johannes.berg@intel.com>,
        syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com
Subject: Re: [PATCH] bonding: init notify_work earlier to avoid uninitialized use
In-reply-to: <20210517161335.e40fea7f895a.I8b8487a9c0b8f54716cf44fdae02185381b1f64e@changeid>
References: <20210517161335.e40fea7f895a.I8b8487a9c0b8f54716cf44fdae02185381b1f64e@changeid>
Comments: In-reply-to Johannes Berg <johannes@sipsolutions.net>
   message dated "Mon, 17 May 2021 16:13:35 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29234.1621265999.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Mon, 17 May 2021 08:39:59 -0700
Message-ID: <29235.1621265999@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> wrote:

>From: Johannes Berg <johannes.berg@intel.com>
>
>If bond_kobj_init() or later kzalloc() in bond_alloc_slave() fail,
>then we call kobject_put() on the slave->kobj. This in turn calls
>the release function slave_kobj_release() which will always try to
>cancel_delayed_work_sync(&slave->notify_work), which shouldn't be
>done on an uninitialized work struct.
>
>Always initialize the work struct earlier to avoid problems here.
>
>Syzbot bisected this down to a completely pointless commit, some
>fault injection may have been at work here that caused the alloc
>failure in the first place, which may interact badly with bisect.
>
>Reported-by: syzbot+bfda097c12a00c8cae67@syzkaller.appspotmail.com
>Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> drivers/net/bonding/bond_main.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index 20bbda1b36e1..c5a646d06102 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -1526,6 +1526,7 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
> 
> 	slave->bond = bond;
> 	slave->dev = slave_dev;
>+	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
> 
> 	if (bond_kobj_init(slave))
> 		return NULL;
>@@ -1538,7 +1539,6 @@ static struct slave *bond_alloc_slave(struct bonding *bond,
> 			return NULL;
> 		}
> 	}
>-	INIT_DELAYED_WORK(&slave->notify_work, bond_netdev_notify_work);
> 
> 	return slave;
> }
>-- 
>2.31.1
>
