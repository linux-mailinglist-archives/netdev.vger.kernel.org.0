Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1971136C0
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 21:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfLDUvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 15:51:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36442 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbfLDUvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 15:51:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3211B14D9599A;
        Wed,  4 Dec 2019 12:51:36 -0800 (PST)
Date:   Wed, 04 Dec 2019 12:51:35 -0800 (PST)
Message-Id: <20191204.125135.750458923752225025.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     jakub.kicinski@netronome.com, vvidic@valentin-vidic.from.hr,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/tls: Fix return values for setsockopt
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CA+FuTSdhtGZtTnuncpYaoOROF7L=coGawCPSLv7jzos2Q+Tb=Q@mail.gmail.com>
References: <CA+FuTSdcDW1oJU=BK-rifxm1n4kh0tkj0qQQfOGSoUOkkBKrFg@mail.gmail.com>
        <20191204113544.2d537bf7@cakuba.netronome.com>
        <CA+FuTSdhtGZtTnuncpYaoOROF7L=coGawCPSLv7jzos2Q+Tb=Q@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 12:51:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 4 Dec 2019 15:43:00 -0500

> On Wed, Dec 4, 2019 at 2:36 PM Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
>>
>> (there is a v2, in case you missed)
> 
> Thanks. I meant to respond to your comment. (but should have done sooner :)
> 
>> On Wed, 4 Dec 2019 14:22:55 -0500, Willem de Bruijn wrote:
>> > On Tue, Dec 3, 2019 at 6:08 PM Jakub Kicinski wrote:
>> > > On Tue,  3 Dec 2019 23:44:58 +0100, Valentin Vidic wrote:
>> > > > ENOTSUPP is not available in userspace:
>> > > >
>> > > >   setsockopt failed, 524, Unknown error 524
>> > > >
>> > > > Signed-off-by: Valentin Vidic <vvidic@valentin-vidic.from.hr>
>> > >
>> > > I'm not 100% clear on whether we can change the return codes after they
>> > > had been exposed to user space for numerous releases..
>> >
>> > This has also come up in the context of SO_ZEROCOPY in the past. In my
>> > opinion the answer is no. A quick grep | wc -l in net/ shows 99
>> > matches for this error code. Only a fraction of those probably make it
>> > to userspace, but definitely more than this single case.
>> >
>> > If anything, it may be time to define it in uapi?
>>
>> No opinion but FWIW I'm toying with some CI for netdev, I've added a
>> check for use of ENOTSUPP, apparently checkpatch already sniffs out
>> uses of ENOSYS, so seems appropriate to add this one.
> 
> Good idea if not exposing this in UAPI.

I'm trying to understand this part of the discussion.

If we have been returning a non-valid error code, this 524 internal
kernel thing, it is _NOT_ an exposed UAPI.

It is a kernel bug and we should fix it.

If userspace anywhere is checking for 524, that is what needs to be fixed.

Do we agree on this point?
