Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01383679348
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 09:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjAXIlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 03:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjAXIlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 03:41:10 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6E22A3A840;
        Tue, 24 Jan 2023 00:41:07 -0800 (PST)
Date:   Tue, 24 Jan 2023 09:41:03 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ozsh@nvidia.com, marcelo.leitner@gmail.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v3 4/7] netfilter: flowtable: allow updating
 offloaded rules asynchronously
Message-ID: <Y8+Zny8S9BQm7asq@salvia>
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <20230119195104.3371966-5-vladbu@nvidia.com>
 <Y8p96knLDtxnRtjz@salvia>
 <871qnke7ga.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <871qnke7ga.fsf@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vlad,

On Tue, Jan 24, 2023 at 09:06:13AM +0200, Vlad Buslov wrote:
> 
> On Fri 20 Jan 2023 at 12:41, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Vlad,
> >
> > On Thu, Jan 19, 2023 at 08:51:01PM +0100, Vlad Buslov wrote:
> >> Following patches in series need to update flowtable rule several times
> >> during its lifetime in order to synchronize hardware offload with actual ct
> >> status. However, reusing existing 'refresh' logic in act_ct would cause
> >> data path to potentially schedule significant amount of spurious tasks in
> >> 'add' workqueue since it is executed per-packet. Instead, introduce a new
> >> flow 'update' flag and use it to schedule async flow refresh in flowtable
> >> gc which will only be executed once per gc iteration.
> >
> > So the idea is to use a NF_FLOW_HW_UPDATE which triggers the update
> > from the garbage collector. I understand the motivation here is to
> > avoid adding more work to the workqueue, by simply letting the gc
> > thread pick up for the update.
> >
> > I already proposed in the last year alternative approaches to improve
> > the workqueue logic, including cancelation of useless work. For
> > example, cancel a flying "add" work if "delete" just arrive and the
> > work is still sitting in the queue. Same approach could be use for
> > this update logic, ie. cancel an add UDP unidirectional or upgrade it
> > to bidirectional if, by the time we see traffic in both directions,
> > then work is still sitting in the queue.
> 
> Thanks for the suggestion. I'll try to make this work over regular
> workqueues without further extending the flow flags and/or putting more
> stuff into gc.

Let me make a second pass to sort out thoughts on this.

Either we use regular workqueues (without new flags) or we explore
fully consolidating this hardware offload workqueue infrastructure
around flags, ie. use flags not only for update events, but also for
new and delete.

This would go more in the direction of your _UPDATE flag idea:

- Update the hardware offload workqueue to iterate over the
  flowtable. The hardware offload workqueue would be "scanning" for
  entries in the flowtable that require some sort of update in the
  hardware. The flags would tell what kind of action is needed.

- Add these flags:

NF_FLOW_HW_NEW
NF_FLOW_HW_UPDATE
NF_FLOW_HW_DELETE

and remove the work object (flow_offload_work) and the existing list.
If the workqueue finds an entry with:

NEW|DELETE, this means this is short lived flow, not worth to waste
cycles to offload it.
NEW|UPDATE, this means this is an UDP flow that is bidirectional.

Then, there will be no more work allocation + "flying" work objects to
the hardware offload workqueue. Instead, the hardware offload
workqueue will be iterating.

This approach would need _DONE flags to annotate if the offload
updates have been applied to hardware already (similar to the
conntrack _DONE flags).

(Oh well, this proposal is adding even more flags. But I think flags
are not the issue, but the mixture of the existing flow_offload_work
approach with this new _UPDATE flag and the gc changes).

If flow_offload_work is removed, we would also need to add a:

 struct nf_flowtable *flowtable;

field to the flow_offload entry, which is an entry field that is
passed via flow_offload_work. So it is one extra field for the each
flow_offload entry.

The other alternative is to use the existing nf_flow_offload_add_wq
with UPDATE command, which might result in more flying objects in
turn. I think this is what you are trying to avoid with the _UPDATE
flag approach.

Thanks.
