Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1B338147B
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 02:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhEOATQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 20:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233856AbhEOATO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 20:19:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D7E5613C1;
        Sat, 15 May 2021 00:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621037881;
        bh=+s/88Y7HX4sY22PkY201rbIdAcvJgMX3KGUSkg05MC0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FdwnoktUZh3aVFXG/ufBS/N36rRZCT3+atxRZZ2MSx6f5bl11+2gYw4oKli/yNxyK
         6NgbZH/gabNzG5LyoRCsmificZUyVd95ASLKXi0ZBQs0zyq3tJ28YcPd0T6jhm4A+j
         xkugOJv/qpEGGLLEb5rSCwSJuM+917cwl7RhVxji9Uhq9P0QEvRUcWku091cHUIzjy
         iTdEA1hQ9mMdC8N91JyQ74RCL2l3U3UsFAv998VzrcJHm42brsRFlhbVxzLbQxgkWu
         3xGjxkbH0q/g6xXctqjXg5hPItahPM2xSNbHCTjMnKuSg+XLAVSjpWLdeLh0+2pHGz
         joic2sBURqD1w==
Date:   Fri, 14 May 2021 17:17:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        David Miller <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>, kpsingh@kernel.org,
        bpf <bpf@vger.kernel.org>, Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>, Jike Song <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, atenart@kernel.org,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Hillf Danton <hdanton@sina.com>, jgross@suse.com,
        JKosina@suse.com, Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net v8 1/3] net: sched: fix packet stuck problem for
 lockless qdisc
Message-ID: <20210514171759.5572c8f0@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAM_iQpXZNASp7+kA=OoCVbXuReAtOzHnqMn8kFUVfi9_qWe_kw@mail.gmail.com>
References: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
        <1620959218-17250-2-git-send-email-linyunsheng@huawei.com>
        <CAM_iQpXWgYQxf8Ba-D4JQJMPUaR9MBfQFTLFCHWJMVq9PcUWRg@mail.gmail.com>
        <20210514163923.53f39888@kicinski-fedora-PC1C0HJN>
        <CAM_iQpXZNASp7+kA=OoCVbXuReAtOzHnqMn8kFUVfi9_qWe_kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 16:57:29 -0700 Cong Wang wrote:
> On Fri, May 14, 2021 at 4:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 14 May 2021 16:36:16 -0700 Cong Wang wrote:  
>  [...]  
> > >
> > > We have test_and_clear_bit() which is atomic, test_bit()+clear_bit()
> > > is not.  
> >
> > It doesn't have to be atomic, right? I asked to split the test because
> > test_and_clear is a locked op on x86, test by itself is not.  
> 
> It depends on whether you expect the code under the true condition
> to run once or multiple times, something like:
> 
> if (test_bit()) {
>   clear_bit();
>   // this code may run multiple times
> }
> 
> With the atomic test_and_clear_bit(), it only runs once:
> 
> if (test_and_clear_bit()) {
>   // this code runs once
> }
> 
> This is why __netif_schedule() uses test_and_set_bit() instead of
> test_bit()+set_bit().

Thanks, makes sense, so hopefully the MISSED-was-set case is not common
and we can depend on __netif_schedule() to DTRT, avoiding the atomic op
in the common case.
