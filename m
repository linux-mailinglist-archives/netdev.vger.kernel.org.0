Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CB522B695
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 21:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgGWTNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 15:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgGWTNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 15:13:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793FDC0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 12:13:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1051F139D8D2B;
        Thu, 23 Jul 2020 11:57:01 -0700 (PDT)
Date:   Thu, 23 Jul 2020 12:13:45 -0700 (PDT)
Message-Id: <20200723.121345.1943051054532406842.davem@davemloft.net>
To:     sundeep.lkml@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sgoutham@marvell.com,
        sbhatta@marvell.com
Subject: Re: [PATCH net 0/3] Fix bugs in Octeontx2 netdev driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CALHRZupy+YDXjK6VsAJhat0d8+0Wv+SB2p4dFRPVA69+ypC1=Q@mail.gmail.com>
References: <20200721.161728.1020067920131361017.davem@davemloft.net>
        <CALHRZuofbFnE8E-wpdosvKP6m3Ygp=jjcHz9QUn=R3gUbyNmsg@mail.gmail.com>
        <CALHRZupy+YDXjK6VsAJhat0d8+0Wv+SB2p4dFRPVA69+ypC1=Q@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 11:57:01 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: sundeep subbaraya <sundeep.lkml@gmail.com>
Date: Thu, 23 Jul 2020 20:29:03 +0530

> Hi David,
> 
> On Wed, Jul 22, 2020 at 7:34 PM sundeep subbaraya
> <sundeep.lkml@gmail.com> wrote:
>>
>> Hi David,
>>
>> On Wed, Jul 22, 2020 at 4:47 AM David Miller <davem@davemloft.net> wrote:
>> >
>> > From: sundeep.lkml@gmail.com
>> > Date: Tue, 21 Jul 2020 22:44:05 +0530
>> >
>> > > Subbaraya Sundeep (3):
>> > >   octeontx2-pf: Fix reset_task bugs
>> > >   octeontx2-pf: cancel reset_task work
>> > >   octeontx2-pf: Unregister netdev at driver remove
>> >
>> > I think you should shut down all the interrupts and other state
>> > before unregistering the vf network device.
>>
>> Okay will change it and send v2.
>>
> 
> For our case interrupts need to be ON when unregister_netdev is called.
> If driver remove is called when the interface is up then
> otx2_stop(called by unregister_netdev)
> needs mailbox interrupts to communicate with PF to release its resources.

If you leave interrupts on then an interrupt can arrive after the software
state has been released by unregister_netdev.

Sounds like you need to resolve this some other way.
