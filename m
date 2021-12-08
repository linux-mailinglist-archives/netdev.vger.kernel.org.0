Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B4546DF24
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 00:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbhLIACP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:02:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57308 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238024AbhLIACO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:02:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3965CB82311;
        Wed,  8 Dec 2021 23:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49A0C00446;
        Wed,  8 Dec 2021 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639007920;
        bh=7nRwmELBED/pXoZE1UZHjca3QuaLjFUC/7GMuoTjSQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o/+Eh5pHo3NSQt+A8ZV6JbESSWfAA6Gny9fmDWO67nTeMRZtzVePLhp5JHIGtDSAg
         1myCJhfnjBA7Lxgz7UHWfznqH/2DAJTxX/9fVR64jttXIqR3ULxh3Kqgp1rGCESphk
         TaPQJEXyT5upXi3oNZ7aoaVBCPFEmA37HKlu+8v3rNuDvgWP39Dhjb83tB2dRjRoH2
         NbJFMKK6mCb2VoYXN5SGRZNByIAcrjqM8TkmOL04uy0AB4rX/d/jEpD2Ep2jJDxgL0
         X5FDgZ0+3sRF9OwhmPX07Y5McpdP2kspyOM48ykqq3dMJjGId+Z2R3Z877zo5stu+E
         LkhraO8yuSK1w==
Date:   Wed, 8 Dec 2021 15:58:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tun: avoid double free in tun_free_netdev
Message-ID: <20211208155838.24556030@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b141489b-780c-1753-2a83-ccb60c4554d0@oracle.com>
References: <1638974605-24085-1-git-send-email-george.kennedy@oracle.com>
        <YbDR/JStiIco3HQS@kroah.com>
        <022193b1-4ddd-f04e-aafa-ce249ec6d120@oracle.com>
        <20211208083614.61f386ad@hermes.local>
        <b141489b-780c-1753-2a83-ccb60c4554d0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 11:44:02 -0500 George Kennedy wrote:
> > It looks like a lot of the problem is duplicate unwind.
> > Why does err_free_flow, err_free_stat etc unwinds need to exist if
> > the free_netdev is going to do same thing.  
> 
> Maybe instead do not call security_tun_dev_free_security(tun->security) 
> in err_free_flow if it's going to be done anyway in tun_free_netdev().

That won't be good either. register_netdevice() has multiple failure
modes, it may or may not call the destructor depending on where it
fails. Either the stuff that destructor undoes needs to be moved to
ndo_init (which is what destructor always pairs with), or you can check
dev->reg_state. If dev->reg_state is NETREG_UNREGISTERING that means
the destructor will be caller later.

The ndo_init way is preferable, just cut and past the appropriate lines
preceding registration into a ndo_init callback.
