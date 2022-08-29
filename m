Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6B95A438D
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 09:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiH2HKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 03:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiH2HKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 03:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012731ADA3
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:10:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661757001;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g8cv676sSfaHjT/63KpLEv8mxIGZzQiHREOSs36nC/k=;
        b=c62ppTDL6l1A///+xmFlKOY6PLXnNAixiFwI5mVml5O0Tnmy6axnfChoMQSd1aGW+LxEOa
        vvPRxRKWX+jDzJFXe44HpjVAp4szdYDylF+gblDwQZpGUFXT5sg0z9gST/SwNug8HkkXhT
        3XtqSynJjHKVAH/l8g1c2M+ZceI/nuI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-61-UFG_NObJMiqcADVNP3evQg-1; Mon, 29 Aug 2022 03:10:00 -0400
X-MC-Unique: UFG_NObJMiqcADVNP3evQg-1
Received: by mail-qt1-f199.google.com with SMTP id ff27-20020a05622a4d9b00b0034306b77c08so5796227qtb.6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:10:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=g8cv676sSfaHjT/63KpLEv8mxIGZzQiHREOSs36nC/k=;
        b=unqKuEHZykRPturtVvxiXHWGgUFwl3wkzMUjcdmAt/ASGVhzPH6Xus3V3gR9CHRgIY
         jh9VVUFLaeuM0JWPg45JmWo4nU1sv5Zn9Yzv03MXErGQdwMHIOWiLILCyds0JWgojuni
         tqdyFc6BTCVsxG+1bMivGrOeqvlD0M+g6QJNC+Hq9Hz/hCa16Mgz0MpYDvGGrZZbAEnj
         mLc34Cr0NtdSj7WORMxV3Sx6W4AHjB8w2Gz8kwG+T4BqKtmdvKFILgkNQ9S5ci50gKfi
         2IlgQhfxt3U9Kqr7YM4XutP4qN5raPG/RHCGhhh6RkPwRNjQonNd1qeWhWgknubc5U56
         CCZw==
X-Gm-Message-State: ACgBeo03HDJ3++8f1dUlBiiTc4tpFDUj+ckSuEUxh6ZD1lKCUrCPi/jL
        oT2T0cI3wHldcsOjxpCs5C1cXdm6PI1BHMCi6EWXYrRXWoOx6RCgxNYR5NodeAP9+bwDTaN9ZKm
        7Zz/pBu4vk9smyUJlMjhk4FpaE6mqjfx5
X-Received: by 2002:a05:620a:2727:b0:6bb:b262:bfcb with SMTP id b39-20020a05620a272700b006bbb262bfcbmr7250835qkp.401.1661756999958;
        Mon, 29 Aug 2022 00:09:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7/qe7PAUDYIfhhX1bsEZWtG4KNZtMMKztNFGPolTTG+Hvf2IauzLExUB8mynJozhyeFxdhX2mukz0uUsQqoTg=
X-Received: by 2002:a05:620a:2727:b0:6bb:b262:bfcb with SMTP id
 b39-20020a05620a272700b006bbb262bfcbmr7250818qkp.401.1661756999739; Mon, 29
 Aug 2022 00:09:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220819082001.15439-1-ihuguet@redhat.com> <20220825090242.12848-1-ihuguet@redhat.com>
 <YwegaWH6yL2RHW+6@lunn.ch> <CACT4oufGh++TyEY-FdfUjZpXSxmbC0W2O-y4uprQdYFTevv2pw@mail.gmail.com>
 <YwjB84tvHAPymRRn@lunn.ch>
In-Reply-To: <YwjB84tvHAPymRRn@lunn.ch>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 29 Aug 2022 09:09:48 +0200
Message-ID: <CACT4oudsW5LNdwDbaKK7=DX9wiPua1cYdQ7DLuRsNoZmV8=tmQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] sfc: add support for PTP over IPv6 and 802.3
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, richardcochran@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 2:52 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Aug 26, 2022 at 08:58:31AM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > On Thu, Aug 25, 2022 at 6:17 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Thu, Aug 25, 2022 at 11:02:39AM +0200, =C3=8D=C3=B1igo Huguet wrot=
e:
> > > > Most recent cards (8000 series and newer) had enough hardware suppo=
rt
> > > > for this, but it was not enabled in the driver. The transmission of=
 PTP
> > > > packets over these protocols was already added in commit bd4a2697e5=
e2
> > > > ("sfc: use hardware tx timestamps for more than PTP"), but receivin=
g
> > > > them was already unsupported so synchronization didn't happen.
> > >
> > > You don't appear to Cc: the PTP maintainer.
> > >
> > >     Andrew
> > >
> >
> > I didn't think about that, but looking at MAINTAINERS, there doesn't
> > seem to be any. There are 2 maintainers for the drivers of the clock
> > devices, but none for anything related to the network protocol...
>
> PTP HARDWARE CLOCK SUPPORT
> M:      Richard Cochran <richardcochran@gmail.com>
> L:      netdev@vger.kernel.org
> S:      Maintained
> W:      http://linuxptp.sourceforge.net/
> F:      Documentation/ABI/testing/sysfs-ptp
> F:      Documentation/driver-api/ptp.rst
> F:      drivers/net/phy/dp83640*
> F:      drivers/ptp/*
> F:      include/linux/ptp_cl*
>
> I assume you are using linuxptp with this?
>
>   Andrew
>

I'm still not sure if this falls under his responsibility because it
doesn't affect the part of the clock device, but in any case it
doesn't hurt to CC him as you suggest. Thanks!

Richard, missed to CC you in this patch series, just in case it's of
your interest.

--=20
=C3=8D=C3=B1igo Huguet

