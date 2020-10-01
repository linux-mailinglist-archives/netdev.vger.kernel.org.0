Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508F92806C3
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 20:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbgJASiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 14:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732673AbgJASiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 14:38:03 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB900C0613E2
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 11:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gyTeLX6Y38Dedq2+Gxc/dfmLIit/k3gJ9EOqa9J6Cco=; b=PQ9YtEfaHnWOPa/wnWkLt/UIOe
        t2FRKiD3YuMGeM+mlIekkphQCu1dZrFTn8wdWA6pNyyj9gnomYyMroIGD7s6epxDxSgAX9JrsG/G4
        KYeBqD4uCvsuiXy/g2g4U1L/+t2OSLnSgIgxJXt4vwirXkNLksaJ5qE5A2Rjuzlv3rKo=;
Received: from p4ff134da.dip0.t-ipconnect.de ([79.241.52.218] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kO3Sb-0008OC-51; Thu, 01 Oct 2020 20:37:45 +0200
To:     Eric Dumazet <edumazet@google.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20200930192140.4192859-1-weiwan@google.com>
 <20200930192140.4192859-6-weiwan@google.com>
 <03d4edde-dce3-b263-39eb-d217f06936da@nbd.name>
 <CAEA6p_AsJuGb3C2MmWNDQYaZQtcCQc2CHdqcSPiH9i9NmPZMdQ@mail.gmail.com>
 <e9fdabda-72b1-fabd-8522-38965a62744c@nbd.name>
 <CANn89iL0dVFZ1QxMsJd4mT=idtb+AwLE4cFQy9DLzN0heUrqVQ@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH net-next 5/5] net: improve napi threaded config
Message-ID: <f1c7ed6f-ca02-1a1b-1489-1af05325832e@nbd.name>
Date:   Thu, 1 Oct 2020 20:37:44 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <CANn89iL0dVFZ1QxMsJd4mT=idtb+AwLE4cFQy9DLzN0heUrqVQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-10-01 20:03, Eric Dumazet wrote:
> On Thu, Oct 1, 2020 at 7:12 PM Felix Fietkau <nbd@nbd.name> wrote:
>>
>> On 2020-10-01 19:01, Wei Wang wrote:
>> > On Thu, Oct 1, 2020 at 3:01 AM Felix Fietkau <nbd@nbd.name> wrote:
>> >>
>> >>
>> >> On 2020-09-30 21:21, Wei Wang wrote:
>> >> > This commit mainly addresses the threaded config to make the switch
>> >> > between softirq based and kthread based NAPI processing not require
>> >> > a device down/up.
>> >> > It also moves the kthread_create() call to the sysfs handler when user
>> >> > tries to enable "threaded" on napi, and properly handles the
>> >> > kthread_create() failure. This is because certain drivers do not have
>> >> > the napi created and linked to the dev when dev_open() is called. So
>> >> > the previous implementation does not work properly there.
>> >> >
>> >> > Signed-off-by: Wei Wang <weiwan@google.com>
>> >> > ---
>> >> > Changes since RFC:
>> >> > changed the thread name to napi/<dev>-<napi-id>
>> >> >
>> >> >  net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
>> >> >  net/core/net-sysfs.c |  9 +++-----
>> >> >  2 files changed, 31 insertions(+), 27 deletions(-)
>> >> >
>> >> > diff --git a/net/core/dev.c b/net/core/dev.c
>> >> > index b4f33e442b5e..bf878d3a9d89 100644
>> >> > --- a/net/core/dev.c
>> >> > +++ b/net/core/dev.c
>> >> > @@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
>> >> >
>> >> >  static int napi_threaded_poll(void *data);
>> >> >
>> >> > -static void napi_thread_start(struct napi_struct *n)
>> >> > +static int napi_kthread_create(struct napi_struct *n)
>> >> >  {
>> >> > -     if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
>> >> > -             n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
>> >> > -                                        n->dev->name, n->napi_id);
>> >> > +     int err = 0;
>> >> > +
>> >> > +     n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
>> >> > +                                n->dev->name, n->napi_id);
>> >> > +     if (IS_ERR(n->thread)) {
>> >> > +             err = PTR_ERR(n->thread);
>> >> > +             pr_err("kthread_create failed with err %d\n", err);
>> >> > +             n->thread = NULL;
>> >> > +     }
>> >> > +
>> >> > +     return err;
>> >> If I remember correctly, using kthread_create with no explicit first
>> >> wakeup means the task will sit there and contribute to system loadavg
>> >> until it is woken up the first time.
>> >> Shouldn't we use kthread_run here instead?
>> >>
>> >
>> > Right. kthread_create() basically creates the thread and leaves it in
>> > sleep mode. I think that is what we want. We rely on the next
>> > ___napi_schedule() call to wake up this thread when there is work to
>> > do.
>> But what if you have a device that's basically idle and napi isn't
>> scheduled until much later? It will get a confusing loadavg until then.
>> I'd prefer waking up the thread immediately and filtering going back to
>> sleep once in the thread function before running the loop if
>> NAPI_STATE_SCHED wasn't set.
>>
> 
> I was not aware of this kthread_create() impact on loadavg.
> This seems like a bug to me. (although I do not care about loadavg)
> 
> Do you have pointers on some documentation ?
I don't have any specific documentation pointers, but this is something
I observed on several occasions when playing with kthreads.

From what I can find in the loadavg code it seems that tasks in
TASK_UNINTERRUPTIBLE state are counted for loadavg alongside actually
runnable tasks. This seems intentional to me, but I don't know why it
was made like this.

A kthread does not start the thread function until it has been woken up
at least once, most likely to give the creating code a chance to perform
some initializations after successfully creating the thread, before the
thread function starts doing something. Instead, kthread() sets
TASK_UNINTERRUPTIBLE and calls schedule() once.

> Probably not a big deal, but this seems quite odd to me.
I've run into enough users that look at loadavg as a measure of system
load and would likely start reporting bugs if they observe such
behavior. I'd like to avoid that.

- Felix
