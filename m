Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0529FFD274
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbfKOBaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:30:17 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57158 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfKOBaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:30:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 85D2B14B73AFE;
        Thu, 14 Nov 2019 17:30:16 -0800 (PST)
Date:   Thu, 14 Nov 2019 17:30:15 -0800 (PST)
Message-Id: <20191114.173015.93572744645212390.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, gvrose8192@gmail.com, blp@ovn.org,
        netdev@vger.kernel.org, dev@openvswitch.org
Subject: Re: [PATCH net-next v4] net: openvswitch: add hash info to upcall
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573657489-16067-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1573657489-16067-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 17:30:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Wed, 13 Nov 2019 23:04:49 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> When using the kernel datapath, the upcall don't
> include skb hash info relatived. That will introduce
> some problem, because the hash of skb is important
> in kernel stack. For example, VXLAN module uses
> it to select UDP src port. The tx queue selection
> may also use the hash in stack.
> 
> Hash is computed in different ways. Hash is random
> for a TCP socket, and hash may be computed in hardware,
> or software stack. Recalculation hash is not easy.
> 
> Hash of TCP socket is computed:
> tcp_v4_connect
>     -> sk_set_txhash (is random)
> 
> __tcp_transmit_skb
>     -> skb_set_hash_from_sk
> 
> There will be one upcall, without information of skb
> hash, to ovs-vswitchd, for the first packet of a TCP
> session. The rest packets will be processed in Open vSwitch
> modules, hash kept. If this tcp session is forward to
> VXLAN module, then the UDP src port of first tcp packet
> is different from rest packets.
> 
> TCP packets may come from the host or dockers, to Open vSwitch.
> To fix it, we store the hash info to upcall, and restore hash
> when packets sent back.
 ...
> Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Applied, thank you.
