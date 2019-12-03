Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBF2A1104FB
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfLCTWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:22:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51716 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfLCTWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:22:47 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 712CA1510370A;
        Tue,  3 Dec 2019 11:22:46 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:22:45 -0800 (PST)
Message-Id: <20191203.112245.4269861704222403.davem@davemloft.net>
To:     nikolay@cumulusnetworks.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org, syzkaller-bugs@googlegroups.com,
        stephen@networkplumber.org,
        syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: bridge: deny dev_set_mac_address() when
 unregistering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203144806.10468-1-nikolay@cumulusnetworks.com>
References: <20191203144806.10468-1-nikolay@cumulusnetworks.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:22:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Date: Tue,  3 Dec 2019 16:48:06 +0200

> We have an interesting memory leak in the bridge when it is being
> unregistered and is a slave to a master device which would change the
> mac of its slaves on unregister (e.g. bond, team). This is a very
> unusual setup but we do end up leaking 1 fdb entry because
> dev_set_mac_address() would cause the bridge to insert the new mac address
> into its table after all fdbs are flushed, i.e. after dellink() on the
> bridge has finished and we call NETDEV_UNREGISTER the bond/team would
> release it and will call dev_set_mac_address() to restore its original
> address and that in turn will add an fdb in the bridge.
> One fix is to check for the bridge dev's reg_state in its
> ndo_set_mac_address callback and return an error if the bridge is not in
> NETREG_REGISTERED.
> 
> Easy steps to reproduce:
>  1. add bond in mode != A/B
>  2. add any slave to the bond
>  3. add bridge dev as a slave to the bond
>  4. destroy the bridge device
> 
> Trace:
>  unreferenced object 0xffff888035c4d080 (size 128):
 ...
> Fixes: 43598813386f ("bridge: add local MAC address to forwarding table (v2)")
> Reported-by: syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Looks good, applied and queued up for -stable.

Thanks.
