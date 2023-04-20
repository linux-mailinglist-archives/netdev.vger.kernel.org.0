Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54EC6E9D21
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 22:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbjDTUZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 16:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbjDTUZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 16:25:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBEB72B1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682022199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ghx4l8LuGC+KjjHmCk/oxHcr8JwHJVJzrTvXad1IGDQ=;
        b=Lt4aUEb3cCGkyBDsRlKUztaLy0So3IYY1RaGhhtPWaWXG72fH6XP+m+rxsTb47SfSnQ89Z
        qQ5mnReeD4HZvNkhAhKVYK3pzf1S/7nf93EOzYr9NU63TOLzwXmeRnNa/2v68tFIQdBe6z
        7bwJ8BHVwysswkE0hXusx/2ypHNGzTM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-373-8ZAoUCsiNFieWsJXLBIrKQ-1; Thu, 20 Apr 2023 16:23:18 -0400
X-MC-Unique: 8ZAoUCsiNFieWsJXLBIrKQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f175ad3429so2315705e9.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 13:23:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682022197; x=1684614197;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ghx4l8LuGC+KjjHmCk/oxHcr8JwHJVJzrTvXad1IGDQ=;
        b=NkZuStJJ6iPA8W0lc7WYxjTQt1kg/HlDFVW91ZnskYJiIXuNY7TM0a2MsB2r4bjJR4
         bjcLPiX4popQ6C969da4sB8FweOzc3RkZqzYCMgsjK2jRNLFQMtzTAvxiXnMLppUYfz3
         3anpQ4TWdAOW4uutJdc6fITd8XJce7izvxhs7a9sfo6C0D3HacECoT94aLrPdmXIws9v
         Y8GglusJwYwGFPI6+RoHKdS9d1PwPA6/+EmjVdf6I0zNKonGatcly9RrDVcxHm/Q2QiD
         bi+jUXPqAOoo+sgevmFW4o/L8PNjwfRexAJaNc88UCpVwv5eijQAK8b4qpSbtGdAN9MT
         rLbQ==
X-Gm-Message-State: AAQBX9dJL08rI6bISaGXPQGVM477L31PljqQ5dg/lO1VMtCA6FUj57Vv
        omrhyhP+eeMmlhCajLGN8OfklJWj9lQTGJeFMQl3NMn/m1APIoZVuJL8t5RuP8XctO+3Y+VreKd
        9/Xh6+B6rJR7KFmX7
X-Received: by 2002:a5d:6683:0:b0:2e4:c9ac:c491 with SMTP id l3-20020a5d6683000000b002e4c9acc491mr1948827wru.1.1682022196830;
        Thu, 20 Apr 2023 13:23:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZRilyAe9v61SphJuWGUumuvxcT+gsNQFr5rvosSPjF9WH/DbaaocEkW93a9eSgTXGWoCCHAw==
X-Received: by 2002:a5d:6683:0:b0:2e4:c9ac:c491 with SMTP id l3-20020a5d6683000000b002e4c9acc491mr1948817wru.1.1682022196477;
        Thu, 20 Apr 2023 13:23:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-108-137.dyn.eolo.it. [146.241.108.137])
        by smtp.gmail.com with ESMTPSA id q9-20020a1ce909000000b003f177c3672dsm6126552wmc.29.2023.04.20.13.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 13:23:15 -0700 (PDT)
Message-ID: <98b96b354ef9e0b7cafb951b12988aee727807a3.camel@redhat.com>
Subject: Re: [PATCH 0/3] softirq: uncontroversial change
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        tglx@linutronix.de, jstultz@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 20 Apr 2023 22:23:14 +0200
In-Reply-To: <CANn89iKQ2KR23Ln9FU5RCKH89KWCNcu9QWuVLB4CcEqgoH+iRQ@mail.gmail.com>
References: <20221222221244.1290833-1-kuba@kernel.org>
         <305d7742212cbe98621b16be782b0562f1012cb6.camel@redhat.com>
         <CANn89iKQ2KR23Ln9FU5RCKH89KWCNcu9QWuVLB4CcEqgoH+iRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-04-20 at 19:41 +0200, Eric Dumazet wrote:
> On Thu, Apr 20, 2023 at 7:24=E2=80=AFPM Paolo Abeni <pabeni@redhat.com> w=
rote:
> > I would like to propose a revert of:
> >=20
> > 4cd13c21b207 softirq: Let ksoftirqd do its job
> >=20
> > the its follow-ups:
> >=20
> > 3c53776e29f8 Mark HI and TASKLET softirq synchronous
> > 0f50524789fc softirq: Don't skip softirq execution when softirq thread =
is parking
> >=20
> > The problem originally addressed by 4cd13c21b207 can now be tackled
> > with the threaded napi, available since:
> >=20
> > 29863d41bb6e net: implement threaded-able napi poll loop support
> >=20
> > Reverting the mentioned commit should address the latency issues
> > mentioned by Jakub - I verified it solves a somewhat related problem in
> > my setup - and reduces the layering of heuristics in this area.
> >=20
> > A refactor introducing uniform overload detection and proper resource
> > control will be better, but I admit it's beyond me and anyway it could
> > still land afterwards.
> >=20
> > Any opinion more then welcome!
>=20
> Seems fine, but I think few things need to be fixed first in
> napi_threaded_poll()
> to enable some important features that are currently  in net_rx_action() =
only.

Thanks for the feedback.

I fear I'll miss some relevant bits.=C2=A0

On top of my head I think about RPS and  skb_defer_free. Both should
work even when napi threaded is enabled - with an additional softirq ;)
Do you think we should be able to handle both inside the napi thread?
Or do you refer to other features?

Thanks!

Paolo

