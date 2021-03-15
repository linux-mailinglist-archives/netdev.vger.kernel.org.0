Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B551933ADE7
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 09:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCOIv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 04:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCOIux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 04:50:53 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431FFC061574
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 01:50:53 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id h82so32340136ybc.13
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 01:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l2O57MtvjdnNHzD4neH/h5doFZculQvdjShG/AZS2Og=;
        b=gDgsw7Tb+HXOoQEbpVhgQqfXspgXmqQAu7boGHprky98IHo5PPEuLyFlvAs+XLWYUG
         mhPP9g52vYZAFJzLW+7WWPCHmxYWIGW1s160NRYEacH7nTzt7rDjj6BoZDhDps39dadM
         D9rHMNEb9UYM8oTyed4XYSdDOIKVbi6I4Tatk+yue0NYH3SZDyaUNFkcrgyUkxmPLt00
         B26JIteFm+7TPWv5LmfQ12dT59Z+FAfdlXURaLTrQJqc16/G+noKPAno75JsWSSoj7Ur
         SH0AharqhZ2LdGwf264H4JKwTGlqs4yZX5m9O7iAr5m3qOy3av78iYFeBnUofs9cDcg0
         tiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l2O57MtvjdnNHzD4neH/h5doFZculQvdjShG/AZS2Og=;
        b=iuUSA/Y0Uetp2pHEt3rkYMTXhIwXQtVSur/qPwiD5vsczxsFXhSkdwKC+6nW9OAowy
         pg2LSWgMmTDyEgMgLeS9fXRirma9NjL5jPs8nMb+zPYY77WQMs2F6tf3m3l9yJccj4+U
         qEhLQ0ilL9hDak0kWmxz3m5PZ5miCubhk+gBtvbw+73WI49D1Mcec3afbcxQKxtznAmy
         2dMvbtTowEcLKVy09aFPKovI54v5Pt5nbDmAOkfipk7eYyfMURrdoU/oOZmDow9icM3D
         T4wRVTQipyu2kyg5vCtPT1O0vDxFwn/8lHUlj0afBQ2hnzi/wwOZJh5ImQYO3iZHShj9
         dasA==
X-Gm-Message-State: AOAM530qgoqMhJE0losWKv3CYtLmWKWHtvGFBZPAroPiD01jIoO5tm7E
        3XK4HfCP9Oh6DqD49yANRIjGnJ/tiYceTZnuQTPrfQ==
X-Google-Smtp-Source: ABdhPJwoEZDriN7rqaE+uMf4T/zFAf7FdqqD5Bu80PYjKj+IWsK837X70gLJ5Q3iUigAbOq1yTV/A/jbN6yqLBx89po=
X-Received: by 2002:a25:1d88:: with SMTP id d130mr36556088ybd.446.1615798252202;
 Mon, 15 Mar 2021 01:50:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210313202946.59729-1-alobakin@pm.me>
In-Reply-To: <20210313202946.59729-1-alobakin@pm.me>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 15 Mar 2021 09:50:40 +0100
Message-ID: <CANn89iKmJg641Wz7uJkcbdGd41+Vu4_eT7xtWv_V-rmyQhmyBQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/3] gro: micro-optimize dev_gro_receive()
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 13, 2021 at 9:30 PM Alexander Lobakin <alobakin@pm.me> wrote:
>
> This random series addresses some of suboptimal constructions used
> in the main GRO entry point.
> The main body is gro_list_prepare() simplification and pointer usage
> optimization in dev_gro_receive() itself. Being mostly cosmetic, it
> gives like +10 Mbps on my setup to both TCP and UDP (both single- and
> multi-flow).
>
> Since v1 [0]:
>  - drop the replacement of bucket index calculation with
>    reciprocal_scale() since it makes absolutely no sense (Eric);
>  - improve stack usage in dev_gro_receive() (Eric);
>  - reverse the order of patches to avoid changes superseding.
>
> [0] https://lore.kernel.org/netdev/20210312162127.239795-1-alobakin@pm.me
>

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumaet@google.com>
