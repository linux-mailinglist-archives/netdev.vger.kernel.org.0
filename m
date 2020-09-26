Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB0279C33
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 21:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgIZTfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 15:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729291AbgIZTfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 15:35:21 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D37F2C0613CE
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 12:35:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E088C129A349C;
        Sat, 26 Sep 2020 12:18:32 -0700 (PDT)
Date:   Sat, 26 Sep 2020 12:35:19 -0700 (PDT)
Message-Id: <20200926.123519.1489325826604036131.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, fabf@skynet.be
Subject: Re: [PATCH net-next] Revert "vxlan: move encapsulation warning"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200926015604.3363358-1-kuba@kernel.org>
References: <20200926015604.3363358-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Sat, 26 Sep 2020 12:18:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Fri, 25 Sep 2020 18:56:04 -0700

> This reverts commit 546c044c9651e81a16833806feff6b369bb5de33.
> 
> Nothing prevents user from sending frames to "external" VxLAN devices.
> In fact kernel itself may generate icmp chatter.
> 
> This is fine, such frames should be dropped.
> 
> The point of the "missing encapsulation" warning was that
> frames with missing encap should not make it into vxlan_xmit_one().
> And vxlan_xmit() drops them cleanly, so let it just do that.
> 
> Without this revert the warning is triggered by the udp_tunnel_nic.sh
> test, but the minimal repro is:
> 
> $ ip link add vxlan0 type vxlan \
>      	      	     group 239.1.1.1 \
> 		     dev lo \
> 		     dstport 1234 \
> 		     external
> $ ip li set dev vxlan0 up
> 
> [  419.165981] vxlan0: Missing encapsulation instructions
> [  419.166551] WARNING: CPU: 0 PID: 1041 at drivers/net/vxlan.c:2889 vxlan_xmit+0x15c0/0x1fc0 [vxlan]
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Applied, thanks Jakub.
