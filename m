Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D2F25DDEF
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726331AbgIDPja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:39:30 -0400
Received: from mga04.intel.com ([192.55.52.120]:47125 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgIDPjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 11:39:23 -0400
IronPort-SDR: J540pS9ZcsTnRpga7v/0KLOqjrr+8AKqS2QONwvy7r12gluoQv6yKo192yHEGtyI6SxHQGtvrG
 L9HZPF2oSbTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="155163339"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="155163339"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 08:39:21 -0700
IronPort-SDR: t7x+QaKHtSufFhQd3YkwT+8LxVHUo4SRfHkBSEypptvX6xzHyNfDK00MbUn0O5gqnyu9g8uG07
 CO0nJxWRQUrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,390,1592895600"; 
   d="scan'208";a="332198951"
Received: from andreyfe-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.37.82])
  by orsmga008.jf.intel.com with ESMTP; 04 Sep 2020 08:39:18 -0700
Subject: Re: [PATCH bpf-next 3/6] xsk: introduce xsk_do_redirect_rx_full()
 helper
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, intel-wired-lan@lists.osuosl.org
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
 <20200904135332.60259-4-bjorn.topel@gmail.com>
 <20200904171143.5868999a@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <dfa75afc-ceb7-76ce-6ba3-3b89c53f92f3@intel.com>
Date:   Fri, 4 Sep 2020 17:39:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904171143.5868999a@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 17:11, Jesper Dangaard Brouer wrote:
> On Fri,  4 Sep 2020 15:53:28 +0200 Björn Töpel
> <bjorn.topel@gmail.com> wrote:
> 
>> From: Björn Töpel <bjorn.topel@intel.com>
>> 
>> The xsk_do_redirect_rx_full() helper can be used to check if a
>> failure of xdp_do_redirect() was due to the AF_XDP socket had a
>> full Rx ring.
> 
> This is very AF_XDP specific.  I think that the cpumap could likely 
> benefit from similar approach? e.g. if the cpumap kthread is
> scheduled on the same CPU.
> 

At least I thought this was *very* AF_XDP specific, since the kernel is
dependent of that userland runs. Allocation (source) and Rx ring (sink).
Maybe I was wrong! :-)

The thing with AF_XDP zero-copy, is that we sort of assume that if a
user enabled that most packets will have XDP_REDIRECT to an AF_XDP socket.


> But for cpumap we only want this behavior if sched on the same CPU
> as RX-NAPI.  This could be "seen" by the cpumap code itself in the
> case bq_flush_to_queue() drops packets, check if rcpu->cpu equal 
> smp_processor_id().  Maybe I'm taking this too far?
> 

Interesting. So, if you're running on the same core, and redirect fail
for CPUMAP, you'd like to yield the NAPI loop? Is that really OK from a
fairness perspective? I mean, with AF_XDP zero-copy we pretty much know
that all actions will be redirect to socket. For CPUMAP type of
applications, can that assumption be made?


Björn

