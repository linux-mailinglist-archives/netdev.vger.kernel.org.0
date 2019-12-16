Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 201C511FCA8
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 02:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfLPBvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 20:51:33 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:48438 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726299AbfLPBvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 20:51:33 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id B11228EDEEEBACE7084A;
        Mon, 16 Dec 2019 09:51:31 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Mon, 16 Dec 2019
 09:51:30 +0800
Subject: Re: [PATCH][v2] page_pool: handle page recycle for NUMA_NO_NODE
 condition
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "Li,Rongqing" <lirongqing@baidu.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191212111831.2a9f05d3@carbon>
 <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
 <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
 <079a0315-efea-9221-8538-47decf263684@huawei.com>
 <20191213094845.56fb42a4@carbon>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <15be326d-1811-329c-424c-6dd22b0604a8@huawei.com>
Date:   Mon, 16 Dec 2019 09:51:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20191213094845.56fb42a4@carbon>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/13 16:48, Jesper Dangaard Brouer wrote:> You are basically saying that the NUMA check should be moved to
> allocation time, as it is running the RX-CPU (NAPI).  And eventually
> after some time the pages will come from correct NUMA node.
> 
> I think we can do that, and only affect the semi-fast-path.
> We just need to handle that pages in the ptr_ring that are recycled can
> be from the wrong NUMA node.  In __page_pool_get_cached() when
> consuming pages from the ptr_ring (__ptr_ring_consume_batched), then we
> can evict pages from wrong NUMA node.

Yes, that's workable.

> 
> For the pool->alloc.cache we either accept, that it will eventually
> after some time be emptied (it is only in a 100% XDP_DROP workload that
> it will continue to reuse same pages).   Or we simply clear the
> pool->alloc.cache when calling page_pool_update_nid().

Simply clearing the pool->alloc.cache when calling page_pool_update_nid()
seems better.

> 

