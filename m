Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8FC11E04C2
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 04:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388539AbgEYCel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 22:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388110AbgEYCel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 22:34:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 500AFC05BD43
        for <netdev@vger.kernel.org>; Sun, 24 May 2020 19:34:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A0A511280D0AD;
        Sun, 24 May 2020 19:34:40 -0700 (PDT)
Date:   Sun, 24 May 2020 19:34:40 -0700 (PDT)
Message-Id: <20200524.193440.1964639574698146489.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, roopa@cumulusnetworks.com,
        mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next] vxlan: Do not assume RTNL is held in
 vxlan_fdb_info()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200524213856.1314103-1-idosch@idosch.org>
References: <20200524213856.1314103-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 24 May 2020 19:34:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Mon, 25 May 2020 00:38:56 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> vxlan_fdb_info() is not always called with RTNL held or from an RCU
> read-side critical section. For example, in the following call path:
> 
> vxlan_cleanup()
>   vxlan_fdb_destroy()
>     vxlan_fdb_notify()
>       __vxlan_fdb_notify()
>         vxlan_fdb_info()
> 
> The use of rtnl_dereference() can therefore result in the following
> splat [1].
> 
> Fix this by dereferencing the nexthop under RCU read-side critical
> section.
> 
> [1]
> [May24 22:56] =============================
> [  +0.004676] WARNING: suspicious RCU usage
> [  +0.004614] 5.7.0-rc5-custom-16219-g201392003491 #2772 Not tainted
> [  +0.007116] -----------------------------
> [  +0.004657] drivers/net/vxlan.c:276 suspicious rcu_dereference_check() usage!
 ...
> Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reported-by: Amit Cohen <amitc@mellanox.com>

Applied, thanks Ido.
