Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE5F381452
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 01:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhENXkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 19:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234359AbhENXkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 19:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 813BF613AF;
        Fri, 14 May 2021 23:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621035567;
        bh=uCnRxCzxT4jtW/+RePRVO8X2RC5kc5CB3ewbkJjyuWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aF17/21XizEIOCVAufD/YMV1yEk9xL5TzbEbXzBKm0DgU+v4JsD1LyJYXky+GWwoE
         XMueAPLkcAIujuf5GGUQsKRSEodl+SSTzy5hFe0VrEuQ3FracNiYrHHW79u4ovnETL
         ch6qdibfzF1APnyuWoGiE5cvfMuydeWmqAVy30uFio86kox73kRtZRYXammlGosnK6
         fQXW6e8t2yS7YkkSabrrELKr+o8vRGvGKkz0azjABFbE4Ckxn8D0cAeZo5tjmf4r9Q
         H2I7WQsjiV8PWbmJXab5wtQpxIJoVH1XUGO3hRPLKO6y7OpbdkzKAVK9rvY2q0/r2u
         vISjSwGdiPa0g==
Date:   Fri, 14 May 2021 16:39:23 -0700
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
Message-ID: <20210514163923.53f39888@kicinski-fedora-PC1C0HJN>
In-Reply-To: <CAM_iQpXWgYQxf8Ba-D4JQJMPUaR9MBfQFTLFCHWJMVq9PcUWRg@mail.gmail.com>
References: <1620959218-17250-1-git-send-email-linyunsheng@huawei.com>
        <1620959218-17250-2-git-send-email-linyunsheng@huawei.com>
        <CAM_iQpXWgYQxf8Ba-D4JQJMPUaR9MBfQFTLFCHWJMVq9PcUWRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 May 2021 16:36:16 -0700 Cong Wang wrote:
> > @@ -176,8 +202,15 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
> >  static inline void qdisc_run_end(struct Qdisc *qdisc)
> >  {
> >         write_seqcount_end(&qdisc->running);
> > -       if (qdisc->flags & TCQ_F_NOLOCK)
> > +       if (qdisc->flags & TCQ_F_NOLOCK) {
> >                 spin_unlock(&qdisc->seqlock);
> > +
> > +               if (unlikely(test_bit(__QDISC_STATE_MISSED,
> > +                                     &qdisc->state))) {
> > +                       clear_bit(__QDISC_STATE_MISSED, &qdisc->state);  
> 
> We have test_and_clear_bit() which is atomic, test_bit()+clear_bit()
> is not.

It doesn't have to be atomic, right? I asked to split the test because
test_and_clear is a locked op on x86, test by itself is not.
