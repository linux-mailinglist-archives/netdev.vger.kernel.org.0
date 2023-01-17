Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5380466DC8B
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236863AbjAQLev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbjAQLeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:34:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 529F04C0D;
        Tue, 17 Jan 2023 03:34:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id z11so44659860ede.1;
        Tue, 17 Jan 2023 03:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKImS4xgZOsDvWnmTXNW8sRtuXLN5RfP18E53XuTWcM=;
        b=GogbKFgPQId39gvfAWoJDB/zRT66rLjJj4UQLUBlsAod9GG/npc1Vo7H3jH4xSOCuk
         9NQoukwe6jMe0Vdpu8s4n9YK36QEYGlasZM0ZEhPX96a3nvDYRIu80u6o19/JBt4QHIB
         Fu1IiwkBg318wfK0NxllzzgMSEfXpNSncnn2ZiDrBW6H3Gt6daZnMglzF60idpBLVZzP
         OGLKFLLvqtClY+h2zNH27dx+cUBHvehk4+LpwPieNbm1ZZTAu26nZ7WWEkVs6t/c5K2X
         9oW3Cb09RyVulKbEF+ChuheaniPzkRTiS8AtD5VthWue85D9203qvIKhB2FTjMYVClmG
         VsAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JKImS4xgZOsDvWnmTXNW8sRtuXLN5RfP18E53XuTWcM=;
        b=j1AaWIedzTI1MjT22DAoOHi0B/eg96bBYPH4ZvfZVDgELeFNwOE9xjbavfaVPwNiaY
         sVSxdfJDf7OPgA5IZINjdwo70gfBEiYxhKM1pe9Z550V/EvmGsHJ3xIjWzUtW4ELmRbE
         iKFTpWZsZMVjtcERXsh8u3BGtEzq1+vNeCxd/XR2xGra22oo+iDDccTV0TipkRDsGSu6
         aTL0OM3lZ4HNslYNbpsq3jIPDJPUCiNBX1K2PBj57riDtTqnvqrKIKt34ESbnWiiu6Jq
         jxCvPSPWNho/BKZU+yqvEj4M0suptduhFv6oM+KmsczctfRP9wnyxzaimIuebA1unDi2
         z8oQ==
X-Gm-Message-State: AFqh2krmomhagnsrVv/u0RQtDseQ7J5tACd9Fhhgz8/4vogQmbsd7YP+
        Sdwbn+J4b5iB3KGBIpxnxCvDBo24vOkZ+BAONm8=
X-Google-Smtp-Source: AMrXdXuxXo1Ye9mc1Z724/7OCmaOvg3Bh7WMJO7SJXfcjrE1pbgQMmxAOFL7K17pgcaMl2KA5KiKug3aylxQqnWnpuw=
X-Received: by 2002:a50:e617:0:b0:49e:545:a815 with SMTP id
 y23-20020a50e617000000b0049e0545a815mr279275edm.265.1673955257810; Tue, 17
 Jan 2023 03:34:17 -0800 (PST)
MIME-Version: 1.0
References: <20230117092533.5804-1-magnus.karlsson@gmail.com> <87lem1ct2e.fsf@toke.dk>
In-Reply-To: <87lem1ct2e.fsf@toke.dk>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 17 Jan 2023 12:34:05 +0100
Message-ID: <CAJ8uoz2-tg2QWvaON2vJ9TrTQQO5K9NFvu=m-YXzYCAJcgB6Fg@mail.gmail.com>
Subject: Re: [PATCH net 0/5] net: xdp: execute xdp_do_flush() before napi_complete_done()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        mst@redhat.com, jasowang@redhat.com, ioana.ciornei@nxp.com,
        madalin.bucur@nxp.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 12:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>
> Magnus Karlsson <magnus.karlsson@gmail.com> writes:
>
> > Make sure that xdp_do_flush() is always executed before
> > napi_complete_done(). This is important for two reasons. First, a
> > redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> > napi context X on CPU Y will be follwed by a xdp_do_flush() from the
>
> Typo in 'followed' here (and in all the copy-pasted commit messages).
>
> > same napi context and CPU. This is not guaranteed if the
> > napi_complete_done() is executed before xdp_do_flush(), as it tells
> > the napi logic that it is fine to schedule napi context X on another
> > CPU. Details from a production system triggering this bug using the
> > veth driver can be found in [1].
> >
> > The second reason is that the XDP_REDIRECT logic in itself relies on
> > being inside a single NAPI instance through to the xdp_do_flush() call
> > for RCU protection of all in-kernel data structures. Details can be
> > found in [2].
> >
> > The drivers have only been compile-tested since I do not own any of
> > the HW below. So if you are a manintainer, please make sure I did not
>
> And another typo in 'maintainer' here.

Thanks for spotting. Will fix these spelling errors in a v2.

> > mess something up. This is a lousy excuse for virtio-net though, but
> > it should be much simpler for the vitio-net maintainers to test this,
> > than me trying to find test cases, validation suites, instantiating a
> > good setup, etc. Michael and Jason can likely do this in minutes.
> >
> > Note that these were the drivers I found that violated the ordering by
> > running a simple script and manually checking the ones that came up as
> > potential offenders. But the script was not perfect in any way. There
> > might still be offenders out there, since the script can generate
> > false negatives.
> >
> > [1] https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudfla=
re.com
> > [2] https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com=
/
>
> Otherwise LGTM!
>
> For the series:
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
