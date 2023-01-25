Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0340D67C09A
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 00:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjAYXIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 18:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjAYXIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 18:08:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EC037F28
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 15:08:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 31DAD616CE
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41875C433D2;
        Wed, 25 Jan 2023 23:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674688117;
        bh=mIVS0k71XuzTBRYRWCIjc8eh32LyEfGi6Tw/LuHkCQQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LlIVQOP8oaE+Z/Wp2+EIkVYsWL1aGmWd6zTRc95vk68N5P5aD0okq2hxKm2XNj6bG
         X7VUsH1ZaFynmPXivS6N6r4TaNZhcAoRFD4DPjXycicgl4KJAWMFRnewIYqstH7K0m
         tz7F9tFXsmw98xIQ1/s0zbs7xUoBNgpnnVFOgQiAtJseYY6v/ben2IGcAYEW+JYKNr
         /89qsqo0aboRjSESNVGiciYgv0FQHSDguOgLRfkYcg/Ws5ZZDA11tvY9ODyz1ZRrLZ
         NswYpu0gP6JUMCPjuRZm/Z8LnwN0WCC0YN09VdzKnj4xLpVidACrcX1yK46WIN0vxJ
         u39/J+lEz9NqA==
Date:   Wed, 25 Jan 2023 15:08:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simo Sorce <simo@redhat.com>
Cc:     Apoorv Kothari <apoorvko@amazon.com>, sd@queasysnail.net,
        borisp@nvidia.com, dueno@redhat.com, fkrenzel@redhat.com,
        gal@nvidia.com, netdev@vger.kernel.org, tariqt@nvidia.com
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230125150836.590fae7a@kernel.org>
In-Reply-To: <b2079e8c46815eedf40987e3c967e356242e3c52.camel@redhat.com>
References: <Y8//pypyM3HAu+cf@hog>
        <20230125184720.56498-1-apoorvko@amazon.com>
        <20230125105743.16d7d4c6@kernel.org>
        <3e9dc325734760fc563661066cd42b813991e7ce.camel@redhat.com>
        <20230125144351.30d1d5ab@kernel.org>
        <b2079e8c46815eedf40987e3c967e356242e3c52.camel@redhat.com>
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

On Wed, 25 Jan 2023 18:05:38 -0500 Simo Sorce wrote:
> > > If it is not guaranteed, are you blocking use of AES GCM and any other
> > > block cipher that may have very bad failure modes in a situation like
> > > this (in the case of AES GCM I am thinking of IV reuse) ?  
> > 
> > I don't know what you mean.  
> 
> The question was if there is *any* case where re-transmission can cause
> different data to be encrypted with the same key + same IV

Not in valid use cases. With zero-copy / sendfile Tx technically 
the page from the page cache can change between tx and rtx, but 
the user needs to opt in explicitly acknowledging the application 
will prevent this from happening. If they don't opt-in we'll copy 
the data.
