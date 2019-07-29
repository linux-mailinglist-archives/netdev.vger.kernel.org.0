Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E179AE9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388522AbfG2VRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:17:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39598 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387595AbfG2VRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 17:17:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 598CB148155BB;
        Mon, 29 Jul 2019 14:17:53 -0700 (PDT)
Date:   Mon, 29 Jul 2019 14:17:52 -0700 (PDT)
Message-Id: <20190729.141752.457438545178811941.davem@davemloft.net>
To:     suyj.fnst@cn.fujitsu.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net] net: ipv6: Fix a bug in ndisc_send_ns when netdev
 only has a global address
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564368591-42301-1-git-send-email-suyj.fnst@cn.fujitsu.com>
References: <1564368591-42301-1-git-send-email-suyj.fnst@cn.fujitsu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 14:17:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Date: Mon, 29 Jul 2019 10:49:51 +0800

> When we send mpls packets and the interface only has a
> manual global ipv6 address, then the two hosts cant communicate.
> I find that in ndisc_send_ns it only tries to get a ll address.
> In my case, the executive path is as below.
> ip6_output
>  ->ip6_finish_output
>   ->lwtunnel_xmit
>    ->mpls_xmit
>     ->neigh_resolve_output
>      ->neigh_probe
>       ->ndisc_solicit
>        ->ndisc_send_ns
> 
> In RFC4861, 7.2.2 says
> "If the source address of the packet prompting the solicitation is the
> same as one of the addresses assigned to the outgoing interface, that
> address SHOULD be placed in the IP Source Address of the outgoing
> solicitation.  Otherwise, any one of the addresses assigned to the
> interface should be used."
> 
> In this patch we try get a global address if we get ll address failed.
> 
> Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>

David, can you take a quick look at this?

Thank you.
