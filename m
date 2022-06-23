Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8F8557F56
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 18:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbiFWQHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 12:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbiFWQHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 12:07:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C66544A1C
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 09:07:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A906161EDE
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8292C3411B;
        Thu, 23 Jun 2022 16:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656000468;
        bh=ODQ+lCa1/KsLzalYs2pWvR31kK2GV1GmjDSRYfOl9kk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Qajl7iCNKoTsjW8+r12M4VQAPJBZ1pD5+XQKQWInFMgsVfvBS0FSGnRPsDbHHJa65
         kLKjW5Ez+9STZffekPRwkYvas89p2bk/jUtBCqEVYDJSQ21NkE9UlUaUaOceyrLJSh
         lReyCHcIzZTT5nrN8lMLuiiHysRtPI6dkii+V0SZU+7z5iJ5Hc9EWILKpYsBQm2mSH
         gKdI0gFqN06oeHgJMbipWfSSc4eSArV4zsDFyZGdWTZL3fYyDL9Tu3z7ysFZLjREfw
         Mx24OVeZWq7OS0wUtSsX3fInPBADFqUP6OlH1nnAfWBbZvigXfkVcrKuPnPL1GWUyk
         hfHpvM8ATJS0A==
Date:   Thu, 23 Jun 2022 09:07:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Kolacinski, Karol" <karol.kolacinski@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Message-ID: <20220623090739.2ae8c14b@kernel.org>
In-Reply-To: <MW4PR11MB58003D5B00016D1F30E0DC0686B59@MW4PR11MB5800.namprd11.prod.outlook.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
        <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
        <20220518215723.28383e8e@kernel.org>
        <MW4PR11MB58005F4C9EFF1DF1541A421C86D49@MW4PR11MB5800.namprd11.prod.outlook.com>
        <20220523105850.606a75c1@kernel.org>
        <MW4PR11MB58003D5B00016D1F30E0DC0686B59@MW4PR11MB5800.namprd11.prod.outlook.com>
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

On Thu, 23 Jun 2022 13:39:35 +0000 Kolacinski, Karol wrote:
> On Mon, 23 May 2022 19:58 +0000 Jakub Kicinski wrote:
> > I meant discovered at the uAPI level. Imagine I plug in a shiny E810T
> > with a GNSS receiver into a box, the PRSNT_N bit is set and the driver
> > registered the ttys. How do I find the GNSS under /dev ?  
> 
> If the module is physically present, driver creates 2 TTYs for each supported
> device in /dev, ttyGNSS_<device>:<function>_0 and _1. First one (_0) is RW and
> the second one is RO.
> The protocol of write commands is dependent on the GNSS module as the driver
> writes raw bytes from the TTY to the GNSS i2c.
> 
> I added this to Documentation/.

Sounds good, thanks!
