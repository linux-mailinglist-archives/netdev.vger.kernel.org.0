Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD35136B75E
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 19:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhDZRBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 13:01:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:35142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233736AbhDZRBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 13:01:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06946127A;
        Mon, 26 Apr 2021 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619456420;
        bh=1PGTrQzdrhjZhXcEUGNUGcalfSPKJi8soz4uCTobsdo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gdUW4RsNDNT1Qj+5hu+8cYS0ya3w+M5Y0r2d4J6RBHRYV/9fG32bF7zAmdUCzPWrY
         kaz/7whAoP400/0xJJzRW6iDmHNJZYBUF6rYdQnCyrK92nqCimscGHZx17VRKKMfXa
         Ud3sgHO1DrUa/PpnsyZYLNZ1Yt+Ai58lrUVoKmCHLcsgn38pXKwcfj+HUK5llPlLad
         hn6b//wBR6nxnBIJzfa+bB0bpbljiroYa0brw2cdCEqb1a+BunaYI6IOfwVaBqWQ6a
         0rSc4GA3sQP3QORDoDDBR+B0rR5wcNSF83H6YIxWdUvhApzuhUG67Yu1dPYsxyqcxo
         xUYd5ThfV0Ijw==
Date:   Mon, 26 Apr 2021 10:00:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Andrew Gospodarek <gospo@broadcom.com>
Subject: Re: [PATCH net-next v2 10/10] bnxt_en: Implement
 .ndo_features_check().
Message-ID: <20210426100019.53a82b13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACKFLimdhTTD-vmfjkFDME_uHUBZTEMbUgA0WvSzjhPMjOPn_w@mail.gmail.com>
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
        <1619372727-19187-11-git-send-email-michael.chan@broadcom.com>
        <20210426092935.728fda80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACKFLinRRcoaxsiHZyYcywgRtOs0E5hJdQ0gjHPAj3991gMzHw@mail.gmail.com>
        <CACKFLimdhTTD-vmfjkFDME_uHUBZTEMbUgA0WvSzjhPMjOPn_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Apr 2021 09:45:17 -0700 Michael Chan wrote:
> On Mon, Apr 26, 2021 at 9:35 AM Michael Chan <michael.chan@broadcom.com> wrote:
> > On Mon, Apr 26, 2021 at 9:29 AM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > On Sun, 25 Apr 2021 13:45:27 -0400 Michael Chan wrote:  
> > > This should have been "features & ~(CSUM | GSO)" if you actually
> > > accepted my feedback.  
> 
> Sorry, hit send too early.  If it is not UDP, it could be GRE or IP
> over IP for example, right?  Why do we need to turn off offload?

All supported protocols can be included in the allow list.
That's one of the costs of NETIF_F_IP_CSUM, the driver needs 
to make sure the device can understand the packet.

> > I mentioned extension headers as an example,  
> 
> Extension headers (Geneve for example) are supported.

I thought the Geneve things were called options. I meant IPv6 extension
headers, which the device may also support, but then the right thing to
do is something like a call to ipv6_skip_exthdr() to retrieve the L4
proto.
