Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DA81CE5FE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgEKUtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729517AbgEKUtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:49:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4DDC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 13:49:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 79673120477C4;
        Mon, 11 May 2020 13:49:39 -0700 (PDT)
Date:   Mon, 11 May 2020 13:49:38 -0700 (PDT)
Message-Id: <20200511.134938.651986318503897703.davem@davemloft.net>
To:     David.Laight@ACULAB.COM
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net/ipv4/raw Optimise ipv4 raw sends when
 IP_HDRINCL set.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6d52098964b54d848cbfd1957f093bd8@AcuMS.aculab.com>
References: <6d52098964b54d848cbfd1957f093bd8@AcuMS.aculab.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 May 2020 13:49:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Sun, 10 May 2020 16:00:41 +0000

> The final routing for ipv4 packets may be done with the IP address
> from the message header not that from the address buffer.
> If the addresses are different FLOWI_FLAG_KNOWN_NH must be set so
> that a temporary 'struct rtable' entry is created to send the message.
> However the allocate + free (under RCU) is relatively expensive
> and can be avoided by a quick check shows the addresses match.
> 
> Signed-off-by: David Laight <david.laight@aculab.com>

The user can change the daddr field in userspace between when you do
this test and when the iphdr is copied into the sk_buff.

Also, you are obfuscating what you are doing in the way you have coded
this check.  You extract 4 bytes from a magic offset (16), which is
hard to understand.

Just explicitly code out the fact that you are accessing the daddr
field of an ip header.

But nonetheless you have to solve the "modified in userspace
meanwhile" problem, as this is a bug we fix often in the kernel so we
don't want to add new instances.

Thanks.
