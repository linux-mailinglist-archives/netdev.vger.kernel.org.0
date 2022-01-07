Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA73C487183
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiAGDxi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiAGDxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:53:37 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F64BC061245;
        Thu,  6 Jan 2022 19:53:37 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id F13F24212E;
        Fri,  7 Jan 2022 03:53:26 +0000 (UTC)
Message-ID: <4625b434-ed73-d266-0340-76c8bd8fd46e@marcan.st>
Date:   Fri, 7 Jan 2022 12:53:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 07/35] brcmfmac: pcie: Read Apple OTP information
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
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-8-marcan@marcan.st>
 <CAHp75VcHjGAVog31AHaVLAq452=h=tqEN-1GNm_Aiu3113oTLA@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CAHp75VcHjGAVog31AHaVLAq452=h=tqEN-1GNm_Aiu3113oTLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/04 20:26, Andy Shevchenko wrote:
> On Tue, Jan 4, 2022 at 9:28 AM Hector Martin <marcan@marcan.st> wrote:
>>
>> On Apple platforms, the One Time Programmable ROM in the Broadcom chips
>> contains information about the specific board design (module, vendor,
>> version) that is required to select the correct NVRAM file. Parse this
>> OTP ROM and extract the required strings.
>>
>> Note that the user OTP offset/size is per-chip. This patch does not add
>> any chips yet.
> 
> ...
> 
>> +static int
>> +brcmf_pcie_parse_otp_sys_vendor(struct brcmf_pciedev_info *devinfo,
>> +                               u8 *data, size_t size)
>> +{
>> +       int idx = 4;
> 
> Can you rather have a structure
> 
> struct my_cool_and_strange_blob {
> __le32 hdr;
> const char ...[];
> ...
> }
> 
> and then cast your data to this struct?

That would mean I need to copy, since the original data is not aligned.
Since it's just one u32 header (which we don't even truly know the
interpretation of), it seems get_unaligned_le32 is easier.

> 
>> +       const char *chip_params;
>> +       const char *board_params;
>> +       const char *p;
>> +
>> +       /* 4-byte header and two empty strings */
>> +       if (size < 6)
>> +               return -EINVAL;
>> +
>> +       if (get_unaligned_le32(data) != BRCMF_OTP_VENDOR_HDR)
>> +               return -EINVAL;
>> +
>> +       chip_params = &data[idx];
> 
>> +       /* Skip first string, including terminator */
>> +       idx += strnlen(chip_params, size - idx) + 1;
> 
> strsep() ?

We're splitting on \0 here, so that won't work.

