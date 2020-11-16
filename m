Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1F2B45E4
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730179AbgKPObb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:31:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:25467 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729614AbgKPObb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 09:31:31 -0500
IronPort-SDR: 7WkET3B31E6scFgsZJF/xXo8HC3kyPLCYDFfdNfh8E7ic+4RghOCo9YZbpnzRqtGY+YS/dW9ik
 Hwm1OI8UsfoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9806"; a="157778516"
X-IronPort-AV: E=Sophos;i="5.77,482,1596524400"; 
   d="scan'208";a="157778516"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 06:31:29 -0800
IronPort-SDR: K+El57vBYgY5hP1q9UKFPgeoUch/f9q3VoR1XZukigW7fBy5imXpuuCprZOKjFffXpaEwBbTLh
 jarEOLfyJcYQ==
X-IronPort-AV: E=Sophos;i="5.77,482,1596524400"; 
   d="scan'208";a="543620406"
Received: from wrzedzic-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.34.230])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 06:31:25 -0800
Subject: Re: [PATCH] xsk: add cq event
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>, netdev@vger.kernel.org
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b18c1f2cfb0c9c0b409c25f4a73248e869c8ac97.1605513087.git.xuanzhuo@linux.alibaba.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <90c58756-934d-adf6-64e8-680cfc019cd4@intel.com>
Date:   Mon, 16 Nov 2020 15:31:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <b18c1f2cfb0c9c0b409c25f4a73248e869c8ac97.1605513087.git.xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-16 09:10, Xuan Zhuo wrote:
> When we write all cq items to tx, we have to wait for a new event based
> on poll to indicate that it is writable. But the current writability is
> triggered based on whether tx is full or not, and In fact, when tx is
> dissatisfied, the user of cq's item may not necessarily get it, because it
> may still be occupied by the network card. In this case, we need to know
> when cq is available, so this patch adds a socket option, When the user
> configures this option using setsockopt, when cq is available, a
> readable event is generated for all xsk bound to this umem.
> 
> I can't find a better description of this event,
> I think it can also be 'readable', although it is indeed different from
> the 'readable' of the new data. But the overhead of xsk checking whether
> cq or rx is readable is small.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Thanks for the patch!

I'm not a fan of having two different "readable" event (both Rx and cq).
Could you explain a bit what the use case is, so I get a better
understanding.

The Tx queues has a back-pressure mechanism, determined of the number of
elements in cq. Is it related to that?

Please explain a bit more what you're trying to solve, and maybe we can
figure out a better way forward!


Thanks!
Björn
