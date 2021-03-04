Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE3C32CFB0
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 10:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbhCDJbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 04:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237528AbhCDJbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 04:31:02 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A964CC061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 01:30:16 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id z11so41983146lfb.9
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 01:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pu1CyogJ4KszgKg6MY278wInXSM0/2I0jFkvTWlawbU=;
        b=N4YzgkI4XEJmywt0HKmr6CbpkRSyBojXjIAASYLn+1uN6BTtnJvl9O48X81O86BgE/
         TVJbYdT81FrclKBHqrCrvf+ceN9SbBHQFF/P2XS+Yp2NnmDkpEhD8IWeou+Fm2cRcvhQ
         6mCO0zvvSzRm74+q4LoccouiNLRWofrJ8QN88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pu1CyogJ4KszgKg6MY278wInXSM0/2I0jFkvTWlawbU=;
        b=pLb0nCBr4W+6rCQKijE1v26P4VnaF2Vzw3rjRmPeZGglEVVaCZKoSPQEhFfUCCNai2
         qv50JKhPOpIOjim2imkIyfbSnu5w32ZzqRb5Mh41iLMOkZNueUZjSzM9xZZ/NQd6MT5a
         hy+t2QKGKVeh3PjPsBK5mnObbJFNRWEFr1CrfzyKlEShp3EC+MY8wZ1W2Tc7isYI6/0L
         Dt79pOiJ6zhnP71bySnlssj+YS5ikLcwibcv/Y/EKVVBwXx5/j285CfQPzB21FDFye5o
         hyWgsPR7Vxor61yf9r+BTalutFwAQFiOeAIgWOvFNBnm2zWkXL4XzIH7j+tuzSpCzxXP
         3a8A==
X-Gm-Message-State: AOAM530tGb0yJRdq/37vjaYvyuaX7Q73r7keSWAxwASIVXgyUwkAdg2o
        yNjl+As+a95Cx8iF06WlaDHYwRVwowY84Rrs/V/SLQ==
X-Google-Smtp-Source: ABdhPJwlixlxCnqkgC1LrPgFWhjtNBffgD6PjHWqhLJTn/0O3QIki63zZdo2sZRaFSJmMf6Qq7PWsI3ypTNOwd8nPL4=
X-Received: by 2002:a05:6512:12c3:: with SMTP id p3mr1724168lfg.97.1614850215201;
 Thu, 04 Mar 2021 01:30:15 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
 <20210302023743.24123-3-xiyou.wangcong@gmail.com> <CACAyw9-SjsNn4_J1KDXuFh1nd9Hr-Mo+=7S-kVtooJwdi1fodQ@mail.gmail.com>
 <CAM_iQpXqE9qJ=+zKA6H1Rq=KKgm8LZ=p=ZtvrrH+hfSrTg+zxw@mail.gmail.com>
 <CACAyw99BweMk-82f270=Vb=jDuec0q0N-6E8Rr8enaOGuZEDNQ@mail.gmail.com> <CAM_iQpWHTvFPifcPL-x64fWqY5k8yP9vu6Bnp8D-HdpUp6vs6g@mail.gmail.com>
In-Reply-To: <CAM_iQpWHTvFPifcPL-x64fWqY5k8yP9vu6Bnp8D-HdpUp6vs6g@mail.gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 4 Mar 2021 09:30:04 +0000
Message-ID: <CACAyw98r+Srg3K89VAh6VEYG7NxUxF=HzyqPwkBEXKCe2omimQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/9] sock: introduce sk_prot->update_proto()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Mar 2021 at 18:21, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Yeah, I am not surprised we can change tcp_update_ulp() too, but
> why should I bother kTLS when I do not have to? What you suggest
> could at most save us a bit of code size, not a big gain. So, I'd keep
> its return value as it is, unless you see any other benefits.

I think the end result is code that is easier to understand and
therefore maintain. Keep it as it is if you prefer.

> BTW, I will rename it to 'psock_update_sk_prot', please let me know
> if you have any better names.

SGTM.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
