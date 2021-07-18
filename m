Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582423CC9DF
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 18:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhGRQeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 12:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhGRQeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Jul 2021 12:34:21 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD10C061762;
        Sun, 18 Jul 2021 09:31:22 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id q190so14350816qkd.2;
        Sun, 18 Jul 2021 09:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lbh05RiC9h+30ZwLSJuzKF/YhVuILafOxJla7vQvCA0=;
        b=jmNWNzfIx2VINMPbOuBUsWw7VW5Q/BWYX9XhYEVPT4sPwF5HDm7MQrRaAbcG3JFPTj
         V0fsbZaWmM54ex9ja8pt32rWm5SqOzpPoisihs/387WycF2t43snthLEc08kMWxmHPg4
         9GSFYDG9wcdXDTrwtVfR6oqOzF3JvuwMnkDPR6jflnc2USTr0Qc18ygfc2E78DrBoEgI
         8mbrnnJje1MliJf/CTdrJC2F12vdPXdKvmJ39Rwy/qupeDIUmI9QkLh56j4WCeQR0a83
         I2lrPzaM8bGJno6oAXaAHm98gsP+nvZqxrCJmyf+MpTP/fddxjO3LMTnD/6mXjFXX/zg
         d3+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lbh05RiC9h+30ZwLSJuzKF/YhVuILafOxJla7vQvCA0=;
        b=Bj6RWrfJWbhOLnESD30NXsBTzjQN9noTCMkjma0hUTlcCDv9ERFgsppcFVL+hd9jR+
         7R2Wfmy6ZdWdgVQbXbRQ0BWnwdALuzjBE++VH/Oz4gCLLCZMvp5d69839PRnwHNeGkPd
         QzkcdroMpsl4iFbH0tKKyIOkX/xG2dI25iryEBbSPpCGaGT4GHdrpe1VH2GQcqIND7i6
         XiFU13SzN0GB5dcyLmqpWJPq8a7N3JeZLvgtpnfJ3UXyWeRLqDTFUufeiXFSa7zsNfjB
         bwQrB2py7rKNYT38XK4vGcRHCSfU5iVBhOmpRr09Dj5JpFNbOGw8PpDroZ0owf+Zjcok
         XUBw==
X-Gm-Message-State: AOAM530v6EJV8rChzzFiG/ewOTmQC33BN0LrcDdPoRzmAUbZ6axMWrZN
        MwzlaX6RzUFVz9PZyS1FAz6WwzLIBYvV658c8Ww=
X-Google-Smtp-Source: ABdhPJwdZrYq6+2AmWIqGSoKlOkdc1j95wY48iXw7BxS7NWHlKR+ilQMiiMkB4+eflmAtVVIaWMOKxa9rEMT2tFF+/A=
X-Received: by 2002:a05:620a:24c7:: with SMTP id m7mr19929203qkn.143.1626625881476;
 Sun, 18 Jul 2021 09:31:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAOSf1CGVpogQGAatuY_N0db6OL2BFegGtj6VTLA9KFz0TqYBQg@mail.gmail.com>
 <20210708154550.GA1019947@bjorn-Precision-5520>
In-Reply-To: <20210708154550.GA1019947@bjorn-Precision-5520>
From:   "Oliver O'Halloran" <oohall@gmail.com>
Date:   Mon, 19 Jul 2021 02:31:10 +1000
Message-ID: <CAOSf1CHtHLyEHC58jwemZS6j=jAU2OrrYitkUYmdisJtuFu4dw@mail.gmail.com>
Subject: Re: [PATCH 1/2] igc: don't rd/wr iomem when PCI is removed
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Aaron Ma <aaron.ma@canonical.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 9, 2021 at 1:45 AM Bjorn Helgaas <helgaas@kernel.org> wrote:
>
> *snip*
>
> Apologies for rehashing what's probably obvious to everybody but me.
> I'm trying to get a better handle on benign vs poisonous errors.
>
> MMIO means CPU reads or writes to the device.  In PCI, writes are
> posted and don't receive a response, so a driver will never see
> writel() return an error (although an error may be reported
> asynchronously via AER or similar).
>
> So I think we're mostly talking about CPU reads here.  We expect a PCI
> response containing the data.  Sometimes there's no response or an
> error response.  The behavior of the host bridge in these error cases
> is not defined by PCI, so what the CPU sees is not consistent across
> platforms.  In some cases, the bridge handles this as a catastrophic
> error that forces a system restart.
>
> But in most cases, at least on x86, the bridge logs an error and
> fabricates ~0 data so the CPU read can complete.  Then it's up to
> software to recognize that an error occurred and decide what to do
> about it.  Is this a benign or a poisonous error?
>
> I'd say this is a benign error. It certainly can't be ignored, but as
> long as the driver recognizes the error, it should be able to deal
> with it without crashing the whole system and forcing a restart.

I was thinking more in terms of what the driver author sees rather
than what's happening on the CPU side. The crash seen in the OP
appears to be because the code is "doing an MMIO." However, the
reasons for the crash have nothing to do with the actual mechanics of
the operation (which should be benign). The point I was making is that
the pattern of:

if (is_disconnected())
    return failure;
return do_mmio_read(addr);

does have some utility as a last-ditch attempt to prevent crashes in
the face of obnoxious bridges or bad hardware. Granted, that should be
a platform concern rather than something that should ever appear in
driver code, but considering drivers open-code readl()/writel() calls
there's not really any place to put that sort of workaround.

That all said, the case in the OP is due to an entirely avoidable
driver bug and that sort of hack is absolutely the wrong thing to do.

Oliver
