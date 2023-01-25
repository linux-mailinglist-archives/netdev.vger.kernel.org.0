Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E97467B934
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbjAYSWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbjAYSWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:22:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDE4599B5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:22:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E7B9B81B41
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 18:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD5AC433EF;
        Wed, 25 Jan 2023 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674670954;
        bh=lyPg4EAdMKSDAZ3stsI0z7iCe1tjFijNBZh0BD4dfQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cmVe7YhYw8BWFY0SHQGdOlO4zO8mSNb+ZLk6N6EPIVHCJemq/wzOXTYdtZt9x5vin
         foc+Xs9V/R3FamHmy7zRxF497Pz3X9Q4u5bNriRa6YrIOck0LAOfIzcYfbo9GG50Dv
         XIKH7K5GI5DVElEVYK/00tuuJagHfmp9tlOR/7LPmP5ummqQR3NTVuQyDtR3+6Sdpo
         +Y7AnOOjHyPhiGOhzcss6jVNFRwfdYscqwgMj7kw7XcuEXsZHK9+Ux4Ec2et0ZGpjj
         0bWlU3QMnGNuV0IWoUdZgObqho1ZPcVIRxmaZ6J3oNpaa+KVaoCGUJM8vyWrKwSzGA
         7s9LC7nIV+wEQ==
Date:   Wed, 25 Jan 2023 10:22:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org
Subject: Re: Setting TLS_RX and TLS_TX crypto info more than once?
Message-ID: <20230125102233.1848e960@kernel.org>
In-Reply-To: <77DB4DFF-0950-47D4-A6A1-56F6D7142B19@holtmann.org>
References: <A07B819E-A406-457A-B7DB-8926DCEBADCD@holtmann.org>
        <Y9Bbz60sAwkmrsrt@hog>
        <77DB4DFF-0950-47D4-A6A1-56F6D7142B19@holtmann.org>
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

On Wed, 25 Jan 2023 11:24:18 +0100 Marcel Holtmann wrote:
> My bad, I kinda remembered they are from end of 2020. Anyway, following
> that thread, I see you fixed my problem already.
> 
> The encrypted handshake portion is actually simple since it defines
> really clear boundaries for the handshake traffic secret. The deployed
> servers are a bit optimistic since they send you an unencrypted
> ServerHello followed right away by the rest of the handshake messages
> fully encrypted. I was surprised I can MSG_PEEK at the TLS record
> header and then just read n bytes of just the ServerHello leaving
> everything else in the receive buffer to be automatically decrypted
> once I set the keys. This allows for just having the TLS handshake
> implemented in userspace.
> 
> It is a little bit unfortunate that with the support for TLS 1.3, the
> old tls12_ structures for providing the crypto info have been used. I
> would have argued for providing the traffic_secret into the kernel and
> then the kernel could have easily derived key+iv by itself. And with
> that it could have done the KeyUpdate itself as well.
> 
> The other problem is actually that userspace needs to know when we are
> close to the limits of AES-GCM encryptions or when the sequence number
> is about to wrap. We need to feed back the status of the rec_seq back
> to userspace (and with that also from the HW offload).
> 
> I would argue that it might have made sense not just specifying the
> starting req_seq, but also either an ending or some trigger when
> to tell userspace that it is a good time to re-key.

Could you say more about your use case?

What you're describing sound contrary to the common belief/design
direction of TLS which was to keep the kernel out of as much complexity
as possible, focus only on parts where we can add perf.
