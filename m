Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16CE483426
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 16:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233967AbiACP10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 10:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbiACP10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 10:27:26 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1534C061761;
        Mon,  3 Jan 2022 07:27:25 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id e5so21220856wmq.1;
        Mon, 03 Jan 2022 07:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YSZSGK7sMUbzBZTBD3mtB8wyOlpZdA+12ekBkJMnHig=;
        b=mLhXxzrg0YKh0ANk4pS/yb+KEkB48DKx0o+VE+Rv6M1WmpBFd6c85f31XeGtSo5kDZ
         cgERwactIUj4aZJaPZEonBy0dz/DX6MYrGn+Bovo8aDMsTVRVHUFf3pd8YyS6OEXz96i
         h6KAGV5wbp7aw7hg2NJJJnyiQJyoP+MFeo0ejLav2RXBWdbtAGxQIxVQh75JJ8cTNiLD
         N2SvNwJn3VUYsXsHpGGxKsNXMthHOTmVCybZZhkAn2Qi54rl7B6OoJHG9sYmX1qgOVhf
         plx5RRoUFX4jS/3QFYJ1QmKRtVfL+ZZo5nqrQyAgfnNFkoTSa2pKnJmX+5vVZBrMNEBj
         wfEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YSZSGK7sMUbzBZTBD3mtB8wyOlpZdA+12ekBkJMnHig=;
        b=1l+NQhky1fynoPB0MtDOkWa30JxAPqik2+knlrD8lN/kTBuswMyexgv6VDTmOr4CPE
         L3XoCUpgTHtId+mYLJrgKZSQRgDhTs7/QgN/8421IOwKegJqRSZ0gZO3MXrzWq8SsCF5
         MThCjsGGUGK7xJiJktsWJcIdpo+X6RFMXxc7aN+qyO+Yo3yZuo65UMTxT5WQ40hYF+wV
         TcdHrYpFww8+n2GkRSgOPervWSUF5DP9eFfupPaAr7D5BrGBXflCNLq7H3Iri+f9IrSi
         Vef+4cM4mC31iyRi3f+PImNJEdUPLqWpviW+gXB2sQkrjYrcew6f50ezvvmxG7B2Rdo6
         8nqw==
X-Gm-Message-State: AOAM533AXbBV8ypGZxlOdcxCHY3AdZdr5MFPH2cp6NsAOMau5SThbGG6
        gk2zNw35mRR1ZwG5NLfZv/yObS5PY8THkBa+16s=
X-Google-Smtp-Source: ABdhPJyF5RxRWI+iBxJ8gl1vdxgINicCrkQem0rhMVouxNARtFNzQBImlyk41zg60Zy9MJ6LAsTgguzMas/fwFG1H+A=
X-Received: by 2002:a1c:ed01:: with SMTP id l1mr17956544wmh.185.1641223643305;
 Mon, 03 Jan 2022 07:27:23 -0800 (PST)
MIME-Version: 1.0
References: <CAB_54W50xKFCWZ5vYuDG2p4ijpd63cSutRrV4MLs9oasLmKgzQ@mail.gmail.com>
 <20220103120925.25207-1-paskripkin@gmail.com>
In-Reply-To: <20220103120925.25207-1-paskripkin@gmail.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Mon, 3 Jan 2022 10:27:12 -0500
Message-ID: <CAB_54W7jpTJ-PicyZLTvY4+ELdQVgELR1wRPrSjbZOBLzz46Jg@mail.gmail.com>
Subject: Re: [PATCH v2] ieee802154: atusb: fix uninit value in atusb_set_extended_addr
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, 3 Jan 2022 at 07:09, Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Alexander reported a use of uninitialized value in
> atusb_set_extended_addr(), that is caused by reading 0 bytes via
> usb_control_msg().
>
> Fix it by validating if the number of bytes transferred is actually
> correct, since usb_control_msg() may read less bytes, than was requested
> by caller.
>
> Fail log:
>
> BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
> BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
> BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
> Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
>  ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
>  atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
>  atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
>  usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
>
> Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
> Reported-by: Alexander Potapenko <glider@google.com>
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

Although I think if such error exists the most common solution would
be to replug the usb device and hope it gets resolved? A retry with a
maximum amount would be another try... However, let's hope those
errors are rare and we care about them when they occur.

Thanks.

- Alex
