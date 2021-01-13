Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8A22F4FC7
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 17:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727429AbhAMQU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 11:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbhAMQUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 11:20:25 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFABC061794
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:19:45 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id d13so2018062ioy.4
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 08:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xEPkDwVE9RtnXuRxHoTlrHwQitE78zqBqfATtPtI1UA=;
        b=lJA9CNNPtgcXrhTIrSypuNObSP77MJyUlIs+QKRmtu6gHJFeanhw7/XaGr1Li3VKM/
         2yCbgcMfPHpPI3G1PeAD1jpUQ+96vgLiIIR+QVg8E3pfe+dMhiBJeKCFKPMecJhKJ95U
         Q++il9AlFfG6tfd1+wT+5KpXpy1ijYMgJ9bk5iY9NY/2ZGJg4aUIvRn4VqOwk4nCRTnc
         4cituXjcaVGPSitOWCJmUz1AAUOiDUWwxClPaetj6euOMmgnjr+KsPJ9wuaw4hro77r9
         Vk1wQnKl2it8TmgG9X6J5aecv0zsd5jDu/N8ddROK4Dhbl83CqOcr7XFDzmNcghEtsXZ
         oIAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xEPkDwVE9RtnXuRxHoTlrHwQitE78zqBqfATtPtI1UA=;
        b=BtqTetq3tCkuF72TKe5sO6zmCDZ1/35ZTAp1FLItoUjbM4DOymLFaA6aSXjVs7ldSo
         uC/Qf/cO246/OTYd68E7zzEcnXOEVrPaA4iuhQUZH83cp1wjvFQfpS3B4MtNV7lIDG3m
         x8ut0pLIoMVdlWtaGQ6A51mPFeFQAHlMMf49ybmcIJfCnOqaEv7phINGdY3WA3ibN1w4
         qDUnwGhNFiK5/6dFcBnZd8lrMXc87dv8u0tefSd/2iBOH0PN9T/+t6+mNizQyxItblN+
         j3dz71M0prV1s7Y5BTgFozhyjXSW+ZB/gZFXPX3ItxKUOio1BU5UWBR1g5qDCx264Gdn
         UFPA==
X-Gm-Message-State: AOAM531VddJpOYgEkVuiWYyoT7RdbOZJumhioqUwN9HdZRqhK6AMCYtp
        ugq4pX7i1uRinFnpJuEQIxrW8lR8RfkI3NE2lsQ=
X-Google-Smtp-Source: ABdhPJxtJRbIJ8rd/8KvVO/iH5cbcBfYsiysK0as6sV3To8TfXWO5sRlItdFgSWDvRgjVvpZBzOs4sIWpJhBmTutzKc=
X-Received: by 2002:a6b:d007:: with SMTP id x7mr2367487ioa.88.1610554784721;
 Wed, 13 Jan 2021 08:19:44 -0800 (PST)
MIME-Version: 1.0
References: <1610538220-25980-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1610538220-25980-1-git-send-email-lirongqing@baidu.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 13 Jan 2021 08:19:33 -0800
Message-ID: <CAKgT0Udh8_m=MpDLsWfAeWh2uvFq4ksJ=00e8zMB-v7=P4XLMg@mail.gmail.com>
Subject: Re: [PATCH][v2] igb: avoid premature Rx buffer reuse
To:     Li RongQing <lirongqing@baidu.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 3:47 AM Li RongQing <lirongqing@baidu.com> wrote:
>
> Igb needs a similar fix as commit 75aab4e10ae6a ("i40e: avoid
> premature Rx buffer reuse")
>
> The page recycle code, incorrectly, relied on that a page fragment
> could not be freed inside xdp_do_redirect(). This assumption leads to
> that page fragments that are used by the stack/XDP redirect can be
> reused and overwritten.
>
> To avoid this, store the page count prior invoking xdp_do_redirect().
>
> Longer explanation:
>
> Intel NICs have a recycle mechanism. The main idea is that a page is
> split into two parts. One part is owned by the driver, one part might
> be owned by someone else, such as the stack.
>
> t0: Page is allocated, and put on the Rx ring
>               +---------------
> used by NIC ->| upper buffer
> (rx_buffer)   +---------------
>               | lower buffer
>               +---------------
>   page count  == USHRT_MAX
>   rx_buffer->pagecnt_bias == USHRT_MAX
>
> t1: Buffer is received, and passed to the stack (e.g.)
>               +---------------
>               | upper buff (skb)
>               +---------------
> used by NIC ->| lower buffer
> (rx_buffer)   +---------------
>   page count  == USHRT_MAX
>   rx_buffer->pagecnt_bias == USHRT_MAX - 1
>
> t2: Buffer is received, and redirected
>               +---------------
>               | upper buff (skb)
>               +---------------
> used by NIC ->| lower buffer
> (rx_buffer)   +---------------
>
> Now, prior calling xdp_do_redirect():
>   page count  == USHRT_MAX
>   rx_buffer->pagecnt_bias == USHRT_MAX - 2
>
> This means that buffer *cannot* be flipped/reused, because the skb is
> still using it.
>
> The problem arises when xdp_do_redirect() actually frees the
> segment. Then we get:
>   page count  == USHRT_MAX - 1
>   rx_buffer->pagecnt_bias == USHRT_MAX - 2
>
> From a recycle perspective, the buffer can be flipped and reused,
> which means that the skb data area is passed to the Rx HW ring!
>
> To work around this, the page count is stored prior calling
> xdp_do_redirect().
>
> Fixes: 9cbc948b5a20 ("igb: add XDP support")
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

Looks good.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
