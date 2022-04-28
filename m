Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2392513B8C
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 20:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350720AbiD1Sbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 14:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiD1Sbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 14:31:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C669859A
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 11:28:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D87BF619B5
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 18:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15EFC385A0;
        Thu, 28 Apr 2022 18:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651170502;
        bh=qWVRw5Id6H3dmoXmwzdsRfaIS65ve75GD3sJixbmRMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qjJPYlH8x7VYARJgTH+3zhDjv0Lg1fF8SyfJaC6FGS+8Cp3EDdrKF9OlmWEiJ4Jd8
         JnNP2t1hLP1kOVTt9LnK+qr7PP9oX3+T1dlXkjPpTngmiA6EBn4AQ6H4gdjgEzFL0W
         Khp9+uvNN86rS+R7Lz5HzHT+TB9tl2wGYSMWwshQPML31Jn+avt+7BQWAcJhXk/bsd
         5AXHyEENdQ9OonUhEbzrD15ZWbn6W5NVUFqlyXJ8yc6oifl4Cap5ooAFOPGsfOMWcF
         3BYxQHznavyvCB6YhSud/NJ9Tz4mymI4z21nwCfYQ9YQPpCyqpvifwED7GooFj6fT+
         zhUKzTSqTYBIg==
Date:   Thu, 28 Apr 2022 11:28:20 -0700
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
Message-ID: <20220428112820.4f36b5e6@kernel.org>
In-Reply-To: <BL1PR11MB5430A4AD0469C1C4BDCBB5C486FD9@BL1PR11MB5430.namprd11.prod.outlook.com>
References: <20220420172624.931237-1-anthony.l.nguyen@intel.com>
        <20220420172624.931237-2-anthony.l.nguyen@intel.com>
        <20220422154752.1fab6496@kernel.org>
        <BL1PR11MB5430A4AD0469C1C4BDCBB5C486FD9@BL1PR11MB5430.namprd11.prod.outlook.com>
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

On Thu, 28 Apr 2022 18:10:49 +0000 Maloszewski, Michal wrote:
>> Can't we wait for the device to get into the right state?
>> Throwing EAGAIN back to user space is not very friendly.  
> 
> When we have state which is running, it does not mean that we have
> queues configured on PF. So in order to configure queues on PF, the
> IAVF_FLAG_QUEUES has to be disabled. I use here EAGAIN, because as
> long as we are not configured with queues, it does not make any sense
> to trigger command and we are not sure when the configuration of
> queues will end - so that is why EAGAIN is used.

Let me rephrase the question. Does getting out of the state where error
is reported require user to change something, or is it something that
happens automatically behind the scenes (i.e. the state is transient).
