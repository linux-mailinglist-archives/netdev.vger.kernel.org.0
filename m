Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6026397074
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 11:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhFAJfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 05:35:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233218AbhFAJfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 05:35:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A4060FE5;
        Tue,  1 Jun 2021 09:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622540001;
        bh=z9BF47t2jCOs1z4eddFfaMUgAQ8k2fwgJgS+XUassNk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JIzELpx2qyYoBpdjTznHY7qNWdOll4CxnMDzTufG8ULUtHrZgV6ySyCtmXSZLYpk3
         VRE4VXffLdOM4PLh0plDcJJa2zUFtiyRsCGMLIaYLJKuQpQ8JHLK+TbdfJU2M3ionf
         40YDpxXN+uwEIyb9c6Y94UMTqSyUx0Ra1F9VjzJt2Ve6GhBz6E9hx5CAVaz+Xct7Vl
         28gD0KtJLlq0e3qgJcrkz8609TVDrkFovc7euQYs10mfgwXYJUhR6GVhyJ++1Q/rXo
         fTmK+QAjHcS2jI1RfL/ulGSqealBcXTiKCzy+OaKIzVycuHcapE/e1/YiQz4sk/Heg
         D07n64obamlYw==
Message-ID: <483c73edf02fa0139aae2b81e797534817655ea0.camel@kernel.org>
Subject: Re: Kernel Panic in skb_release_data using genet
From:   nicolas saenz julienne <nsaenz@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>
Cc:     Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Tue, 01 Jun 2021 11:33:18 +0200
In-Reply-To: <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
References: <20210524130147.7xv6ih2e3apu2zvu@gilmour>
         <a53f6192-3520-d5f8-df4b-786b3e4e8707@gmail.com>
         <20210524151329.5ummh4dfui6syme3@gilmour>
         <1482eff4-c5f4-66d9-237c-55a096ae2eb4@gmail.com>
         <6caa98e7-28ba-520c-f0cc-ee1219305c17@gmail.com>
         <20210528163219.x6yn44aimvdxlp6j@gilmour>
         <77d412b4-cdd6-ea86-d7fd-adb3af8970d9@gmail.com>
         <9e99ade5-ebfc-133e-ac61-1aba07ca80a2@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0 (3.40.0-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-05-31 at 19:36 -0700, Florian Fainelli wrote:
> > That is also how I boot my Pi4 at home, and I suspect you are right, if
> > the VPU does not shut down GENET's DMA, and leaves buffer addresses in
> > the on-chip descriptors that point to an address space that is managed
> > totally differently by Linux, then we can have a serious problem and
> > create some memory corruption when the ring is being reclaimed. I will
> > run a few experiments to test that theory and there may be a solution
> > using the SW_INIT reset controller to have a big reset of the controller
> > before handing it over to the Linux driver.
> 
> Adding a WARN_ON(reg & DMA_EN) in bcmgenet_dma_disable() has not shown
> that the TX or RX DMA have been left running during the hand over from
> the VPU to the kernel. I checked out drm-misc-next-2021-05-17 to reduce
> as much as possible the differences between your set-up and my set-up
> but so far have not been able to reproduce the crash in booting from NFS
> repeatedly, I will try again.

FWIW I can reproduce the error too. That said it's rather hard to reproduce,
something in the order of 1 failure every 20 tries.

Regards,
Nicolas

