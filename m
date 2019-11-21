Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9B6105C2D
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfKUVoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:44:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54108 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfKUVoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:44:18 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C2E56150728B4;
        Thu, 21 Nov 2019 13:44:17 -0800 (PST)
Date:   Thu, 21 Nov 2019 13:44:14 -0800 (PST)
Message-Id: <20191121.134414.613685320791127696.davem@davemloft.net>
To:     john.fastabend@gmail.com
Cc:     alexei.starovoitov@gmail.com, netdev@vger.kernel.org,
        dan.carpenter@oracle.com, daniel@iogearbox.net
Subject: Re: [net PATCH] bpf: skmsg, fix potential psock NULL pointer
 dereference
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5dd6f32b2816_30202ae8b398a5b469@john-XPS-13-9370.notmuch>
References: <157435350971.16582.7099707189039358561.stgit@john-Precision-5820-Tower>
        <CAADnVQLX3U4uSASVeha54oZsgi6DhNuYSXyW6=uKuf=ijC5vdQ@mail.gmail.com>
        <5dd6f32b2816_30202ae8b398a5b469@john-XPS-13-9370.notmuch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 13:44:18 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>
Date: Thu, 21 Nov 2019 12:27:23 -0800

> Alexei Starovoitov wrote:
>> On Thu, Nov 21, 2019 at 8:28 AM John Fastabend <john.fastabend@gmail.com> wrote:
>> >
>> > Report from Dan Carpenter,
>> >
>> >  net/core/skmsg.c:792 sk_psock_write_space()
>> >  error: we previously assumed 'psock' could be null (see line 790)
>> >
>> >  net/core/skmsg.c
>> >    789 psock = sk_psock(sk);
>> >    790 if (likely(psock && sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)))
>> >  Check for NULL
>> >    791 schedule_work(&psock->work);
>> >    792 write_space = psock->saved_write_space;
>> >                      ^^^^^^^^^^^^^^^^^^^^^^^^
>> >    793          rcu_read_unlock();
>> >    794          write_space(sk);
>> >
>> > Ensure psock dereference on line 792 only occurs if psock is not null.
>> >
>> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
>> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>> 
>> lgtm.
>> John, do you feel strongly about it going to net tree asap?
>> Can it go to net-next ? The merge window is right around the corner.
> 
> Agree we can send it to net-next, its been in the kernel for multiple
> versions anyways.

Applied to net-next, thanks.
