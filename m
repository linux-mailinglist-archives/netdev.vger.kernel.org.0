Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D43A71E2
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 00:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhFNW1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 18:27:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFNW1k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 18:27:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 415DC611EE;
        Mon, 14 Jun 2021 22:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623709537;
        bh=p42I5PjK3IFM01tg8PmHjDB28mgxh90ooODVbYVknQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RFOX1TkZ4SlyWD1jb8GFG8Gzvp7dP628dQEfjjoS3o7RbNmhWFPvrY2ZB1H3cI4Pp
         e1YUrlRtazBHwKC71atHntxSPvLZw4s0V4ojECvBDbXBn/WZLZqb+igDzBx520S9mk
         RFm8I5wqFO4VLAxPwt+/O8l4vs0xBFG7hx9gBgUY1ni3BG4kmC0SxQhhSZHyAN9BWZ
         1dgutrYrvry7YEBxrVjG6Sr+dZDWGtGz6wEqNp4pjYVWyFn+Yanw+C/xf5HcGF04bd
         wgLAzLSRNhYei3WMA+/cCHqWqyC1GghM4NyLgB+wb+z9p07sJGD7HMc1IDa6SGMtDj
         /fiG9B+W4PvvQ==
Date:   Mon, 14 Jun 2021 15:25:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Brelinski, TonyX" <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 5/8] ice: register 1588 PTP clock device object
 for E810 devices
Message-ID: <20210614152536.2f6fc094@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ce2898d4-7cb9-c668-58e1-a3d759cb6b13@intel.com>
References: <20210611162000.2438023-1-anthony.l.nguyen@intel.com>
        <20210611162000.2438023-6-anthony.l.nguyen@intel.com>
        <20210611141800.5ebe1d4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ca27bafc-fdc2-c5f1-fc37-1cdf48d393b2@intel.com>
        <20210614110831.65d21c8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <427ddb2579f14d77b537aae9c2fa9759@intel.com>
        <20210614134802.633be4c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <ce2898d4-7cb9-c668-58e1-a3d759cb6b13@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Jun 2021 13:51:57 -0700 Jacob Keller wrote:
> > Ah, you're right, ptp4l will explicitly cap the freq adjustments
> > based on max_adj from sysfs, so setting max_adj too low could impact
> > the convergence time in strange scenarios.
> 
> Your patch to fix it so that the conversion from scaled_ppm to ppb can't
> overflow is the correct approach, here. The scaled_ppm function didn't
> account for the fact that the provided adjustment could overflow the s32.
> 
> Increasing that to s64 ensures it won't overflow and prevents invalid
> bogus frequencies from passing that check.

On second though I went with long for ppb IOW the same as scaled_ppm,
presumably the problem does not exist on 32bit, so no point using 64b
everywhere.
