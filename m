Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37DDF4D952F
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345374AbiCOHZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345370AbiCOHZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:25:45 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12384AE3D;
        Tue, 15 Mar 2022 00:24:32 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KHlHW6qlhzfYrn;
        Tue, 15 Mar 2022 15:23:03 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 15:24:30 +0800
Subject: Re: [PATCH bpf-next] bpf, sockmap: Manual deletion of sockmap
 elements in user mode is not allowed
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <ast@kernel.org>, <john.fastabend@gmail.com>,
        <daniel@iogearbox.net>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <kafai@fb.com>, <dsahern@kernel.org>,
        <kuba@kernel.org>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
References: <20220314124432.3050394-1-wangyufen@huawei.com>
 <87sfrky2bt.fsf@cloudflare.com>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <ff9d0ecf-315b-00a3-8140-424714b204ff@huawei.com>
Date:   Tue, 15 Mar 2022 15:24:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87sfrky2bt.fsf@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/14 23:30, Jakub Sitnicki 写道:
> On Mon, Mar 14, 2022 at 08:44 PM +08, Wang Yufen wrote:
>> A tcp socket in a sockmap. If user invokes bpf_map_delete_elem to delete
>> the sockmap element, the tcp socket will switch to use the TCP protocol
>> stack to send and receive packets. The switching process may cause some
>> issues, such as if some msgs exist in the ingress queue and are cleared
>> by sk_psock_drop(), the packets are lost, and the tcp data is abnormal.
>>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
> Can you please tell us a bit more about the life-cycle of the socket in
> your workload? Questions that come to mind:
>
> 1) What triggers the removal of the socket from sockmap in your case?
We use sk_msg to redirect with sock hash, like this:

  skA   redirect    skB
  Tx <-----------> skB,Rx

And construct a scenario where the packet sending speed is high, the
packet receiving speed is slow, so the packets are stacked in the ingress
queue on the receiving side. In this case, if run bpf_map_delete_elem() to
delete the sockmap entry, will trigger the following procedure:

sock_hash_delete_elem()
   sock_map_unref()
     sk_psock_put()
       sk_psock_drop()
         sk_psock_stop()
           __sk_psock_zap_ingress()
             __sk_psock_purge_ingress_msg()

> 2) Would it still be a problem if removal from sockmap did not cause any
> packets to get dropped?
Yes, it still be a problem. If removal from sockmap  did not cause any
packets to get dropped, packet receiving process switches to use TCP
protocol stack. The packets in the psock ingress queue cannot be received

by the user.


Thanks.

>
> [...]
> .
