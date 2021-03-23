Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D681345658
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 04:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCWDic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 23:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCWDiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 23:38:18 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9287EC061574;
        Mon, 22 Mar 2021 20:38:17 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so9541600pjb.2;
        Mon, 22 Mar 2021 20:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5HV1xHdxdx/M9zJqeRyyYopwE56XgIHxgZRsBKDb7k=;
        b=hzD+mUcsuf07pobGU/UCZYrzjGrjYAtZL0XaMoV8EGuTxmRdO23x2In2iIrI0gsNIq
         WfG+ifPQ7xrh68/mV170/e49FJbS/5dq9xvCuSzGS81Kz6KA07SWzq+Y2rJW17PAsF4D
         gSR7G8c7H34vpq6T40VsNqce6wKmYfptXhtRK9/u4dcaUHcPlklxF3CkbpAwoa0uEyaR
         FYCscPI1b6QYfNDkxkhIUL0cz1fn7lhG2Ah7g0xVgkO8I2VU+epBsV+P+A6N353pOzLv
         Y7zuWWSE3pWJU/DuHmHT73Rw1L3vGvptfJXnTJBCZpcdTHmKB6vmclvA1VoIkgpqPwjN
         eDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5HV1xHdxdx/M9zJqeRyyYopwE56XgIHxgZRsBKDb7k=;
        b=IJ4t/r6syRHjuxMwhMnaG43X/1WmKu3xhrYrjPkjP0uX3HtOaX0deAerQenZgsXAmw
         MKUffyDm4Cut6ry8OsMYVP9v+yR90HM70yBKYyiJCF5YR0/QKOgPITMTqnZlOimEIZNq
         +f2rshSq2At7pPkCPtpZf+RkgKoOU2XhoBxFFvxPTfb1axjjlyinmPmkDIj7hba4gdhz
         rX2ePjsfuI+XlKsk+gROIt6XTu7r4Vh9TK8HIqIDTfdEE8BdXDx4sXTWrIAO+0HFV6N0
         WoVlt+qf66OCPeUK+9aaH3GiV/O52nQ+yFytiPtNLsDWJP0S+svm3WV5hjHNU68YCraf
         J5Kw==
X-Gm-Message-State: AOAM531ianzRCSi6WB/c5GYlWoW4xzJV/fTa2BffLymixO5OkXn9WhcO
        zo88B1YcbdUAa9XwOPM2mwcQIk5FY2WEUawTK5w=
X-Google-Smtp-Source: ABdhPJzraWPPHcrLYiGZacjy+KtOsXJtn3LIcEolKdtlrQuvOBLqi0ukNfd5Bep3jPXpGjeuQWS1f6USjmQFvKht2BM=
X-Received: by 2002:a17:90a:43a2:: with SMTP id r31mr2367388pjg.52.1616470697183;
 Mon, 22 Mar 2021 20:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
 <20210323003808.16074-3-xiyou.wangcong@gmail.com> <93f9be88-2803-93cd-df6b-43f494c0f67d@huawei.com>
In-Reply-To: <93f9be88-2803-93cd-df6b-43f494c0f67d@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 22 Mar 2021 20:38:05 -0700
Message-ID: <CAM_iQpXoWmk2anOHmVJH0z+ih3mcEY8ghid+OjsZPAGbL0qKqQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v6 02/12] skmsg: introduce a spinlock to protect ingress_msg
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 6:25 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/3/23 8:37, Cong Wang wrote:
> > +static inline struct sk_msg *sk_psock_next_msg(struct sk_psock *psock,
> > +                                            struct sk_msg *msg)
> > +{
> > +     struct sk_msg *ret;
>
> Nit:
> Use msg instead of ret to be consistently with sk_psock_dequeue_msg()
> and sk_psock_next_msg().

Please read it carefully, clearly 'msg' is already a parameter name here.

Thanks.
