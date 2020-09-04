Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A162725DBCB
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbgIDOdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:33:18 -0400
Received: from mga05.intel.com ([192.55.52.43]:13049 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730416AbgIDOdD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 10:33:03 -0400
IronPort-SDR: /s6PvvRowemCwoOJhRguF20WS5xxOX49f4y8V3ExaQIUh9lGVoz7YIDij1DJ0GlrR4ajOIoK7E
 nz83Fm+57h7A==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="242567070"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="242567070"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 07:33:02 -0700
IronPort-SDR: 0fQmUyCZwuWDeyZqTifDwD//sGCxUDtTpl0ayOdXn4hYYfPD01xG/YbSufAPCUvfyhHmrjAMqG
 zewbQoeohDWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="332178816"
Received: from andreyfe-mobl2.ccr.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.37.82])
  by orsmga008.jf.intel.com with ESMTP; 04 Sep 2020 07:32:58 -0700
Subject: Re: [PATCH bpf-next 0/6] xsk: exit NAPI loop when AF_XDP Rx ring is
 full
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, magnus.karlsson@intel.com,
        davem@davemloft.net, kuba@kernel.org, john.fastabend@gmail.com,
        intel-wired-lan@lists.osuosl.org
References: <20200904135332.60259-1-bjorn.topel@gmail.com>
 <20200904162751.632c4443@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <27e05518-99c6-15e2-b801-cbc0310630ef@intel.com>
Date:   Fri, 4 Sep 2020 16:32:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200904162751.632c4443@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-09-04 16:27, Jesper Dangaard Brouer wrote:
> On Fri,  4 Sep 2020 15:53:25 +0200
> Björn Töpel <bjorn.topel@gmail.com> wrote:
> 
>> On my machine the "one core scenario Rx drop" performance went from
>> ~65Kpps to 21Mpps. In other words, from "not usable" to
>> "usable". YMMV.
> 
> We have observed this kind of dropping off an edge before with softirq
> (when userspace process runs on same RX-CPU), but I thought that Eric
> Dumazet solved it in 4cd13c21b207 ("softirq: Let ksoftirqd do its job").
> 
> I wonder what makes AF_XDP different or if the problem have come back?
> 

I would say this is not the same issue. The problem is that the softirq 
is busy dropping packets since the AF_XDP Rx is full. So, the cycles 
*are* split 50/50, which is not what we want in this case. :-)

This issue is more of a "Intel AF_XDP ZC drivers does stupid work", than 
fairness. If the Rx ring is full, then there is really no use to let the 
NAPI loop continue.

Would you agree, or am I rambling? :-P


Björn
