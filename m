Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643373E1467
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239222AbhHEMFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:05:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232222AbhHEMFn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:05:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04CD661155;
        Thu,  5 Aug 2021 12:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628165129;
        bh=Ck+H5fHI4Uj5s8lLUfFUqZDAYUKh5122ORxvtmz/diU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ojAQ0/Bvj/hG6iywm8KiqE05dPpMEvxcfSxBvuCla2Apr2GSomNOZy/me748qcNBf
         /pneQ0yIZmcxZxE5+WZIWlbXLnbrLL1MOjrsJY0G18YtgmGBDoPSnmqCqw3tBAs2ZW
         6+K8oa2lPLSb3Oo9wo3Xh+Fp3gq6uFlW2HpG055EsA0+tNscKhvrCSOjDLfz0nO9Gs
         JHgxoO2kry+/ilfrvdo+LVBAB13g1pHJ8wr9Xx0++gS/RFAkaX9eUKavPFgryNymxi
         986wF2pUQzg1oBPgm0RxnRKeA7MFXGZ5lwo2JQ1QQpagI+zGQNNTtJNFLNjjZsYGEn
         9n34ZvNmViWsQ==
Received: by mail-wm1-f46.google.com with SMTP id n11so3191260wmd.2;
        Thu, 05 Aug 2021 05:05:28 -0700 (PDT)
X-Gm-Message-State: AOAM5333ooI6l7/YwMxByICGoL67Pnt4CNi2p80OsyBlcnPs185VBSsM
        5fWjW08i0Zcj+bstOKsdQunF6kc1Y5g4rPuI8s4=
X-Google-Smtp-Source: ABdhPJzAfd9uLhTu78AQivM2yBgntkHqfEKvNqhhAmF5n8E+GHRMhqoKm0bwhIJJSnrxZVM9ikU7c363gPqVeaTy6cc=
X-Received: by 2002:a05:600c:3641:: with SMTP id y1mr4545036wmq.43.1628165127559;
 Thu, 05 Aug 2021 05:05:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210805110048.1696362-1-arnd@kernel.org> <20210805112546.gitosuu7bzogbzyf@skbuf>
 <CAK8P3a0w95+3dBo5OLeCsEi8gjmFqabnSeqeNPQq49=rPeRm=A@mail.gmail.com> <20210805114946.n46mumz2re7fxdto@skbuf>
In-Reply-To: <20210805114946.n46mumz2re7fxdto@skbuf>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Thu, 5 Aug 2021 14:05:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3csnad2Ote5JeRAdTwToZNa-2+DGwUs62sobU-ESWmbQ@mail.gmail.com>
Message-ID: <CAK8P3a3csnad2Ote5JeRAdTwToZNa-2+DGwUs62sobU-ESWmbQ@mail.gmail.com>
Subject: Re: [PATCH net-next] dsa: sja1105: fix reverse dependency
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 5, 2021 at 1:49 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Thu, Aug 05, 2021 at 01:39:34PM +0200, Arnd Bergmann wrote:
> > Do you have any opinion on whether that 'select' going the other way is still
> > relevant?
>
> Yes, of course it is. It also has nothing to do with build dependencies.
> With the original DSA design from 2008, an Ethernet switch has separate
> drivers for
> (a) accessing its registers
> (b) manipulating the packets that the switch sends towards a host
>     Ethernet controller ("DSA master")
>
> The register access drivers are in drivers/net/dsa/*, the packet
> manipulation ("tagging protocol") drivers are in net/dsa/tag_*.c.
>
> [ This is because it was originally thought that a "tagging protocol" is
>   completely stateless and you should never need to access a hardware
>   register when manipulating a packet. ]
>
> When you enable a driver for a switch, you absolutely want to ping
> through it too, so all register access drivers enable the tagging
> protocol driver specific to their hardware as well, using 'select'.
> This works just fine because tagging protocol drivers generally have no
> dependencies, or if they do, the register access driver inherits them too.
> So a user does not need to manually enable the tagging protocol driver.

Got it, thanks for the explanation.

      Arnd