> 
>> +       if (idx >= size)
>> +               return -EINVAL;
>> +
>> +       board_params = &data[idx];
>> +
>> +       /* Skip to terminator of second string */
>> +       idx += strnlen(board_params, size - idx);
>> +       if (idx >= size)
>> +               return -EINVAL;
>> +
>> +       /* At this point both strings are guaranteed NUL-terminated */
>> +       brcmf_dbg(PCIE, "OTP: chip_params='%s' board_params='%s'\n",
>> +                 chip_params, board_params);
>> +
>> +       p = board_params;
>> +       while (*p) {
>> +               char tag = *p++;
>> +               const char *end;
>> +               size_t len;
>> +
>> +               if (tag == ' ') /* Skip extra spaces */
>> +                       continue;
> 
> skip_spaces()

Sure.

> 
>> +
>> +               if (*p++ != '=') /* implicit NUL check */
>> +                       return -EINVAL;
> 
> Have you checked the next_arg() implementation?

That function has a lot more logic (handling quotes, etc) and no other
hardware drivers use it. I'm not sure I feel comfortable using it to
parse untrusted data from a potentially compromised device. The parsing
we need to do here is much simpler.

> 
>> +               /* *p might be NUL here, if so end == p and len == 0 */
>> +               end = strchrnul(p, ' ');
>> +               len = end - p;
>> +
>> +               /* leave 1 byte for NUL in destination string */
>> +               if (len > (BRCMF_OTP_MAX_PARAM_LEN - 1))
>> +                       return -EINVAL;
>> +
>> +               /* Copy len characters plus a NUL terminator */
>> +               switch (tag) {
>> +               case 'M':
>> +                       strscpy(devinfo->otp.module, p, len + 1);
>> +                       break;
>> +               case 'V':
>> +                       strscpy(devinfo->otp.vendor, p, len + 1);
>> +                       break;
>> +               case 'm':
>> +                       strscpy(devinfo->otp.version, p, len + 1);
>> +                       break;
>> +               }
>> +
>> +               /* Skip to space separator or NUL */
>> +               p = end;
>> +       }
>> +
>> +       brcmf_dbg(PCIE, "OTP: module=%s vendor=%s version=%s\n",
>> +                 devinfo->otp.module, devinfo->otp.vendor,
>> +                 devinfo->otp.version);
>> +
>> +       if (!devinfo->otp.module ||
>> +           !devinfo->otp.vendor ||
>> +           !devinfo->otp.version)
>> +               return -EINVAL;
>> +
>> +       devinfo->otp.valid = true;
>> +       return 0;
>> +}
>> +
>> +static int
>> +brcmf_pcie_parse_otp(struct brcmf_pciedev_info *devinfo, u8 *otp, size_t size)
>> +{
>> +       int p = 0;
> 
>> +       int ret = -1;
> 
> Use proper error codes.

Ack.

> 
>> +       brcmf_dbg(PCIE, "parse_otp size=%ld\n", size);
>> +
>> +       while (p < (size - 1)) {
> 
> too many parentheses

Really? I see this is all over kernel code. I know it's redundant, but I
find parentheses around expressions used for one side of a comparison to
be a lot more readable since you don't have to start doubting whether
that particular operator has higher precedence than the comparison (+
does but & does not).

> 
>> +               u8 type = otp[p];
>> +               u8 length = otp[p + 1];
>> +
>> +               if (type == 0)
>> +                       break;
>> +
>> +               if ((p + 2 + length) > size)
>> +                       break;
>> +
>> +               switch (type) {
>> +               case BRCMF_OTP_SYS_VENDOR:
>> +                       brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): SYS_VENDOR\n",
> 
> length as hex a bit harder to parse

Not so sure about that, especially if you're trying to mentally add it
to offsets... but sure, I can make it decimal.

> 
>> +                                 p, length);
>> +                       ret = brcmf_pcie_parse_otp_sys_vendor(devinfo,
>> +                                                             &otp[p + 2],
>> +                                                             length);
>> +                       break;
>> +               case BRCMF_OTP_BRCM_CIS:
>> +                       brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): BRCM_CIS\n",
>> +                                 p, length);
>> +                       break;
>> +               default:
>> +                       brcmf_dbg(PCIE, "OTP @ 0x%x (0x%x): Unknown type 0x%x\n",
>> +                                 p, length, type);
>> +                       break;
>> +               }
> 
>> +               p += 2 + length;
> 
> 
> length + 2 is easier to read.

I was following the data order here; 2 header bytes and then length
payload bytes. Same reason I used p + 2 + length above.

> 
>> +       }
>> +
>> +       return ret;
>> +}
> 
> ...
> 
>> +               /* Map OTP to shadow area */
>> +               WRITECC32(devinfo, sromcontrol,
>> +                         sromctl | BCMA_CC_SROM_CONTROL_OTPSEL);
> 
> One line?

That exceeds 80 chars, which seems to be the standard in this file which
I'm trying to stick to. If people are okay with pushing to 100 lines,
there are lots of other places I could unwrap lines in this series.

> 
> ...
> 
>> +       otp = kzalloc(sizeof(u16) * words, GFP_KERNEL);
> 
> No check, why? I see in many places you forgot to check for NULL from
> allocator functions.

I think at some point something convinced me that kzalloc and friends
don't fail with GFP_KERNEL... which they rarely do, but they do. I'll
fix it, and add a few missing checks to the existing code while I'm at it.

> Moreover here you should use kzalloc() which does overflow protection.
words is a constant from the switch statement so this could never
overflow anyway, but sure.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
