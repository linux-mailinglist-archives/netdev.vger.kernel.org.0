Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291575F7230
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 02:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbiJGAL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 20:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiJGALy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 20:11:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D7BA99F0
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 17:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3934261B54
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 00:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4BDC433C1;
        Fri,  7 Oct 2022 00:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665101512;
        bh=9B0T2Z1li7GvbA75uv2C5um5FuAy5BHnlYZnru2+6ro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lpseepOG6LJSi7afFKZrmo5a3QVM8nd1/XGCfOyfQxTsKtU7x9x6k9+IvzVP383VC
         aKemLfWU0DHpWQj4Q6SV6FZ6OVyS2o/9Db0fU9Mdx4JawhNgKHUjeQ6jauuCtyHuc2
         dd6V5tiUuBN37yI5Dst8tS6inimC4HppRLWqVIqwQQXEaJcNmZ4t7quUW9rDpNCKYD
         wxJGEIkrYN8EilSnXlSVaWJwkw/m5FXu3S4L3bq2nb1/K315S3p9pbldOdbYjLytXZ
         PylKempdW5ufPJkN5PkIgPnZC3jzNIFNK/UQRLrUhbIJLmTRVgz3a5iSHJjflPEizo
         7P0hRrwgvrAWw==
Date:   Thu, 6 Oct 2022 17:11:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "Jaron, MichalX" <michalx.jaron@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Message-ID: <20221006171151.3090bf13@kernel.org>
In-Reply-To: <ddf02cb6-0ad4-0396-79f7-bd12a5c8d552@intel.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
        <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
        <20220927182933.30d691d2@kernel.org>
        <CY5SPRMB001206C679A78691032E6E73E3549@CY5SPRMB0012.namprd11.prod.outlook.com>
        <20220928071110.365a2fcd@kernel.org>
        <CY5SPRMB001280F71009BE8356684179E3579@CY5SPRMB0012.namprd11.prod.outlook.com>
        <ddf02cb6-0ad4-0396-79f7-bd12a5c8d552@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Oct 2022 15:28:47 -0700 Tony Nguyen wrote:
> The version with updated commit message[1] is on Intel Wired LAN but I'm 
> not sure whether your comment still stands or if this is ok after the 
> explanation/updated message.

As far as I know wiping XPS on ethtool -L is what most drivers do. We
need to have a discussion about who is expecting the config to not get
wiped and under what conditions. Then think about ways of doing this
generically.

The local driver patches are a no-go from my PoV.
