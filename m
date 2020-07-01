Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9865D210ED3
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731842AbgGAPOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgGAPOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 11:14:55 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E4CC08C5C1;
        Wed,  1 Jul 2020 08:14:54 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n23so27529111ljh.7;
        Wed, 01 Jul 2020 08:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mOVsX3kr5wvUtd+Ybm4YYwvdPcagWNgDYxxADlgIgrc=;
        b=Y0bzxwzd9CyG9EzDuuL4VsjdIwIKrHC30W0d+HXjNCTY55/uuYolnfSAw8Z3rtRkAU
         7n7DT9Ey8lMgRHLDUxNy3JSLmpVwCamJI682wmvlcpkVQDyl1OBtlRk53SF9GaNNvph/
         XVWSEvjiRUoCnRPYJrVPdcGl+YzlrlNfgcMgZ1giFTnq5KJIB1zYSlKPa+NL/XwkdhqE
         lwqdGr7ry4WP8MbJRj2e3BUFTq319Wq4fbpt8j1JLpPj2+jV65RfbWO8pLeBxVopB/vK
         q2Df5P9GOAVCiKaDul3tARcl3PLG9PLbmY/MizDWqBCnr4PpYjSAPajnHcMBl/G5DIFV
         LjrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mOVsX3kr5wvUtd+Ybm4YYwvdPcagWNgDYxxADlgIgrc=;
        b=S0Maiz9wMUBuwjEeXB8dENdhytka8AGj0COIseQfh5tfmc25kdta+3JwtTf/KEvv2h
         wPOLeswjgMXWvNA7J5H7JaAy9tE1x5rReipM1nPksDqq1mwxDwdUJEHkfA8eYELv4zkK
         qexBwFzrUM9gYyTYg2wqDa2WoCbmeWM3KqOZPwmcqXRuL24faSche2te5Xv4/kpIsLrl
         K0PJC0f+di/yQZQsXnyGMMUIv30HZE7Qmss9x5k0w4tpEQFfqdp2mREy4NsvoQ/1Ggca
         5zcepna5eENT949hT+eMp5ZWNsk2pdOCUTb95u7HENxvoGyCqdy9iaQY9PlSY/ti19/M
         XZPw==
X-Gm-Message-State: AOAM532F/4zPLtw7FSZZ39IKf0OJcInt1UPAx+R9+UZWuFiHUsxhYQAI
        142QMzAd+1dPol3j1YF1IjhiSeQH4CWhilavpmQ=
X-Google-Smtp-Source: ABdhPJwwvFHmEnRgIu6avB/AxPg2NdVW3HGtGryDSIOTNcrPmg+/qCTrJfFoPG4N87ULrFpaJJdCecVCyoBamilheIA=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr9553720ljh.290.1593616493382;
 Wed, 01 Jul 2020 08:14:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com> <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
 <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com> <1e9d88c9-c5f2-6def-7afc-aca47a88f4b0@iogearbox.net>
In-Reply-To: <1e9d88c9-c5f2-6def-7afc-aca47a88f4b0@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Jul 2020 08:14:41 -0700
Message-ID: <CAADnVQKF4z1kGduHdoRdNqmFQSoQ+b9skyb7n23YQj7X0qx8TA@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 1, 2020 at 2:17 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> ("bpf: Replace cant_sleep() with cant_migrate()"). So perhaps one way to catch
> bugs for sleepable progs is to add a __might_sleep() into __bpf_prog_enter_sleepable()

that's a good idea.

> in order to trigger the assertion generally for DEBUG_ATOMIC_SLEEP configured
> kernels when we're in non-sleepable sections? Still not perfect since the code
> needs to be exercised first but better than nothing at all.
>
> >> What about others like security_sock_rcv_skb() for example which could be
> >> bh_lock_sock()'ed (or, generally hooks running in softirq context)?
> >
> > ahh. it's in running in bh at that point? then it should be added to blacklist.
>
> Yep.

I'm assuming KP will take care of it soon.
If not I'll come back to this set some time in August.

In the meantime I've pushed patch 1 that removes redundant sync_rcu to bpf-next,
since it's independent and it benefits from being in the tree as much
as possible.
