Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A1A5159DE
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 04:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382088AbiD3Cpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 22:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbiD3Cpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 22:45:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB288C7F5
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 19:42:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 640F3B8354D
        for <netdev@vger.kernel.org>; Sat, 30 Apr 2022 02:42:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6283C385A7;
        Sat, 30 Apr 2022 02:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651286529;
        bh=GEuLQdxDHLodtyuSsN82uCzuz1jz4IzNQ4a/ZujIl5E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c4CCx/SC4a0ZUsEXd6+nowQ2gSlfdrx8jQSBlv628mf2jVg7E+pexIxhB+imR3zh2
         kdvLnB7ZHqRJm9P+rQI9YdoXAhKl6NZMLHLQHYUTeQn3s3HTsSHZT6iiOJotjkeRaZ
         jYSuxz8ap8jgKIBGkpEA2YAJb6xAbv3kuuUmIJOvowrxjIsWfxhMqpAUqxjWeaTDRM
         LMKNbErRn4JR3uIIMnJWIEuYxS4UF/9SPahTAFuMwB4LMAmeOgRGw879hNegUPdxRX
         BQpwWmqaF3rAj1nIbIr7z+AOZTW83l3GNGZAbS0bfkJvT2sIDm/ae3o6nxAdJnIpnO
         Gx5jzVs4z/sCg==
Date:   Fri, 29 Apr 2022 19:42:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Sreenivas, Bharathi" <bharathi.sreenivas@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next 01/11] ice: Add support for classid based queue
 selection
Message-ID: <20220429194207.3f17bf96@kernel.org>
In-Reply-To: <MWHPR11MB129308C755FAB7B4EA1F8DDCF1FF9@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <20220428172430.1004528-1-anthony.l.nguyen@intel.com>
        <20220428172430.1004528-2-anthony.l.nguyen@intel.com>
        <20220428160414.28990a0c@kernel.org>
        <MWHPR11MB1293C17C30E689270E0C39AAF1FC9@MWHPR11MB1293.namprd11.prod.outlook.com>
        <20220429171717.5b0b2a81@kernel.org>
        <MWHPR11MB129308C755FAB7B4EA1F8DDCF1FF9@MWHPR11MB1293.namprd11.prod.outlook.com>
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

On Sat, 30 Apr 2022 02:00:05 +0000 Nambiar, Amritha wrote:
> IIUC, currently the action skbedit queue_mapping is for transmit queue selection,
> and the bound checking is w.r.to dev->real_num_tx_queues. Also, based on my
> discussion with Alex (https://www.spinics.net/lists/netdev/msg761581.html), it
> looks like this currently applies at the qdisc enqueue stage and not at the
> classifier level.

They both apply at enqueue stage, AFAIU. Setting classid on ingress
does exactly nothing, no? :)

Neither is perfect, at least skbedit seems more straightforward. 
I suspect modern DC operator may have little familiarity with classful
qdiscs and what classid is. Plus, again, you're assuming mqprio's
interpretation like it's a TC-wide thing.

skbedit OTOH is used with a clsact qdisc.

Also it would be good if what we did had some applicability to SW. 
Maybe extend skbedit with a way of calling skb_record_rx_queue()?
