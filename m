Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C7B5A703A
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 23:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiH3V7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbiH3V7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 17:59:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B17561119
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 14:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFB6DB81DFC
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 21:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B61C433D6;
        Tue, 30 Aug 2022 21:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661896456;
        bh=b97XBs8QqgMTyMfc3j0JxoiCdLrkh0Jv4p8m+L5fDg8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=btJMeBOfAEEXF1iHT+S7GirNmgDyb5aB1hMu3AycLVc8E5YYdRmhtQA4a1jwyNBzx
         LWdOTTQOwh+FkMlOn9tP6T0hLHMMDt0+4SE2E6iNp6hq6B8PTygdNe5VYQTuD3r9E4
         21J7vfeJpNzCSNkKdXXGbItvCM6Rx9/qG1Bd/hDmyJUB2dQHgzgkKBsTZXx11aJyZ2
         pKO5hRBBV9+gUp4h7pt/b51JHmEKjpAQtbbdJ3RxMBf0zpPHby3rrvQGssvb4Ke9b9
         BmnEHvo1PK8KrF1F5NoIHmjnpIDcSGptliCGgJnnrAZyOSrrC0K5pNKN8wI5OMJfCC
         upJ+EmvNWZ2Bw==
Date:   Tue, 30 Aug 2022 14:54:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        "Anirudh Venkataramanan" <anirudh.venkataramanan@intel.com>,
        <netdev@vger.kernel.org>,
        Lukasz Plachno <lukasz.plachno@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gurucharan <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 5/5] ice: Print human-friendly PHY types
Message-ID: <20220830145414.3a2ba804@kernel.org>
In-Reply-To: <3b248522-3193-cd31-3452-78e02b95c369@intel.com>
References: <20220824170340.207131-1-anthony.l.nguyen@intel.com>
        <20220824170340.207131-6-anthony.l.nguyen@intel.com>
        <20220825200344.32cb445f@kernel.org>
        <3b248522-3193-cd31-3452-78e02b95c369@intel.com>
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

On Tue, 30 Aug 2022 11:33:07 -0700 Jesse Brandeburg wrote:
> > Is this not something that can be read via ethtool -m ?  
> 
> Hi Jakub, I saw Dave committed this, but I wanted to answer.
> 
> AFAIK ethtool -m just dumps the eeprom in a hexdump. This data is part 
> of a firmware response about "all the things" that it knows about the 
> current link and PHY/cable.

ethtool -m decodes the information into text format. Perhaps it doesn't
understand the EEPROM layout for the SFP type you're checking?
I'd be surprised but it's possible.

Obviously PHY stuff outside the SFP would not be reported there, but
most of the prints look like module info.

> these *debug* prints extra information on the phy that the driver gets 
> in one call, but is not clearly mapped today to a single ethtool command.
> 
> Would this be a good candidate for debugfs (read only) file for our 
> driver, or should we just leave it as dev_dbg() output?

The prints themselves are not a big deal, but it'd be great if the info
which is available via ethtool -m was stripped. Just to move to
"standard APIs" wherever possible, it's not a big deal.
