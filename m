Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8339850BD89
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449834AbiDVQxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444743AbiDVQxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:53:44 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBA25DE56
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:50:51 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id w20so9327654ybi.8
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OZvA79b7vVq1SNe+wDrRtCIMcVba4TSSrUIydbtHAq0=;
        b=roALnPDISx4w+0b4UtgZaMkYauGKuvHSVSiLRsxJOMoRxqVhe2YfnbPxlZxdt+C/65
         VKMeFvmzlqEl/PpWyHMsJCKjDCvk5jSPNpVJ0//umnXriRfjy6/BJ4zhW2GDNogLaU0W
         Vy6qYM0pohVtfSGRBwDMZpN5Ap3Ld24F3uWiH6OcrUVm6zpqKO/AR/ADXhbdv1jUhLCd
         636R8qOz2RFYoQJ1SnJfDav/nfXG0V3Ez90s/NF9Axt4AjGk1hHAhjzVrYOtX/dF0Bs3
         j12OPxyXn9VEnWuxlG27esjLvHzGCJjWE9/O0Zl/+fUM58bI4oNU2di554UM7U36Hphm
         tfjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OZvA79b7vVq1SNe+wDrRtCIMcVba4TSSrUIydbtHAq0=;
        b=V4qu0nf0C3Jc4p8CjguiihHNjSeuBpIRMCjUJD2ZkM86GzwXkz+KQL4sHCxR6sMjhV
         OfLe64m7XAygJ+bS5/5QLc/EB9iVuja0KTT7uGlMQqSNY7DGln7lueyNnTVwk9d15aEH
         dLREHTUZUaDRKPloxeBVqkqF2H1WX8uAWib73kOpzdN+9RxnrUf9Tz9gcJeogf4Rnuc6
         acj/Io2V7ajTCLZJA/F9sqwJOO7Hs/ybb1D/aW7BvnkhXFOeuWpxHuNdTOF0AL+kFaFp
         eSK4oVu92V+dGfLEim0OypvY3TT4V1r7QOZsrTg7Hw/bIp1KNIrEzEjlsDK+daIvrn28
         MbiA==
X-Gm-Message-State: AOAM5335Ltf6xcMtlQ3BsHT4aOlhy1Wc7oJKo6foqFbSgj1x5JSZRF8n
        SapG3zJzz0mQV+BTmR60D/t5JXHptrOR4sgvVV0+XmNgiONHyw==
X-Google-Smtp-Source: ABdhPJwmncmvVZ17rbyBoSFqX7ZfPG1IhzsY1yie1uJLifG4B57dH8kON4BMsxiwmK1IlxqHL1+mc6AE3Ell2YVYdc8=
X-Received: by 2002:a25:6157:0:b0:645:8d0e:f782 with SMTP id
 v84-20020a256157000000b006458d0ef782mr3896018ybb.36.1650646244680; Fri, 22
 Apr 2022 09:50:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220421153920.3637792-1-eric.dumazet@gmail.com> <20220422094014.1bcf78d5@kernel.org>
In-Reply-To: <20220422094014.1bcf78d5@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 22 Apr 2022 09:50:33 -0700
Message-ID: <CANn89iLK5i9y5=iAHS=8+SinGkmGgEXR=xk=ATpnXPakD1j-vQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: generalize skb freeing deferral to per-cpu lists
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 22, 2022 at 9:40 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 21 Apr 2022 08:39:20 -0700 Eric Dumazet wrote:
> > 10 runs of one TCP_STREAM flow
>
> Was the test within a NUMA node or cross-node?

This was a NUMA host, but nothing done to force anything (no pinning,
both for sender and receiver)

>
> For my learning - could this change cause more cache line bouncing
> than individual per-socket lists for non-RFS setups. Multiple CPUs
> may try to queue skbs for freeing on one remove node.

I did tests as well in non-RFS setups, and got nice improvement as well
I could post them in v2 if you want.

The thing is that with a typical number of RX queues (typically 16 or
32 queues on a 100Gbit NIC),
there is enough sharding for this spinlock to be a non-issue.

Also, we could quite easily add some batching in a future patch, for
the cases where the number of RX queues
is too small.

(Each cpu could hold up to 8 or 16 skbs in a per-cpu cache, before
giving them back to alloc_cpu(s))


>
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 7dccbfd1bf5635c27514c70b4a06d3e6f74395dd..0162a9bdc9291e7aae967a044788d09bd2ef2423 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -3081,6 +3081,9 @@ struct softnet_data {
> >       struct sk_buff_head     input_pkt_queue;
> >       struct napi_struct      backlog;
> >
> > +     /* Another possibly contended cache line */
> > +     struct sk_buff_head     skb_defer_list ____cacheline_aligned_in_smp;
>
> If so maybe we can avoid some dirtying and use a single-linked list?
> No point modifying the cache line of the skb already on the list.

Good idea, I can think about it.

>
> > +     call_single_data_t  csd_defer;
> >  };
