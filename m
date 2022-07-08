Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8DBB56C052
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238678AbiGHSKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238428AbiGHSKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28492409B
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 11:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C22BB828B8
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 18:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15DEC341C0;
        Fri,  8 Jul 2022 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657303815;
        bh=icZGKxU5iu7kARoS5NfIYEa7Jdeoek89pJi/8csY60I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IsPnL/eFwo2SsvTeAmSkMl7CcsY2yMHfQSMTKGZCMiZkE+lYBFE1Bn1+tS6MfODu3
         YTRAcYSAskz1fE/nAHF0hZQVXLAVu2IAOo+nwgoBcy+I8Xt5zsiibTpAHChwEWb9n3
         46NqMxuxJ1vQKA1PHDi9qCeV++LigRFc6WfYdCqfJj7u8pNTeuA8KANkLJV26NQhNQ
         rqI2JR9Yvz37BNoUGTu1P54EVU1DKTMY7caqvONkZcDR4TRFoxHalcwT2w1+hImRTR
         G5SECBCU7RSVjagBz7ARhKNakhMN4BfaxcCdznUzIKF+Dvwyn62ww7IUfmyZ/3HnNH
         7xeViWEGhFIqQ==
Date:   Fri, 8 Jul 2022 11:10:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     "ttoukan.linux@gmail.com" <ttoukan.linux@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 11/15] net/tls: Multi-threaded calls to TX
 tls_dev_del
Message-ID: <20220708111013.03c80e60@kernel.org>
In-Reply-To: <6a19625bed077cb063aef035ec846e2f6c0d7464.camel@nvidia.com>
References: <20220706232421.41269-1-saeed@kernel.org>
        <20220706232421.41269-12-saeed@kernel.org>
        <20220706193735.49d5f081@kernel.org>
        <953f4a8c-1b17-cf22-9cbf-151ba4d39656@gmail.com>
        <20220707171726.5759eb5c@kernel.org>
        <6a19625bed077cb063aef035ec846e2f6c0d7464.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jul 2022 13:10:38 +0000 Maxim Mikityanskiy wrote:
> On Thu, 2022-07-07 at 17:17 -0700, Jakub Kicinski wrote:
> > On Fri, 8 Jul 2022 01:14:32 +0300 Tariq Toukan wrote:  
> > > > Why don't we need the flush any more? The module reference is gone as
> > > > soon as destructor runs (i.e. on ULP cleanup), the work can still be
> > > > pending, no?    
> 
> Is this an issue? The work doesn't seem to access any module-level
> objects like tls_device_gc_list anymore. Did I miss anything?

The function itself is still in the module's text, right?
