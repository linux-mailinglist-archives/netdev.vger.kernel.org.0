Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D447119B535
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732566AbgDASO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:14:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727723AbgDASO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:14:29 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7991C11D69C3E;
        Wed,  1 Apr 2020 11:14:28 -0700 (PDT)
Date:   Wed, 01 Apr 2020 11:14:27 -0700 (PDT)
Message-Id: <20200401.111427.789296252666544265.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     linux-kernel@vger.kernel.org, moshele@mellanox.com,
        stephen@networkplumber.org, mleitner@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v2] ipv6: don't auto-add link-local address to lag
 ports
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200330152219.58296-1-jarod@redhat.com>
References: <CAKfmpSd_VQTwxy-gr-jNvQu_CMFf9F2enEjyQC3+W9+Y2WO1Dg@mail.gmail.com>
        <20200330152219.58296-1-jarod@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Apr 2020 11:14:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Mon, 30 Mar 2020 11:22:19 -0400

> Bonding slave and team port devices should not have link-local addresses
> automatically added to them, as it can interfere with openvswitch being
> able to properly add tc ingress.
> 
> Basic reproducer, courtesy of Marcelo:
 ...
> (above trimmed to relevant entries, obviously)
> 
> $ sysctl net.ipv6.conf.ens2f0np0.addr_gen_mode=0
> net.ipv6.conf.ens2f0np0.addr_gen_mode = 0
> $ sysctl net.ipv6.conf.ens2f1np2.addr_gen_mode=0
> net.ipv6.conf.ens2f1np2.addr_gen_mode = 0
> 
> $ ip a l ens2f0np0
> 2: ens2f0np0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
> mq master bond0 state UP group default qlen 1000
>     link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
>     inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
>        valid_lft forever preferred_lft forever
> $ ip a l ens2f1np2
> 5: ens2f1np2: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
> mq master bond0 state DOWN group default qlen 1000
>     link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
>     inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
>        valid_lft forever preferred_lft forever
> 
> Looks like addrconf_sysctl_addr_gen_mode() bypasses the original "is
> this a slave interface?" check added by commit c2edacf80e15, and
> results in an address getting added, while w/the proposed patch added,
> no address gets added. This simply adds the same gating check to another
> code path, and thus should prevent the same devices from erroneously
> obtaining an ipv6 link-local address.
> 
> Fixes: d35a00b8e33d ("net/ipv6: allow sysctl to change link-local address generation mode")
> Reported-by: Moshe Levi <moshele@mellanox.com>
> CC: Stephen Hemminger <stephen@networkplumber.org>
> CC: Marcelo Ricardo Leitner <mleitner@redhat.com>
> CC: netdev@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Applied and queued up for -stable, thanks.
