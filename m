Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2546222B5CC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgGWSgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgGWSgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:36:36 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07599C0619DC
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:36:36 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E370E136A8C2D;
        Thu, 23 Jul 2020 11:19:47 -0700 (PDT)
Date:   Thu, 23 Jul 2020 11:36:30 -0700 (PDT)
Message-Id: <20200723.113630.349385359255054401.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com, mhabets@solarflare.com,
        mslattery@solarflare.com
Subject: Re: [PATCH net-next v2] sfc: convert to new udp_tunnel
 infrastructure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <76c2ae76-a692-e401-8e1e-623613c7e2ae@solarflare.com>
References: <20200722190510.2877742-1-kuba@kernel.org>
        <76c2ae76-a692-e401-8e1e-623613c7e2ae@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jul 2020 11:19:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Thu, 23 Jul 2020 10:47:01 +0100

> On 22/07/2020 20:05, Jakub Kicinski wrote:
>> Check MC_CMD_DRV_ATTACH_EXT_OUT_FLAG_TRUSTED, before setting
>> the info, which will hopefully protect us from -EPERM errors
>> the previous code was gracefully ignoring. Ed reports this
>> is not the 100% correct bit, but it's the best approximation
>> we have. Shared code reports the port information back to user
>> space, so we really want to know what was added and what failed.
>> Ignoring -EPERM is not an option.
>>
>> The driver does not call udp_tunnel_get_rx_info(), so its own
>> management of table state is not really all that problematic,
>> we can leave it be. This allows the driver to continue with its
>> copious table syncing, and matching the ports to TX frames,
>> which it will reportedly do one day.
>>
>> Leave the feature checking in the callbacks, as the device may
>> remove the capabilities on reset.
>>
>> Inline the loop from __efx_ef10_udp_tnl_lookup_port() into
>> efx_ef10_udp_tnl_has_port(), since it's the only caller now.
>>
>> With new infra this driver gains port replace - when space frees
>> up in a full table a new port will be selected for offload.
>> Plus efx will no longer sleep in an atomic context.
>>
>> v2:
>>  - amend the commit message about TRUSTED not being 100%
>>  - add TUNNEL_ENCAP_UDP_PORT_ENTRY_INVALID to mark unsed
>>    entries
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Looks reasonable enough, have an
> Acked-By: Edward Cree <ecree@solarflare.com>

Applied, thanks everyone.
