Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3F420FC71
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgF3TFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:05:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbgF3TFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 15:05:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 390F92065D;
        Tue, 30 Jun 2020 19:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593543919;
        bh=ryF1+f0PF0+cRwFI4GllY63sjrBgs1LAJI1Ccnq/pPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eEWeWZA28pm+aSLVyJn9yemCsXXhzAlm0dS2XD1UkB8ex8I9SoFtMlHSqHkvKDewN
         E3OQLTq2T5OjYdY0i6mUKNyKwju+f3FrwdaYTlsExrgfOMTqSiTwQsfVVS0A+T0SkQ
         nf9W5KyFGnY3XhbzRvDhqBOPNJqGc0yCqLp3K9NE=
Date:   Tue, 30 Jun 2020 12:05:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 6/8] bnxt_en: Implement ethtool -X to set
 indirection table.
Message-ID: <20200630120517.2237bb87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLin7DSADqfm8BjQxtM2sYZZV6Ycq_oHPT0+e53xpCoi1xA@mail.gmail.com>
References: <1593412464-503-1-git-send-email-michael.chan@broadcom.com>
        <1593412464-503-7-git-send-email-michael.chan@broadcom.com>
        <20200629170618.2b265417@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLin7DSADqfm8BjQxtM2sYZZV6Ycq_oHPT0+e53xpCoi1xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Jun 2020 17:38:33 -0700 Michael Chan wrote:
> On Mon, Jun 29, 2020 at 5:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 29 Jun 2020 02:34:22 -0400 Michael Chan wrote:
> > > With the new infrastructure in place, we can now support the setting of
> > > the indirection table from ethtool.
> > >
> > > The user-configured indirection table will need to be reset to default
> > > if we are unable to reserve the requested number of RX rings or if the
> > > RSS table size changes.
> > >
> > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>  
> >
> > Hm. Clearing IFF_RXFH_CONFIGURED seems wrong. The user has clearly
> > requested a RSS mapping, if it can't be maintained driver should
> > return an error from the operation which attempts to change the ring
> > count.  
> 
> Right.  In this case the user has requested non default RSS map and is
> now attempting to change rings.  We have a first level check by
> calling bnxt_check_rings().  Firmware will tell us if the requested
> rings are available or not.  If not, we will return error and the
> existing rings and RSS map will be kept.  This should be the expected
> outcome in most cases.
> 
> In rare cases, firmware can return success during bnxt_check_rings()
> but during the actual ring reservation, it fails to reserve all the
> rings it promised were available earlier.  In this case, we fall back
> and accept the fewer rings and set the RSS map to default.  I have
> never seen this scenario but we need to put the code in just in case
> it happens.  It should be rare.

What's the expected application flow? Every time the application 
makes a change to NIC settings it has to re-validate that some of 
the previous configuration didn't get lost? I don't see the driver
returning the error if FW gave it less rings than requested. There 
isn't even a warning printed..

I'd prefer if the driver wrapped the rss indexes, and printed a
warning, but left the config intact. And IMO set_channels should 
return an error.
