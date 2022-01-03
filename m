Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFFC9483583
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235207AbiACRXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiACRXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:23:04 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB257C061761;
        Mon,  3 Jan 2022 09:23:03 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 8BDD4419BC;
        Mon,  3 Jan 2022 17:22:53 +0000 (UTC)
Message-ID: <87cd5244-501d-1a3a-35d1-2687cf145bb9@marcan.st>
Date:   Tue, 4 Jan 2022 02:22:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 16/34] brcmfmac: acpi: Add support for fetching Apple ACPI
 properties
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
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
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-17-marcan@marcan.st>
 <CAHp75VcZcJ+zCDL-J+w8gEeKXGYdJajjLoa1JTj_kkJixrV12Q@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CAHp75VcZcJ+zCDL-J+w8gEeKXGYdJajjLoa1JTj_kkJixrV12Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/04 1:20, Andy Shevchenko wrote:
>     +void brcmf_acpi_probe(struct device *dev, enum brcmf_bus_type bus_type,
>     +                     struct brcmf_mp_device *settings)
>     +{
>     +       acpi_status status;
>     +       struct acpi_device *adev = ACPI_COMPANION(dev);
> 
> 
> Please, move the assignment closer to its first user 

So... two lines down? :-)

>   
> 
>     +       const union acpi_object *o;
>     +       struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
>     +
>     +       if (!adev)
>     +               return;
>     +
>     +       if (!ACPI_FAILURE(acpi_dev_get_property(adev, "module-instance",
>     +                                               ACPI_TYPE_STRING,
>     &o))) {
>     +               const char *prefix = "apple,";
>     +               int len = strlen(prefix) + o->string.length + 1;
>     +               char *board_type = devm_kzalloc(dev, len, GFP_KERNEL);
>     +
>     +               strscpy(board_type, prefix, len);
>     +               strlcat(board_type, o->string.pointer, 
> 
> 
> NIH devm_kasprintf()?

That sounds useful, didn't know that existed. Thanks!

>  
> 
>     +               brcmf_dbg(INFO, "ACPI module-instance=%s\n",
>     o->string.pointer);
>     +               settings->board_type = board_type;
>     +       } else {
>     +               brcmf_dbg(INFO, "No ACPI module-instance\n");
>     +       }
>     +
>     +       status = acpi_evaluate_object(adev->handle, "RWCV", NULL, &buf);
>     +       o = buf.pointer;
>     +       if (!ACPI_FAILURE(status) && o && o->type == ACPI_TYPE_BUFFER &&
>     +           o->buffer.length >= 2) {
>     +               char *antenna_sku = devm_kzalloc(dev, 3, GFP_KERNEL);
>     +
>     +               memcpy(antenna_sku, o->buffer.pointer, 2);
> 
> 
> NIH devm_kmemdup()?

Not *quite*. I take the first two bytes of the returned buffer and turn
them into a null-terminated 3-byte string. kmemdup wouldn't
null-terminate or would copy too much, depending on length.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
