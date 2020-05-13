Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8E71D17AC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388994AbgEMOeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388857AbgEMOeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:34:17 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BB2C061A0C
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:34:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z72so19144168wmc.2
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 07:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=PMu8cny99dlUViWjZ5MCDrEV5woqa0pX5kBNOy1ATp8=;
        b=cYEygrrSvPebxqcGsAb7pf2DaudcK/YBw/UGwq9nbVbhBLtUHA08Fd502x74/Un1lb
         xbS/ZCleetgjazw1kDbzZzk/C+o5gcj0Ls6n9UwoE3bTcSDXY05ao/5qPIvSkXJkpBCW
         vyK708vZWwfwi4lZXw3yUwC5lVXsjIRRm8nCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=PMu8cny99dlUViWjZ5MCDrEV5woqa0pX5kBNOy1ATp8=;
        b=uWsbXfVkoaf7wZkPG7KVodbLZE/Gd/Ls1xcK3A0kSARqaDGYHarFawnPm4h7zahSWe
         gA81x6WEUYyC/bxX6J643SfM2nnRverw93dHzdR5a7CxowPBtvc8J84wo42bmRWyA4LY
         flacywd2pryVCytuyEDtj5CF+3VxenDi3kYH9l4W0GXD0Sp35uhJ694FIBdXiAfd5nct
         C1DxAjPZuvcKy0TaKimd6a6uHU6dIoQe4td67Me0+24aRrNLEIlrnYSKAJ5R04qVAFlx
         P1F1+HY6yIs+9zDwBAuAck2OigmJomkj8hjW8e+DrgtPcYONH85x7AqnwZem499cuD57
         UYjw==
X-Gm-Message-State: AOAM530AQGynyzgbfZ0Vav+GlPCbzRgsql2/xCWmEHQJZBOjRk3LKVrl
        1qKrkdg2YhiEc62dTLLMuIi5Ow==
X-Google-Smtp-Source: ABdhPJzSwCqjxV5YkOU9DMMQzUrpwlQbJkdpBuW6OJVkA/YTDjb/3RHUCk655nUU8SY2h8pKRFqgfw==
X-Received: by 2002:a1c:b3c1:: with SMTP id c184mr6192757wmf.36.1589380455727;
        Wed, 13 May 2020 07:34:15 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 32sm28181517wrg.19.2020.05.13.07.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 07:34:14 -0700 (PDT)
References: <20200511185218.1422406-1-jakub@cloudflare.com> <20200511185218.1422406-3-jakub@cloudflare.com> <20200513054121.qztevjyfkc2ltcvp@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, dccp@vger.kernel.org,
        kernel-team@cloudflare.com, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Marek Majkowski <marek@cloudflare.com>,
        "Lorenz Bauer" <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v2 02/17] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <20200513054121.qztevjyfkc2ltcvp@kafai-mbp.dhcp.thefacebook.com>
Date:   Wed, 13 May 2020 16:34:13 +0200
Message-ID: <87wo5fucnu.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 07:41 AM CEST, Martin KaFai Lau wrote:
> On Mon, May 11, 2020 at 08:52:03PM +0200, Jakub Sitnicki wrote:
>
> [ ... ]
>
>> +BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
>> +	   struct sock *, sk, u64, flags)
> The SK_LOOKUP bpf_prog may have already selected the proper reuseport sk.
> It is possible by looking up sk from sock_map.
>
> Thus, it is not always desired to do lookup_reuseport() after sk_assign()
> in patch 5.  e.g. reuseport_select_sock() just uses a normal hash if
> there is no reuse->prog.
>
> A flag (e.g. "BPF_F_REUSEPORT_SELECT") can be added here to
> specifically do the reuseport_select_sock() after sk_assign().
> If not set, reuseport_select_sock() should not be called.

That's true that in addition to steering connections to different
services with SK_LOOKUP, you could also, in the same program,
load-balance among sockets belonging to one service.

So skipping the reuseport socket selection, if sk_lookup already did
load-balancing sounds useful.

Thinking about our use-case, I think we would always pass
BPF_F_REUSEPORT_SELECT to sk_assign() because we either (i) know that
application is using reuseport and want it manage the load-balancing
socket group by itself, or (ii) don't know if application is using
reuseport and don't want to break expected behavior.

IOW, we'd like reuseport selection to run by default because application
expects it to happen if it was set up. OTOH, the application doesn't
have to be aware that there is sk_lookup attached (we can put one of its
sockets in sk_lookup SOCKMAP when systemd activates it).

Beacuse of that I'd be in favor of having a flag for sk_assign() that
disables reuseport selection on demand.

WDYT?
