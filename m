Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DC7312AFF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBHHMJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Feb 2021 02:12:09 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:2827 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbhBHHLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:11:22 -0500
Received: from dggeme755-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4DYxv308Z2z13rhR;
        Mon,  8 Feb 2021 15:08:15 +0800 (CST)
Received: from dggeme758-chm.china.huawei.com (10.3.19.104) by
 dggeme755-chm.china.huawei.com (10.3.19.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 8 Feb 2021 15:10:28 +0800
Received: from dggeme758-chm.china.huawei.com ([10.6.80.69]) by
 dggeme758-chm.china.huawei.com ([10.6.80.69]) with mapi id 15.01.2106.006;
 Mon, 8 Feb 2021 15:10:28 +0800
From:   "Wanghongzhe (Hongzhe, EulerOS)" <wanghongzhe@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "keescook@chromium.org" <keescook@chromium.org>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "wad@chromium.org" <wad@chromium.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [PATCH] seccomp: Improve performance by optimizing memory barrier
Thread-Topic: [PATCH] seccomp: Improve performance by optimizing memory
 barrier
Thread-Index: AQHW/eXFi+qpMZFbwU6sef0d1SUt7qpN1k9Q
Date:   Mon, 8 Feb 2021 07:10:28 +0000
Message-ID: <cf245927a58b4a62bb6ac9ac4169fff7@huawei.com>
References: <1612183781-15469-1-git-send-email-wanghongzhe@huawei.com>
 <20210208064336.GA4656@unreal>
In-Reply-To: <20210208064336.GA4656@unreal>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.177.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Monday, February 8, 2021 2:44 PM
> To: Wanghongzhe (Hongzhe, EulerOS) <wanghongzhe@huawei.com>
> Cc: keescook@chromium.org; luto@amacapital.net; wad@chromium.org;
> ast@kernel.org; daniel@iogearbox.net; andrii@kernel.org; kafai@fb.com;
> songliubraving@fb.com; yhs@fb.com; john.fastabend@gmail.com;
> kpsingh@kernel.org; linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
> bpf@vger.kernel.org
> Subject: Re: [PATCH] seccomp: Improve performance by optimizing memory
> barrier
> 
> On Mon, Feb 01, 2021 at 08:49:41PM +0800, wanghongzhe wrote:
> > If a thread(A)'s TSYNC flag is set from seccomp(), then it will
> > synchronize its seccomp filter to other threads(B) in same thread
> > group. To avoid race condition, seccomp puts rmb() between reading the
> > mode and filter in seccomp check patch(in B thread).
> > As a result, every syscall's seccomp check is slowed down by the
> > memory barrier.
> >
> > However, we can optimize it by calling rmb() only when filter is NULL
> > and reading it again after the barrier, which means the rmb() is
> > called only once in thread lifetime.
> >
> > The 'filter is NULL' conditon means that it is the first time
> > attaching filter and is by other thread(A) using TSYNC flag.
> > In this case, thread B may read the filter first and mode later in CPU
> > out-of-order exection. After this time, the thread B's mode is always
> > be set, and there will no race condition with the filter/bitmap.
> >
> > In addtion, we should puts a write memory barrier between writing the
> > filter and mode in smp_mb__before_atomic(), to avoid the race
> > condition in TSYNC case.
> >
> > Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
> > ---
> >  kernel/seccomp.c | 31 ++++++++++++++++++++++---------
> >  1 file changed, 22 insertions(+), 9 deletions(-)
> >
> > diff --git a/kernel/seccomp.c b/kernel/seccomp.c index
> > 952dc1c90229..b944cb2b6b94 100644
> > --- a/kernel/seccomp.c
> > +++ b/kernel/seccomp.c
> > @@ -397,8 +397,20 @@ static u32 seccomp_run_filters(const struct
> seccomp_data *sd,
> >  			READ_ONCE(current->seccomp.filter);
> >
> >  	/* Ensure unexpected behavior doesn't result in failing open. */
> > -	if (WARN_ON(f == NULL))
> > -		return SECCOMP_RET_KILL_PROCESS;
> > +	if (WARN_ON(f == NULL)) {
> > +		/*
> > +		 * Make sure the first filter addtion (from another
> > +		 * thread using TSYNC flag) are seen.
> > +		 */
> > +		rmb();
> > +
> > +		/* Read again */
> > +		f = READ_ONCE(current->seccomp.filter);
> > +
> > +		/* Ensure unexpected behavior doesn't result in failing open. */
> > +		if (WARN_ON(f == NULL))
> > +			return SECCOMP_RET_KILL_PROCESS;
> > +	}
> 
> IMHO, double WARN_ON() for the fallback flow is too much.
> Also according to the description, this "f == NULL" check is due to races and
> not programming error which WARN_ON() are intended to catch.
> 
> Thanks

Maybe you are right. I think 'if (f == NULL)' is enough for this optimizing.
