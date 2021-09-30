Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD2541D132
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 03:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347740AbhI3B6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 21:58:01 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24155 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347699AbhI3B55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 21:57:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKbsT4wSYz1DHPC;
        Thu, 30 Sep 2021 09:54:53 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 09:56:06 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 09:56:04 +0800
Subject: Re: [PATCH net 2/2] auth_gss: Fix deadlock that blocks
 rpcsec_gss_exit_net when use-gss-proxy==1
To:     "bfields@fieldses.org" <bfields@fieldses.org>
CC:     Trond Myklebust <trondmy@hammerspace.com>,
        "neilb@suse.com" <neilb@suse.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "tyhicks@canonical.com" <tyhicks@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "tom@talpey.com" <tom@talpey.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "timo@rothenpieler.org" <timo@rothenpieler.org>,
        "jiang.wang@bytedance.com" <jiang.wang@bytedance.com>,
        "kuniyu@amazon.co.jp" <kuniyu@amazon.co.jp>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Rao.Shoaib@oracle.com" <Rao.Shoaib@oracle.com>,
        "wenbin.zeng@gmail.com" <wenbin.zeng@gmail.com>,
        "kolga@netapp.com" <kolga@netapp.com>
References: <20210928031440.2222303-1-wanghai38@huawei.com>
 <20210928031440.2222303-3-wanghai38@huawei.com>
 <a845b544c6592e58feeaff3be9271a717f53b383.camel@hammerspace.com>
 <20210928134952.GA25415@fieldses.org>
 <77051a059fa19a7ae2390fbda7f8ab6f09514dfc.camel@hammerspace.com>
 <20210928141718.GC25415@fieldses.org>
 <cc92411f242290b85aa232e7220027b875942f30.camel@hammerspace.com>
 <20210928145747.GD25415@fieldses.org>
 <8b0e774bdb534c69b0612103acbe61c628fde9b1.camel@hammerspace.com>
 <20210928154300.GE25415@fieldses.org> <20210929211211.GC20707@fieldses.org>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <ba12c503-401d-9b22-be83-7645c619d9d1@huawei.com>
Date:   Thu, 30 Sep 2021 09:56:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20210929211211.GC20707@fieldses.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/9/30 5:12, bfields@fieldses.org Ð´µÀ:
> On Tue, Sep 28, 2021 at 11:43:00AM -0400, bfields@fieldses.org wrote:
>> On Tue, Sep 28, 2021 at 03:36:58PM +0000, Trond Myklebust wrote:
>>> What is the use case here? Starting the gssd daemon or knfsd in
>>> separate chrooted environments? We already know that they have to be
>>> started in the same net namespace, which pretty much ensures it has to
>>> be the same container.
>> Somehow I forgot that knfsd startup is happening in some real process's
>> context too (not just a kthread).
>>
>> OK, great, I agree, that sounds like it should work.
> Wang Hai, do you want to try that, or should I?
>
> --b.
> .
Thank you, of course with great pleasure. I tried the solution
suggested by Myklebust yesterday, but I can't seem to get this
done very well. It would be a great pleasure for me if you could
help to finish it. I can help test it after you finish it.

--
Wang Hai

>
