Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04395661D5
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 05:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231983AbiGED06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 23:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiGED06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 23:26:58 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D5B65E4;
        Mon,  4 Jul 2022 20:26:56 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LcShZ4qxYz1L8ph;
        Tue,  5 Jul 2022 11:24:30 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 5 Jul 2022 11:26:54 +0800
Subject: Re: [PATCH] net: tls: fix tls with sk_redirect using a BPF verdict.
To:     Jakub Kicinski <kuba@kernel.org>,
        Julien Salleyron <julien.salleyron@gmail.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        Marc Vertes <mvertes@free.fr>
References: <20220628152505.298790-1-julien.salleyron@gmail.com>
 <20220628103424.5330e046@kernel.org>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <062f5ac8-0533-bf29-d51c-b9390ad06d78@huawei.com>
Date:   Tue, 5 Jul 2022 11:26:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20220628103424.5330e046@kernel.org>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, 28 Jun 2022 17:25:05 +0200 Julien Salleyron wrote:
>> This patch allows to use KTLS on a socket where we apply sk_redirect using a BPF
>> verdict program.
>>
>> Without this patch, we see that the data received after the redirection are
>> decrypted but with an incorrect offset and length. It seems to us that the
>> offset and length are correct in the stream-parser data, but finally not applied
>> in the skb. We have simply applied those values to the skb.
>>
>> In the case of regular sockets, we saw a big performance improvement from
>> applying redirect. This is not the case now with KTLS, may be related to the
>> following point.
> 
> It's because kTLS does a very expensive reallocation and copy for the
> non-zerocopy case (which currently means all of TLS 1.3). I have
> code almost ready to fix that (just needs to be reshuffled into
> upstreamable patches). Brings us up from 5.9 Gbps to 8.4 Gbps per CPU
> on my test box with 16k records. Probably much more than that with
> smaller records.
> 
>> It is still necessary to perform a read operation (never triggered) from user
>> space despite the redirection. It makes no sense, since this read operation is
>> not necessary on regular sockets without KTLS.
>>
>> We do not see how to fix this problem without a change of architecture, for
>> example by performing TLS decrypt directly inside the BPF verdict program.
>>
>> An example program can be found at
>> https://github.com/juliens/ktls-bpf_redirect-example/
>>
>> Co-authored-by: Marc Vertes <mvertes@free.fr>
>> ---
>>  net/tls/tls_sw.c                           | 6 ++++++
>>  tools/testing/selftests/bpf/test_sockmap.c | 8 +++-----
>>  2 files changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
>> index 0513f82b8537..a409f8a251db 100644
>> --- a/net/tls/tls_sw.c
>> +++ b/net/tls/tls_sw.c
>> @@ -1839,8 +1839,14 @@ int tls_sw_recvmsg(struct sock *sk,
>>  			if (bpf_strp_enabled) {
>>  				/* BPF may try to queue the skb */
>>  				__skb_unlink(skb, &ctx->rx_list);
>> +
>>  				err = sk_psock_tls_strp_read(psock, skb);
>> +
>>  				if (err != __SK_PASS) {
>> +                    if (err == __SK_REDIRECT) {
>> +                        skb->data += rxm->offset;
>> +                        skb->len = rxm->full_len;
>> +                    }
> 

Read the code with the following ktls + ebpf redirect model,
we may find the problem for the above modfication.

sk_psock_tls_strp_read()
->sk_psock_tls_verdict_apply()
  ->sk_psock_skb_redirect()
    ->skb_queue_tail() // add skb to ingress_skb queue
      schedule_work() [ sk_psock_backlog ] // sk_psock_tls_strp_read return

Walk through sk_psock->ingress_skb queue in sk_psock_backlog(),
after sk_psock_handle_skb(), it will kfree_skb() if not ingress.
So I think the above modfication has race problem about skb.
And I backport the above modfication to linux-5.10 as following:

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1882,6 +1882,10 @@ int tls_sw_recvmsg(struct sock *sk,
                        if (bpf_strp_enabled) {
                                err = sk_psock_tls_strp_read(psock, skb);
                                if (err != __SK_PASS) {
+                                       if (err == __SK_REDIRECT) {
+                                               skb->data += rxm->offset;
+                                               skb->len = rxm->full_len;
+                                       }
                                        rxm->offset = rxm->offset + rxm->full_len;

Run the following ktls + ebpf redirect model, occur system panic.

ktls       ktls
sender     proxy_recv         proxy_send        recv
 |            |                                  |
 |          verdict ---------------+             |
 |            |    redirect_egress |             |
 +------------+                    +-------------+

Call trace as following. It's may be not the race problem about skb,
but the above modfication is not OK for the ktls + ebpf redirect model.

[  816.687852] BUG: unable to handle page fault for address: ffff8f057ffdf000
[  816.687998] Oops: 0000 [#1] SMP PTI
[  816.688025] CPU: 2 PID: 619 Comm: kworker/2:3 Kdump: loaded Not tainted 5.10.0-ktls+ #4
[  816.688122] Workqueue: events sk_psock_backlog
[  816.688152] RIP: 0010:memcpy_erms+0x6/0x10
[  816.688263] RSP: 0018:ffff9c60c01cfc58 EFLAGS: 00010286
[  816.688292] RAX: ffff8f054f880000 RBX: 0000000000008000 RCX: 00000000000044bb
[  816.688330] RDX: 0000000000008000 RSI: ffff8f057ffdf000 RDI: ffff8f054f883b45
[  816.688376] RBP: 0000000000008000 R08: 0000000000000001 R09: 0000000000000000
[  816.688412] R10: 0000000000000001 R11: ffff9c60c01cfdd0 R12: ffff9c60c01cfdd0
[  816.688447] R13: ffff8f054f880000 R14: ffff9c60c01cfdb0 R15: 0000000000008000
[  816.688480] FS:  0000000000000000(0000) GS:ffff8f0775d00000(0000) knlGS:0000000000000000
[  816.688524] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  816.688564] CR2: ffff8f057ffdf000 CR3: 0000000120b16005 CR4: 0000000000370ee0
[  816.688600] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  816.688631] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  816.688661] Call Trace:
[  816.688681]  _copy_from_iter_full+0x1ee/0x270
[  816.688725]  tcp_sendmsg_locked+0x5aa/0xdc0
[  816.688749]  tcp_sendmsg+0x28/0x40
[  816.688769]  sock_sendmsg+0x57/0x60
[  816.688790]  ? sendmsg_unlocked+0x20/0x20
[  816.688811]  __skb_send_sock+0x29b/0x2f0
[  816.688847]  ? linear_to_page+0xf0/0xf0
[  816.688868]  sk_psock_backlog+0x85/0x1d0
[  816.688890]  process_one_work+0x1b0/0x350
[  816.688911]  worker_thread+0x49/0x300


In addition, I'm trying to explain performance degradation for the
ktls + ebpf redirect model compare to the following general proxy
model using TLS 1.3 (which are all using non-zerocopy), even though
ktls + ebpf redirect model reduce two cross-kernel data copies.
Now I find a memcpy_erms hot spot for _copy_from_iter_full() in
tcp_sendmsg_locked  within redirect_egress process. I suspect that
copy efficiency for the kvec is not good. But this just my guess, I
need to verify.

ktls           ktls
sender         proxy_recv proxy_send      recv
 |                |           |           |
 +----------------+           +-----------+

If you have some ideas, hope you can give me some advice.

Thand you!

> IDK what this is trying to do but I certainly depends on the fact 
> we run skb_cow_data() and is not "generally correct" :S
> .
> 
