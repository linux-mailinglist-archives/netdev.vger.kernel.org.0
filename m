Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE8A348384
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbhCXVVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbhCXVUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:20:47 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105FCC06174A;
        Wed, 24 Mar 2021 14:20:47 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id dc12so130954qvb.4;
        Wed, 24 Mar 2021 14:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dOmdT6ipboTSZZCZryyZVzFwMznCKbrrIEej1XKASws=;
        b=f4h+ronCdtBAJxdbXGkzZnGPitTp0XMNhYw/afJ7oNvPzZmgX906r9hghpNtwkqY2C
         SrXG2uvS8v4OjqgX7MU8dUKFjQNWQHKv9eIDGL9RmGVOf42l1cGHKTcB3FU0yhKnaGZH
         C7Zkmktx3+bEnVgU/5k2NU4ibcxOzw9il5lMfUcxslk9U0rZEN1dT0RwxZszSUxsN6YG
         DzCifxH6yaL+QeMFL1+DI4OrZLoO3Ad6TCFZlq9Q8cmxhylG1CadHtdr+mC8ylpn9la8
         AwvA8ZeCAtoGEipg4nGB+MEsMCpTArAlOMVAjBy/T8JveVNumgjW6AMn9oz77BsLZXQh
         8Aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dOmdT6ipboTSZZCZryyZVzFwMznCKbrrIEej1XKASws=;
        b=dIKGlUHcZh6aQBosWOuHCM2wCVZk+FMwlJ8p6spHoz4U4wpc9eBUjS0N7EFz2yvxNg
         ffkdoAydg6o5pIO6EdpkB3GF6v/SDsgfxgzjDKeFtAlXve5lDxcazc3YUUrdMkJslyie
         zqPHXrb+pvWYpEQulMrRPda52dWs3m1MQhwAW5ZfO0yeemBFWLY6k9ejikJL7P/5F4HW
         2rkkMgCvGSHDrJ2uoJXr4LwswRsE6eyu0F4GYn7fzr0Qnk/tYvDZE98H1CP/Dn9wRXtj
         gb+J+c2u4P7HuclwJunS1NUB12tfS1PzGt+ngOM66T8fHQEANPsM9aK4XHWBsvbr/5/f
         073A==
X-Gm-Message-State: AOAM5321BH+1o4+ej3xBeGP0383YSA7o5vXzgPvOLogOuIH2LcsksAHJ
        uMXxSIbsLfmajn1xroBOMC8=
X-Google-Smtp-Source: ABdhPJx6WupHON7mVcH1JHkCfrN2B3xlj8zDjgZ3h0B0qLpNqYjjav6hiFur/b5Dr9Rkd+kpblETCw==
X-Received: by 2002:ad4:5887:: with SMTP id dz7mr5426798qvb.12.1616620846253;
        Wed, 24 Mar 2021 14:20:46 -0700 (PDT)
Received: from horizon.localdomain ([2001:1284:f013:162c:584e:5081:a7ea:f835])
        by smtp.gmail.com with ESMTPSA id i6sm2602324qkf.96.2021.03.24.14.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:20:45 -0700 (PDT)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 3BB49C0784; Wed, 24 Mar 2021 18:20:43 -0300 (-03)
Date:   Wed, 24 Mar 2021 18:20:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: separate replace, destroy
 and stats to different workqueues
Message-ID: <YFutK3Mn+h5OWNXe@horizon.localdomain>
References: <20210303125953.11911-1-ozsh@nvidia.com>
 <20210303161147.GA17082@salvia>
 <YFjdb7DveNOolSTr@horizon.localdomain>
 <20210324013810.GA5861@salvia>
 <6173dd63-7769-e4a1-f796-889802b0a898@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6173dd63-7769-e4a1-f796-889802b0a898@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 01:24:53PM +0200, Oz Shlomo wrote:
> Hi,

Hi,

> 
> On 3/24/2021 3:38 AM, Pablo Neira Ayuso wrote:
> > Hi Marcelo,
> > 
> > On Mon, Mar 22, 2021 at 03:09:51PM -0300, Marcelo Ricardo Leitner wrote:
> > > On Wed, Mar 03, 2021 at 05:11:47PM +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > > Or probably make the cookie unique is sufficient? The cookie refers to
> > > > the memory address but memory can be recycled very quickly. If the
> > > > cookie helps to catch the reorder scenario, then the conntrack id
> > > > could be used instead of the memory address as cookie.
> > > 
> > > Something like this, if I got the idea right, would be even better. If
> > > the entry actually expired before it had a chance of being offloaded,
> > > there is no point in offloading it to then just remove it.
> > 
> > It would be interesting to explore this idea you describe. Maybe a
> > flag can be set on stale objects, or simply remove the stale object
> > from the offload queue. So I guess it should be possible to recover
> > control on the list of pending requests as a batch that is passed
> > through one single queue_work call.
> > 
> 
> Removing stale objects is a good optimization for cases when the rate of
> established connections is greater than the hardware offload insertion rate.
> However, with a single workqueue design, a burst of del commands may postpone connection offload tasks.
> Postponed offloads may cause additional packets to go through software, thus
> creating a chain effect which may diminish the system's connection rate.

Right. I didn't intend to object to multiqueues. I'm sorry if it
sounded that way.

> 
> Marcelo, AFAIU add/del are synchronized by design since the del is triggered by the gc thread.
> A del workqueue item will be instantiated only after a connection is in hardware.

They were synchronized, but after this patch, not anymore AFAICT:

tcf_ct_flow_table_add()
  flow_offload_add()
              if (nf_flowtable_hw_offload(flow_table)) {
                  __set_bit(NF_FLOW_HW, &flow->flags);    [A]
                  nf_flow_offload_add(flow_table, flow);
                           ^--- schedules on _add workqueue

then the gc thread:
nf_flow_offload_gc_step()
          if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct))
                  set_bit(NF_FLOW_TEARDOWN, &flow->flags);

          if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
	                   ^-- can also set by tcf_ct_flow_table_lookup()
			       on fin's, by calling flow_offload_teardown()
                  if (test_bit(NF_FLOW_HW, &flow->flags)) {
                                    ^--- this is set in [A], even if the _add is still queued
                          if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
                                  nf_flow_offload_del(flow_table, flow);

nf_flow_offload_del()
          offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_DESTROY);
          if (!offload)
                  return;

          set_bit(NF_FLOW_HW_DYING, &flow->flags);
          flow_offload_queue_work(offload);

NF_FLOW_HW_DYING only avoids a double _del here.

Maybe I'm just missing it but I'm not seeing how removals would only
happen after the entry is actually offloaded. As in, if the add queue
is very long, and the datapath see a FIN, seems the next gc iteration
could try to remove it before it's actually offloaded. I think this is
what Pablo meant on his original reply here too, then his idea on
having add/del to work with the same queue.
