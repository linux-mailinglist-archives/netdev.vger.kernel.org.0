Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4A1217AF9
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgGGW1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729289AbgGGW1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:27:16 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E815C061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:27:16 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 205A8120F19F2;
        Tue,  7 Jul 2020 15:27:16 -0700 (PDT)
Date:   Tue, 07 Jul 2020 15:27:15 -0700 (PDT)
Message-Id: <20200707.152715.2019375640902315638.davem@davemloft.net>
To:     sd@queasysnail.net
Cc:     netdev@vger.kernel.org, pwouters@redhat.com
Subject: Re: [PATCH net] ipv4: fill fl4_icmp_{type,code} in ping_v4_sendmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e14ad6ba2a92a44a8b146e57e8fcdb10fb906226.1593767365.git.sd@queasysnail.net>
References: <e14ad6ba2a92a44a8b146e57e8fcdb10fb906226.1593767365.git.sd@queasysnail.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jul 2020 15:27:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>
Date: Fri,  3 Jul 2020 17:00:32 +0200

> IPv4 ping sockets don't set fl4.fl4_icmp_{type,code}, which leads to
> incomplete IPsec ACQUIRE messages being sent to userspace. Currently,
> both raw sockets and IPv6 ping sockets set those fields.
> 
> Expected output of "ip xfrm monitor":
>     acquire proto esp
>       sel src 10.0.2.15/32 dst 8.8.8.8/32 proto icmp type 8 code 0 dev ens4
>       policy src 10.0.2.15/32 dst 8.8.8.8/32
>         <snip>
> 
> Currently with ping sockets:
>     acquire proto esp
>       sel src 10.0.2.15/32 dst 8.8.8.8/32 proto icmp type 0 code 0 dev ens4
>       policy src 10.0.2.15/32 dst 8.8.8.8/32
>         <snip>
> 
> The Libreswan test suite found this problem after Fedora changed the
> value for the sysctl net.ipv4.ping_group_range.
> 
> Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
> Reported-by: Paul Wouters <pwouters@redhat.com>
> Tested-by: Paul Wouters <pwouters@redhat.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied and queued up for -stable, thank you.
