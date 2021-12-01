Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65376464545
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 04:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346357AbhLADM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:12:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346422AbhLADMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:12:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2880FC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 19:09:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71C4BCE1A31
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 03:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B04C53FCC;
        Wed,  1 Dec 2021 03:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638328167;
        bh=lwLCqyAnfFMpSY98Obo0M9K79bb8rX1EcoFWZxOrSK8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DdkPMLmiU2x/t3ruorIwY+sAkdhYM1Gd2WtoJMaDVhKM/CxJm5ue2HDsrEEqFH+br
         2/DN0UB83YCOiU+Brjlze6L2JvTYDvPqOKdLIKzs8NnhNMPO/4CcK2bLu9GlxgH9Bv
         iAIOvvQafkMG2ketjzGjyXlgtC7vsVTR6zOBgtUab7PldTWAzsrnkG5SBE4acJYTd1
         Al6U2FsHM+9FpTVtSDavQve0Bqz8F3lvUX1XPufv0vvMZFhLmZbqa59XF3HXy16Thx
         LPrUxCtIZv90IFqZHPGX05dHZZJFADEW258zT+uT0OlgRrQsUtMjnV1LrblnkXhQ9I
         KkpiDbPsOYKbA==
Date:   Tue, 30 Nov 2021 19:09:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [RFC PATCH 0/4] r8169: support dash
Message-ID: <20211130190926.7c1d735d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
        <20211129095947.547a765f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <918d75ea873a453ab2ba588a35d66ab6@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Dec 2021 02:57:00 +0000 Hayes Wang wrote:
> Jakub Kicinski <kuba@kernel.org>
> > Sent: Tuesday, November 30, 2021 2:00 AM
> > Subject: Re: [RFC PATCH 0/4] r8169: support dash
> > 
> > On Mon, 29 Nov 2021 18:13:11 +0800 Hayes Wang wrote:  
> > > These patches are used to support dash for RTL8111EP and
> > > RTL8111FP(RTL81117).  
> > 
> > If I understand correctly DASH is a DMTF standard for remote control.
> > 
> > Since it's a standard I think we should have a common way of
> > configuring it across drivers.  
> 
> Excuse me. I am not familiar with it.
> What document or sample code could I start?
> 
> > Is enable/disable the only configuration
> > that we will need?  
> 
> I don't think I could answer it before I understand the above way
> you mentioned.
> 
> > We don't use sysfs too much these days, can we move the knob to
> > devlink, please? (If we only need an on/off switch generic devlink param
> > should be fine).  
> 
> Thanks. I would study devlink.

I'm not sure how relevant it will be to you but this is the
documentation we have:

https://www.kernel.org/doc/html/latest/networking/devlink/index.html
https://www.kernel.org/doc/html/latest/networking/devlink/devlink-params.html

You'll need to add a generic parameter (define + a short description)
like 325e0d0aa683 ("devlink: Add 'enable_iwarp' generic device param")

In terms of driver changes I think the most relevant example to you
will be:

drivers/net/ethernet/ti/cpsw_new.c

You need to call devlink_alloc(), devlink_register and
devlink_params_register() (and the inverse functions).
