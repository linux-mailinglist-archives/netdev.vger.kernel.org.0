Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CACF11059B
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 20:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbfLCT6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 14:58:20 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52058 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbfLCT6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 14:58:19 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA0EE1510CE16;
        Tue,  3 Dec 2019 11:58:18 -0800 (PST)
Date:   Tue, 03 Dec 2019 11:58:18 -0800 (PST)
Message-Id: <20191203.115818.1902434596879929857.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, ja@ssi.bg, marcelo.leitner@gmail.com,
        dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCHv2 net] ipv6/route: should not update neigh confirm time
 during PMTU update
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191203102534.GK18865@dhcp-12-139.nay.redhat.com>
References: <20191202.184704.723174427717421022.davem@davemloft.net>
        <20191203101536.GJ18865@dhcp-12-139.nay.redhat.com>
        <20191203102534.GK18865@dhcp-12-139.nay.redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Dec 2019 11:58:19 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Tue, 3 Dec 2019 18:25:35 +0800

> 
> Hi David,
> On Tue, Dec 03, 2019 at 06:15:36PM +0800, Hangbin Liu wrote:
>> On Mon, Dec 02, 2019 at 06:47:04PM -0800, David Miller wrote:
>> > From: Hangbin Liu <liuhangbin@gmail.com>
>> > Date: Tue,  3 Dec 2019 10:11:37 +0800
>> > 
>> > > Fix it by removing the dst_confirm_neigh() in __ip6_rt_update_pmtu() as
>> > > there is no two-way communication during PMTU update.
>> > > 
>> > > v2: remove dst_confirm_neigh directly as David Miller pointed out.
>> > 
>> > That's not what I said.
>> > 
>> > I said that this interface is designed for situations where the neigh
>> > update is appropriate, and that's what happens for most callers _except_
>> > these tunnel cases.
>> > 
>> > The tunnel use is the exception and invoking the interface
>> > inappropriately.
>> > 
>> > It is important to keep the neigh reachability fresh for TCP flows so
>> > you cannot remove this dst_confirm_neigh() call.
> 
> I have one question here. Since we have the .confirm_neigh fuction in
> struct dst_ops. How about do a dst->ops->confirm_neigh() separately after
> dst->ops->update_pmtu()? Why should we mix the confirm_neigh() in
> update_pmtu(), like ip6_rt_update_pmtu()?

Two indirect calls which have high cost due to spectre mitigation?
