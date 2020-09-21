Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EAD27369F
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbgIUX0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:43476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgIUX0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 19:26:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F293723A6C;
        Mon, 21 Sep 2020 23:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600730805;
        bh=PzmgE2q46al4ZeKWFU/MDd4rkMwb2NpH3wqzW6gDnoo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z27C8LhBfH87TabcikPdwrA+CGuI1NQU/G3wnqQ+swvIaLnnHqMXzeznyC65G5dpt
         enHtijuc1JruykvrrO4WH8EBIbwSJPAlkAgkWlAB3L2X70ff8lRWF3xnMCdHbrjrpB
         m3mwaQ6DnY0tCsmkIKEaWX3DRL9AAdfpqLPyC4U4=
Date:   Mon, 21 Sep 2020 16:26:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislaw Kardach <skardach@marvell.com>
Cc:     <davem@davemloft.net>, <sgoutham@marvell.com>,
        <netdev@vger.kernel.org>, <kda@semihalf.com>
Subject: Re: [PATCH net-next v2 3/3] octeontx2-af: add support for custom
 KPU entries
Message-ID: <20200921162643.6a52361d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200921175442.16789-4-skardach@marvell.com>
References: <20200921175442.16789-1-skardach@marvell.com>
        <20200921175442.16789-4-skardach@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Sep 2020 19:54:42 +0200 Stanislaw Kardach wrote:
> Add ability to load a set of custom KPU entries via firmware APIs. This
> allows for flexible support for custom protocol parsing and CAM matching.
> 
> The firmware file name is specified by a module parameter (kpu_profile)
> to allow re-using the same kernel and initramfs package on nodes in
> different parts of the network where support for different protocols is
> required.
> 
> AF driver will attempt to load the profile from the firmware file and
> verify if it can fit hardware capabilities. If not, it will revert to
> the built-in profile.
> 
> Next it will read the maximum first KPU_MAX_CST_LT (2) custom entries
> from the firmware image. Those will be later programmed at the top of
> each KPU after the built-in profile entries have been programmed.
> The built-in profile is amended to always contain KPU_MAX_CSR_LT first
> no-match entries and AF driver will disable those in the KPU unless
> custom profile is loaded.

So the driver loads the firmware contents, interprets them and programs
the device appropriately?

Real firmware files are not usually interpreted or parsed by the driver.
