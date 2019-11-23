Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6089B107C2B
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 01:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKWAvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 19:51:04 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38375 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbfKWAvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 19:51:04 -0500
Received: by mail-pg1-f195.google.com with SMTP id t3so3717701pgl.5
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 16:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YEx9gkUUkZlIfBrM5Cbpff4Fb2jz3vKVv8jxLN8IwcM=;
        b=TDYJmfyA9tvr839j2Qfc5xuu0ZxFLfrMKwvcBzvSaEfMuVOV/sguZJfwo0X5PON/9J
         8WvxwhWmhYF/baIrJYundj8Y3NxmV0VjnxE0i11PH4XjLZjCNbWa2EFLdEA1a7DX9vXL
         Rx1qZMykTRmTHZd6lrVleJNQpZOGxho5nemIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YEx9gkUUkZlIfBrM5Cbpff4Fb2jz3vKVv8jxLN8IwcM=;
        b=top3KM+LlkiRK79rZXXXMx4kLSAua/DDimQQUz1dSiaIS37ky5C0mb9EpqI5h7xWPc
         Z2iPBgF0G8rEvEREo2StCidlPYX7w6JtrnBgqZUXn3B390cgiGG0IRZr0SHSU+5cKCvu
         rSCz+uwSit1mSb+xj0a9uEc7carpLovQxBcH9lKyV/WOOvKEcU3SZaPf5CR0AVOIXyFN
         7tlq1fMpRKhpEYihx0eo2aDDCVQWQUbyf4+N8OI5CDm0dC+4DZ16bj7N0NoAJt0hD/Sx
         q/meEBY7KS3aVD81ihHydk10nvWBZJv1ErBTI58oJb6kc+ZdDCGBlrUJ6vwJfWAA8rab
         DWfA==
X-Gm-Message-State: APjAAAVGb/x2875KpEg5uO4eqbFcKJn2ZN8173LgP4lSUQ+RPPiCABMs
        xkKBEQAzWwCDoQ8+WvBnBhGGoYLgSZo=
X-Google-Smtp-Source: APXvYqwMJMSPAmhp4Go/fyPR9gy++5+i6LNMl7e4m/DKSVuR7t0cqOKww2BvvAz1j2cBMDIATLdQmg==
X-Received: by 2002:a63:d854:: with SMTP id k20mr19360771pgj.305.1574470263399;
        Fri, 22 Nov 2019 16:51:03 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id v3sm8933989pfi.26.2019.11.22.16.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 16:51:02 -0800 (PST)
Date:   Fri, 22 Nov 2019 16:51:00 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Chun-Hao Lin <hau@realtek.com>
Subject: Re: [PATCH] [RFC] r8169: check for valid MAC before clobbering
Message-ID: <20191123005054.GA116745@google.com>
References: <20191113005816.37084-1-briannorris@chromium.org>
 <32422b2d-6cab-3ea2-aca3-3e74d68599a3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32422b2d-6cab-3ea2-aca3-3e74d68599a3@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

Thanks for the response, and sorry for some delay. I've been busy in the
last week.

On Wed, Nov 13, 2019 at 09:30:42PM +0100, Heiner Kallweit wrote:
> On 13.11.2019 01:58, Brian Norris wrote:
> > I have some old systems with RTL8168g Ethernet, where the BIOS (based on
> > Coreboot) programs the MAC address into the MAC0 registers (at offset
> > 0x0 and 0x4). The relevant Coreboot source is publicly available here:
> > 
> > https://review.coreboot.org/cgit/coreboot.git/tree/src/mainboard/google/jecht/lan.c?h=4.10#n139
> > 
> > (The BIOS is built off a much older branch, but the code is effectively
> > the same.)
> > 
> > Note that this was apparently the recommended solution in an application
> > note at the time (I have a copy, but it's not marked for redistribution
> > :( ), with no mention of the method used in rtl_read_mac_address().
> > 
> The application note refers to RTL8105e which is quite different from
> RTL8168g.

Understood. But the register mapping for this part does appear to be the
same, and I'm really having trouble finding any other documentation, so
I can't really blame whoever was writing the Coreboot code in the first
place.

> For RTL8168g the BIOS has to write the MAC to the respective
> GigaMAC registers, see rtl_read_mac_address for these registers.

I already see the code, but do you have any reference docs? For example,
how am I to determine "has to"? I've totally failed at finding any good
documentation.

To the contrary, I did find an alleged RTL8169 document (no clue if it's
legit), and it appears to describe the IDR0-5 registers (i.e., offset
0000h) as:

  ID Register 0: The ID registers 0-5 are only permitted to write by
  4-byte access. Read access can be byte, word, or double word access.
  The initial value is autoloaded from EEPROM EthernetID field. 

If that implies anything, it seems to imply that any EEPROM settings
should be automatically applied, and that register 0-5h are the correct
source of truth.

Or it doesn't really imply anything, except that some other similar IP
doesn't specifically mention this "backup register."

> If recompiling the BIOS isn't an option,

It's not 100% impossible, but it seems highly unlikely to happen. To me
(and likely the folks responsible for this BIOS), this looks like a
kernel regression (this driver worked just fine for me before commit
89cceb2729c7).

> then easiest should be to
> change the MAC after boot with "ifconfig" or "ip" command.

No, I think the easiest option is to apply my patch, which I'll probably
do if I can't find anything else.

I'm curious: do you see any problem with my patch? In your
understanding, what's the purpose of the "backup registers" (as they
were called in commit 89cceb2729c7)? To be the primary source of MAC
address information? Or to only be a source if the primary registers are
empty? If the latter, then my patch should be a fine substitute.

Brian

> > The result is that ever since commit 89cceb2729c7 ("r8169:add support
> > more chips to get mac address from backup mac address register"), my MAC
> > address changes to use an address I never intended.
> > 
> > Unfortunately, these commits don't really provide any documentation, and
> > I'm not sure when the recommendation actually changed. So I'm sending
> > this as RFC, in case I can get any tips from Realtek on how to avoid
> > breaking compatibility like this.
> > 
> > I'll freely admit that the devices in question are currently pinned to
> > an ancient kernel. We're only recently testing newer kernels on these
> > devices, which brings me here.
> > 
> > I'll also admit that I don't have much means to test this widely, and
> > I'm not sure what implicit behaviors other systems were depending on
> > along the way.
> > 
> > Fixes: 89cceb2729c7 ("r8169:add support more chips to get mac address from backup mac address register")
> > Fixes: 6e1d0b898818 ("r8169:add support for RTL8168H and RTL8107E")
> > Cc: Chun-Hao Lin <hau@realtek.com>
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
