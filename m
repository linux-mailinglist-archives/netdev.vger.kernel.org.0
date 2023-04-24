Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92D56ED795
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233228AbjDXWKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233058AbjDXWKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:10:51 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20EAB975F
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:10:17 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-63b60366047so4120736b3a.1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:10:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1682374215; x=1684966215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bcdIqlfD6r1Te4RUWnyztXZ4ItJU4n1Xey64yq7aAno=;
        b=sCXnHzSOei7xLYqF0vUXEhaB+dEYsGfWwMEzZLhJY4nsErF5iMENi15xokGvdgKkop
         Ijt+Xq0hNxOyUdXE3JLpADa2dP0Tqgv6Muo2eMke+uVUo3guhLXoG3ex83C7uFHOa9cs
         FU+MmSSTXTx7AwgxgUENaBjrVn6SB5h/i5MQs/dujEMPNWbREfM8khJF9AkVXfZ9T8xi
         6sTzN+C6LmWj9n3xKAYRh+JtYB2gF/m33iit5Ex0JAezfZNSWEVPrs5vpoDZjyL94zzw
         zobh6yOROlldxbZPEXl07g/eBx7g5NjQzCZq33UXaJgoqNjW5J+5C4s1BTcJ26eQS5z0
         xCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682374215; x=1684966215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bcdIqlfD6r1Te4RUWnyztXZ4ItJU4n1Xey64yq7aAno=;
        b=fhwa2mWADXq+ZFqyDTjtrg0rtsB+FgBLST4loF111Z3smLwiz6T+P1N+652CU/8M37
         JvUSw2FqNgvyRqw2oElHGhFOtjqdlb+C6WE5GLueB8o7nrkognXpPj1Gg2OUx/vkpN6Y
         MQdCTMeoM0z1fKAPl/gTG+LikqZY1BDJCaSeVXg9yDOohH841nk7cV1jYOCbqBV9+gJf
         kgsZMICobFSoqplXWSOgr/VwDOIaDPQMF+K4kKYssJRCb+EmSV5uIUpJzW5DALgh2WBL
         omuPS2R8ZrhluP0V4UP2k9vTeJFLy33szewKFTZdebeBQwuQJddswh+q94L3AZbduY7C
         2xoQ==
X-Gm-Message-State: AAQBX9euHJCVyZP84Zl103ca9vEw2glLEpyvPlz0SWW0qzIW761Si8YJ
        IvTCF6H2RpgHWsQ+uGawtcaeqQ==
X-Google-Smtp-Source: AKy350aW7Hp8DrNPhecRTWlsffjAK/fjb6kw3PWBWw0Xvv9GecpSuyDHaz1W2kI4pT8NcoksX4D3JQ==
X-Received: by 2002:a05:6a00:248e:b0:63f:185a:6db2 with SMTP id c14-20020a056a00248e00b0063f185a6db2mr19161318pfv.18.1682374215640;
        Mon, 24 Apr 2023 15:10:15 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y5-20020a056a00180500b0063b733fdd33sm7894508pfa.89.2023.04.24.15.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 15:10:13 -0700 (PDT)
Date:   Mon, 24 Apr 2023 15:10:11 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kernel@mojatatu.com
Subject: Re: [PATCH net v2] net/sched: act_mirred: Add carrier check
Message-ID: <20230424151011.0f8cd8b3@hermes.local>
In-Reply-To: <CAM0EoM==4T=64FH7t4taURugM4d0Stv2oXFgr5+qNBNEe9bjwQ@mail.gmail.com>
References: <20230424170832.549298-1-victor@mojatatu.com>
        <20230424173602.GA27649@unreal>
        <20230424104408.63ba1159@hermes.local>
        <CAM0EoMnM-s4M4HFpK1MVr+ey6PkU=uzwYsUipc1zBA5RPhzt-A@mail.gmail.com>
        <20230424143651.53137be4@kernel.org>
        <CAM0EoM==4T=64FH7t4taURugM4d0Stv2oXFgr5+qNBNEe9bjwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 17:53:03 -0400
Jamal Hadi Salim <jhs@mojatatu.com> wrote:

> On Mon, Apr 24, 2023 at 5:36=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> =
wrote:
> >
> > On Mon, 24 Apr 2023 13:59:15 -0400 Jamal Hadi Salim wrote: =20
> > > > Then fix the driver. It shouldn't hang.
> > > > Other drivers just drop packets if link is down. =20
> > >
> > > We didnt do extensive testing of drivers but consider this a safeguard
> > > against buggy driver (its a huge process upgrading drivers in some
> > > environments). It may even make sense to move this to dev_queue_xmit()
> > > i.e the arguement is: why is the core sending a packet to hardware
> > > that has link down to begin with? BTW, I believe the bridge behaves
> > > this way ... =20
> >
> > I'm with Stephen, even if the check makes sense in general we should
> > first drill down into the real bug, and squash it. =20
>=20
> Ok then, I guess in keeping up with the spirit of trivial patches
> generating the most discussion, these are two separate issues in my
> opinion: IOW, the driver bug should be fixed (we have reached out to
> the  vendor) - but the patch stands on its own.

There are many other ways packet could arrive at driver when link
is down. You are addressing only one small corner case by patching
mirred.
