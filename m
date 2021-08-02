Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006733DDB2E
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhHBOh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhHBOh7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:37:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7EA760F5A;
        Mon,  2 Aug 2021 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627915069;
        bh=rjcQFbefs4y8JgCbUFdJmgVkXkThVhcwqF9WjgoJ+Qo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AGjDHM9zoZPQcQ1/pFuwYYKiW7tWnt6cXUBqqRX0DQIFsMIpy4MS+2E2mSMbcyH0/
         uGVd3PF/DEkXYoTs03fpVZDpKfCNCYYIOMS1IeaAObHxH1X0CrcGnfnESnWkDLuE7D
         fGKsdmEmw72k9cxtW3bGaUp1GoUes1itvEl0D/G6SdjUO5rKNFVEBald3rv2D7obxw
         EcMGlTFylFkv3c1lL2I8B+7jMqkQspRafaG37PmQBq/pm5pxzxQRWaWjMmGRCzdvyU
         oz3ogpGHtKb8Yrnsq7fmJCqWcDUgblaStB+jFYjNMPlU1yQu5jL/cyTIbIniUO4fP0
         QYWK9wbWArvmQ==
Received: by mail-wm1-f48.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so8509980wms.2;
        Mon, 02 Aug 2021 07:37:49 -0700 (PDT)
X-Gm-Message-State: AOAM533wkjgxel0mit8wO03GeCVGIv7lSwXY04S+cErTWR/8IBunu1w8
        VIVGjQVu17DCbGTxWEYxghpvJMthuSpDyp+/MYM=
X-Google-Smtp-Source: ABdhPJz2CjiBj+grqC6TsAgL3UXrYpUYw974570svL7N/F/FFAMi39HARl7wlXhmOQD3aMN8wkEdOY4DSpgmMaDTJJ8=
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr8196846wmq.43.1627915068330;
 Mon, 02 Aug 2021 07:37:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210726084540.3282344-1-arnd@kernel.org> <BYAPR11MB336781A3C6B41DFFFD838157FCEF9@BYAPR11MB3367.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB336781A3C6B41DFFFD838157FCEF9@BYAPR11MB3367.namprd11.prod.outlook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 16:37:32 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3g60Rg5XxEk+DUUy6pSkSw4TDK7R52Sy6zEVba3O6WsA@mail.gmail.com>
Message-ID: <CAK8P3a3g60Rg5XxEk+DUUy6pSkSw4TDK7R52Sy6zEVba3O6WsA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     "G, GurucharanX" <gurucharanx.g@intel.com>
Cc:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "intel-wired-lan-bounces@osuosl.org" 
        <intel-wired-lan-bounces@osuosl.org>,
        Richard Cochran <richardcochran@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 3:10 PM G, GurucharanX <gurucharanx.g@intel.com> wrote:
> >
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The 'imply' keyword does not do what most people think it does, it only
> > politely asks Kconfig to turn on another symbol, but does not prevent it from
> > being disabled manually or built as a loadable module when the user is built-
> > in. In the ICE driver, the latter now causes a link failure:
...
> Tested-by: Gurucharan  G <Gurucharanx.g@intel.com> (A Contingent Worker at Intel)

Sorry for the delay. I had remembered that there was a previous discussion
about that option but couldn't find the thread at first.

I now found
https://lore.kernel.org/netdev/CAK8P3a3=eOxE-K25754+fB_-i_0BZzf9a9RfPTX3ppSwu9WZXw@mail.gmail.com/

and will add Richard to Cc for my new version as well, just in case he
has objections
to this version and wants to fix it differently.

       Arnd
