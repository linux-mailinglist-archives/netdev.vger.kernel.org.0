Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1DC645683
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 10:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiLGJcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 04:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLGJcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 04:32:52 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963941010
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 01:32:50 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 05BE121C43;
        Wed,  7 Dec 2022 09:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1670405569; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=idZFoqWrH89JBE4OgxfHWhTHygKga3/FXRlwq09deFU=;
        b=P0/2G8t96/ibpFLo86PWgjnosQG+s1vs2lj8Bdg244eE08jhsY9PhuEF7FOyPzhPliMEpJ
        T2qmYhQ3ty08/niGjacfIM0Uxqta3ecziuc943N7xv5mr04DpFnbKUHLP1DIANobu11zJy
        jUXStKcEyq/XUIlcsUKU2SA4nircDuk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1670405569;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=idZFoqWrH89JBE4OgxfHWhTHygKga3/FXRlwq09deFU=;
        b=qVEGTCVS3dkHKMswhHTnmcV7hJN2E6BiTrR6Fh1ZeYYmKe4WNb8VguLfngkwyVsZ4WWcaP
        C/oGHT3BWlKIQiAw==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C4ADA2C141;
        Wed,  7 Dec 2022 09:32:48 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 955A96030C; Wed,  7 Dec 2022 10:32:48 +0100 (CET)
Date:   Wed, 7 Dec 2022 10:32:48 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, corbet@lwn.net,
        sridhar.samudrala@intel.com, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v7] ethtool: add netlink based get rss support
Message-ID: <20221207093248.x6dwbcdxkgaqb6zh@lion.mk-sys.cz>
References: <20221202002555.241580-1-sudheer.mogilappagari@intel.com>
 <Y4yPwR2vBSepDNE+@unreal>
 <20221204153850.42640ac2@kernel.org>
 <Y42hg4MsATH/07ED@unreal>
 <20221206161441.ziprba72sfydmjrk@lion.mk-sys.cz>
 <Y5BR/n7/rqQ+q8gm@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5BR/n7/rqQ+q8gm@unreal>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 10:42:38AM +0200, Leon Romanovsky wrote:
> On Tue, Dec 06, 2022 at 05:14:41PM +0100, Michal Kubecek wrote:
> > 
> >   - avoiding the inherently racy get/modify/set cycle
> 
> How? IMHO, it is achieved in netlink by holding relevant locks, it can
> be rtnl lock or specific to that netlink interface lock (devl). You cam
> and should have same locking protection for legacy flow as well.

What I had in mind is changing only one (or few) of the parameters which
are passed in a structure via ioctl interface, i.e. commands like

  ethtool -G eth0 rx 2048

To do that with ioctl interface, userspace needs to fetch the whole
ethtool_ringparam structure with ETHTOOL_GRINGPARAM first, modify its
rx_pending member and pass the structure back with ETHTOOL_SRINGPARAM.
Obviously you cannot hold a kernel lock over multiple ioctl() syscall.

In some cases, there is a special with "no change" meaning but that is
rather an exception. It would be possible to work around the problem
using some "version counter" that would kernel check against its own
(and reject the update if they do not match) but introducing that would
also be a backward incompatible change.

Michal
