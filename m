Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0D9A67B9FE
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 19:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbjAYS5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 13:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbjAYS5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 13:57:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F8740E7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 10:57:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 908A1B8198A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 18:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAAAAC433D2;
        Wed, 25 Jan 2023 18:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674673065;
        bh=ODihhGg+fvePSvXcHLfT1u3HSt0/QLf9enTGWoZiB9k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fl98JuCyf/b4Jn7bNrJDI5LdJosUUkjdQh8QJuN5uUs0a624uOTgdgypYPKfKmlNW
         0YOBmjGIx8Fhn8XwehjdUklgdGOIWBJCzxmhM+rwhdW6Pw2X5Fwdx3kPet6wEQw/aa
         mkCTrRiPRgs22BkE+S/4izvjkPjsR76Jt75BLXNYBS6xhQROsNXCXWXYrIswVqHvs8
         GgWT/w4nShJrKwEv38Xg0Y/fhdaixoneKafP1MZ4OG1dN5EA+6ZxVpcHZ0Uoyc2iYQ
         Tj8g+QwBBf6HbWfd7/EkVv/Iw8KVlo6htcQO9cyw9k77PNlIkJFPQyHVPYykxLsWX5
         j3pc/oXCPIzIw==
Date:   Wed, 25 Jan 2023 10:57:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Apoorv Kothari <apoorvko@amazon.com>
Cc:     <sd@queasysnail.net>, <borisp@nvidia.com>, <dueno@redhat.com>,
        <fkrenzel@redhat.com>, <gal@nvidia.com>, <netdev@vger.kernel.org>,
        <simo@redhat.com>, <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
Message-ID: <20230125105743.16d7d4c6@kernel.org>
In-Reply-To: <20230125184720.56498-1-apoorvko@amazon.com>
References: <Y8//pypyM3HAu+cf@hog>
        <20230125184720.56498-1-apoorvko@amazon.com>
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

On Wed, 25 Jan 2023 10:47:20 -0800 Apoorv Kothari wrote:
> > We'll need to keep the old key around until we know all the records
> > using it have been fully received, right?  And that could be multiple
> > old keys, in case of a quick series of key updates.  
> 
> Why does the hardware implementation need to store old keys? Does the need
> for retransmitted data assume we are operating in TLS_HW_RECORD mode and
> the hardware is also implementing the TCP stack?

We're talking about the Tx direction, the packets are queued to the
lower layers of the stack unencrypted, and get encrypted by the NIC.
Until TCP gets acks for all the data awaiting offloaded crypto - we
must hold onto the keys.

Rx direction is much simpler indeed.

> The TLS RFC assumes that the underlying transport layer provides reliable
> and in-order deliver so storing previous keys and encrypting 'old' data
> would be quite divergent from normal TLS behavior. Is the TLS_HW_RECORD mode
> processing TLS records out of order? If the hardware offload is handling
> the TCP networking stack then I feel it should also handle the
> retransmission of lost data.

Ignore TLS_HW_RECORD, it's a ToE offload, the offload we care about
just offloads encryption.
