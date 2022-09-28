Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF225EDE7A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 16:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiI1OLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 10:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbiI1OLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 10:11:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CD73A4B6
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 07:11:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2779BB820E5
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 14:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A95C433D6;
        Wed, 28 Sep 2022 14:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664374271;
        bh=aKkpUc9FO6ApQd0OTjv11rblqLxx2Sgdf2yc06Tjz2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nCglVDHIAA7St6pwISTeSdqDsPXCS1mtWn9MOsHHCSLk/SUl9US66f/D1TPWvVp+O
         yAcinFLHrk2AFHIJihmfJaz7YZp5O0pSEba8iXLMZSB877qtrBIly8uU0BBiq/h0Ep
         gMyttWSnWcquoirGqfnou5TREWdcjF+Ity+nqk2deOLaWUMsAM4Ehgn5yyZzaosmUy
         u/MRpxI0vulbxN0D7g+87y3mv7cQR4FlskU4NQOw5UHQdCsJvTKqoSb6NsZwa/CVbf
         l5/pYtAb5VWZAL5Ujm5Vrh71IRCsL8Qo6kpzk8XuwosILZqGj2vUklKwDTeI3lzJx4
         4bq7Puc8xftfg==
Date:   Wed, 28 Sep 2022 07:11:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jaron, MichalX" <michalx.jaron@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Message-ID: <20220928071110.365a2fcd@kernel.org>
In-Reply-To: <CY5SPRMB001206C679A78691032E6E73E3549@CY5SPRMB0012.namprd11.prod.outlook.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
        <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
        <20220927182933.30d691d2@kernel.org>
        <CY5SPRMB001206C679A78691032E6E73E3549@CY5SPRMB0012.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Sep 2022 13:32:41 +0000 Jaron, MichalX wrote:
> > Not sure this is a fix, are there other drivers in the tree which do this? In the
> > drivers I work with IRQ mapping and XPS are just seemingly randomly reset
> > on reconfiguration changes. User space needs to rerun its affinitization script
> > after all changes it makes.
> > 
> > Apart from the fact that I don't think this is a fix, if we were to solve it we
> > should shoot for a more generic solution and not sprinkle all drivers with
> > #ifdef CONFIG_XPS blocks :S  
> 
> XPS to CPUs maps are configured by i40e driver, based on active cpus,
> after initialization or after drivers reset with reinit (i.e. when
> queues count changes). User may want to leave this mapping or set his
> own mapping by writing to xps_cpus file. In case when we do reset on
> our network interface without changing number of queues(when reinit
> is not true), i.e. by calling ethtool -t <interface>, in
> i40e_rebuild() those maps were cleared (set to 0) for every tx by
> netdev_set_num_tc(). After reset those maps were still set to 0
> despite that it was set by driver or by user and user was not
> informed about it.

Set to 0 or reset to default (which I would hope is spread across 
the CPUs in the same fashion as affinity hint)?

> With this fix maps are preserved and restored
> after reset to not surprise user that maps have changed when user
> doesn't want it. Mapping restoration is based on CPUs mapping and is
> done by netif_set_xps_queue() which is XPS function, then I think
> this affinization should be performed well.
> 
> If user doesn't want to change queues then those maps should be
> restored to the way it was.
