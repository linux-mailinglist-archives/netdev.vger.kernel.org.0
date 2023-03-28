Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A24A6CBB1D
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbjC1Jdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbjC1JdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B227E86AF
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679995770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fw+UNgg8tbQKJQVmaoiT613D8teaf+aPc3V9zje+IMk=;
        b=I5opOQrpGw94Zk4iG0DkP/Z3AnCuE7i+IDSFyniYD6hztRg0Ix2gSPop/LjOU0malFqvH8
        vTiCMPvw94ta3vklGap9dWkn7JB+6i59iVdxL1bkr72Ib2T9rPjy4GfyV8bu1wTptREBWy
        z5EwuElvI/b8fyd8G5lOwCGvu4DI11A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-lvj20K2tPhmp1gDoBgSvWw-1; Tue, 28 Mar 2023 05:29:29 -0400
X-MC-Unique: lvj20K2tPhmp1gDoBgSvWw-1
Received: by mail-qv1-f69.google.com with SMTP id h7-20020a0cd807000000b005dd254e7babso4739521qvj.14
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679995768; x=1682587768;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fw+UNgg8tbQKJQVmaoiT613D8teaf+aPc3V9zje+IMk=;
        b=L1chU3QMtprZy6V7/6u77yPPWsVTGqZTIrDh1S7w+RXsX2+U5d/6onfN++JEeExhAR
         0rDVISf9WGN7kD3w1QXCUf5OVITODDeXhEXi4g9cNh15Cc+niLJEA28tPTtLc2Njw6rm
         m7QEfZ32w8TaPNqlFphF+tMmav4wSNZ47xKXxIzG/2nzE+1SLFWJGgVD7+qNoH1KylAx
         Qi6tZKmypZ3s8qoWCQneaA/V6UmsrF0x1sm8KMBxPP2B9LmSw5C8Efx0tPsGkzUnSZzS
         gQWqntT7D5Ir8nU1egT3tssjeCpZG/A7t3uvlwznTZBBU0tMLBuCMAB2iNCIKY3Tm2yy
         z/jA==
X-Gm-Message-State: AAQBX9dEKHqZLjBDynk9jntMLNN08DrAPH6HPagWKs/t1r7/z2EPUpk6
        bCAmg9jmTL1c/IIiJNvkqa+1SzEepmdmQA7MU9I11zrLqULyFRsZCRL1TqfaZO9qqHYYd5fEFED
        /yN6G8bIrk5qWn2IpDzFJiOgG
X-Received: by 2002:ad4:5c82:0:b0:59b:920e:1f9a with SMTP id o2-20020ad45c82000000b0059b920e1f9amr23301368qvh.2.1679995768421;
        Tue, 28 Mar 2023 02:29:28 -0700 (PDT)
X-Google-Smtp-Source: AKy350Yhosdb9jRnfDlVMSbhVbs3enUteMjYgbNDq5BkkD1Z+eB1egG4zioOle5Y5B0ENyz3O9JJaQ==
X-Received: by 2002:ad4:5c82:0:b0:59b:920e:1f9a with SMTP id o2-20020ad45c82000000b0059b920e1f9amr23301349qvh.2.1679995768123;
        Tue, 28 Mar 2023 02:29:28 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-148.dyn.eolo.it. [146.241.232.148])
        by smtp.gmail.com with ESMTPSA id lx12-20020a0562145f0c00b005dd8b9345bdsm3621117qvb.85.2023.03.28.02.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 02:29:27 -0700 (PDT)
Message-ID: <751fd5bb13a49583b1593fa209bfabc4917290ae.camel@redhat.com>
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
From:   Paolo Abeni <pabeni@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 28 Mar 2023 11:29:24 +0200
In-Reply-To: <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
References: <20230324171314.73537-1-nbd@nbd.name>
         <20230324102038.7d91355c@kernel.org>
         <2d251879-1cf4-237d-8e62-c42bb4feb047@nbd.name>
         <20230324104733.571466bc@kernel.org>
         <f59ee83f-7267-04df-7286-f7ea147b5b49@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-03-24 at 18:57 +0100, Felix Fietkau wrote:
> On 24.03.23 18:47, Jakub Kicinski wrote:
> > On Fri, 24 Mar 2023 18:35:00 +0100 Felix Fietkau wrote:
> > > I'm primarily testing this on routers with 2 or 4 CPUs and limited=
=20
> > > processing power, handling routing/NAT. RPS is typically needed to=
=20
> > > properly distribute the load across all available CPUs. When there is=
=20
> > > only a small number of flows that are pushing a lot of traffic, a sta=
tic=20
> > > RPS assignment often leaves some CPUs idle, whereas others become a=
=20
> > > bottleneck by being fully loaded. Threaded NAPI reduces this a bit, b=
ut=20
> > > CPUs can become bottlenecked and fully loaded by a NAPI thread alone.
> >=20
> > The NAPI thread becomes a bottleneck with RPS enabled?
>=20
> The devices that I work with often only have a single rx queue. That can
> easily become a bottleneck.
>=20
> > > Making backlog processing threaded helps split up the processing work=
=20
> > > even more and distribute it onto remaining idle CPUs.
> >=20
> > You'd want to have both threaded NAPI and threaded backlog enabled?
>=20
> Yes
>=20
> > > It can basically be used to make RPS a bit more dynamic and=20
> > > configurable, because you can assign multiple backlog threads to a se=
t=20
> > > of CPUs and selectively steer packets from specific devices / rx queu=
es=20
> >=20
> > Can you give an example?
> >=20
> > With the 4 CPU example, in case 2 queues are very busy - you're trying
> > to make sure that the RPS does not end up landing on the same CPU as
> > the other busy queue?
>=20
> In this part I'm thinking about bigger systems where you want to have a
> group of CPUs dedicated to dealing with network traffic without
> assigning a fixed function (e.g. NAPI processing or RPS target) to each
> one, allowing for more dynamic processing.
>=20
> > > to them and allow the scheduler to take care of the rest.
> >=20
> > You trust the scheduler much more than I do, I think :)
>=20
> In my tests it brings down latency (both avg and p99) considerably in
> some cases. I posted some numbers here:
> https://lore.kernel.org/netdev/e317d5bc-cc26-8b1b-ca4b-66b5328683c4@nbd.n=
ame/

It's still not 110% clear to me why/how this additional thread could
reduce latency. What/which threads are competing for the busy CPU[s]? I
suspect it could be easier/cleaner move away the others (non RPS)
threads.

Cheers,

Paolo


