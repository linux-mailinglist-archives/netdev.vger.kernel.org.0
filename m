Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064CE5F6FBB
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 22:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiJFUuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 16:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbiJFUtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 16:49:31 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6ECC2CA7;
        Thu,  6 Oct 2022 13:49:14 -0700 (PDT)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogXnr-0002z3-Ld; Thu, 06 Oct 2022 22:49:11 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ogXnr-0002UP-8j; Thu, 06 Oct 2022 22:49:11 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20221004231143.19190-1-daniel@iogearbox.net>
 <20221004231143.19190-2-daniel@iogearbox.net>
 <CAM0EoM=i_zFMQ5YEtaaWyu-fSE7=wq2LmNTXnwDJoXcBJ9de6g@mail.gmail.com>
Message-ID: <aa8034e8-a64e-3587-1e1f-1d07c69edd98@iogearbox.net>
Date:   Thu, 6 Oct 2022 22:49:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM0EoM=i_zFMQ5YEtaaWyu-fSE7=wq2LmNTXnwDJoXcBJ9de6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26681/Thu Oct  6 09:58:02 2022)
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

On 10/5/22 9:04 PM, Jamal Hadi Salim wrote:
[...]
> Let me see if i can summarize the issue of ownership..
> It seems there were two users each with root access and one decided they want
> to be prio 1 and basically deleted the others programs and added
> themselves to the top?
> And of course both want to be prio 1. Am i correct? And this feature
> basically avoids
> this problem by virtue of fd ownership.

Yes and no ;) In the specific example I gave there was an application bug that
led to this race of one evicting the other, so it was not intentional and also
not triggered on all the nodes in the cluster, but aside from the example, the
issue is generic one for tc BPF users. Not fd ownership, but ownership of BPF
link solves this as it does similarly for other existing BPF infra which is one
of the motivations as outlined in patch 2 to align this for tc BPF, too.

> IIUC,  this is an issue of resource contention. Both users who have
> root access think they should be prio 1. Kubernetes has no controls for this?
> For debugging, wouldnt listening to netlink events have caught this?
> I may be misunderstanding - but if both users took advantage of this
> feature seems the root cause is still unresolved i.e  whoever gets there first
> becomes the owner of the highest prio?

This is independent of K8s core; system applications for observability, runtime
enforcement, networking, etc can be deployed as Pods via kube-system namespace into
the cluster and live in the host netns. These are typically developed independently
by different groups of people. So it all depends on the use cases these applications
solve, e.g. if you try to deploy two /main/ CNI plugins which both want to provide
cluster networking, it won't fly and this is also generally understood by cluster
operators, but there can be other applications also attaching to tc BPF for more
specialized functions (f.e. observing traffic flows, setting EDT tstamp for subsequent
fq, etc) and interoperability can be provided to a certain degree with prio settings &
unspec combo to continue the pipeline. Netlink events would at best only allow to
observe the rig being pulled from underneath us, but not prevent it compared to tc
BPF links, and given the rise of BPF projects we see in K8s space, it's becoming
more crucial to avoid accidental outage just from deploying a new Pod into a
running cluster given tc BPF layer becomes more occupied.

> Other comments on just this patch (I will pay attention in detail later):
> My two qualms:
> 1) Was bastardizing all things TC_ACT_XXX necessary?
> Maybe you could create #define somewhere visible which refers
> to the TC_ACT_XXX?

Optional as mentioned in the other thread. It was suggested having enums which
become visible via vmlinux BTF as opposed to defines, so my thought was to lower
barrier for new developers by making the naming and supported subset more obvious
similar/closer to XDP case. I didn't want to pull in new header, but I can move it
to pkt_cls.h.

> 2) Why is xtc_run before tc_run()?

It needs to be first in the list because its the only hook point that has an
'ownership' model in tc BPF layer. If its first we can unequivocally know its
owner and ensure its never skipped/bypassed/removed by another BPF program either
intentionally or due to users bugs/errors. If we put it after other hooks like cls_bpf
we loose the statement because those hooks might 'steal', remove, alter the skb before
the BPF link ones are executed. Other option is to make this completely flexible, to
the point that Stan made, that is, tcf_classify() is just callback from the array at
a fixed position and it's completely up to the user where to add from this layer,
but we went with former approach.

Thanks,
Daniel
