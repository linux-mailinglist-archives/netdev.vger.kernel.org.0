Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B757027BB8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 13:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbfEWLZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 07:25:47 -0400
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35484 "EHLO
        tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730415AbfEWLZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 07:25:47 -0400
Received: from vc1.ecl.ntt.co.jp (vc1.ecl.ntt.co.jp [129.60.86.153])
        by tama500.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id x4NBPHq9030084;
        Thu, 23 May 2019 20:25:17 +0900
Received: from vc1.ecl.ntt.co.jp (localhost [127.0.0.1])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id C8841EA807E;
        Thu, 23 May 2019 20:25:17 +0900 (JST)
Received: from jcms-pop21.ecl.ntt.co.jp (jcms-pop21.ecl.ntt.co.jp [129.60.87.134])
        by vc1.ecl.ntt.co.jp (Postfix) with ESMTP id BD901EA807D;
        Thu, 23 May 2019 20:25:17 +0900 (JST)
Received: from [IPv6:::1] (eb8460w-makita.sic.ecl.ntt.co.jp [129.60.241.47])
        by jcms-pop21.ecl.ntt.co.jp (Postfix) with ESMTPSA id B2CBB4007AA;
        Thu, 23 May 2019 20:25:17 +0900 (JST)
Subject: Re: [PATCH bpf-next 1/3] xdp: Add bulk XDP_TX queue
References: <1558609008-2590-1-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <1558609008-2590-2-git-send-email-makita.toshiaki@lab.ntt.co.jp>
 <8736l52zon.fsf@toke.dk>
From:   Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>
Message-ID: <2ab04d02-634e-9420-9514-e4ede08bcb10@lab.ntt.co.jp>
Date:   Thu, 23 May 2019 20:24:46 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <8736l52zon.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CC-Mail-RelayStamp: 1
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
X-TM-AS-MML: disable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/05/23 20:11, Toke Høiland-Jørgensen wrote:
> Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp> writes:
> 
>> XDP_TX is similar to XDP_REDIRECT as it essentially redirects packets to
>> the device itself. XDP_REDIRECT has bulk transmit mechanism to avoid the
>> heavy cost of indirect call but it also reduces lock acquisition on the
>> destination device that needs locks like veth and tun.
>>
>> XDP_TX does not use indirect calls but drivers which require locks can
>> benefit from the bulk transmit for XDP_TX as well.
> 
> XDP_TX happens on the same device, so there's an implicit bulking
> happening because of the NAPI cycle. So why is an additional mechanism
> needed (in the general case)?

Not sure what the implicit bulking you mention is. XDP_TX calls
.ndo_xdp_xmit() for each packet, and it acquires a lock in veth and tun.
To avoid this, we need additional storage for bulking like devmap for
XDP_REDIRECT.

-- 
Toshiaki Makita

