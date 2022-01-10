Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79386489AE5
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbiAJNzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:55:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41362 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbiAJNzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:55:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFE8DB81654;
        Mon, 10 Jan 2022 13:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBDDC36AE5;
        Mon, 10 Jan 2022 13:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641822904;
        bh=rj4fKmBFoTHA0iE6ZmISK6tpcbjzpc6k3C0OppRQfXI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mLOFKpfG5t6VcVdIo8HnBo4TNSUN0tKjo69CxcZVSODX4E/wp4Qq2JAJ/RDV2iBbg
         18oBED1NTpckFJA7zbUwmTe1QZE4Wrro1ocg82W3n7wpQftGoLJTQU3AGP/LJ9nGtl
         Q1izKRVSRFl6rZoA9r+DPbZMSAWeVNeOvLI1TwuOkyOMR0Vxizmi4PdQpSPxz5GxbU
         IUGNwPnsHWCL6bNde0DXS2J3fJM+zoTRiiZyZjjXvYXH9EbYJcQEeV9hygDLBG7CEx
         yorgSW3rmF3Zs+Ti399XXtPitqyOhR30/IelIneFxcNpCUNwpdPhrkyTKHSXYqYfRA
         etY7UfhX/G3nQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list\:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH v2 12/35] brcmfmac: pcie: Fix crashes due to early IRQs
References: <20220104072658.69756-1-marcan@marcan.st>
        <20220104072658.69756-13-marcan@marcan.st>
        <CAHp75VdeNhmRUW1mFY-H5vyzTRHZ9Y2dv03eo+rfcTQKjn9tuQ@mail.gmail.com>
        <759f46bd-bfc2-62c6-6257-a2a0d702e2b6@marcan.st>
Date:   Mon, 10 Jan 2022 15:54:54 +0200
In-Reply-To: <759f46bd-bfc2-62c6-6257-a2a0d702e2b6@marcan.st> (Hector Martin's
        message of "Thu, 6 Jan 2022 22:10:45 +0900")
Message-ID: <87bl0jlmq9.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> writes:

> On 04/01/2022 23.12, Andy Shevchenko wrote:
>> On Tue, Jan 4, 2022 at 9:29 AM Hector Martin <marcan@marcan.st> wrote:
>>>
>>> The driver was enabling IRQs before the message processing was
>>> initialized. This could cause IRQs to come in too early and crash the
>>> driver. Instead, move the IRQ enable and hostready to a bus preinit
>>> function, at which point everything is properly initialized.
>>>
>>> Fixes: 9e37f045d5e7 ("brcmfmac: Adding PCIe bus layer support.")
>> 
>> You should gather fixes at the beginning of the series, and even
>> possible to send them as a separate series. In the current state it's
>> unclear if there are dependencies on your new feature (must not be for
>> fixes that meant to be backported).
>> 
>
> Thanks, I wasn't sure what order you wanted those in. I'll put them at
> the top for v3. I think none of those should have any dependencies on
> the rest of the patches, modulo some trivial rebase wrangling.

If there are no dependencies, please send the brcmfmac fixes separately
so that I can apply them earlier.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
