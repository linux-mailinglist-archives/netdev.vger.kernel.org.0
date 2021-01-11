Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716E52F1D6C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 19:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389662AbhAKSED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 13:04:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732662AbhAKSED (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 13:04:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39A0B20738;
        Mon, 11 Jan 2021 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610388202;
        bh=epvKOWonVUFPSyX+WJP6xmKtL5tFzn6K/IuELuQ87mQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nMaTfvy+QxMaNVlN64KekkPukTr4a21sSoJ2bpcy4GIunSUHupTzb/Jm+T4Q9w/Wp
         ytJQbPmcW+Y65jHfOkPJEruuewown0owS8al1eECk6VN9nvu17F3N98nP5jEYU9cy2
         KZJ91ZAnLwCgqdDnyCTLJ8zFvvKB9SuxitdKzVGl1VoLwmFszI0xs7/KnOKPNRqHt3
         uDR0RiVsdkU0kBLU13vUwdOeFN7AAGWLHqFs4VY/plpNMSlXM9XXWD10el9x4k+7/e
         Lu8K4lxj8yZDNrNHjBKrrvdb06yPyMsIXLCE5tq+lIpbUconwcV/z9hqOL4nzuxW19
         aOG7PqAOXTzjw==
Date:   Mon, 11 Jan 2021 10:03:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Dan Murphy <dmurphy@ti.com>,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        davem@davemloft.net
Subject: Re: [net-next 15/19] can: tcan4x5x: rework SPI access
Message-ID: <20210111100321.3f9a0b08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7a0e400a-7522-f3f0-55e1-887127636c09@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
        <20210107094900.173046-16-mkl@pengutronix.de>
        <20210107110035.42a6bb46@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210107110656.7e49772b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c98003bf-e62a-ab6a-a526-1f3ed0bb1ab7@pengutronix.de>
        <20210107143851.51675f8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8185f3e1-d0b1-0ea4-ac45-f2ea0b63ced9@pengutronix.de>
        <20210108083229.6f42479b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <7a0e400a-7522-f3f0-55e1-887127636c09@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jan 2021 16:35:30 +0100 Ahmad Fatoum wrote:
> Hello Jakub,
> 
> On 08.01.21 17:32, Jakub Kicinski wrote:
> > On Fri, 8 Jan 2021 11:07:26 +0100 Ahmad Fatoum wrote:  
> >>>>> +struct __packed tcan4x5x_map_buf { 
> >>>>> +	struct tcan4x5x_buf_cmd cmd; 
> >>>>> +	u8 data[256 * sizeof(u32)]; 
> >>>>> +} ____cacheline_aligned;       
> >>>>
> >>>> Due to the packing of the struct tcan4x5x_buf_cmd it should have a length of 4
> >>>> bytes. Without __packed, will the "u8 data" come directly after the cmd?    
> >>>
> >>> Yup, u8 with no alignment attribute will follow the previous
> >>> field with no holes.    
> >>
> >> __packed has a documentation benefit though. It documents that the author
> >> considers the current layout to be the only correct one. (and thus extra
> >> care should be taken when modifying it).  
> > 
> > ____cacheline_aligned adds a big architecture dependent padding at the
> > end of this struct, so the size of this structure is architecture
> > dependent. Besides using packed forced the compiler to use byte by byte
> > loads on architectures without unaligned access, so __packed is not
> > free.  
> 
> https://godbolt.org/z/j68x8n
> 
> seems to indicate that explicit alignment "overrules" packed's implicit
> alignment of 1 as
>  there isn't any byte-by-byte access generated for a struct
> that is both packed and cacheline aligned. packed only structs are accessed
> byte-by-byte however.
> 
> Did I get something wrong in my testcase?
> 
> I compiled with ARM gcc 8.2  -mno-unaligned-access -fno-strict-aliasing -O2

I see, that's why I said combining ____cacheline_aligned with __packed
looks very confusing. Good to know which one takes precedence.
That doesn't change my recommendation to remove __packed, though, let's
not leave readers of this code scratching their heads.
