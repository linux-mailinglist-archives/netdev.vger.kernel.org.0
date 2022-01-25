Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F097649BA51
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 18:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbiAYR0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 12:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1587915AbiAYRUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 12:20:39 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099A3C0617A9
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 09:20:24 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id l68so63147341ybl.0
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 09:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vs/nbW/WWGPRZ1C8gSP2RCWKFp+3soR2nJN36DROd+k=;
        b=M9Yl5EOpd/LKXLSZBQ17kD/bqNoRLK8pnljpDipe5NNrkFX8OoBWRLDspfZOqxVDsW
         +VkIhG98/GndXBKvEsRBQZ6mmPe4VdFWCv8sO7D3rJC1Mu1d17kKC3qgle0H6MzCSVok
         0IcjODEXUi01PNvYSk0gin1DU/bZ8DIIuSoPHHfHUHNvMyvRVEXtwINdjWUQg9fBUK7z
         JH0HIm66GYOB3o4U1XTSQ5PmmioWn+Qv/UA62gMpiHJyLhpaSBMw5kt/4b4hBDKVo7u/
         LCdGHnIUuttJhk0e4Ye4EZQsY41+3H89EsUUhKwFB3zrsvwUw0Rzj56vJwk7j5g3aEGF
         1Gmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vs/nbW/WWGPRZ1C8gSP2RCWKFp+3soR2nJN36DROd+k=;
        b=aa2nfitpZSSocOSv9d86eiPYkBAlqKtSPr3TTZKJ4LWKk0lv1F2wr2Uw/+809MDx+L
         ZkO4OpuTmjLOVwYTwvrrchcvDc3euQikThzwsrkif63G/bDnP3swQY/T5TnIwWiIhBB6
         5HQ8szROU3sgHfH2SWyQXdIItrvIWkU9RLMGaveqaATfm66UdHa2cwnSBTPnLFOdQ7h+
         p2A5L4EXQYhsZbuZlA6421BELrD92AY2FJUkAsmYEpiajqleh8sedte6k8HjgVmSBHBf
         vNs/mduScY60JdEZBYrkDnUODd/ZHlbrJd2De4qv/8Dk2o7o+RXdliucOZHCvpi0RQRW
         9xqg==
X-Gm-Message-State: AOAM532VziaQJYaKPmYGpTxsUXd6vxNrDDr4+3gFtOpwjybXktj77VVn
        +Xwf4AzVyH79ym/63BDu/xDCRzGNNIQcMNGpKyO2Gz7/YE9ivw==
X-Google-Smtp-Source: ABdhPJxvXSv+Th9Zq7ZWXv4d01XTfBQI1LqdOdox1ygwh3HeBTrL/bIaZvfNZe1DuoEjaS+vilyNIUKaAR9krbgasYQ=
X-Received: by 2002:a25:820f:: with SMTP id q15mr31633866ybk.296.1643131222804;
 Tue, 25 Jan 2022 09:20:22 -0800 (PST)
MIME-Version: 1.0
References: <20220125024511.27480-1-dsahern@kernel.org> <CANn89i+b0phX3zfX7rwCHLzEYR6Y9JGXxRYa92M8PE9kbtg8Mg@mail.gmail.com>
 <6a53c204-9bc1-7fe9-07bc-6f3b7a006bce@gmail.com>
In-Reply-To: <6a53c204-9bc1-7fe9-07bc-6f3b7a006bce@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 25 Jan 2022 09:20:11 -0800
Message-ID: <CANn89i+Nn7ce8=r07b00Acq9acmX9Lm6rTOx6L59REqaV2v68g@mail.gmail.com>
Subject: Re: [PATCH net-next] net: Adjust sk_gso_max_size once when set
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 25, 2022 at 9:16 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 1/25/22 9:46 AM, Eric Dumazet wrote:
> > On Mon, Jan 24, 2022 at 6:45 PM David Ahern <dsahern@kernel.org> wrote:
> >>
> >> sk_gso_max_size is set based on the dst dev. Both users of it
> >> adjust the value by the same offset - (MAX_TCP_HEADER + 1). Rather
> >> than compute the same adjusted value on each call do the adjustment
> >> once when set.
> >>
> >> Signed-off-by: David Ahern <dsahern@kernel.org>
> >> Cc: Eric Dumazet <edumazet@google.com>
> >
> >
> > SGTM, thanks.
> >
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
>
> The git history does not explain why MAX_TCP_HEADER is used to lower
> sk_gso_max_size. Do you recall the history on it?

Simply that max IP datagram size is 64K

And TCP is sizing its payload size there (eg in  tcp_tso_autosize()),
when skb only contains payload.

Headers are added later in various xmit layers.

MAX_TCP_HEADER is chosen to avoid re-allocs of skb->head in typical workload.
