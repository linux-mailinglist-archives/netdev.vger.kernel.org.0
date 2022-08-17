Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B9559734E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 17:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237227AbiHQPry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 11:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234267AbiHQPrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 11:47:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7370488DCE
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 08:47:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 201E4B81E09
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 15:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E764C433C1;
        Wed, 17 Aug 2022 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660751269;
        bh=tSa2s2YxFDhsWP+2KDNE+J3rjAOdNufNPNqD3O3tImU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tT2XmYtPrh/LlM0C/LCy91++/F/Ix4Z6naDOw6WjmdsDL7P/7QlnXkpapL2OvSxq/
         bDJQkq8mytng16nFftS6z1jR8YVggVo9FHbwiOnFTFIs64/OFvrukqRjMYoHushcZn
         nYp63RSPAx/yNvx4PW192J2f7l/rZBJKswPSJocWVJ45TCDFWjeDllP2IAx7VphPmA
         N3+SowIaAu3tEHcOnUWU+rYfC8su+9cTM4MoiD96WtLFQi++bcEnazpsuChipLFKL0
         On8Db9D0c3legtK1bAKMWzKwWRDUORMH9GpMFhrrCVi4q6ngZtArceQdxZiB2u7feZ
         8g/DlWfTilgWw==
Date:   Wed, 17 Aug 2022 08:47:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Sokolowski, Jan" <jan.sokolowski@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Jaron, MichalX" <michalx.jaron@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Jagielski, Jedrzej" <jedrzej.jagielski@intel.com>,
        "Szlosek, Marek" <marek.szlosek@intel.com>
Subject: Re: [PATCH net 2/2] ice: Fix call trace with null VSI during VF
 reset
Message-ID: <20220817084748.7ed9ee99@kernel.org>
In-Reply-To: <PH7PR11MB5819695C8B5C6E5F7D0500E1996A9@PH7PR11MB5819.namprd11.prod.outlook.com>
References: <20220811161714.305094-1-anthony.l.nguyen@intel.com>
        <20220811161714.305094-3-anthony.l.nguyen@intel.com>
        <20220812171319.495e33f5@kernel.org>
        <PH7PR11MB5819695C8B5C6E5F7D0500E1996A9@PH7PR11MB5819.namprd11.prod.outlook.com>
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

On Wed, 17 Aug 2022 13:31:00 +0000 Sokolowski, Jan wrote:
> I'd like to send this response in Michal Jaron's name, as he currently cannot respond to this email.
> 
> Generally you are right, it is better idea to try to keep the system
> in a consistent state than adding "if NULL return;" but I don't think
> it will work here. This "if NULL return;" is here because of race
> between two resets and I don't think we can guarantee that this race
> will be not present if we flush the service work before reset. The
> problem is that vf reset is called in the same time from vf on vm and
> from pf. When reset from vf is called and reset form pf don't clear
> rings yet we must go into ice_reset_vf and clear those rings without
> triggering second reset. If we don't clear rings there we may trigger
> page_frag_cache_drain crash related to writing data to unmapped
> queues. In such cases if there are no vsis we don't need to do this
> and this WARN_ON is not necessary, but we need to check it anyway.

Hm, I assumed there's some synchronization here which we can use 
to prevent the race. After all _something_ must ensure the pointer
returned from ice_get_vf_vsi() will not go away, for instance.

But I'm obviously speculating and Dave already applied the patches 
so moving on.. :)
