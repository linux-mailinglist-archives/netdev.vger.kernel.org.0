Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81FB05C767
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 04:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbfGBCjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 22:39:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54350 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfGBCjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 22:39:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2BBF314DECD2F;
        Mon,  1 Jul 2019 19:39:22 -0700 (PDT)
Date:   Mon, 01 Jul 2019 19:39:21 -0700 (PDT)
Message-Id: <20190701.193921.1287174101564488400.davem@davemloft.net>
To:     willy@infradead.org
Cc:     xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        dcaratti@redhat.com, chrism@mellanox.com
Subject: Re: [Patch net 0/3] idr: fix overflow cases on 32-bit CPU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190702023730.GA1729@bombadil.infradead.org>
References: <20190628180343.8230-1-xiyou.wangcong@gmail.com>
        <20190701.191600.1570499492484804858.davem@davemloft.net>
        <20190702023730.GA1729@bombadil.infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jul 2019 19:39:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 1 Jul 2019 19:37:30 -0700

> On Mon, Jul 01, 2019 at 07:16:00PM -0700, David Miller wrote:
>> From: Cong Wang <xiyou.wangcong@gmail.com>
>> Date: Fri, 28 Jun 2019 11:03:40 -0700
>> 
>> > idr_get_next_ul() is problematic by design, it can't handle
>> > the following overflow case well on 32-bit CPU:
>> > 
>> > u32 id = UINT_MAX;
>> > idr_alloc_u32(&id);
>> > while (idr_get_next_ul(&id) != NULL)
>> >  id++;
>> > 
>> > when 'id' overflows and becomes 0 after UINT_MAX, the loop
>> > goes infinite.
>> > 
>> > Fix this by eliminating external users of idr_get_next_ul()
>> > and migrating them to idr_for_each_entry_continue_ul(). And
>> > add an additional parameter for these iteration macros to detect
>> > overflow properly.
>> > 
>> > Please merge this through networking tree, as all the users
>> > are in networking subsystem.
>> 
>> Series applied, thanks Cong.
> 
> Ugh, I don't even get the weekend to reply?
> 
> I think this is just a bad idea.  It'd be better to apply the conversion
> patches to use XArray than fix up this crappy interface.  I didn't
> reply before because I wanted to check those patches still apply and
> post them as part of the response.  Now they're definitely broken and
> need to be redone.

Please work this out with Cong.

I think his approach is safe for net and thus -stable than an xarray
conversion.
