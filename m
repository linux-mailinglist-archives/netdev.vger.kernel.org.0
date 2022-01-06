Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD6486357
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 12:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238222AbiAFLAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 06:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238102AbiAFK77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 05:59:59 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3C9C061245;
        Thu,  6 Jan 2022 02:59:59 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 1413A41F5D;
        Thu,  6 Jan 2022 10:59:47 +0000 (UTC)
Message-ID: <c23cb138-e32f-d770-6fab-4a3ae5c23ea1@marcan.st>
Date:   Thu, 6 Jan 2022 19:59:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 03/35] brcmfmac: firmware: Handle per-board clm_blob
 files
Content-Language: en-US
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-4-marcan@marcan.st>
 <955f3b68-f1aa-767c-2539-7b8362372a60@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <955f3b68-f1aa-767c-2539-7b8362372a60@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/06 19:19, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> Teach brcm_alt_fw_paths to correctly split off variable length
>> extensions, and enable alt firmware lookups for the CLM blob firmware
>> requests.
>>
>> Apple platforms have per-board CLM blob files.
> 
> Are you sure? I am not involved in development for Apple platforms, but 
> in general we build a CLM blob specific for a chip revision. As always 
> with the blobs they are created at a certain point in time and that is 
> mostly why you need another one for a newer platform. Apple tends to do 
> things a bit different so you could be right though. Anyway, despite my 
> doubts on this it does not change the need for per-board firmware files.

Yup, I'm sure. The 2021 MacBook Pro 14" and the MacBook Pro 16", both
using BCM4387 and both released simultaneously, have different CLM
blobs; they're even a significantly different size. Running `strings` on
the files yields:

CLM DATA
Oly.Maldives
1.61.4
ClmImport: 1.63.1
v3 Final 210923

CLM DATA
Oly.Madagascar
1.61.4
ClmImport: 1.63.1
v4 Final 210923

The data shows significant differences and since the file format is
opaque I can't know what's going on. Even if it's safe to use one file
for both, unless there is some way for me to programmatically identify
this fact so I can incorporate that logic into my firmware copier, I
would much rather just keep them separate like Apple does.

> So all firmware files are attempted with board-specific path now.

Yes, I figured I'd keep things uniform. Technically for Apple platforms
the CLM blob and firmware are only per-board and possibly per-antenna
(they don't need the module variants, those are for nvram only), but
there's no real harm in unifying it and using the same firmware naming
alt path list for everything.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
