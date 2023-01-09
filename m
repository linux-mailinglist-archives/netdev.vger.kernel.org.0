Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F7F6633B6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 23:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjAIWKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 17:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjAIWKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 17:10:38 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539983FA2A
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 14:10:37 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id v23so6212050plo.1
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 14:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oPZvvK1G7KaXv71fk9zLoDwM5wPXKESl1M0gNv7ZiGI=;
        b=jRYnKRV/T7l8AbwbEYYHcafyoYERFsLjJznSWCcSA6F/D/OlH0QXimiRhMIcCqPuBc
         7Px3KB1rsUxLXaxvpTW6xpEUlLCNd2Y5q5rEf3zCFjnUMo2t41tIFRUoWTPLvPbZrIMb
         EN+rpwux8cxbgcKRYLEOSJCSHoOzVfNxQwdFI9qWyXaWONB7ZofxTRgjzj7Ggt8a1RK5
         hRhsZ5kYxuHbCPE/9hYGY2zePbvv7vszPmElHAU04OojnRgYMyh83EmT8cPj63kpIHwv
         0eO/67TtiJ12Y+PegSMbY3B31RU4bKVYw+MWiku5fYB+DJufKg9UCgvyuPofRDksMWP+
         3Quw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oPZvvK1G7KaXv71fk9zLoDwM5wPXKESl1M0gNv7ZiGI=;
        b=ro3NWBYupJt/fDXTtUIZGrIPFJS0E8fa94eEbjljow5XwQrC0ogGmJNs/TsXxtS+j1
         JAJSgcHzGWUMci5a066cnWFPQk5O1R4DzJLHBuHh39+ooLLNUdDaPiA9xYuCt9RlLYYY
         4o267SGO6SIJOaxeO7MWtgf+oh7alogJLpON11YjhJWzlatrgW0T8ahiWh/Qx1ZDqpuW
         PKHTe9kpjC5vqEFA5NPjSreWvC6kyG0/j0dVOa2RTrocTj8fN86AP0uWQkP+e8Ojmd01
         5TVcJeO4PCKZnNbOdicS8+vxL/C5yqF2fiRtvTnqUy1zc1NDcFOa5bYDya9FtE04wWd6
         LKtA==
X-Gm-Message-State: AFqh2koNhrslpNki/rxSpUBBhdVT6BBzGnAlNQrLdMY6g8ZRFuAN8yn5
        Ce2ieBhd0e+TlNIorx7E7CU=
X-Google-Smtp-Source: AMrXdXuf+thcpR5A2rchSRp7AO2fDrjXSeGNfKm6sACEimw8P7Wnho5NvQOM+79vF0ODLomKav9EYg==
X-Received: by 2002:a17:90a:7142:b0:226:19ea:5c2a with SMTP id g2-20020a17090a714200b0022619ea5c2amr44138850pjs.43.1673302236688;
        Mon, 09 Jan 2023 14:10:36 -0800 (PST)
Received: from [192.168.0.128] ([98.97.43.196])
        by smtp.googlemail.com with ESMTPSA id i3-20020a17090aa90300b00218b32f6a9esm5981639pjq.18.2023.01.09.14.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 14:10:36 -0800 (PST)
Message-ID: <fa307736d5448733f08a5a700bc9c647b383a553.camel@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        pabeni@redhat.com
Date:   Mon, 09 Jan 2023 14:10:34 -0800
In-Reply-To: <20230109113409.2d5fab44@kernel.org>
References: <167293333469.249536.14941306539034136264.stgit@firesoul>
         <167293336786.249536.14237439594457105125.stgit@firesoul>
         <20230106143310.699197bd@kernel.org>
         <fa1c57de-52f6-719f-7298-c606c119d1ab@redhat.com>
         <20230109113409.2d5fab44@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-09 at 11:34 -0800, Jakub Kicinski wrote:
> On Mon, 9 Jan 2023 13:24:54 +0100 Jesper Dangaard Brouer wrote:
> > > Also the lack of perf numbers is a bit of a red flag.
> > > =20
> >=20
> > I have run performance tests, but as I tried to explain in the
> > cover letter, for the qdisc use-case this code path is only activated
> > when we have overflow at enqueue.  Thus, this doesn't translate directl=
y
> > into a performance numbers, as TX-qdisc is 100% full caused by hardware
> > device being backed up, and this patch makes us use less time on freein=
g
> > memory.
>=20
> I guess it's quite subjective, so it'd be good to get a third opinion.
> To me that reads like a premature optimization. Saeed asked for perf
> numbers, too.
>=20
> Does anyone on the list want to cast the tie-break vote?

I'd say there is some value to be gained by this. Basically it means
less overhead for dropping packets if we picked a backed up Tx path.

> > I have been using pktgen script ./pktgen_bench_xmit_mode_queue_xmit.sh
> > which can inject packets at the qdisc layer (invoking __dev_queue_xmit)=
.
> > And then used perf-record to see overhead of SLUB (__slab_free is top#4=
)
> > is reduced.
>=20
> Right, pktgen wasting time while still delivering line rate is not of
> practical importance.

I suspect there are probably more real world use cases out there.
Although to test it you would probably have to have a congested network
to really be able to show much of a benefit.

With the pktgen I would be interested in seeing the Qdisc dropped
numbers for with vs without this patch. I would consider something like
that comparable to us doing an XDP_DROP test since all we are talking
about is a synthetic benchmark.

>=20
> > > kfree_skb_list_bulk() ? =20
> >=20
> > Hmm, IMHO not really worth changing the function name.  The
> > kfree_skb_list() is called in more places, (than qdisc enqueue-overflow
> > case), which automatically benefits if we keep the function name
> > kfree_skb_list().
>=20
> To be clear - I was suggesting a simple
>   s/kfree_skb_defer_local/kfree_skb_list_bulk/
> on the patch, just renaming the static helper.
>=20
> IMO now that we have multiple freeing optimizations using "defer" for
> the TCP scheme and "bulk" for your prior slab bulk optimizations would
> improve clarity.

Rather than defer_local would it maybe make more sense to look at
naming it something like "kfree_skb_add_bulk"? Basically we are
building onto the list of buffers to free so I figure something like an
"add" or "append" would make sense.

