Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9543BA504
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 23:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhGBV3F convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 2 Jul 2021 17:29:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47017 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbhGBV3F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 17:29:05 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1lzQg5-0003hu-S5; Fri, 02 Jul 2021 21:26:26 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0FF3F5FDD5; Fri,  2 Jul 2021 14:26:24 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 08451A040B;
        Fri,  2 Jul 2021 14:26:24 -0700 (PDT)
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
Content-ID: <14515.1625261183.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Fri, 02 Jul 2021 14:26:24 -0700
Message-ID: <14516.1625261184@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Taehee Yoo <ap420073@gmail.com> wrote:

[...]
>@@ -479,8 +481,9 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
> 	if (BOND_MODE(bond) != BOND_MODE_ACTIVEBACKUP)
> 		return true;

	Not a question about this patch, but isn't the "return true"
above incorrect (i.e., should return false)?  I understand that the
ipsec offload is only available for active-backup mode, but the test
above will return true for all modes other than active-backup.

	-J

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
