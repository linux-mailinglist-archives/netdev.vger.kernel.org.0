Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F3858B098
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 21:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbiHET6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 15:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiHET6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 15:58:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0051E3C6
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 12:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F471B829E8
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 19:58:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C79C433D6;
        Fri,  5 Aug 2022 19:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659729525;
        bh=8GyTfo/xig9mMK2sKTW8FsWYFOVMiw67n94LpVCBjRs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jG8oY9LSLcUy9L6TocfNNZqv4RUqjwNBHo8CycP03P/M3sUUcl8Ng6iuQO+k8ZlvI
         byndK1IMUSs4xrEiIZVfvtmJWoHK93AGEteqOu7EDgomhmXzT6VZb76tcH8tegi2E2
         IweOKcfvFFa32Z5QN6TYASE1PXwZa3VPyUh0+tVagaOMFHNI5QZwccQ3Lp3KHQ+t1D
         jZeX+SEh7uO1wIKMi6OdOi2Vt1NDGLzlpU8tIy0kW4+Q48efkD7xX45RMOAMYCdhug
         RRS1eFTYhImnvPC1GoCMldhgvXbM8wn+jAIq3eBAyVEkodZhjlPIkFMseoPHbLdk3J
         ww27E0+sUHncw==
Date:   Fri, 5 Aug 2022 12:58:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "moshe@nvidia.com" <moshe@nvidia.com>
Subject: Re: [patch net-next 2/4] net: devlink: convert reload command to
 take implicit devlink->lock
Message-ID: <20220805125843.540fbc9c@kernel.org>
In-Reply-To: <CO1PR11MB50899F33FF6F1B95CD3F1B11D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220729071038.983101-1-jiri@resnulli.us>
        <20220729071038.983101-3-jiri@resnulli.us>
        <CO1PR11MB50899F33FF6F1B95CD3F1B11D69E9@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 5 Aug 2022 16:21:16 +0000 Keller, Jacob E wrote:
> > Convert reload command to behave the same way as the rest of the
> > commands and let if be called with devlink->lock held. Remove the
> > temporary devl_lock taking from drivers. As the DEVLINK_NL_FLAG_NO_LOCK
> > flag is no longer used, remove it alongside.
> > 
> > Signed-off-by: Jiri Pirko <jiri@nvidia.com>  
> 
> Wasn't reload avoiding the lock done so that drivers could perform other devlink operations during reload? Or is that no longer a problem with the recent refactors done to move devlink initialization and such earlier so that its now safe?

Drivers have control over the lock now, they can take the lock
themselves (devl_lock()) and call the "I'm already holding the lock"
functions. So the expectation is that shared paths used by probe and
reload will always run under the lock.
