Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DED31BCC78
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbgD1Tgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:36:43 -0400
Received: from www62.your-server.de ([213.133.104.62]:37982 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728474AbgD1Tgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 15:36:43 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTW21-0002pP-77; Tue, 28 Apr 2020 21:36:37 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jTW20-000Xle-Jv; Tue, 28 Apr 2020 21:36:36 +0200
Subject: Re: [PATCH net-next 29/33] xdp: allow bpf_xdp_adjust_tail() to grow
 packet size
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     sameehj@amazon.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        zorik@amazon.com, akiyano@amazon.com, gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
 <158757178840.1370371.13037637865133257416.stgit@firesoul>
 <940b8c06-b71f-f6b1-4832-4abc58027589@iogearbox.net>
 <20200428183743.19dee96e@carbon>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <7f6cd231-36f2-721c-4137-27b9da138ff2@iogearbox.net>
Date:   Tue, 28 Apr 2020 21:36:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200428183743.19dee96e@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25796/Tue Apr 28 14:00:48 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/28/20 6:37 PM, Jesper Dangaard Brouer wrote:
> On Mon, 27 Apr 2020 21:01:14 +0200
> Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 4/22/20 6:09 PM, Jesper Dangaard Brouer wrote:
>>> Finally, after all drivers have a frame size, allow BPF-helper
>>> bpf_xdp_adjust_tail() to grow or extend packet size at frame tail.
>>>
>>> Remember that helper/macro xdp_data_hard_end have reserved some
>>> tailroom.  Thus, this helper makes sure that the BPF-prog don't have
>>> access to this tailroom area.
>>>
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>> ---
>>>    include/uapi/linux/bpf.h |    4 ++--
>>>    net/core/filter.c        |   15 +++++++++++++--
>>>    2 files changed, 15 insertions(+), 4 deletions(-)
>>>
> [...]
>>> diff --git a/net/core/filter.c b/net/core/filter.c
>>> index 7d6ceaa54d21..5e9c387f74eb 100644
>>> --- a/net/core/filter.c
>>> +++ b/net/core/filter.c
>>> @@ -3422,12 +3422,23 @@ static const struct bpf_func_proto bpf_xdp_adjust_head_proto = {
>>>    
>>>    BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
>>>    {
>>> +	void *data_hard_end = xdp_data_hard_end(xdp);
>>>    	void *data_end = xdp->data_end + offset;
>>>    
>>> -	/* only shrinking is allowed for now. */
>>> -	if (unlikely(offset >= 0))
>>> +	/* Notice that xdp_data_hard_end have reserved some tailroom */
>>> +	if (unlikely(data_end > data_hard_end))
>>>    		return -EINVAL;
>>>    
>>> +	/* ALL drivers MUST init xdp->frame_sz, some chicken checks below */
>>> +	if (unlikely(xdp->frame_sz < (xdp->data_end - xdp->data_hard_start))) {
>>> +		WARN(1, "Too small xdp->frame_sz = %d\n", xdp->frame_sz);
>>> +		return -EINVAL;
>>> +	}
> 
> I will remove this "too small" check, as it is useless, given it will
> already get caught by above check.
> 
>>> +	if (unlikely(xdp->frame_sz > PAGE_SIZE)) {
>>> +		WARN(1, "Too BIG xdp->frame_sz = %d\n", xdp->frame_sz);
>>> +		return -EINVAL;
>>> +	}
>>
>> I don't think we can add the WARN()s here. If there is a bug in the
>> driver in this area and someone deploys an XDP-based application
>> (otherwise known to work well elsewhere) on top of this, then an
>> attacker can basically remote DoS the machine with malicious packets
>> that end up triggering these WARN()s over and over.
> 
> Good point.  I've changed this to WARN_ONCE(), but I'm still
> considering to remove it completely...
> 
>> If you are worried that not all your driver changes are correct,
>> maybe only add those that you were able to actually test yourself or
>> that have been acked, and otherwise pre-init the frame_sz to a known
>> invalid value so this helper would only allow shrinking for them in
>> here (as today)?
> 
> Hmm... no, I really want to require ALL drivers to set a valid value,
> because else we will have the "data_meta" feature situation, where a lot
> of drivers still doesn't support this.

Ok, makes sense, it's probably better that way. I do have a data_meta
series for a few more drivers to push out soon to make sure there's more
coverage as we're using it in Cilium.
