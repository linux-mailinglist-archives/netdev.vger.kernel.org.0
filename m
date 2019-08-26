Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D429C8E4
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 08:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729316AbfHZF76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:59:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbfHZF76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:59:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A417E15248637;
        Sun, 25 Aug 2019 22:59:57 -0700 (PDT)
Date:   Sun, 25 Aug 2019 22:59:57 -0700 (PDT)
Message-Id: <20190825.225957.2229146461648644754.davem@davemloft.net>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        jiri@mellanox.com, ray.jui@broadcom.com
Subject: Re: [PATCH net-next 08/14] bnxt_en: Add BNXT_STATE_IN_FW_RESET
 state and pf->registered_vfs.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566791705-20473-9-git-send-email-michael.chan@broadcom.com>
References: <1566791705-20473-1-git-send-email-michael.chan@broadcom.com>
        <1566791705-20473-9-git-send-email-michael.chan@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 25 Aug 2019 22:59:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Sun, 25 Aug 2019 23:54:59 -0400

> @@ -9234,6 +9243,13 @@ int bnxt_close_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
>  {
>  	int rc = 0;
>  
> +	while (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
> +		netdev_info(bp->dev, "FW reset in progress, delaying close");
> +		rtnl_unlock();
> +		msleep(250);
> +		rtnl_lock();
> +	}

Dropping the RTNL here is extremely dangerous.

Operations other than actual device close can get into the
bnxt_close_nic() code paths (changing features, ethtool ops, etc.)

So we can thus re-enter this function once you drop the RTNL mutex.

Furthermore, and I understand what pains you go into in patch #9 to
avoid this, but it's an endless loop.  If there are bugs there, we
will get stuck in this close path forever.

