Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42903DF4BA
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238834AbhHCS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238793AbhHCS1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 14:27:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 828EF60F38;
        Tue,  3 Aug 2021 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628015251;
        bh=b5coXSNVumOlwboi0Y8EY/7mMzZofAt1yR97rrjEWuo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EnOniVccHYcbPUOoldYN5TcX8f3C+JRnuXOHZxWbtWJMY1Ak5Rft8Yu9IVWd25mIX
         iudADck47r7/bo4UFcQvUYnq8hgDIIjzrESTJ2ktslvjw9WlMl0U28hVWKLw//VWBu
         d1HQGlOXqV5jyTRfDykOOCsp1cM4DsXuauWnSHlIWKyLmujnwW7Gg7191OH5tv9Ysa
         r6GOfrOdkaj5I9PQoVYzh6TzMNLgh8Feahn8l0jBdxFecoTVsgKs5oI/+U3jfHaBUZ
         e/xx8m2hml8eTRRgpcXieQrEUdQnt/C/QMfdHCIeBhVM3y7czlpbR6cVa19JB2U3FE
         Bn+jkASbimQIA==
Received: by mail-wm1-f48.google.com with SMTP id l11-20020a7bcf0b0000b0290253545c2997so2677634wmg.4;
        Tue, 03 Aug 2021 11:27:31 -0700 (PDT)
X-Gm-Message-State: AOAM533jmkLPA1WOaooXymw+poBR9UqPrAzNR03Qht7E92QkvtT1XYkS
        +claN/LL0w43SmIRYzUubf67gbIQvsq9tSVH1+Y=
X-Google-Smtp-Source: ABdhPJyjyh5NW4HNDbY103glgZvlOfMtw6fuLPusi+3xAq38xsO4vRLS5MKwwQ0mEBFcXf8KsEzBXD0TMoyA7M3oU3E=
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr5573870wmm.120.1628015250107;
 Tue, 03 Aug 2021 11:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145937.1155571-1-arnd@kernel.org> <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com> <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org> <20210803161434.GE32663@hoboy.vegasvil.org>
 <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com> <CO1PR11MB50892EAF3C871F6934B85852D6F09@CO1PR11MB5089.namprd11.prod.outlook.com>
In-Reply-To: <CO1PR11MB50892EAF3C871F6934B85852D6F09@CO1PR11MB5089.namprd11.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 3 Aug 2021 20:27:14 +0200
X-Gmail-Original-Message-ID: <CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com>
Message-ID: <CAK8P3a06enZOf=XyZ+zcAwBczv41UuCTz+=0FMf2gBz1_cOnZQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 3, 2021 at 7:19 PM Keller, Jacob E <jacob.e.keller@intel.com> w=
rote:
> > On Tue, Aug 3, 2021 at 6:14 PM Richard Cochran <richardcochran@gmail.co=
m> wrote:

> There is an alternative solution to fixing the imply keyword:
>
> Make the drivers use it properly by *actually* conditionally enabling the=
 feature only when IS_REACHABLE, i.e. fix ice so that it uses IS_REACHABLE =
instead of IS_ENABLED, and so that its stub implementation in ice_ptp.h act=
ually just silently does nothing but returns 0 to tell the rest of the driv=
er things are fine.

I would consider IS_REACHABLE() part of the problem, not the solution, it m=
akes
things magically build, but then surprises users at runtime when they do no=
t get
the intended behavior.

      Arnd
