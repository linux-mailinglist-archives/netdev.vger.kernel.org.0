Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D1D515318
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 19:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379840AbiD2SAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 14:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379795AbiD2SAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 14:00:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246F4C12E2
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 10:57:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B67CF62307
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 17:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60BAC385A7;
        Fri, 29 Apr 2022 17:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651255037;
        bh=8YUeZ16Q0twPHNndMdVAm1ySeAwOTK3s4fspDMZeNVU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dEL9N/mftVB+qDiZLtvv26rYXbSPIA77jkKb9BHbjBbV+x6euxCqspmmMeOob9d0q
         B2L7zuJ5czUicDp5LO3Yk/0Jej3kdi0CU9LgLlIBCKWu6xE3p5EIvB9tmaOxISbwnd
         zrOm6bI3Me3+7OW61mmgGxXVwIT1hAxC8PLFLem73uxQUIFNpLWlLBrjVd+CK7Q/0T
         TgNtE84lfTvWn88jIlDTSjvw4LgjPBLPGg5/Quc3yqqrsPJS4DZ+4FHjObq4c90RjF
         QeRooDO2zuUjsVTnAM+IEGia6dhngzcvHfhN2PAUhKHDzR0egUxgmXASeJgObJ9Fp4
         a2CWmb5M2Fabg==
Date:   Fri, 29 Apr 2022 10:57:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Maloszewski, Michal" <michal.maloszewski@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net 1/2] iavf: Fix error when changing ring parameters
 on ice PF
Message-ID: <20220429105715.6179fc9b@kernel.org>
In-Reply-To: <BL1PR11MB54308512D3CB817F76DFBCF686FC9@BL1PR11MB5430.namprd11.prod.outlook.com>
References: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
        <20220420172624.931237-2-anthony.l.nguyen@intel.com>
        <20220422154752.1fab6496@kernel.org>
        <BL1PR11MB5430A4AD0469C1C4BDCBB5C486FD9@BL1PR11MB5430.namprd11.prod.outlook.com>
        <20220428112820.4f36b5e6@kernel.org>
        <BL1PR11MB54308512D3CB817F76DFBCF686FC9@BL1PR11MB5430.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 13:14:12 +0000 Maloszewski, Michal wrote:
> >> When we have state which is running, it does not mean that we have 
> >> queues configured on PF. So in order to configure queues on PF, the 
> >> IAVF_FLAG_QUEUES has to be disabled. I use here EAGAIN, because as 
> >> long as we are not configured with queues, it does not make any sense 
> >> to trigger command and we are not sure when the configuration of 
> >> queues will end - so that is why EAGAIN is used.  
> >
> >Let me rephrase the question. Does getting out of the state where error is
> >reported require user to change something, or is it something that happens
> >automatically behind the scenes (i.e. the state is transient).  
> 
> It is something that happens automatically behind the scenes. 
> It takes some time and there is no guarantee that it will be finished.

Then either wait for it to finish (wait queue or such) or if
possible record the desired config and return success. Apply
the new config when the reset is finished.

It really seems like you're making users pay the price for poor
design of the driver's internals.
