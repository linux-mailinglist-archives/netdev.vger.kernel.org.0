Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A524D901D
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 00:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343592AbiCNXNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 19:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiCNXNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 19:13:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D78A3BF8E
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 16:12:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8778B80F92
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 23:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D0FC340E9;
        Mon, 14 Mar 2022 23:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647299518;
        bh=RKGjw9iXmU3zDGxFB18/+INGy5gZT+LoBLuC3nfehvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l8FoXJ++WcEMaZigbL3bddrxTTwbUpf4JFkwnbntMnfYg/TXcMbNCnbJ1VCkm5beM
         pMYLOqrNMxBVIfwzASlEnX7aH4R0458j2hUTgfRAwkhmP3DbdSrWWUgrA7XrUkW795
         ZRGwAYNkpxHXvilzI6l3juhlHqarGDZHZzzg9K/T2Bi5dE/zyL7UtFyw971g0hxAia
         6IDGwRaOW8CaaqZhBbghlZifOCbF/E1l/BG5JhF8YZY2YK6cQfrGFvQ72suDfmFRv9
         BPEKGkAqIe/D5yBMjzmQoZOCouQlOUQqbcqeFdyNmGMSA00Tu8xLJsBXQo9DASGxzK
         9hUO+Vm0ggiiQ==
Date:   Mon, 14 Mar 2022 16:11:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 00/25][pull request] 100GbE Intel Wired LAN
 Driver Updates 2022-03-14
Message-ID: <20220314161156.073d9579@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
References: <20220314181016.1690595-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 11:09:51 -0700 Tony Nguyen wrote:
> The ice_virtchnl_pf.c file has become a single place for a lot of
> virtualization functionality. This includes most of the virtchnl message
> handling, integration with kernel hooks like the .ndo operations, reset
> logic, and more.
> 
> We are planning in the future to implement and support Scalable IOV in the
> ice driver. To do this, much (but not all) of the code in ice_virtchnl_pf.c
> will want to be reused.
> 
> Rather than dump all of the Scalable IOV implementation into
> ice_virtchnl_pf.c it makes sense to house it in a separate file. But that
> still leaves all of the Single Root IOV code littered among more generic
> logic.
> 
> This series reorganizes code to make the non-implementation specific bits
> into new files with the following general guidelines:
> 
>  * ice_vf_lib.[ch]
> 
>    Basic VF structures and accessors. This is where scheme-independent
>    code will reside.
> 
>  * ice_virtchnl.[ch]
> 
>    Virtchnl message handling. This is where the bulk of the logic for
>    processing messages from VFs using the virtchnl messaging scheme will
>    reside. This is separated from ice_vf_lib.c because it is distinct
>    and has a bulk of the processing code.
> 
>  * ice_sriov.[ch]
> 
>    Single Root IOV implementation, including initialization and the
>    routines for interacting with SR-IOV based netdev operations.
> 
>  * (future) ice_siov.[ch]
> 
>    Scalable IOV implementation.
> 
> The goal is to make it easier to re-use parts of the virtualization logic
> while separating concerns such as Single Root specific implementation
> details.
> 
> In addition, this series has several minor cleanups and refactors we've
> accumulated during this development cycle which help prepare the ice driver
> for the Scalable IOV implementation.

Why is there 25 patches in this series? The limit is 15. If you need to
show a longer trajectory of the work you can post a link to a branch
with all the patches so that interested parties can take a look. 
We apply patches rather promptly, please return us a favor and obey 
the limit.
