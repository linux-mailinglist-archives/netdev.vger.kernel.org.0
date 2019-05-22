Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E76E25FA7
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 10:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbfEVIhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 04:37:37 -0400
Received: from www62.your-server.de ([213.133.104.62]:45058 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728609AbfEVIhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 04:37:36 -0400
Received: from [78.46.172.3] (helo=sslproxy06.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTMkR-0004Uo-If; Wed, 22 May 2019 10:37:19 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hTMkR-000LEU-B8; Wed, 22 May 2019 10:37:19 +0200
Subject: Re: tc_classid access in skb bpf context
To:     Matthew Cover <matthew.cover@stackpath.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Matthew Cover <werekraken@gmail.com>
References: <BYAPR10MB2680B63C684345098E6E7669E3070@BYAPR10MB2680.namprd10.prod.outlook.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <73d5b951-2598-0d7f-5b6e-8925cc61989a@iogearbox.net>
Date:   Wed, 22 May 2019 10:37:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <BYAPR10MB2680B63C684345098E6E7669E3070@BYAPR10MB2680.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25456/Tue May 21 09:56:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22/2019 01:52 AM, Matthew Cover wrote:
> __sk_buff has a member tc_classid which I'm interested in accessing from the skb bpf context.
> 
> A bpf program which accesses skb->tc_classid compiles, but fails verification; the specific failure is "invalid bpf_context access".
> 
> if (skb->tc_classid != 0)
>  return 1;
> return 0;
> 
> Some of the tests in tools/testing/selftests/bpf/verifier/ (those on tc_classid) further confirm that this is, in all likelihood, intentional behavior.
> 
> The very similar bpf program which instead accesses skb->mark works as desired.
> 
> if (skb->mark != 0)
>  return 1;
> return 0;

You should be able to access skb->tc_classid, perhaps you're using the wrong program
type? BPF_PROG_TYPE_SCHED_CLS is supposed to work (if not we'd have a regression).

> I built a kernel (v5.1) with 4 instances of the following line removed from net/core/filter.c to test the behavior when the instructions pass verification.
> 
>     switch (off) {
> -    case bpf_ctx_range(struct __sk_buff, tc_classid):
> ...
>         return false;
> 
> It appears skb->tc_classid is always zero within my bpf program, even when I verify by other means (e.g. netfilter) that the value is set non-zero.
> 
> I gather that sk_buff proper sometimes (i.e. at some layers) has qdisc_skb_cb stored in skb->cb, but not always.
> 
> I suspect that the tc_classid is available at l3 (and therefore to utils like netfilter, ip route, tc), but not at l2 (and not to AF_PACKET).

From tc/BPF context you can use it; it's been long time, but I think back then
we mapped it into cb[] so it can be used within the BPF context to pass skb data
around e.g. between tail calls, and cls_bpf_classify() when in direct-action mode
which likely everyone is/should-be using then maps that skb->tc_classid u16 cb[]
value to res->classid on program return which then in either sch_handle_ingress()
or sch_handle_egress() is transferred into the skb->tc_index.

> Is it impractical to make skb->tc_classid available in this bpf context or is there just some plumbing which hasn't been connected yet?
> 
> Is my suspicion that skb->cb no longer contains qdisc_skb_cb due to crossing a layer boundary well founded?
> 
> I'm willing to look into hooking things together as time permits if it's a feasible task.
> 
> It's trivial to have iptables match on tc_classid and set a mark which is available to bpf at l2, but I'd like to better understand this.
> 
> Thanks,
> Matt C.
> 

