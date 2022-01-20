Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040BF494728
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 07:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358674AbiATGNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 01:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiATGNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 01:13:22 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82BBAC061574;
        Wed, 19 Jan 2022 22:13:22 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id E5C2F4246A;
        Thu, 20 Jan 2022 06:13:13 +0000 (UTC)
Subject: Re: [PATCH v3 3/9] brcmfmac: firmware: Do not crash on a NULL
 board_type
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
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
References: <20220117142919.207370-1-marcan@marcan.st>
 <20220117142919.207370-4-marcan@marcan.st>
 <CAHp75VfZ+thU+AWeOQSC9Dqq3MO+GMb_8oPxqMEbaxYTH0PH5A@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <d3d46724-6e36-95d1-b614-90ac1811f672@marcan.st>
Date:   Thu, 20 Jan 2022 15:13:11 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VfZ+thU+AWeOQSC9Dqq3MO+GMb_8oPxqMEbaxYTH0PH5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/01/2022 06.45, Andy Shevchenko wrote:
> On Mon, Jan 17, 2022 at 4:30 PM Hector Martin <marcan@marcan.st> wrote:
>>
>> This unbreaks support for USB devices, which do not have a board_type
>> to create an alt_path out of and thus were running into a NULL
>> dereference.
> 
> In v5.16 we have two call sites:
> 
> 1.
>   if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
>     ...
>     alt_path = brcm_alt_fw_path(cur->path, fwctx->req->board_type);
> 
> 2.
>   alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
>   if (alt_path) {
>     ...
> 
> Looking at them I would rather expect to see (as a quick fix, the
> better solution is to unify those call sites by splitting out a common
> helper):
> 
>   if (fwctx->req->board_type) {
>     alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
>   else
>     alt_path = NULL;
>    ...
> 

Since brcm_alt_fw_path can fail anyway, and its return value is already
NULL-checked, it makes sense to propagate the NULL board_path there
rather than doing it at all the callsites. That's a common pattern, e.g.
the entire DT API is designed to accept NULL nodes. That does mean that
the first callsite has a redundant NULL check, yes, but that doesn't hurt.

This is all going to change with subsequent patches anyway; the point of
this patch is just to fix the regression.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
