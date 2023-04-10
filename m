Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882BB6DC23C
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 02:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbjDJA6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 20:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDJA61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 20:58:27 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4A835AD;
        Sun,  9 Apr 2023 17:58:24 -0700 (PDT)
Received: from canpemm500006.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Pvr970HMGznbQf;
        Mon, 10 Apr 2023 08:54:51 +0800 (CST)
Received: from [10.174.179.200] (10.174.179.200) by
 canpemm500006.china.huawei.com (7.192.105.130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 10 Apr 2023 08:58:22 +0800
Subject: Re: [PATCH net] net: qrtr: Fix an uninit variable access bug in
 qrtr_tx_resume()
To:     Manivannan Sadhasivam <mani@kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <andersson@kernel.org>, <luca@z3ntu.xyz>,
        <linux-arm-msm@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230403075417.2244203-1-william.xuanziyang@huawei.com>
 <20230408083528.GA11124@thinkpad>
From:   "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Message-ID: <bf012f37-57b8-4d66-9222-5b86e86393cd@huawei.com>
Date:   Mon, 10 Apr 2023 08:58:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20230408083528.GA11124@thinkpad>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.200]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500006.china.huawei.com (7.192.105.130)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Apr 03, 2023 at 03:54:17PM +0800, Ziyang Xuan wrote:
>> Syzbot reported a bug as following:
>>
>> =====================================================
>> BUG: KMSAN: uninit-value in qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>>  qrtr_tx_resume+0x185/0x1f0 net/qrtr/af_qrtr.c:230
>>  qrtr_endpoint_post+0xf85/0x11b0 net/qrtr/af_qrtr.c:519
>>  qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
>>  call_write_iter include/linux/fs.h:2189 [inline]
>>  aio_write+0x63a/0x950 fs/aio.c:1600
>>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>>  __do_sys_io_submit fs/aio.c:2078 [inline]
>>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> Uninit was created at:
>>  slab_post_alloc_hook mm/slab.h:766 [inline]
>>  slab_alloc_node mm/slub.c:3452 [inline]
>>  __kmem_cache_alloc_node+0x71f/0xce0 mm/slub.c:3491
>>  __do_kmalloc_node mm/slab_common.c:967 [inline]
>>  __kmalloc_node_track_caller+0x114/0x3b0 mm/slab_common.c:988
>>  kmalloc_reserve net/core/skbuff.c:492 [inline]
>>  __alloc_skb+0x3af/0x8f0 net/core/skbuff.c:565
>>  __netdev_alloc_skb+0x120/0x7d0 net/core/skbuff.c:630
>>  qrtr_endpoint_post+0xbd/0x11b0 net/qrtr/af_qrtr.c:446
>>  qrtr_tun_write_iter+0x270/0x400 net/qrtr/tun.c:108
>>  call_write_iter include/linux/fs.h:2189 [inline]
>>  aio_write+0x63a/0x950 fs/aio.c:1600
>>  io_submit_one+0x1d1c/0x3bf0 fs/aio.c:2019
>>  __do_sys_io_submit fs/aio.c:2078 [inline]
>>  __se_sys_io_submit+0x293/0x770 fs/aio.c:2048
>>  __x64_sys_io_submit+0x92/0xd0 fs/aio.c:2048
>>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>  do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
>>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> It is because that skb->len requires at least sizeof(struct qrtr_ctrl_pkt)
>> in qrtr_tx_resume(). And skb->len equals to size in qrtr_endpoint_post().
>> But size is less than sizeof(struct qrtr_ctrl_pkt) when qrtr_cb->type
>> equals to QRTR_TYPE_RESUME_TX in qrtr_endpoint_post() under the syzbot
>> scenario. This triggers the uninit variable access bug.
>>
>> Add size check when qrtr_cb->type equals to QRTR_TYPE_RESUME_TX in
>> qrtr_endpoint_post() to fix the bug.
>>
>> Fixes: 5fdeb0d372ab ("net: qrtr: Implement outgoing flow control")
>> Reported-by: syzbot+4436c9630a45820fda76@syzkaller.appspotmail.com
>> Link: https://syzkaller.appspot.com/bug?id=c14607f0963d27d5a3d5f4c8639b500909e43540
>> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> Looks good to me. But I have a small suggestion below.
> 
>> ---
>>  net/qrtr/af_qrtr.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
>> index 3a70255c8d02..631e81a8a368 100644
>> --- a/net/qrtr/af_qrtr.c
>> +++ b/net/qrtr/af_qrtr.c
>> @@ -498,6 +498,10 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
>>  	if (!size || len != ALIGN(size, 4) + hdrlen)
>>  		goto err;
>>  
>> +	if (cb->type == QRTR_TYPE_RESUME_TX &&
>> +	    size < sizeof(struct qrtr_ctrl_pkt))
> 
> There is already a check for QRTR_TYPE_NEW_SERVER below. So you can combine both:
> 
> 	if ((cb->type == QRTR_TYPE_NEW_SERVER ||
> 	     cb->type == QRTR_TYPE_RESUME_TX)
> 	     && size < sizeof(struct qrtr_ctrl_pkt))
> 		goto err;
> 
> - Mani
That's good. Thank you for your suggestion!

v2 will be sent.

William Xuan
> 
>> +		goto err;
>> +
>>  	if (cb->dst_port != QRTR_PORT_CTRL && cb->type != QRTR_TYPE_DATA &&
>>  	    cb->type != QRTR_TYPE_RESUME_TX)
>>  		goto err;
>> -- 
>> 2.25.1
>>
> 
