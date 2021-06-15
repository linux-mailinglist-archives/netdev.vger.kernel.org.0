Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D50113A897A
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 21:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbhFOT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 15:29:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229749AbhFOT3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 15:29:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28CB5611CE;
        Tue, 15 Jun 2021 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623785231;
        bh=XUNjyODqNPBj/mkkvRQ6quNm6DdrObIeGuSxfe5FjZ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jh9UKDdDVnIw4csu3IvEZE51d/SCVKkUXPmcTPZDL2PGXL3OXsgwjo1DuQT/vAjQX
         mKjeysLoYnlk0OWbwBR3/Y3504fzUm+RQeKKOjjiVz89+iQuJUZ09gvWuxiMeLWlOe
         RvO+SBP4B3Mp28T+mEb+zYkVqfykFilaplaJgJMLzr8zU6LSqtm64A8foEYieZeByq
         fPRlpZvTbfqDdeJngJEi8YpZvzE4IiOFu4W08l1+UVvmFGoQlu5MPfBlIhzH1+dOI1
         gUQfZnJ8oIBzgnR0vaoxddw7J01YVpUzYRYcNZ7l+jyhJhaUhDTLmgo2PUuluBnBQO
         NFmA8wlXahY0w==
Date:   Tue, 15 Jun 2021 12:27:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        subashab@codeaurora.org
Subject: Re: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Message-ID: <20210615122710.68b6eba5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210615122604.1d68b37c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210614141849.3587683-1-kristian.evensen@gmail.com>
        <8735tky064.fsf@miraculix.mork.no>
        <20210614130530.7a422f27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKfDRXgQLvTpeowOe=17xLqYbVRcem9N2anJRSjMcQm6=OnH1A@mail.gmail.com>
        <877divwije.fsf@miraculix.mork.no>
        <CAKfDRXivs063y2sq0p8C1s1ayyt3b5DgxKH6smcvXucrGq=KHA@mail.gmail.com>
        <CAKfDRXhraBRXwaDb6T3XMtGpwK=X2hd8+ONWLSmJhQjGurBMmw@mail.gmail.com>
        <871r93w8l9.fsf@miraculix.mork.no>
        <20210615122604.1d68b37c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Jun 2021 12:26:04 -0700 Jakub Kicinski wrote:
> > > Apologies for the noise. When I check the code again, I see that as
> > > long as FLAG_MULTI_PACKET is set, then we end up with usbnet freeing
> > > the skb (we will always jump to done in rx_process()). So for the
> > > pass-through case, I believe your initial suggestion of having
> > > rx_fixup return 1 is the way to go.    
> > 
> > Yes, if we are to use FLAG_MULTI_PACKET then we must call
> > usbnet_skb_return() for all the non-muxed cases.  There is no clean way
> > to enable FLAG_MULTI_PACKET on-demand.  
> 
> Tricky piece of code. Perhaps we could add another return code 
> to the rx_fixup call? Seems that we expect 0 or 1 today, maybe we 
> can make 2 mean "data was copied out", and use that for the qmimux 
> case?

And to be clear with that still do what Bjorn suggested and return 1 
instead of netif_rx() in the non-qmimux case.
