Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CE256378E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiGAQQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiGAQQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:16:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60373B3C9;
        Fri,  1 Jul 2022 09:16:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81E54624FE;
        Fri,  1 Jul 2022 16:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 917ECC3411E;
        Fri,  1 Jul 2022 16:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656692160;
        bh=rPLnVuFYKE2hnIL4OrOAXJEyO4Ed+Pa/RTSKSg3uzvk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BuaOb3sZXxVkcdUYJx0r6XejHVdsL1EvYNhpkICQ362rv2o1vZThMCeQvgRftijj+
         xd8UI7zjWJ06tc/aX2leRJ7AMhTkVc18Imox/LwLCS51pvXSLb2mNI9i0y/QxUVNlC
         F2Ak5/QIGV405lMGFgEJoROykinGU8xY8ecFmm5RQk/sAUhqVNSyG3PH0TYB7zFH8j
         XX9UYtEjSpVz4bw57vPK7pyW8Hxt3I9NaNA7f0lX7SNfuYNQ+VtWpQENxbfV7Z0S6i
         sLDwuBrZePh/UbsVD56j7dzrTRO9U+xPliisNB1H40bq46d+uWbyL1wJN+2lfN8HA6
         U7P+fxPIvYDzg==
Date:   Fri, 1 Jul 2022 09:15:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Lamparter <equinox@diac24.net>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
Message-ID: <20220701091559.0d6e1081@kernel.org>
In-Reply-To: <Yr7z7HU2Z79pMrM0@eidolon.nox.tf>
References: <20220701044234.706229-1-kuba@kernel.org>
        <Yr7NpQz6/esZAiZv@nanopsycho>
        <Yr7z7HU2Z79pMrM0@eidolon.nox.tf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 1 Jul 2022 15:17:32 +0200 David Lamparter wrote:
> > Hmm, I can understand what for driver for HW that is no longer
> > developed, the driver changes might be very minimal. The fact that the
> > code does not change for years does not mean that there are users of
> > this NIC which this patch would break :/  

Nah, bugs will be discovered. Look at mlx4 or ixgbe, those are
similarly old yet we still occasionally get a fix for a 10 year old
bug. The only bug report I could find for vxge is RH bugzilla filed
likely by RH QA themselves, 11 years ago.

> > Isn't there some obsoletion scheme globally applied to kernel device
> > support? I would expect something like that.  
> 
> I have the same question - didn't see any such policy but didn't look
> particularly hard.

I don't know of any one that works, that's the problem. I think
previous discussions were about more serious stuff like uAPI.

I don't really care about vxge in particular, I was already looking for
something to delete and the bad patch I mention in the commit msg came
up. What I'm mostly interested in is getting some experience to inform
a deletion policy. We can't come up with one by just talking. I'm
hoping to make this a topic for the maintainer's summit as well.

We are pretty open to taking in new drivers, (necessarily) even without
users, I think the flip side of that coin has to be that we delete unused
stuff. We're not a code storage service.

Here are some facts:
 - driver is not actively maintained (Jon did not nack the bad patch)
 - driver has no known users (it's unlikely they exist)
 - driver is not of great quality (constant stream of bot fixes)
 - driver is of significant complexity and needs to be adjusted each
   time we change core APIs

It's been over a decade of no development, let's delete this code.

If someone complains we can quickly revert the deletion in stable
(CCing Greg to keep me honest, I haven't actually talked to him).
I'm obviously responsible for the deletion so I'll prepare the revert.
