Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A289C2804CC
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 19:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733005AbgJARMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 13:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732702AbgJARMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 13:12:08 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FC7C0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 10:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OzFH5UeUg3kW3MHpRXjmcIo5ZeriLPFjzjSR2F6jAPA=; b=FY/zJ6Miwfkx+XGD7bI76fa2Hu
        4CQiPJY2NAj5PXWdZPtSuVWVVz1qaXXU+5l1y+cYEJELkDVaJIuncL64yr586wsWOuu7nk5kwdNYe
        Mju00o0lTA9mbDw1LwL/N+P9LPAXj4V4kSGc7DIhcYU4OAGBTdbLdBgU5gKDcP32Twfk=;
Received: from p4ff134da.dip0.t-ipconnect.de ([79.241.52.218] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kO27W-00031B-WD; Thu, 01 Oct 2020 19:11:55 +0200
Subject: Re: [PATCH net-next 5/5] net: improve napi threaded config
To:     Wei Wang <weiwan@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20200930192140.4192859-1-weiwan@google.com>
 <20200930192140.4192859-6-weiwan@google.com>
 <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name>
 <CAEA6p_AsJuGb3C2MmWNDQYaZQtcCQc2CHdqcSPiH9i9NmPZMdQ@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <e9fdabda-72b1-fabd-8522-38965a62744c@nbd.name>
Date:   Thu, 1 Oct 2020 19:11:54 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CAEA6p_AsJuGb3C2MmWNDQYaZQtcCQc2CHdqcSPiH9i9NmPZMdQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-01 19:01, Wei Wang wrote:
> On Thu, Oct 1, 2020 at 3:01 AM Felix Fietkau <nbd@nbd.name> wrote:
>>
>>
>> On 2020-09-30 21:21, Wei Wang wrote:
>> > This commit mainly addresses the threaded config to make the switch
>> > between softirq based and kthread based NAPI processing not require
>> > a device down/up.
>> > It also moves the kthread_create() call to the sysfs handler when user
>> > tries to enable "threaded" on napi, and properly handles the
>> > kthread_create() failure. This is because certain drivers do not have
>> > the napi created and linked to the dev when dev_open() is called. So
>> > the previous implementation does not work properly there.
>> >
>> > Signed-off-by: Wei Wang <weiwan@google.com>
>> > ---
>> > Changes since RFC:
>> > changed the thread name to napi/<dev>-<napi-id>
>> >
>> >  net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
>> >  net/core/net-sysfs.c |  9 +++-----
>> >  2 files changed, 31 insertions(+), 27 deletions(-)
>> >
>> > diff --git a/net/core/dev.c b/net/core/dev.c
>> > index b4f33e442b5e..bf878d3a9d89 100644
>> > --- a/net/core/dev.c
>> > +++ b/net/core/dev.c
>> > @@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
>> >
>> >  static int napi_threaded_poll(void *data);
>> >
>> > -static void napi_thread_start(struct napi_struct *n)
>> > +static int napi_kthread_create(struct napi_struct *n)
>> >  {
>> > -     if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
>> > -             n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
>> > -                                        n->dev->name, n->napi_id);
>> > +     int err = 0;
>> > +
>> > +     n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
>> > +                                n->dev->name, n->napi_id);
>> > +     if (IS_ERR(n->thread)) {
>> > +             err = PTR_ERR(n->thread);
>> > +             pr_err("kthread_create failed with err %d\n", err);
>> > +             n->thread = NULL;
>> > +     }
>> > +
>> > +     return err;
>> If I remember correctly, using kthread_create with no explicit first
>> wakeup means the task will sit there and contribute to system loadavg
>> until it is woken up the first time.
>> Shouldn't we use kthread_run here instead?
>>
> 
> Right. kthread_create() basically creates the thread and leaves it in
> sleep mode. I think that is what we want. We rely on the next
> ___napi_schedule() call to wake up this thread when there is work to
> do.
But what if you have a device that's basically idle and napi isn't
scheduled until much later? It will get a confusing loadavg until then.
I'd prefer waking up the thread immediately and filtering going back to
sleep once in the thread function before running the loop if
NAPI_STATE_SCHED wasn't set.

- Felix
