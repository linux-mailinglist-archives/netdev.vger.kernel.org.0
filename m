Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4554F64FE
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbiDFQNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237201AbiDFQMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:12:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3329123ACAD
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 20:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFCD4619B6
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 03:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4AAC385A6;
        Wed,  6 Apr 2022 03:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649216880;
        bh=Tt05zvSzomiDRjhEQlWcy509zJOPiSQlucql3XBzMEo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XffmZXa77vYkz9zWs/mjB3mOFGe78Lwbta/2IX/Rw4iGkzufJHebYU42xcjHFXAl5
         BcFcnuJusiNmY4JjCvgMAGwnU6445JgRRmIjZ585m31Wu/9S+De2NmU0+2515fDwqk
         5F0XyoCBE50pPj4ufntoHcD9whW0gOT4Ye61Lzkt4Y+A82vSlXnVj1iMxxLBUncuHk
         L0OYZQNipJ/f9LO6rrHcC+aWO0jnWxbHgQmuc07uNoHLGF54PGPVpoMrKgNNjDXr3q
         +aSP9gyTrg1VQIYQXCETpY0vGkK0n2BO8cn8+G7veoemyl/4DTxViiMHjqxPOSsDoB
         2WRnCW50UCSbA==
Date:   Tue, 5 Apr 2022 20:47:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ian Wienand <iwienand@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Tom Gundersen <teg@jklm.no>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: [PATCH v2] net/ethernet : set default assignment identifier to
 NET_NAME_ENUM
Message-ID: <20220405204758.3ebfa82d@kernel.org>
In-Reply-To: <YkzzYxn0/04JT6Yv@fedora19.localdomain>
References: <20220405001500.1485242-1-iwienand@redhat.com>
        <20220405124103.1f25e5b5@kernel.org>
        <YkzzYxn0/04JT6Yv@fedora19.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Apr 2022 11:56:51 +1000 Ian Wienand wrote:
> Thanks for review
> 
> On Tue, Apr 05, 2022 at 12:41:03PM -0700, Jakub Kicinski wrote:
> > Can you spell out how netfront gets a different type to virtio?
> > I see alloc_etherdev_mq() in both cases.  
> 
> Yeah I've been doing further testing to narrow this down, and I think
> I've been confused by the renaming happening during the initrd steps.
> 
> It seems that renamed devices (no matter what the driver) will have
> their name_assign_type set to NET_NAME_USER; which [1] gives away as
> coming from the rtnl_newlink path.  virtio devices were renamed in
> init phase in my testing environment, which is why
> /sys/class/net/<iface>/net_name_type works for them by the time
> interactive login starts -- not because they explicitly flag
> themselves.  Sorry for not recognising that earlier.
> 
> > This worries me. Why is UNKNOWN and ENUM treated differently?
> > Can you point me to the code which pays attention to the assign type?  
> 
> Yeah, I'll have to retract that claim; it remains unclear to me why
> CentOS 8-stream does not rename netfront devices (systemd 239) and
> CentOS 9-stream does (systemd 249).
> 
> systemd only seems to use NET_NAME_ENUM in an informational way to
> print a warning when you're using a .link file to set network info for
> a device that might change names [2].
> 
> Perhaps this still has some utility in making that warning more
> useful?

Okay, all good then. I was worried some user space is refusing to
rename UNKNOWN. I have no objection to changing UNKNOWN -> ENUM.
We just need the commit message to be updated.
