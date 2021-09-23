Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750424166A0
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 22:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243165AbhIWUYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 16:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243173AbhIWUYG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 16:24:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 152C361019;
        Thu, 23 Sep 2021 20:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632428554;
        bh=k3zPwqpim6rXUSX3FUMtpizfa7s/LUqUrCFSwGLVMl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jl6LFI7LsmrIxAq+IbA9wLE6geSN0xdYvqr1ECzUp3i/VipRQiqfiG6iy9AnfEh0s
         x5hjdUPf9VR1aTDUBkA/D3XPMoRvlJTX6DVGx8A7SXVg1a6WXzCzWQCsSnA54IVwWB
         JR2OWHtAAIXnqkUOHOmDZBEEJBoHqQHiQuubeS7FPy8BL6s1gl8AHkc/3rekzE7sBA
         8VfIP3T/mMhkSgz6EiySNZTHCgzQ9yv7zo0CiKNgc3P7NYFpPTMwVLmsolCU2325Tc
         gdaZF7GfIKYvo8+1YarkNKpNyj9JXoIdGEwa3OLXsKi9VSfZnvgZuIkYb+pZZyqUiC
         8ALyo4H4zrbqQ==
Received: by pali.im (Postfix)
        id 971AC7D5; Thu, 23 Sep 2021 22:22:31 +0200 (CEST)
Date:   Thu, 23 Sep 2021 22:22:31 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Message-ID: <20210923202231.t2zjoejpxrbbe5hc@pali>
References: <20210830123704.221494-2-verdre@v0yd.nl>
 <CA+ASDXPKZ0i5Bi11Q=qqppY8OCgw=7m0dnPn0s+y+GAvvQodog@mail.gmail.com>
 <CAHp75VdR4VC+Ojy9NjAtewAaPAgowq-3rffrr3uAdOeiN8gN-A@mail.gmail.com>
 <CA+ASDXNGR2=sQ+w1LkMiY_UCfaYgQ5tcu2pbBn46R2asv83sSQ@mail.gmail.com>
 <YS/rn8b0O3FPBbtm@google.com>
 <0ce93e7c-b041-d322-90cd-40ff5e0e8ef0@v0yd.nl>
 <CA+ASDXNMhrxX-nFrr6kBo0a0c-25+Ge2gBP2uTjE8UWJMeQO2A@mail.gmail.com>
 <bd64c142-93d0-c348-834c-34ed80c460f9@v0yd.nl>
 <e4cbf804-c374-79a3-53ac-8a0fbd8f75b8@v0yd.nl>
 <CAHp75Vd5iCLELx8s+Zvcj8ufd2bN6CK26soDMkZyC1CwMO2Qeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75Vd5iCLELx8s+Zvcj8ufd2bN6CK26soDMkZyC1CwMO2Qeg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 23 September 2021 22:41:30 Andy Shevchenko wrote:
> On Thu, Sep 23, 2021 at 6:28 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
> > On 9/22/21 2:50 PM, Jonas Dreßler wrote:
> 
> ...
> 
> > - Just calling mwifiex_write_reg() once and then blocking until the card
> > wakes up using my delay-loop doesn't fix the issue, it's actually
> > writing multiple times that fixes the issue
> >
> > These observations sound a lot like writes (and even reads) are actually
> > being dropped, don't they?
> 
> It sounds like you're writing into a not ready (fully powered on) device.

This reminds me a discussion with Bjorn about CRS response returned
after firmware crash / reset when device is not ready yet:
https://lore.kernel.org/linux-pci/20210922164803.GA203171@bhelgaas/

Could not be this similar issue? You could check it via reading
PCI_VENDOR_ID register from config space. And if it is not valid value
then card is not really ready yet.

> To check this, try to put a busy loop for reading and check the value
> till it gets 0.
> 
> Something like
> 
>   unsigned int count = 1000;
> 
>   do {
>     if (mwifiex_read_reg(...) == 0)
>       break;
>   } while (--count);
> 
> 
> -- 
> With Best Regards,
> Andy Shevchenko
