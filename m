Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A3A60D7C9
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 01:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiJYXRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 19:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiJYXRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 19:17:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1853171BD3;
        Tue, 25 Oct 2022 16:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 43506CE1ED6;
        Tue, 25 Oct 2022 23:17:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB3C433D6;
        Tue, 25 Oct 2022 23:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666739838;
        bh=nV7OVDrwGLapIVrA2MkHe7ePYFXFsBK++LsqBN3LGxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jgmD4R4nRxyvZqQf+RFkpy8OzZlwZWaN3uMpSb/mKDFK4G0lCt3Ub6SDpdtaf3acw
         RZVWqtWUdVWFpdnLdaoRDbX+u2XI7TUZeUGvvX6eMRqfThv4W+1QhoXi6FhA0uiu3U
         PNjHDugBCqcOWYunfi/Rxn2nqZEUG6HpBB5lfDfbMkst0/sSI7ZTmhUxaSyxO3Dp5g
         X0HKBuHzTUAQJMZ+v2mw/xPvuoxoT7NR1OW7a7axArGENNfisA0CnRHJWsile+/6Db
         VyiNFed0Lk2ahgi29Z9TjFLF2VANpmwGA00vmUK5eYV1xioMDnC9uB8Re4MJZgl8vv
         jUNx3NlKFq+vw==
Date:   Tue, 25 Oct 2022 16:17:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Doug Berger <opendmb@gmail.com>
Cc:     kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        ntfs3@lists.linux.dev, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-scsi@vger.kernel.org,
        linux-mm@kvack.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [linux-next:master] BUILD REGRESSION
 89bf6e28373beef9577fa71f996a5f73a569617c
Message-ID: <20221025161716.1b92a033@kernel.org>
In-Reply-To: <8fbc9d02-3c73-5990-85af-82eecb6d64e3@gmail.com>
References: <63581a3c.U6bx8B6mFoRe2pWN%lkp@intel.com>
        <20221025154150.729bbbd0@kernel.org>
        <8fbc9d02-3c73-5990-85af-82eecb6d64e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 16:04:15 -0700 Doug Berger wrote:
> > On Wed, 26 Oct 2022 01:17:48 +0800 kernel test robot wrote:  
> >> drivers/net/ethernet/broadcom/genet/bcmgenet.c:1497:5-13: ERROR: invalid reference to the index variable of the iterator on line 1475  
> > 
> > CC Doug  
> Thanks for highlighting this for me, but I happened to catch it from the 
> linux-mm list and was just looking into it.
> 
> It looks to me like a false positive since I am initializing the 
> loc_rule variable in all paths outside of the list_for_each_entry() loop 
> prior to its use on line 1497.

Ack, indeed the code looks right. Thanks for investigating.

> If desired I can submit a new patch to make coccinelle happy.

I wonder if Cocci can detect writes. Let me add Julia for visibility.

If not we can use a different variable for the "check if already
exists" iteration? It could make the code easier to follow, IMHO.
Or leave it be.
