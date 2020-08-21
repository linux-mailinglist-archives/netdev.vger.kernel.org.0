Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E505124DFD7
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 20:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgHUSlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 14:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbgHUSlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 14:41:18 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC8DC061573;
        Fri, 21 Aug 2020 11:41:17 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 16F451287CB8E;
        Fri, 21 Aug 2020 11:24:30 -0700 (PDT)
Date:   Fri, 21 Aug 2020 11:41:15 -0700 (PDT)
Message-Id: <20200821.114115.118706831249226561.davem@davemloft.net>
To:     Jianlin.Lv@arm.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove redundant variable in
 vxlan_xmit_one
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200821055636.59937-1-Jianlin.Lv@arm.com>
References: <20200821055636.59937-1-Jianlin.Lv@arm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Aug 2020 11:24:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianlin Lv <Jianlin.Lv@arm.com>
Date: Fri, 21 Aug 2020 13:56:36 +0800

> @@ -2614,8 +2613,8 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
>  	info = skb_tunnel_info(skb);
>  
>  	if (rdst) {
> -		dst = &rdst->remote_ip;
> -		if (vxlan_addr_any(dst)) {
> +		remote_ip = rdst->remote_ip;
> +		if (vxlan_addr_any(&remote_ip)) {
>  			if (did_rsc) {

Now we are making a copy of the remote_ip object on the stack, and
passing a reference to the stack copy to the vxlan_addr_any()
function.  The existing code is passing a reference to the
original object, no copies.

This is not an improvement.
