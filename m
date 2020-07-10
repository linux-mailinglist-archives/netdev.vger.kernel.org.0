Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835BA21B8BA
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 16:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgGJOci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 10:32:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:45970 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJOch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 10:32:37 -0400
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtu4q-0003f1-4H; Fri, 10 Jul 2020 16:32:36 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jtu4p-000Ezt-TD; Fri, 10 Jul 2020 16:32:35 +0200
Subject: Re: [PATCHv6 bpf-next 2/3] sample/bpf: add xdp_redirect_map_multicast
 test
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <20200701041938.862200-1-liuhangbin@gmail.com>
 <20200709013008.3900892-1-liuhangbin@gmail.com>
 <20200709013008.3900892-3-liuhangbin@gmail.com>
 <6170ec86-9cce-a5ec-bd14-7aa56cee951e@iogearbox.net>
 <20200710064145.GA2531@dhcp-12-153.nay.redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f244bae1-25a8-58f7-9368-70c765ea5aae@iogearbox.net>
Date:   Fri, 10 Jul 2020 16:32:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200710064145.GA2531@dhcp-12-153.nay.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25868/Thu Jul  9 15:58:00 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/10/20 8:41 AM, Hangbin Liu wrote:
> On Fri, Jul 10, 2020 at 12:40:11AM +0200, Daniel Borkmann wrote:
>>> +SEC("xdp_redirect_map_multi")
>>> +int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
>>> +{
>>> +	long *value;
>>> +	u32 key = 0;
>>> +
>>> +	/* count packet in global counter */
>>> +	value = bpf_map_lookup_elem(&rxcnt, &key);
>>> +	if (value)
>>> +		*value += 1;
>>> +
>>> +	return bpf_redirect_map_multi(&forward_map, &null_map,
>>> +				      BPF_F_EXCLUDE_INGRESS);
>>
>> Why not extending to allow use-case like ...
>>
>>    return bpf_redirect_map_multi(&fwd_map, NULL, BPF_F_EXCLUDE_INGRESS);
>>
>> ... instead of requiring a dummy/'null' map?
> 
> I planed to let user set NULL, but the arg2_type is ARG_CONST_MAP_PTR, which
> not allow NULL pointer.

Right, but then why not adding a new type ARG_CONST_MAP_PTR_OR_NULL ?
