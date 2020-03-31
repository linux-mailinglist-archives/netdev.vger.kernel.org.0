Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9224A198AB8
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 05:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgCaD5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 23:57:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12658 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727358AbgCaD5D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 23:57:03 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9325F2252625F8F9FCB5;
        Tue, 31 Mar 2020 11:57:01 +0800 (CST)
Received: from [127.0.0.1] (10.173.223.60) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Tue, 31 Mar 2020
 11:56:58 +0800
Subject: Re: [PATCH net] veth: xdp: use head instead of hard_start
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
CC:     <davem@davemloft.net>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kuba@kernel.org>, <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <andriin@fb.com>, <jwi@linux.ibm.com>, <jianglidong3@jd.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20200330102631.31286-1-maowenan@huawei.com>
 <20200330133442.132bde0c@carbon>
 <3053de4c-cee6-f6fc-efc2-09c6250f3ef2@gmail.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <e7cf1271-2953-a5aa-ab25-c4b4a3843ee1@huawei.com>
Date:   Tue, 31 Mar 2020 11:56:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3053de4c-cee6-f6fc-efc2-09c6250f3ef2@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.223.60]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/3/31 7:35, Toshiaki Makita wrote:
> Hi Mao & Jesper
> (Resending with plain text...)
> 
> On 2020/03/30 20:34, Jesper Dangaard Brouer wrote:
>> On Mon, 30 Mar 2020 18:26:31 +0800
>> Mao Wenan <maowenan@huawei.com> wrote:
>>
>>> xdp.data_hard_start is mapped to the first
>>> address of xdp_frame, but the pointer hard_start
>>> is the offset(sizeof(struct xdp_frame)) of xdp_frame,
>>> it should use head instead of hard_start to
>>> set xdp.data_hard_start. Otherwise, if BPF program
>>> calls helper_function such as bpf_xdp_adjust_head, it
>>> will be confused for xdp_frame_end.
>>
>> I have noticed this[1] and have a patch in my current patchset for
>> fixing this.  IMHO is is not so important fix right now, as the effect
>> is that you currently only lose 32 bytes of headroom.
>>
I consider that it is needed because bpf_xdp_adjust_head() just a common helper function,
veth as one driver application should keep the same as 32 bytes of headroom as other driver.
And convert_to_xdp_frame set() also store info in top of packet, and set:
	xdp_frame = xdp->data_hard_start;

>> [1] https://lore.kernel.org/netdev/158446621887.702578.17234304084556809684.stgit@firesoul/
> 
> You are right, the subtraction is not necessary here.
I guess you mean that previous subtraction is not necessary ? this line : void *head = hard_start - sizeof(struct xdp_frame); ?
But in the veth_xdp_rcv_one,below line will use head pointer,
case XDP_TX:
                        orig_frame = *frame;
                        xdp.data_hard_start = head;


> Thank you for working on this.
> 
> Toshiaki Makita
> 
> .


