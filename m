Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3CF265549
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 01:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgIJXA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgIJXAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 19:00:23 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AD4C061573
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 16:00:22 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id u20so7339565ilk.6
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 16:00:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=87E7WP7KJ+EhUL6tOKA8gVWlDGXmxMXk7PqkwPXl9zw=;
        b=ORjaG37HNwMU+ox+XtOyq/DG7tFGVzMkCa8Zk9ZX8LkjQvV/bI3axsdmauDqwQO086
         8RR7AoSE9uvvA3D1bc5bI4McVxLQhKvhMq3TJlgzZ5VkKf9Pe4MXgJY8vM6/gC3qpdG7
         N2ZCW6uUcWhMHzyJouMmDowZm8qGIkhfz7ptFk+H4rD/cfKJ4xxttmCNlKLQpWVUseXT
         gipLErKL3o8+LBStMp00cn6xh/nBt5BNi1FlLFOseiH9mBRgkZJuy4vblgBPUFWWaWJQ
         rIhRSFU6iWjmLKedkl1J9spxcz0ENw1ifl7UMa3GUoNf7sXkQBPfbmvQUoX6kzwkLj/z
         woTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=87E7WP7KJ+EhUL6tOKA8gVWlDGXmxMXk7PqkwPXl9zw=;
        b=EnysB5WlsB2zUPcGSwuDAwYyfGJwCj83wJoIb7bXinRp4jZ6uMJVYKwcFfC9ssab4B
         gzwStREaex+i6ijeJD1GqFlJZr36QsVsqE6XW8/HwqiWOaPS9pTSNgsWl4/RpIkBmJiL
         YlMxQidkrkxPczgXtJMi+Ks5kr4tggPUzMqAaYIxuC0VmYNkPlt0/zj3IoxfeXuMB/fO
         SktoMFFIwxFrwAoaILW1nwYZzr3MHWM2jvB3S9F4oGuCAZ6txmybvlcd9GflynAcDag6
         TklDB8dNgjjLatNXRWRiZhFsQ5xFeRBMxi+8qOzKIe/zrO3vHetjCmj0m8ulIk4MjskD
         CoeQ==
X-Gm-Message-State: AOAM532ma6vrgah60sIN5qlv/XLbuAegJ6w+bUCAEtsj8yDWUjdjYNKY
        E5MZj/Qs2NuRzOwhKtR3R4vwHMEf9DHwp/9R1B3bSg==
X-Google-Smtp-Source: ABdhPJxxSmwKbDgPrc960yI/SsEVLq5aGtXU4IVRRBhKMdwsY9StD2kcBgpL0jtuLAiOWvxbhp9Xp3o/LOhH1Zd/fjA=
X-Received: by 2002:a92:d144:: with SMTP id t4mr10289547ilg.88.1599778821680;
 Thu, 10 Sep 2020 16:00:21 -0700 (PDT)
MIME-Version: 1.0
References: <1599157734-16354-1-git-send-email-michael.chan@broadcom.com>
 <CABb8VeHA8yEmi-iDs3O-eRfOucWqGM+9p6gj87NLdjeQHfJROA@mail.gmail.com> <CACKFLimoBx18uoJmXbVQTML+7eQb94nZJv2To7Wd2drJMSSeNg@mail.gmail.com>
In-Reply-To: <CACKFLimoBx18uoJmXbVQTML+7eQb94nZJv2To7Wd2drJMSSeNg@mail.gmail.com>
From:   Baptiste Covolato <baptiste@arista.com>
Date:   Thu, 10 Sep 2020 16:00:10 -0700
Message-ID: <CABb8VeFjyiMrgN++VxjDu_dYZL7ZeJCAKfgaSKJGWF5x7c-BOg@mail.gmail.com>
Subject: Re: [PATCH net] tg3: Fix soft lockup when tg3_reset_task() fails.
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Christensen <drc@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Sat, Sep 5, 2020 at 2:02 AM Michael Chan <michael.chan@broadcom.com> wrote:
> Now we have AER errors detected on 2 other tg3 devices, not from the
> one above with tg3_abort_hw() failure.
>
> I think this issue that you're reporting is not the same as David's
> issue of TX timeout happening at about the same time as AER.
>
> Please describe the issue in more detail, in particular how's the
> tg3_abort_hw() seen above initiated and how many tg3 devices do you
> have.  Also, are you injecting these AER errors?  Please also include
> the complete dmesg.  Thanks.

Sorry for the delay in response. I have been running some more
experiments with this issue to try to gather as much information as
possible. While running those experiments I noticed some strange
behavior on my system with PCI. I finally narrowed down the issue to
an improper power on sequence. After I fixed this, all my issues with
the tg3 are gone (tested with this patch applied). I think we're all
good now.

I'll let you know if I see any issues in the future.

Thanks
