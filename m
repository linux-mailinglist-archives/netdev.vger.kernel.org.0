Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D458D31C7AC
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 09:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhBPI5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 03:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhBPI5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 03:57:09 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1957DC061786
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 00:56:24 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id m22so14606051lfg.5
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 00:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XyN/1pWzJnIDjuGU29vP9Mf3I8eoOizxWJKMDDh0wtE=;
        b=IcvuvIYXcHFspNRbPxlLm4+57PblcVraelaeMIYyjNTjt1zx1IGKLrTCt0NZ8oW90W
         A3J10ynOrJLbqhOqyW+wT71wdAAER+ez2+dibFWP2sL3GatE3PJ6hhP31uoNXG3SXFcF
         JeH17jjvv0+MXG2vyYwMlLaneE4Le+YYXZz4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XyN/1pWzJnIDjuGU29vP9Mf3I8eoOizxWJKMDDh0wtE=;
        b=gdgZU9gOCew8CYEyDRSx4ZfdB8jFIcsmgUm5KVShlXwDuoQEFTtrZueA9IJ2z4ovun
         yg9zD26d/JDzRExmMeohqUvpMq6KjThEpHUD3x12pkLHrqxxfv4qb6x6J0yT59pVLR1I
         BfrvY7sV+aYVoE4a7wBTd08GulefV5Q+PVI6vU14+vq2suxLCnQEWXwj58fWBBSH+5lB
         Nk8aCh9PdHYKL426HFk9BqJUR1F1of2Uqj8d5pdZNwqV3znMOMiRhEBtvdJkyMixb1zl
         Jl1IgtlUgZQDtQHSWQyO21mCakV2fA0fGtaFYsvykwAbSAtTHu2HF9UMVvBoCRmoT+KV
         Y/Sg==
X-Gm-Message-State: AOAM5329Aih5PdaAi6MJ5e5NQ3CrvUafPTy8KXeUJv4ZQjusWFyb3ME1
        eYOuGQW8KBQYoMoO2F3+22sidDgmNTjwEAkr3ceUYw==
X-Google-Smtp-Source: ABdhPJz/llzLGKvbUYahjbAxay9wgBRpvQ5InkpiWt7iKwvcfTR5/ZZDU010kfQ7VhPsb1+lMFTBUzpXNI4DrXznFv0=
X-Received: by 2002:a05:6512:22c9:: with SMTP id g9mr11781605lfu.325.1613465782607;
 Tue, 16 Feb 2021 00:56:22 -0800 (PST)
MIME-Version: 1.0
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-5-xiyou.wangcong@gmail.com> <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
In-Reply-To: <602ac96f9e30f_3ed41208b6@john-XPS-13-9370.notmuch>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 16 Feb 2021 08:56:11 +0000
Message-ID: <CACAyw99k43REGCh8cP1PioV+k-_BRAjecVHcmtOdL6fi2shxkQ@mail.gmail.com>
Subject: Re: [Patch bpf-next v3 4/5] skmsg: use skb ext instead of TCP_SKB_CB
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Feb 2021 at 19:20, John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Currently TCP_SKB_CB() is hard-coded in skmsg code, it certainly
> > does not work for any other non-TCP protocols. We can move them to
> > skb ext instead of playing with skb cb, which is harder to make
> > correct.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> I'm not seeing the advantage of doing this at the moment. We can
> continue to use cb[] here, which is simpler IMO and use the ext
> if needed for the other use cases. This is adding a per packet
> alloc cost that we don't have at the moment as I understand it.

John, do you have a benchmark we can look at? Right now we're arguing
in the abstract.
