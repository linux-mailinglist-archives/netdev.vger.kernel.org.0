Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906E33DE0B9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 22:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhHBUci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 16:32:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230448AbhHBUcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 16:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2325360F93;
        Mon,  2 Aug 2021 20:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627936346;
        bh=RjKhF4hB/2KcuyIWUfAzYtZZ8R9Gf1asDHL4YKxZRlk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=XoKTKyFs/895DJ6gXNmOgln+KqAa1z/0hs5DJFFQCBLqrUB564mpKLe6QnoO5cP9j
         wxRdd4t9mU89DkAij4LuWxqWQDtN/neVRA4rHZLlrjwb6JBunIp0V+HOFOLKUtlGpQ
         s34cVHvM020folN28dy0+Twb4aP68R0ri4L7UYw1CGgMjIf/6cTwKLJu/xBV9csgC1
         DtKKBTE/EWHmPw1tbLdI84zn5VzRc261nA6egX6EYiLIMBbVQvbJUJXzF7lZpPxGD8
         NPUOwBOJNSX2q1lHqjin2RYHrl1kOMEGOdPDEhdigZ0kNZDZim5dO8cUpfDSasDaVL
         QvjmZ9EnV57DA==
Received: by mail-wm1-f47.google.com with SMTP id n11so11151866wmd.2;
        Mon, 02 Aug 2021 13:32:26 -0700 (PDT)
X-Gm-Message-State: AOAM532sSqzUHJ6slFAIVFW1KtkwZG4IH6ocOy+YOZgwefTJCVOIXrTz
        5ofSlaCllwtbwx4mnj0LTWxc6aqZDputlPgR1W8=
X-Google-Smtp-Source: ABdhPJzYGkFqLqspaoCqN00TaY6q2TQGENW8z+Kn/ypsgZ93keijuGyG0Uyz98n3cAQoC3RU3kB3ITgGfxsX8sNbmis=
X-Received: by 2002:a7b:ce10:: with SMTP id m16mr626048wmc.75.1627936344707;
 Mon, 02 Aug 2021 13:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210802145937.1155571-1-arnd@kernel.org> <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
In-Reply-To: <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 2 Aug 2021 22:32:08 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
Message-ID: <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK dependencies
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 9:54 PM Keller, Jacob E <jacob.e.keller@intel.com> wrote:
>
> So go back to "select"?
>
> It looks like Arnd proposed in the thread a solution that did a sort of
> "please enable this" but still let you disable it.
>
> An alternative (unfortunately per-driver...) solution was to setup the
> drivers so that they gracefully fall back to disabling PTP if the PTP
> core support is not reachable.. but that obviously requires that drivers
> do the right thing, and at least Intel drivers have not tested this
> properly.
>
> I'm definitely in favor of removing "implies" entirely. The semantics
> are unclear, and the fact that it doesn't handle the case of "i'm
> builtin, so my implies can't be modules"...
>
> I don't really like the syntax of the double "depends on A || !A".. I'd
> prefer if we had some keyword for this, since it would be more obvious
> and not run against the standard logic (A || !A is a tautology!)

I think the main reason we don't have a keyword for it is that nobody
so far has come up with an English word that expresses what it is
supposed to mean.

You can do something like it for a particular symbol though, such as

config MAY_USE_PTP_1588_CLOCK
       def_tristate PTP_1588_CLOCK || !PTP_1588_CLOCK

 config E1000E
        tristate "Intel(R) PRO/1000 PCI-Express Gigabit Ethernet support"
        depends on PCI && (!SPARC32 || BROKEN)
+       depends on MAY_USE_PTP_1588_CLOCK
        select CRC32
-       imply PTP_1588_CLOCK


          Arnd
