Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F316B26E9B5
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 02:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIRAB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 20:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726117AbgIRAB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 20:01:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BF7C06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 17:01:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E28E1364E2E4;
        Thu, 17 Sep 2020 16:45:10 -0700 (PDT)
Date:   Thu, 17 Sep 2020 17:01:56 -0700 (PDT)
Message-Id: <20200917.170156.134829479537549493.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Subject: Re: [PATCH net-next 0/3] mlxsw: Support dcbnl_setbuffer,
 dcbnl_getbuffer
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917064903.260700-1-idosch@idosch.org>
References: <20200917064903.260700-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 16:45:10 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 17 Sep 2020 09:49:00 +0300

> From: Ido Schimmel <idosch@nvidia.com>
> 
> Petr says:
> 
> On Spectrum, port buffers, also called port headroom, is where packets are
> stored while they are parsed and the forwarding decision is being made. For
> lossless traffic flows, in case shared buffer admission is not allowed,
> headroom is also where to put the extra traffic received before the sent
> PAUSE takes effect.
> 
> Linux supports two DCB interfaces related to the headroom: dcbnl_setbuffer
> for configuration, and dcbnl_getbuffer for inspection. This patch set
> implements them.
> 
> With dcbnl_setbuffer in place, there will be two sources of authority over
> the ingress configuration: the DCB ETS hook, because ETS configuration is
> mirrored to ingress, and the DCB setbuffer hook. mlxsw is in a similar
> situation on the egress side, where there are two sources of the ETS
> configuration: the DCB ETS hook, and the TC qdisc hooks. This is a
> non-intuitive situation, because the way the ASIC ends up being configured
> depends not only on the actual configured bits, but also on the order in
> which they were configured.
> 
> To prevent these issues on the ingress side, two configuration modes will
> exist: DCB mode and TC mode. DCB ETS will keep getting projected to ingress
> in the (default) DCB mode. When a qdisc is installed on a port, it will be
> switched to the TC mode, the ingress configuration will be done through the
> dcbnl_setbuffer callback. The reason is that the dcbnl_setbuffer hook is
> not standardized and supported by lldpad. Projecting DCB ETS configuration
> to ingress is a reasonable heuristic to configure ingress especially when
> PFC is in effect.
> 
> In patch #1, the toggle between the DCB and TC modes of headroom
> configuration, described above, is introduced.
> 
> Patch #2 implements dcbnl_getbuffer and dcbnl_setbuffer. dcbnl_getbuffer
> can be always used to determine the current port headroom configuration.
> dcbnl_setbuffer is only permitted in the TC mode.
> 
> In patch #3, make the qdisc module toggle the headroom mode from DCB to TC
> and back, depending on whether there is an offloaded qdisc on the port.

Series applied, thank you.
