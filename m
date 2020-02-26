Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD0B16F96B
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 09:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbgBZIPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 03:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:40134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727267AbgBZIPh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 03:15:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E06D20714;
        Wed, 26 Feb 2020 08:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582704936;
        bh=DZJJ59MD4ZfA2IpkgNPwKODsDmCSF4cgvPtO6DpGdD8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hb5AKJga1qq4RyJSLnDN/mVBAuilidZfO5jckJwvSgDSpzFrYJ/nqyaYZKohrc82S
         7PGY66eVZWh3CoNbxvh7yXCKYlwUtCf3gG5c5urBJm2qGeRnRmAvCV1oi9/P/dVj6F
         MGrmXyh9OpbPPstdma9UDIo+Aamo/JQM0H/H1rv4=
Date:   Wed, 26 Feb 2020 09:15:33 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v6 4/9] sysfs: add sysfs_change_owner()
Message-ID: <20200226081533.GC24447@kroah.com>
References: <20200225131938.120447-1-christian.brauner@ubuntu.com>
 <20200225131938.120447-5-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200225131938.120447-5-christian.brauner@ubuntu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:19:33PM +0100, Christian Brauner wrote:
> Add a helper to change the owner of sysfs objects.
> This function will be used to correctly account for kobject ownership
> changes, e.g. when moving network devices between network namespaces.
> 
> This mirrors how a kobject is added through driver core which in its guts is
> done via kobject_add_internal() which in summary creates the main directory via
> create_dir(), populates that directory with the groups associated with the
> ktype of the kobject (if any) and populates the directory with the basic
> attributes associated with the ktype of the kobject (if any). These are the
> basic steps that are associated with adding a kobject in sysfs.
> Any additional properties are added by the specific subsystem itself (not by
> driver core) after it has registered the device. So for the example of network
> devices, a network device will e.g. register a queue subdirectory under the
> basic sysfs directory for the network device and than further subdirectories
> within that queues subdirectory.  But that is all specific to network devices
> and they call the corresponding sysfs functions to do that directly when they
> create those queue objects. So anything that a subsystem adds outside of what
> driver core does must also be changed by it (That's already true for removal of
> files it created outside of driver core.) and it's the same for ownership
> changes.
> 
> Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>

Thanks for the documentation update, looks good:

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
