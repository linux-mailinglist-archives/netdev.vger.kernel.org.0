Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06FF3214183
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 00:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgGCWYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 18:24:19 -0400
Received: from www62.your-server.de ([213.133.104.62]:38302 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbgGCWYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 18:24:18 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrU6T-00051w-4Q; Sat, 04 Jul 2020 00:24:17 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jrU6S-000LJu-Sg; Sat, 04 Jul 2020 00:24:16 +0200
Subject: Re: [PATCH v5 bpf-next 5/9] bpf: cpumap: add the possibility to
 attach an eBPF program to cpumap
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, brouer@redhat.com, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com
References: <cover.1593521029.git.lorenzo@kernel.org>
 <a6bb83a429f3b073e97f81ec3935b8ebe89fbd71.1593521030.git.lorenzo@kernel.org>
 <1f4af1f3-10cf-57ca-4171-11d3bff51c99@iogearbox.net>
 <20200703204810.GB1321275@localhost.localdomain>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4dcc1530-ffdf-30a5-9806-0b06cd0f12d6@iogearbox.net>
Date:   Sat, 4 Jul 2020 00:24:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200703204810.GB1321275@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25862/Fri Jul  3 15:56:19 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/3/20 10:48 PM, Lorenzo Bianconi wrote:
>> On 6/30/20 2:49 PM, Lorenzo Bianconi wrote:
>> [...]
> 
> [...]
> 
>>>    	old_rcpu = xchg(&cmap->cpu_map[key_cpu], rcpu);
>>>    	if (old_rcpu) {
>>> +		if (old_rcpu->prog)
>>> +			bpf_prog_put(old_rcpu->prog);
>>>    		call_rcu(&old_rcpu->rcu, __cpu_map_entry_free);
>>>    		INIT_WORK(&old_rcpu->kthread_stop_wq, cpu_map_kthread_stop);
>>>    		schedule_work(&old_rcpu->kthread_stop_wq);
>>
>> Hm, not quite sure I follow the logic here. Why is the bpf_prog_put() not placed inside
>> __cpu_map_entry_free(), for example? Wouldn't this at least leave a potential small race
>> window of UAF given the rest is still live? If we already piggy-back from RCU side on
>> rcpu entry, why not having it in __cpu_map_entry_free()?
> 
> ack right, thanks for spotting this issue. I guess we can even move
> "bpf_prog_put(rcpu->prog)" in put_cpu_map_entry() so the last consumer
> of bpf_cpu_map_entry will free the attached program. Agree?

Yes, that sounds reasonable to me.

Thanks,
Daniel
