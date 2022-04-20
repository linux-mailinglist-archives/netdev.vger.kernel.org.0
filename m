Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A88E50814F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 08:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352971AbiDTGla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 02:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355703AbiDTGl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 02:41:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D87A435246;
        Tue, 19 Apr 2022 23:38:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5C7617E4;
        Wed, 20 Apr 2022 06:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAA4C385A1;
        Wed, 20 Apr 2022 06:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650436719;
        bh=Ulp2uHH2QMrPkqjxvlQjTR4D2G7L2h9l4LRiYfoqp7E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ji+urf2156sh2jw2j2gwVYmGyxKuQ89gjDU/z0qWU6xSAs0d5Hw2uEOb5i0y3xhyw
         lxMS3PvtggpUPrlbHeS3slVkZnTdU4/VwXzGL8ZoipsPw6CiVJmIzrGmvcxAbkQzDF
         urEHfPL46ethOtyluuL72bBvC5E4r/wJ1qnS8gCk=
Date:   Wed, 20 Apr 2022 08:38:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] add support for enum module parameters
Message-ID: <Yl+qbPG19ot5N3ut@kroah.com>
References: <20220414123033.654198-1-jani.nikula@intel.com>
 <YlgfXxjefuxiXjtC@kroah.com>
 <87a6cneoco.fsf@intel.com>
 <87sfq8qqus.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sfq8qqus.fsf@tynnyri.adurom.net>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 20, 2022 at 08:13:47AM +0300, Kalle Valo wrote:
> + linux-wireless, netdev
> 
> Jani Nikula <jani.nikula@intel.com> writes:
> 
> > On Thu, 14 Apr 2022, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >> On Thu, Apr 14, 2022 at 03:30:32PM +0300, Jani Nikula wrote:
> >>> Hey, I've sent this before, ages ago, but haven't really followed
> >>> through with it. I still think it would be useful for many scenarios
> >>> where a plain number is a clumsy interface for a module param.
> >>> 
> >>> Thoughts?
> >>
> >> We should not be adding new module parameters anyway (they operate on
> >> code, not data/devices), so what would this be used for?
> >
> > I think it's just easier to use names than random values, and this also
> > gives you range check on the input.
> >
> > I also keep telling people not to add new module parameters, but it's
> > not like they're going away anytime soon.
> >
> > If there's a solution to being able to pass device specific debug
> > parameters at probe time, I'm all ears. At least i915 has a bunch of
> > things which can't really be changed after probe, when debugfs for the
> > device is around. Module parameters aren't ideal, but debugfs doesn't
> > work for this.
> 
> Wireless drivers would also desperately need to pass device specific
> parameters at (or before) probe time. And not only debug parameters but
> also configuration parameters, for example firmware memory allocations
> schemes (optimise for features vs number of clients etc) and whatnot.
> 
> Any ideas how to implement that? Is there any prior work for anything
> like this? This is pretty hard limiting usability of upstream wireless
> drivers and I really want to find a proper solution.

Again, configfs?  That should be what that subsystem was designed for...

thanks,

greg k-h
