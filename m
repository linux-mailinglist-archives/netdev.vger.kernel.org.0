Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31CF2214B1
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGOStO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:49:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:59886 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbgGOStO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:49:14 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvmSu-0005rT-Bq; Wed, 15 Jul 2020 20:49:12 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jvmSu-000SBH-4s; Wed, 15 Jul 2020 20:49:12 +0200
Subject: Re: [PATCH net-next v3 2/4] net/sched: Introduce action hash
To:     Ariel Levkovich <lariel@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
References: <20200711212848.20914-1-lariel@mellanox.com>
 <20200711212848.20914-3-lariel@mellanox.com>
 <CAM_iQpXy-_qVUangkd-V8V_shLRMjRNUpJkrWTZ=xv3sYzzaKQ@mail.gmail.com>
 <b4099188-cd5d-cbca-001b-3b0e4b2bb98a@mellanox.com>
 <CAM_iQpWfwOLKufZ4sJk9BP-BMcynmt327WRdNRC5vrGQ=7sT1g@mail.gmail.com>
 <2cfac051-e2fc-e751-72e3-237aa20e7278@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c0d53867-4efa-fb45-b77e-af5dbc019bfc@iogearbox.net>
Date:   Wed, 15 Jul 2020 20:49:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2cfac051-e2fc-e751-72e3-237aa20e7278@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25874/Wed Jul 15 16:18:08 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 3:30 PM, Ariel Levkovich wrote:
> On 7/15/20 2:12 AM, Cong Wang wrote:
>> On Mon, Jul 13, 2020 at 8:17 PM Ariel Levkovich <lariel@mellanox.com> wrote:
>>> On 7/13/20 6:04 PM, Cong Wang wrote:
>>>> On Sat, Jul 11, 2020 at 2:28 PM Ariel Levkovich <lariel@mellanox.com> wrote:
>>>>> Allow user to set a packet's hash value using a bpf program.
>>>>>
>>>>> The user provided BPF program is required to compute and return
>>>>> a hash value for the packet which is then stored in skb->hash.
>>>> Can be done by act_bpf, right?
>>> Right. We already agreed on that.
>>>
>>> Nevertheless, as I mentioned, act_bpf is not offloadable.
>>>
>>> Device driver has no clue what the program does.
>> What about offloading act_skbedit? You care about offloading
>> the skb->hash computation, not about bpf.
>>
>> Thanks.
> 
> That's true but act_skedit provides (according to the current design) hash
> 
> computation using a kernel implemented algorithm.
> 
> HW not necessarily can offload this kernel based jhash function and therefore
> 
> we introduce the bpf option. With bpf the user can provide an implemenation
> 
> of a hash function that the HW can actually offload and that way user
> 
> maintains consistency between SW hash calculation and HW.
> 
> For example, in cases where offload is added dynamically as traffic flows, like
> 
> in the OVS case, first packets will go to SW and hash will be calculated on them
> 
> using bpf that emulates the HW hash so that this packet will get the same hash
> 
> result that it will later get in HW when the flow is offloaded.
> 
> 
> If there's a strong objection to adding a new action,
> 
> IMO, we can include the bpf option in act_skbedit - action skbedit hash bpf <bpf.o>
> 
> What do u think?

Please don't. From a BPF pov this is all very misleading since it might wrongly suggest
to the user that existing means aka {cls,act}_bpf in tc are not capable of already doing
this. They are capable for several years already though. Also, it is very confusing that
act_hash or 'skbedit hash bpf' can do everything that {cls,act}_bpf can do already, so
much beyond setting a hash value (e.g. you could set tunnel keys etc from there). Given
act_hash is only about offloading but nothing else, did you consider for the BPF alternative
to just use plain old classic BPF given you only need to parse the pkt and calc the hash
val but nothing more?
