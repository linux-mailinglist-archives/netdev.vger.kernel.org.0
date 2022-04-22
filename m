Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89AF750ACE1
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 02:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442968AbiDVAnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 20:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiDVAnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 20:43:03 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6B33916D
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 17:40:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d15so7324362pll.10
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 17:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xjtU74ucVZNgzv+0qWyJ15WwTZkDByEH5Om1HFiAbAM=;
        b=Fz/mFy9kw+rzE8ZGbBELnhAyQbYzoqgY7hvmp4Ux6pg7/yYsd4RpuML3TysvLOGMWk
         gsoiq8+x1157m5QKwwibhrTb/zet1WHUP05TYvmYVX4eD4UKyYaP5J33EHQoAPH/zVnS
         ajV/jZaVSTbOQGwQ0qQRTmFs619rtYNPaq6ygO3yWC8WVK6VYyAoeBc0mGwbLEQ+xpCK
         ln59BiUfiXyZe2qOWMZ2342oBeLjzFjW7QWRo9UwhK1EVE46RxtCuZ7FcqEZy1BMaOdA
         zrZiHzsceZu9ihieJjNtCagb+XqKFXhD2iz3eaooabdCNtXmtNp6nA7fF63Sku2RH9E4
         g0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xjtU74ucVZNgzv+0qWyJ15WwTZkDByEH5Om1HFiAbAM=;
        b=PbNPKhbcHeSm3sZcGMICeQZZhopSypR8i4Awvc4cb+C4Khh1F3Vrq4UaAkmrecSBS+
         j1itFc01lOElNnrjEVImbD817spHNBiHh8OtzyKD6hgVpSNZRR0cA/jx8cMTnHi2sWDo
         UH0smjkoA5T7ncj5Mevrmtrz7uZccwVJVuuIS5WyAlf2yT5mSr3QoKJqO49bqYN9+0Zn
         GP6xdmX81WdfxY9HhuI15N6Y2DSepX3v+WC6apcpZw+Co+9RmfaPIUTRD69JSYmiP81o
         SwFs2OOzL9zBxtuHPAPgsIF551V0qAVkkfgikC88/0ZPStAPu/IbXxZlmiU0nFUAsaNT
         r4bA==
X-Gm-Message-State: AOAM530/SnnedWPuYt+2aQWdK1NhAjdvVgQHxG264LhQN63l4qGBNBR1
        9P2pcIQ6dgSu47QcQmuDvflG2A==
X-Google-Smtp-Source: ABdhPJwAGPUf2D0YMH0UebTpG5RelRZT80jZigbGASh8+XNBnQTM9R23VVYrwp4EvPgFaZjxMxncWg==
X-Received: by 2002:a17:90a:5886:b0:1d7:ba9e:d7c1 with SMTP id j6-20020a17090a588600b001d7ba9ed7c1mr2022019pji.20.1650588010129;
        Thu, 21 Apr 2022 17:40:10 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id n3-20020a056a000d4300b0050ac8dbfd0csm287094pfv.163.2022.04.21.17.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 17:40:09 -0700 (PDT)
Date:   Thu, 21 Apr 2022 17:40:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Charles-Francois Natali <cf.natali@gmail.com>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] WireGuard: restrict packet handling to non-isolated
 CPUs.
Message-ID: <20220421174007.0c210496@hermes.local>
In-Reply-To: <YmHwjdfZJJ2DeLTK@zx2c4.com>
References: <20220405212129.2270-1-cf.natali@gmail.com>
        <YmHwjdfZJJ2DeLTK@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 02:02:21 +0200
"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> netdev@ - Original thread is at
> https://lore.kernel.org/wireguard/20220405212129.2270-1-cf.natali@gmail.c=
om/
>=20
> Hi Charles-Fran=C3=A7ois,
>=20
> On Tue, Apr 05, 2022 at 10:21:29PM +0100, Charles-Francois Natali wrote:
> > WireGuard currently uses round-robin to dispatch the handling of
> > packets, handling them on all online CPUs, including isolated ones
> > (isolcpus).
> >=20
> > This is unfortunate because it causes significant latency on isolated
> > CPUs - see e.g. below over 240 usec:
> >=20
> > kworker/47:1-2373323 [047] 243644.756405: funcgraph_entry: |
> > process_one_work() { kworker/47:1-2373323 [047] 243644.756406:
> > funcgraph_entry: | wg_packet_decrypt_worker() { [...]
> > kworker/47:1-2373323 [047] 243644.756647: funcgraph_exit: 0.591 us | }
> > kworker/47:1-2373323 [047] 243644.756647: funcgraph_exit: ! 242.655 us
> > | }
> >=20
> > Instead, restrict to non-isolated CPUs. =20
>=20
> Huh, interesting... I haven't seen this feature before. What's the
> intended use case? To never run _anything_ on those cores except
> processes you choose? To run some things but not intensive things? Is it
> sort of a RT-lite?
>=20
> I took a look in padata/pcrypt and it doesn't look like they're
> examining the housekeeping mask at all. Grepping for
> housekeeping_cpumask doesn't appear to show many results in things like
> workqueues, but rather in core scheduling stuff. So I'm not quite sure
> what to make of this patch.
>=20
> I suspect the thing to do might be to patch both wireguard and padata,
> and send a patch series to me, the padata people, and
> netdev@vger.kernel.org, and we can all hash this out together.
>=20
> Regarding your patch, is there a way to make that a bit more succinct,
> without introducing all of those helper functions? It seems awfully
> verbose for something that seems like a matter of replacing the online
> mask with the housekeeping mask.
>=20
> Jason

Applications like DPDK that do polling often use isolcpus or cgroups
to keep unwanted rabble off of their cpus.  Having wireguard use those
cpus seems bad.
