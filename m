Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FE53994CB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 22:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFBUtP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Jun 2021 16:49:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40690 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhFBUtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 16:49:14 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1loXlp-0007Wf-Pq; Wed, 02 Jun 2021 20:47:22 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 206745FBC1; Wed,  2 Jun 2021 13:47:20 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 18D19A040B;
        Wed,  2 Jun 2021 13:47:20 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Kees Cook <keescook@chromium.org>
cc:     kernel test robot <lkp@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] net: bonding: Use strscpy() instead of manually-truncated strncpy()
In-reply-to: <20210602203138.4082470-1-keescook@chromium.org>
References: <20210602203138.4082470-1-keescook@chromium.org>
Comments: In-reply-to Kees Cook <keescook@chromium.org>
   message dated "Wed, 02 Jun 2021 13:31:38 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7213.1622666840.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Wed, 02 Jun 2021 13:47:20 -0700
Message-ID: <7214.1622666840@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kees Cook <keescook@chromium.org> wrote:

>Silence this warning by just using strscpy_pad() directly:
>
>>> drivers/net/bonding/bond_main.c:4877:3: warning: 'strncpy' specified bound 16 equals destination size [-Wstringop-truncation]
>    4877 |   strncpy(params->primary, primary, IFNAMSIZ);
>         |   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
>Additionally replace other strncpy() uses, as it is considered deprecated:
>https://www.kernel.org/doc/html/latest/process/deprecated.html#strncpy-on-nul-terminated-strings
>
>Reported-by: kernel test robot <lkp@intel.com>
>Link: https://lore.kernel.org/lkml/202102150705.fdR6obB0-lkp@intel.com
>Signed-off-by: Kees Cook <keescook@chromium.org>

	There's one more "strncpy(...); primary[IFNAMSIZ - 1] = 0;" set
in bond_options.c:bond_option_primary_set(), doesn't it also generate
this warning?

	Either way, the change looks good to me.

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>

	-J


>---
>v2:
> - switch to strscpy_pad() and replace earlier strncpy() too
>v1: https://lore.kernel.org/lkml/20210602181133.3326856-1-keescook@chromium.org
>---
> drivers/net/bonding/bond_main.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index c5a646d06102..e9cb716ad849 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -620,7 +620,7 @@ static int bond_check_dev_link(struct bonding *bond,
> 		 */
> 
> 		/* Yes, the mii is overlaid on the ifreq.ifr_ifru */
>-		strncpy(ifr.ifr_name, slave_dev->name, IFNAMSIZ);
>+		strscpy_pad(ifr.ifr_name, slave_dev->name, IFNAMSIZ);
> 		mii = if_mii(&ifr);
> 		if (ioctl(slave_dev, &ifr, SIOCGMIIPHY) == 0) {
> 			mii->reg_num = MII_BMSR;
>@@ -5329,10 +5329,8 @@ static int bond_check_params(struct bond_params *params)
> 			(struct reciprocal_value) { 0 };
> 	}
> 
>-	if (primary) {
>-		strncpy(params->primary, primary, IFNAMSIZ);
>-		params->primary[IFNAMSIZ - 1] = 0;
>-	}
>+	if (primary)
>+		strscpy_pad(params->primary, primary, sizeof(params->primary));
> 
> 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
> 
>-- 
>2.25.1

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
