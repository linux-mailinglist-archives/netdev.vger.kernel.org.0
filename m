Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8FF4647AFE
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiLIAxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLIAxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:53:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20CB72860;
        Thu,  8 Dec 2022 16:53:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B057FB826CB;
        Fri,  9 Dec 2022 00:53:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FB0C433F2;
        Fri,  9 Dec 2022 00:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670547182;
        bh=0Be0x5lVmgi1YFBEAMFYn86z655fGVIeWjhZdVVj0iU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dTewMuM1hie8uAR35A863ritBqtZ5toHAg3Wpo1fQg+D0b15LsZiylOTTVi6m1/Nj
         v3cLbuW+Qp1yZHOHyj9qeoyBBpfW4DGTdA/mOHvoSGeG25KcbRc29nK1k47AtDDJpp
         DXdoMiXQnwosu7pDzqhl2BP/SueEjzAMmw/V1EB9W6tCd+073tKCVNmKgdQmin18C+
         T6hGSJXSuKDAaUhjOP7ZTzGHWP4j5q4is5P7+20/tq6xJJEpxLF/Xs0qytSafzsC7B
         H0yCRO6xu0vzNmL7/J+cLboJMi3/uhfeNIEV9omjyEx0i89pPeb+mvlWKbwXBeaqo/
         dtIiQsASC+bWg==
Date:   Thu, 8 Dec 2022 16:53:01 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Subject: Re: [PATCH net-next v2 5/6] tsnep: Add RX queue info for XDP support
Message-ID: <Y5KG7dhAjyzcPDHB@x130>
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-6-gerhard@engleder-embedded.com>
 <Y5HfxltuOThxi+Wf@boxer>
 <45d4de61-9a6e-be55-5a00-9e7ff464f4be@engleder-embedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <45d4de61-9a6e-be55-5a00-9e7ff464f4be@engleder-embedded.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08 Dec 21:32, Gerhard Engleder wrote:
>On 08.12.22 13:59, Maciej Fijalkowski wrote:
>>On Thu, Dec 08, 2022 at 06:40:44AM +0100, Gerhard Engleder wrote:
>>>Register xdp_rxq_info with page_pool memory model. This is needed for
>>>XDP buffer handling.
>>>
>>>Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>>>---
>>>  drivers/net/ethernet/engleder/tsnep.h      |  5 ++--
>>>  drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
>>>  2 files changed, 30 insertions(+), 9 deletions(-)
>>>
>>>diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>>>index 0e7fc36a64e1..70bc133d4a9d 100644
>>>--- a/drivers/net/ethernet/engleder/tsnep.h
>>>+++ b/drivers/net/ethernet/engleder/tsnep.h
>>>@@ -127,6 +127,7 @@ struct tsnep_rx {
>>>  	u32 owner_counter;
>>>  	int increment_owner_counter;
>>>  	struct page_pool *page_pool;
>>>+	struct xdp_rxq_info xdp_rxq;
>>
>>this occupies full cacheline, did you make sure that you don't break
>>tsnep_rx layout with having xdp_rxq_info in the middle of the way?
>
>Actually I did no cacheline optimisation for this structure so far.
>I saw that igb/igc put xdp_rxq_info to the end. Is this best practice
>to prevent other variables in the same cacheline of xdp_rxq?

a rule of thumb, organize the structure in the same order they are
being accessed in the data path.. but this doesn't go without saying you
need to do some layout testing via pahole for example.. 

It's up to you and the maintainer of this driver to decide how critical this
is.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>


