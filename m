Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9C56C960A
	for <lists+netdev@lfdr.de>; Sun, 26 Mar 2023 17:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbjCZPNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 11:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjCZPNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 11:13:23 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9CD618B;
        Sun, 26 Mar 2023 08:13:21 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aeddf.dynamic.kabel-deutschland.de [95.90.237.223])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C672561CC457B;
        Sun, 26 Mar 2023 17:13:19 +0200 (CEST)
Message-ID: <ab07879f-6ae0-0c75-7ab4-c1765f89a55c@molgen.mpg.de>
Date:   Sun, 26 Mar 2023 17:13:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Intel-wired-lan] [PATCH net v3] ixgbe: Panic during XDP_TX with
 > 64 CPUs
Content-Language: en-US
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     John Hickey <jjh@daedalian.us>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20230308220756.587317-1-jjh@daedalian.us>
 <ddbae662-96d6-8779-eb8a-5a375e97ec22@molgen.mpg.de>
 <f586237d-66be-8968-d980-f911b83d11ca@molgen.mpg.de>
In-Reply-To: <f586237d-66be-8968-d980-f911b83d11ca@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cc: Remove undeliverable <lishujin@kuaishou.com>]

Am 26.03.23 um 17:10 schrieb Paul Menzel:
> [Cc: Remove undeliverable <xingwanli@kuaishou.com>]
> 
> Am 26.03.23 um 17:03 schrieb Paul Menzel:
>> Dear John,
>>
>>
>> Thank you for your patch.
>>
>> I’d recommend, to use a statement in the git commit message/summary by 
>> adding a verb (in imperative mood). Maybe:
>>
>> Fix panic during XDP_TX with > 64 CPUs
>>
>> Am 08.03.23 um 23:07 schrieb John Hickey:
>>> In commit 'ixgbe: let the xdpdrv work with more than 64 cpus'
>>> (4fe815850bdc), support was added to allow XDP programs to run on 
>>> systems
>>
>> I think it’s more common to write it like:
>>
>> In commit 4fe815850bdc (ixgbe: let the xdpdrv work with more than 64 
>> cpus) …
>>
>> Even shorter
>>
>> Commit 4fe815850bdc (ixgbe: let the xdpdrv work with more than 64 
>> cpus) adds support to allow XDP programs …
>>
>>> with more than 64 CPUs by locking the XDP TX rings and indexing them
>>> using cpu % 64 (IXGBE_MAX_XDP_QS).
>>>
>>> Upon trying this out patch via the Intel 5.18.6 out of tree driver
>>
>> Upon trying this patch out via …
>>
>>> on a system with more than 64 cores, the kernel paniced with an
>>> array-index-out-of-bounds at the return in ixgbe_determine_xdp_ring in
>>> ixgbe.h, which means ixgbe_determine_xdp_q_idx was just returning the
>>> cpu instead of cpu % IXGBE_MAX_XDP_QS.  An example splat:
>>
>> Please add, that you have UBSAN  enabled, or does it happen without?
>>
>>>
>>> ==========================================================================
>>>   UBSAN: array-index-out-of-bounds in
>>>   /var/lib/dkms/ixgbe/5.18.6+focal-1/build/src/ixgbe.h:1147:26
>>>   index 65 is out of range for type 'ixgbe_ring *[64]'
>>> ==========================================================================
>>>   BUG: kernel NULL pointer dereference, address: 0000000000000058
>>>   #PF: supervisor read access in kernel mode
>>>   #PF: error_code(0x0000) - not-present page
>>>   PGD 0 P4D 0
>>>   Oops: 0000 [#1] SMP NOPTI
>>>   CPU: 65 PID: 408 Comm: ksoftirqd/65
>>>   Tainted: G          IOE     5.15.0-48-generic #54~20.04.1-Ubuntu
>>>   Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 2.5.4 01/13/2020
>>>   RIP: 0010:ixgbe_xmit_xdp_ring+0x1b/0x1c0 [ixgbe]
>>>   Code: 3b 52 d4 cf e9 42 f2 ff ff 66 0f 1f 44 00 00 0f 1f 44 00 00 55 b9
>>>   00 00 00 00 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 <44> 0f b7
>>>   47 58 0f b7 47 5a 0f b7 57 54 44 0f b7 76 08 66 41 39 c0
>>
>> If you do not it yet, `scripts/decode_stacktrace.sh` helps decoding 
>> these traces.
>>
>>>   RSP: 0018:ffffbc3fcd88fcb0 EFLAGS: 00010282
>>>   RAX: ffff92a253260980 RBX: ffffbc3fe68b00a0 RCX: 0000000000000000
>>>   RDX: ffff928b5f659000 RSI: ffff928b5f659000 RDI: 0000000000000000
>>>   RBP: ffffbc3fcd88fce0 R08: ffff92b9dfc20580 R09: 0000000000000001
>>>   R10: 3d3d3d3d3d3d3d3d R11: 3d3d3d3d3d3d3d3d R12: 0000000000000000
>>>   R13: ffff928b2f0fa8c0 R14: ffff928b9be20050 R15: 000000000000003c
>>>   FS:  0000000000000000(0000) GS:ffff92b9dfc00000(0000)
>>>   knlGS:0000000000000000
>>>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>   CR2: 0000000000000058 CR3: 000000011dd6a002 CR4: 00000000007706e0
>>>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>>>   PKRU: 55555554
>>>   Call Trace:
>>>    <TASK>
>>>    ixgbe_poll+0x103e/0x1280 [ixgbe]
>>>    ? sched_clock_cpu+0x12/0xe0
>>>    __napi_poll+0x30/0x160
>>>    net_rx_action+0x11c/0x270
>>>    __do_softirq+0xda/0x2ee
>>>    run_ksoftirqd+0x2f/0x50
>>>    smpboot_thread_fn+0xb7/0x150
>>>    ? sort_range+0x30/0x30
>>>    kthread+0x127/0x150
>>>    ? set_kthread_struct+0x50/0x50
>>>    ret_from_fork+0x1f/0x30
>>>    </TASK>
>>>
>>> I think this is how it happens:
>>>
>>> Upon loading the first XDP program on a system with more than 64 CPUs,
>>> ixgbe_xdp_locking_key is incremented in ixgbe_xdp_setup.  However,
>>> immediately after this, the rings are reconfigured by ixgbe_setup_tc.
>>> ixgbe_setup_tc calls ixgbe_clear_interrupt_scheme which calls
>>> ixgbe_free_q_vectors which calls ixgbe_free_q_vector in a loop.
>>> ixgbe_free_q_vector decrements ixgbe_xdp_locking_key once per call if
>>> it is non-zero.  Commenting out the decrement in ixgbe_free_q_vector
>>> stopped my system from panicing.
>>>
>>> I suspect to make the original patch work, I would need to load an XDP
>>> program and then replace it in order to get ixgbe_xdp_locking_key back
>>> above 0 since ixgbe_setup_tc is only called when transitioning between
>>> XDP and non-XDP ring configurations, while ixgbe_xdp_locking_key is
>>> incremented every time ixgbe_xdp_setup is called.
>>>
>>> Also, ixgbe_setup_tc can be called via ethtool --set-channels, so this
>>> becomes another path to decrement ixgbe_xdp_locking_key to 0 on systems
>>> with greater than 64 CPUs.
>>
>> … with more than 64 CPUs.
>>
>>> For this patch, I have changed static_branch_inc to static_branch_enable
>>> in ixgbe_setup_xdp.  We weren't counting references.  The
>>> ixgbe_xdp_locking_key only protects code in the XDP_TX path, which is
>>> not run when an XDP program is loaded.  The other condition for setting
>>> it on is the number of CPUs, which I assume is static.
>>>
>>> Fixes: 4fe815850bdc ("ixgbe: let the xdpdrv work with more than 64 cpus")
>>> Signed-off-by: John Hickey <jjh@daedalian.us>
>>> ---
>>> v1 -> v2:
>>>     Added Fixes and net tag.  No code changes.
>>> v2 -> v3:
>>>     Added splat.  Slight clarification as to why ixgbe_xdp_locking_key
>>>     is not turned off.  Based on feedback from Maciej Fijalkowski.
>>> ---
>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 3 ---
>>>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
>>>   2 files changed, 1 insertion(+), 4 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c 
>>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>>> index f8156fe4b1dc..0ee943db3dc9 100644
>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
>>> @@ -1035,9 +1035,6 @@ static void ixgbe_free_q_vector(struct 
>>> ixgbe_adapter *adapter, int v_idx)
>>>       adapter->q_vector[v_idx] = NULL;
>>>       __netif_napi_del(&q_vector->napi);
>>> -    if (static_key_enabled(&ixgbe_xdp_locking_key))
>>> -        static_branch_dec(&ixgbe_xdp_locking_key);
>>> -
>>>       /*
>>>        * after a call to __netif_napi_del() napi may still be used and
>>>        * ixgbe_get_stats64() might access the rings on this vector,
>>> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c 
>>> b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> index ab8370c413f3..cd2fb72c67be 100644
>>> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
>>> @@ -10283,7 +10283,7 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
>>>       if (nr_cpu_ids > IXGBE_MAX_XDP_QS * 2)
>>>           return -ENOMEM;
>>>       else if (nr_cpu_ids > IXGBE_MAX_XDP_QS)
>>> -        static_branch_inc(&ixgbe_xdp_locking_key);
>>> +        static_branch_enable(&ixgbe_xdp_locking_key);
>>>       old_prog = xchg(&adapter->xdp_prog, prog);
>>>       need_reset = (!!prog != !!old_prog);
>>
>>
>> Kind regards,
>>
>> Paul
