Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF68D309689
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232285AbhA3QKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbhA3QBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 11:01:53 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7B0C06174A
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 07:04:42 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f1so13894722edr.12
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 07:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q1DoOERep/4QagAqJxQdnlhfkqrhqIqO/ko/pInHhdc=;
        b=Q/bO5uOzLabEAQYbZivFl0R3oVWSqmWFyZRxosIpzS6ZSLC52Rw4WszYBGqD4AI0eV
         w03A8xTvqoBB1NPvk+kTLr8WOm1Bvm7u2lWagmKr4BcWWRSup1oKsUhIZSN21lcyOSHJ
         L484vwlgLG5tfmo9lH6Rj4ARhzPVGBVdxWg3A3z7QeR+LlA7gBrZJfhuLtizDQeK6u5G
         HtuZHmnAyZqlqiusmnMbuBZA9aupd3Pr3XuXrb29JQwzMqGy99gwdvWrpPC83CoKaS4T
         TzfjVMqNvHntCX8gR7gYARcghv+ZPwSE8H68vgcknL9Ek2na8zd+p/kUNwJcFFu+/xyP
         qURA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q1DoOERep/4QagAqJxQdnlhfkqrhqIqO/ko/pInHhdc=;
        b=G/G69/PDh/UuomyvWZy4NiUmRFXEv3GIA0xa/fcnF6TzTwomOCZGpvteurMzvQbcBP
         oTbaz7TnRnRk9hgYasUhj0Dc6CXayf/sbhhlHhw3zti/FkzDW4GtT3RuLrEUX7DN9Ymw
         JkxpcxWiZ9fiAjNdtoUR5/m+EpqAarinV4HqBmUe0O0MNmbiW3MPY36i9iboxn4zWGkB
         PL9TgiDgZiK7Z3WxAmIYuscKB8hD3oNZTFUQFFqAiUqd3TVsg5HGjrUsibRjhWZvuZUv
         c+MtDMCAz3EmlQbsPfroAY46O+w9FmAo4KPUYz9wHs3NuJfunk9pB3KbPjzXyaFhRIGG
         rJbA==
X-Gm-Message-State: AOAM533QTP14wDrs39GF25Zl6ONyCj5fjK66+N92BAS0jsgRHZ6fSj+8
        KRG+DVq1hpAwrDfXeCUU32iqd6SA+elFILK6Uq0=
X-Google-Smtp-Source: ABdhPJzuCzc2oddugKXxXTB5ldT5aNvegfA4+WK52EHFIwMtivkktfKuklpysTAzlRKOCRBxXZbTy1VH7Bc8elfPi5E=
X-Received: by 2002:aa7:c9cf:: with SMTP id i15mr10255389edt.296.1612019081182;
 Sat, 30 Jan 2021 07:04:41 -0800 (PST)
MIME-Version: 1.0
References: <20210129034711.518250-1-sukadev@linux.ibm.com> <20210129034711.518250-2-sukadev@linux.ibm.com>
In-Reply-To: <20210129034711.518250-2-sukadev@linux.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 30 Jan 2021 10:04:04 -0500
Message-ID: <CAF=yD-+0Q86iZMedrBp2wDjVaNvd2_Wy7BcsXLef_e2wJmYm=A@mail.gmail.com>
Subject: Re: [PATCH net 2/2] ibmvnic: fix race with multiple open/close
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 10:51 PM Sukadev Bhattiprolu
<sukadev@linux.ibm.com> wrote:
>
> If two or more instances of 'ip link set' commands race and first one
> already brings the interface up (or down), the subsequent instances
> can simply return without redoing the up/down operation.
>
> Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> Tested-by: Abdul Haleem <abdhalee@in.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Isn't this handled in the rtnetlink core based on IFF_UP?

        if ((old_flags ^ flags) & IFF_UP) {
                if (old_flags & IFF_UP)
                        __dev_close(dev);
                else
                        ret = __dev_open(dev, extack);
        }
