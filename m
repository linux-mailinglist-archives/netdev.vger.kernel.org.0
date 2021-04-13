Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0079235D56E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 04:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241799AbhDMCt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 22:49:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239643AbhDMCt4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 22:49:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A8D761222;
        Tue, 13 Apr 2021 02:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618282177;
        bh=qsHKlqh/cpVIxFDARoHirpJ/9eKqitQeqGqmBhEjaxE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cORnOqAJ9h7csqsg4ipC+djk9BKDMpZxLsRKuHJlwuOCapCAX0CeFmnBKCBOA1ZDG
         hy//JWOQ5BZnFrd7p/kJGAarnL4pMqChblwd2Ni0VStoBLoCQ6x6Act8i3ynA51aTh
         /DtZPtcWn0DLNGno1UU2jKHdessGic+UViDtwNF8Hmh1oPUpbL4Z2neV2O6YqRanca
         5SnQt35UB6sEQT4IdpUsaLqa3QSvCBkA5hux5pg1n/sLDc3Vwyfs7+XD35N0EEEzOt
         RBOkVYwTa6i55Qu+Mklcj8jjxZBVtuYfFCqUDZ19ePozMJpSrB1UJFvZ3E1d8VQVSk
         8ksuLn4SEN6yg==
Date:   Mon, 12 Apr 2021 19:49:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ibmvnic: add sysfs entry for timeout and
 fatal reset
Message-ID: <20210412194936.7c0d2e4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAOhMmr5H_0QuSwOU-FEBQb3CHegSi4f3hdtEtprKKF7i1WebEw@mail.gmail.com>
References: <20210412074330.9371-1-lijunp213@gmail.com>
        <20210412074330.9371-3-lijunp213@gmail.com>
        <20210412112323.26afa89c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAOhMmr5H_0QuSwOU-FEBQb3CHegSi4f3hdtEtprKKF7i1WebEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 15:26:00 -0500 Lijun Pan wrote:
> On Mon, Apr 12, 2021 at 1:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 12 Apr 2021 02:43:30 -0500 Lijun Pan wrote:  
> > > Add timeout and fatal reset sysfs entries so that both functions
> > > can be triggered manually the tested. Otherwise, you have to run
> > > the program for enough time and check both randomly generated
> > > resets in the long long log.  
> >
> > This looks more suitable for debugfs.
> >
> > But can't you use ethtool or devlink reset functionality somehow?  
> 
> ethtool and devlink reset seem better to be implemented by a FAILVOER reset for
> this driver. ethtool/devlink reset are not implemented in this driver,
> which will be a todo list for me.

ethtool isn't really much to implement, its basically a bunch of ops
the driver implements. You can pick and choose which ones you implement.

It'd be better to use ethtool or devlink, but I guess debugfs could be
acceptable too. sysfs is a stable API, so it's definitely a no-go.

> This timeout reset can be triggered by tx watchdog,
> .ndo_tx_timeout->ibmvnic_tx_timeout->ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
> Do you know is there a way to trigger that ndo_tx_timeout from some
> user space tool?
> 
> The FATAL reset is triggered by Firmware, quite specific for this driver.
> So in order to verify that, I put it in sysfs entry.

Good question, I don't think we have a way to trigger the timeout 
in a generic way. My first instinct would be to use ethtool self test
(ethtool_ops->self_test) to call the same function within the driver.
