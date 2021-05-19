Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85AFF38983C
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhESUuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 16:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229379AbhESUuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 16:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B6BD6135A;
        Wed, 19 May 2021 20:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621457341;
        bh=x3LMoDLLoJzEGziXgwlgGLRIC/je0Pnn+GYwKgGdf8g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=rLKjIkbZ3GBu4wFd794rGKDP9wiNRrcJ+GQcX2ieL+2eAGPzzVBZfN/5dl0ViAVL2
         6YNZFuupEFRFpJujodL/7nT9wvhgbj601hWiNGpKeUxFrem06DxsB1rCsle9/7bcFw
         hAg8CBUVHhY1niCX1GX0Q2Qf64oMmSBUpvJhL36S9CTjMah6QeFR7pAWaa3Oz6cyFo
         XqjSpNZKvFB0YX++ac+xKuPH29SV+OdO/oRd7DgnQhUYWWZE8aqUMBowl0sekYUZ64
         airBZogcF6JjKZgVDoM91UIPU1SC+sAiXqtFD+MxLoiFWBE6/jGmi42+QVBIcJXmGB
         yXo9AlRoDkVWg==
Message-ID: <f48c950330996dcbb11f1a78b7c0a0445c656a20.camel@kernel.org>
Subject: Re: [PATCH net-next] mlx5: count all link events
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Date:   Wed, 19 May 2021 13:49:00 -0700
In-Reply-To: <20210519171825.600110-1-kuba@kernel.org>
References: <20210519171825.600110-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-19 at 10:18 -0700, Jakub Kicinski wrote:
> mlx5 devices were observed generating MLX5_PORT_CHANGE_SUBTYPE_ACTIVE
> events without an intervening MLX5_PORT_CHANGE_SUBTYPE_DOWN. This
> breaks link flap detection based on Linux carrier state transition
> count as netif_carrier_on() does nothing if carrier is already on.
> Make sure we count such events.
> 

Can you share more on the actual scenario that has happened ? 
in mlx5 i know of situations where fw might generate such events, just
as FYI for virtual ports (vports) on some configuration changes.

another explanation is that in the driver we explicitly query the link
state and we never take the event value, so it could have been that the
link flapped so fast we missed the intermediate state.

According to HW spec for some reason we should always query and not
rely on the event. 

<quote>
If software retrieves this indication (port state change event), this
signifies that the state has been
changed and a QUERY_VPORT_STATE command should be performed to get the
new state.
</quote>

> netif_carrier_event() increments the counters and fires the linkwatch
> events. The latter is not necessary for the use case but seems like
> the right thing to do.
> 


