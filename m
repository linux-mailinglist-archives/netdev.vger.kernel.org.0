Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EE5607A50
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiJUPQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJUPQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:16:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A802751A7
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 08:16:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0A1A61EDE
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 15:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC14C433D6;
        Fri, 21 Oct 2022 15:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666365399;
        bh=rkVYIFg2K7PlTr6JQ7UFxz4FZNgle+eLu4pZ7sU4gX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bAIebSUqM9giQkjUrSo/xPocD7OwYDevTwlp6w2EzNtajPf64YkIva06TS0Kj38K6
         /PeznQG/F+d9kLf+YmnQWPdN2x7VIu4J97mQUI66oCvQO7vuknpG+dX6dBobymBuPh
         sgnFvyqdIUJgx1JeHkXFUM0OX5wPi070ea2n9CKvVV8CxDyRoGu7vvKuwABiXJ0OtR
         +WLCKbKAEZyvKHmICaZxuV1B2tLAy60ZEUpbDMKswSjqKGU90ZAFuW+g8eeeAt0J8a
         SPmmOxENh9K8MWs2kDFpT9SF1VyzP8J70FVAFDq2EXO/4NVlJ5NfhJgQpWazJuM1Dc
         VEK3rMjCfwDDw==
Date:   Fri, 21 Oct 2022 08:16:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
        "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "gal@nvidia.com" <gal@nvidia.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP
 packets
Message-ID: <20221021081637.5195953b@kernel.org>
In-Reply-To: <Y1KVLAR2Qi6JeSBj@hoboy.vegasvil.org>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
        <Y06RzWQnTw2RJGPr@hoboy.vegasvil.org>
        <SJ1PR11MB618053D058C8171AAC4D3FADB8289@SJ1PR11MB6180.namprd11.prod.outlook.com>
        <Y09i12Wcqr0whToP@hoboy.vegasvil.org>
        <SJ1PR11MB6180F00C9051443BCEA22AB2B82D9@SJ1PR11MB6180.namprd11.prod.outlook.com>
        <Y1KVLAR2Qi6JeSBj@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 05:48:44 -0700 Richard Cochran wrote:
> > Could you please provide additional details about this? What do you meant by 
> > offering 1 HW Timestamp with many SW timestamps?   
> 
> - Let the PTP stack use hardware time stamps.
> 
> - Let all other applications use software time stamps.

We do need HW stamps for congestion control, the Rx ring queuing 
(as well as Tx ring scheduling jitter) is very often in 10s of msec.
Comparing the SW stamp to the HW stamp is where we derive the signal
that the system is under excessive load.
