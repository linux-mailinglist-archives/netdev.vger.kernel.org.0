Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02964D67C0
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 18:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350794AbiCKRki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 12:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350836AbiCKRkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 12:40:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2469C1AEEDA
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 09:39:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9369B82C89
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 17:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453FCC340E9;
        Fri, 11 Mar 2022 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647020355;
        bh=EDg53oczAB/bKJcQjRwXU6CJ+IDOkPsykEoh7eIMt0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QHkOtWp8ccEpmGkoovCCsGm8mrCJu/iXblnBOjIZf1wuIUfi7cuaoqiqI85U/ybNg
         +OB+1+cXEYlc96mbLp6pOT2odAmaaXnPrIcw7cRzZLpZWcmYm9DdBkkMhIk4wP56rX
         Aw3XOlMHajWlNSf0Fv0lDW3VPM8E72K32s5mcZ+05YdjN63lKUywdkSWjJAaJTO4aT
         bRFCbi5eYXEpPDzeKTsuFtKs1fkBlNjfakLtGciTeG9/+KehRcarPjRlQa5eBIo7RZ
         ooQUgBhaGJDTMvLvdS+Al6znj4POMj98AaBzT2ziq6O8Z8dX2BmdQiF/oC/We4rG0x
         MyJnYzJyxrgVA==
Date:   Fri, 11 Mar 2022 09:39:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     <idosch@nvidia.com>, <petrm@nvidia.com>,
        <simon.horman@corigine.com>, <netdev@vger.kernel.org>,
        <jiri@resnulli.us>
Subject: Re: [RFT net-next 1/6] devlink: expose instance locking and add
 locked port registering
Message-ID: <20220311093913.60694baf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <Yit/f9MQWusTmsJW@unreal>
References: <20220310001632.470337-1-kuba@kernel.org>
        <20220310001632.470337-2-kuba@kernel.org>
        <Yit0QFjt7HAHFNnq@unreal>
        <20220311082611.5bca7d5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yit/f9MQWusTmsJW@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 18:57:35 +0200 Leon Romanovsky wrote:
> On Fri, Mar 11, 2022 at 08:26:11AM -0800, Jakub Kicinski wrote:
> > On Fri, 11 Mar 2022 18:09:36 +0200 Leon Romanovsky wrote:  
> > > What about this?  
> > 
> > Is it better?   
> 
> I think so. It doesn't create shadow dependency on LOCKDEP.
> In your variant, all users of this call will generate WARN
> in production systems that run without lockdep.

No, no, that function is mostly for rcu dereference checking.
The calls should be eliminated as dead code on production systems.

> So if you want the "eliminate" thing like you wrote in the comment,
> the ifdef is a common solution.

I think these days people try to use IS_ENABLED() whenever possible.

> > Can do it you prefer, but I'd lean towards a version
> > without an ifdef myself.  
> 
> So you need to add CONFIG_LOCKDEP dependency in devlink Kconfig.

I don't see why.
