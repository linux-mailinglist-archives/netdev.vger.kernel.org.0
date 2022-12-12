Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F81564A6C4
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiLLSRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiLLSQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:16:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EC016586
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 10:15:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E23BCB80DE5
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE13DC433D2;
        Mon, 12 Dec 2022 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670868907;
        bh=ZEWOxtqLjC/57klM8lry9ShKxUraiw0/ZdctHzAuNgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vh9El+t3UryRUw8NwSv0d9H8hqnsYMA2afYyTPTfIkm/iyDaVqGHpKT2G3lzfAUKs
         8lbgVZqzpCyDrzIUNl+jwZHk7Si3E2+nnEAfVfj1jA5eZNq/Po3U+oLrsFAv/SS/jW
         2om+acasi+JjJVtOyrpVxAW/kPAhm9i1ZL0y8niqMqOAI+vicmVxqNSNtITPEJ0wom
         SsMaqM3XKW2O+nHEsI0n7R0R9DTUolYu0a0LYvSUIVLl6f8D9yiuqzYnIBfd5bPpzM
         IbUr0ijF86lVZpRbgzKdnxD73q6PPFWyGYwtgVReNtssNy3jLRfWNwLcoAp8L/xA2M
         hm3Wg89Px2IyQ==
Date:   Mon, 12 Dec 2022 10:15:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, alexandr.lobakin@intel.com,
        sridhar.samudrala@intel.com, wojciech.drewek@intel.com,
        lukasz.czapnik@intel.com, shiraz.saleem@intel.com,
        jesse.brandeburg@intel.com, mustafa.ismail@intel.com,
        przemyslaw.kitszel@intel.com, piotr.raczynski@intel.com,
        jacob.e.keller@intel.com, david.m.ertman@intel.com,
        leszek.kaliszczuk@intel.com, benjamin.mikailenko@intel.com,
        paul.m.stillwell.jr@intel.com, netdev@vger.kernel.org,
        leon@kernel.org
Subject: Re: [PATCH net-next v1 00/10] implement devlink reload in ice
Message-ID: <20221212101505.403a4084@kernel.org>
In-Reply-To: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
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

On Mon, 12 Dec 2022 12:16:35 +0100 Michal Swiatkowski wrote:
> This is a part of changes done in patchset [0]. Resource management is
> kind of controversial part, so I split it into two patchsets.
> 
> It is the first one, covering refactor and implement reload API call.
> The refactor will unblock some of the patches needed by SIOV or
> subfunction.
> 
> Most of this patchset is about implementing driver reload mechanism.
> Part of code from probe and rebuild is used to not duplicate code.
> To allow this reuse probe and rebuild path are split into smaller
> functions.
> 
> Patch "ice: split ice_vsi_setup into smaller functions" changes
> boolean variable in function call to integer and adds define
> for it. Instead of having the function called with true/false now it
> can be called with readable defines ICE_VSI_FLAG_INIT or
> ICE_VSI_FLAG_NO_INIT. It was suggested by Jacob Keller and probably this
> mechanism will be implemented across ice driver in follow up patchset.

Does not apply, unfortunately, which makes it easier for me to answer
to the question "should I try to squeeze this into 6.2"..
Hopefully we can get some reviews, but the changes seem uncontroversial.
