Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72F918E651
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 10:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbfHOI2v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 04:28:51 -0400
Received: from mga03.intel.com ([134.134.136.65]:28172 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfHOI2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 04:28:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 01:28:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,388,1559545200"; 
   d="scan'208";a="167686584"
Received: from rrranjan-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.35.248])
  by orsmga007.jf.intel.com with ESMTP; 15 Aug 2019 01:28:47 -0700
Subject: Re: [PATCH bpf-next v4 1/2] xsk: remove AF_XDP socket from map when
 the socket is released
To:     Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Bruce Richardson <bruce.richardson@intel.com>,
        Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>
References: <20190802081154.30962-1-bjorn.topel@gmail.com>
 <20190802081154.30962-2-bjorn.topel@gmail.com>
 <5ad56a5e-a189-3f56-c85c-24b6c300efd9@iogearbox.net>
 <CAJ+HfNhO+xSs25aPat9WjC75W6_Kgfq=GU+YCEcoZw-GCjZdEg@mail.gmail.com>
 <5ce25e5b-a07a-31d8-4141-c6bd250bba0e@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <d4f4722b-d2bf-298c-b49f-6a2117b1c688@intel.com>
Date:   Thu, 15 Aug 2019 10:28:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <5ce25e5b-a07a-31d8-4141-c6bd250bba0e@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-08-15 01:17, Daniel Borkmann wrote:
> Seems reasonable to me, and inc as opposed to inc_not_zero is also fine
> here since at this point in time we're still holding one reference to
> the map.

Ok, good.

> But I think there's a catch with the current code that still
> needs fixing:
> 
> Imagine you do a xsk_map_update_elem() where we have a situation where
> xs == old_xs. There, we first do the xsk_map_sock_add() to add the new
> xsk map node at the tail of the socket's xs->map_list. We do the xchg()
> and then xsk_map_sock_delete() for old_xs which then walks xs->map_list
> again and purges all entries including the just newly created one. This
> means we'll end up with an xs socket at the given map slot, but the xs
> socket has empty xs->map_list. This means we could release the xs sock
> and the xsk_delete_from_maps() won't need to clean up anything anymore
> but yet the xs is still in the map slot, so if you redirect to that
> socket, it would be use-after-free, no?

Ah, correct. Checking against self-assignment, or doing the delete prior 
add. I'll spin a v5.

...and again, thanks for detailed review, Daniel!


Björn
