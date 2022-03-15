Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811224D9FF2
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 17:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241701AbiCOQ0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 12:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235452AbiCOQ0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 12:26:42 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F7656C07;
        Tue, 15 Mar 2022 09:25:30 -0700 (PDT)
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nU9z1-0004dT-EN; Tue, 15 Mar 2022 17:25:15 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nU9z1-0002YV-31; Tue, 15 Mar 2022 17:25:15 +0100
Subject: Re: [PATCH bpf-next] bpf, sockmap: Manual deletion of sockmap
 elements in user mode is not allowed
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        wangyufen <wangyufen@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, lmb@cloudflare.com,
        davem@davemloft.net, kafai@fb.com, dsahern@kernel.org,
        kuba@kernel.org, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220314124432.3050394-1-wangyufen@huawei.com>
 <87sfrky2bt.fsf@cloudflare.com>
 <ff9d0ecf-315b-00a3-8140-424714b204ff@huawei.com>
 <87fsnjxvho.fsf@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <79281351-b412-2c54-265b-c0ddf537fae1@iogearbox.net>
Date:   Tue, 15 Mar 2022 17:25:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <87fsnjxvho.fsf@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26482/Tue Mar 15 09:26:17 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/15/22 1:12 PM, Jakub Sitnicki wrote:
> On Tue, Mar 15, 2022 at 03:24 PM +08, wangyufen wrote:
>> 在 2022/3/14 23:30, Jakub Sitnicki 写道:
>>> On Mon, Mar 14, 2022 at 08:44 PM +08, Wang Yufen wrote:
>>>> A tcp socket in a sockmap. If user invokes bpf_map_delete_elem to delete
>>>> the sockmap element, the tcp socket will switch to use the TCP protocol
>>>> stack to send and receive packets. The switching process may cause some
>>>> issues, such as if some msgs exist in the ingress queue and are cleared
>>>> by sk_psock_drop(), the packets are lost, and the tcp data is abnormal.
>>>>
>>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>>> ---
>>> Can you please tell us a bit more about the life-cycle of the socket in
>>> your workload? Questions that come to mind:
>>>
>>> 1) What triggers the removal of the socket from sockmap in your case?
>> We use sk_msg to redirect with sock hash, like this:
>>
>>   skA   redirect    skB
>>   Tx <-----------> skB,Rx
>>
>> And construct a scenario where the packet sending speed is high, the
>> packet receiving speed is slow, so the packets are stacked in the ingress
>> queue on the receiving side. In this case, if run bpf_map_delete_elem() to
>> delete the sockmap entry, will trigger the following procedure:
>>
>> sock_hash_delete_elem()
>>    sock_map_unref()
>>      sk_psock_put()
>>        sk_psock_drop()
>>          sk_psock_stop()
>>            __sk_psock_zap_ingress()
>>              __sk_psock_purge_ingress_msg()
>>
>>> 2) Would it still be a problem if removal from sockmap did not cause any
>>> packets to get dropped?
>> Yes, it still be a problem. If removal from sockmap  did not cause any
>> packets to get dropped, packet receiving process switches to use TCP
>> protocol stack. The packets in the psock ingress queue cannot be received
>>
>> by the user.
> 
> Thanks for the context. So, if I understand correctly, you want to avoid
> breaking the network pipe by updating the sockmap from user-space.
> 
> This sounds awfully similar to BPF_MAP_FREEZE. Have you considered that?

+1

Aside from that, the patch as-is also fails BPF CI in a lot of places, please
make sure to check selftests:

https://github.com/kernel-patches/bpf/runs/5537367301?check_suite_focus=true

   [...]
   #145/73 sockmap_listen/sockmap IPv6 test_udp_redir:OK
   #145/74 sockmap_listen/sockmap IPv6 test_udp_unix_redir:OK
   #145/75 sockmap_listen/sockmap Unix test_unix_redir:OK
   #145/76 sockmap_listen/sockmap Unix test_unix_redir:OK
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   #145/77 sockmap_listen/sockhash IPv4 TCP test_insert_invalid:FAIL
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   #145/78 sockmap_listen/sockhash IPv4 TCP test_insert_opened:FAIL
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   #145/79 sockmap_listen/sockhash IPv4 TCP test_insert_bound:FAIL
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   ./test_progs:test_ops_cleanup:1424: map_delete: expected EINVAL/ENOENT: Operation not supported
   test_ops_cleanup:FAIL:1424
   [...]

Thanks,
Daniel
