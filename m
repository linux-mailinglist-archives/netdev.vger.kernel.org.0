Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84BEF3D131C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240179AbhGUPTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:51844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240169AbhGUPTa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:19:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C0CD461242;
        Wed, 21 Jul 2021 16:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883206;
        bh=56AcHZe+xcAeqPK5me90Zap1MGn4hlFZi/cefQOjw5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qWEGWFrCFNqq9qafzmR8I6WchAYfcIgFyAbirjZM4NhUurJ/mPZPIcpLfymRQJ1s5
         RQ82BoJnTiyUW+cIFF4iGfrTQEaiyhpf8jZE+yjydBbxV8p/cXduXoScq0cSIvOe/r
         6WXiIjAXXVY1JN2NSbPTcGG9c7Kz9GvlJp2c/Db2LBfKd6OhX7n2xzbEDlY0fmFfWi
         aHmyHfZjFAh4IZVwvTIGOXc/n/ErM2wYCPRQ7sUQ6zokqEIfn0F/zdRnpkRa/JLiL5
         JZO3MeQZE+9NYTdVZCKM39vVxjs4jnJEfLGiKdIIqM1E+NhavZqAWZ8D6RoKOZ/FOB
         tDEnYCkyrxl5w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8A48609B0;
        Wed, 21 Jul 2021 16:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/1] i40e: add support for PTP external
 synchronization clock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688320675.24738.6639673456557233972.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:00:06 +0000
References: <20210720232348.3087841-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210720232348.3087841-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, piotr.kwapulinski@intel.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        aleksandr.loktionov@intel.com, arkadiusz.kubalewski@intel.com,
        ashishx.k@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Jul 2021 16:23:48 -0700 you wrote:
> From: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
> 
> Add support for external synchronization clock via GPIOs.
> 1PPS signals are handled via the dedicated 3 GPIOs: SDP3_2,
> SDP3_3 and GPIO_4.
> Previously it was not possible to use the external PTP
> synchronization clock.
> All possible HW configurations are supported.
> 	SDP3_2,	SDP3_3,	GPIO_4
> 	off,	off,	off
> 	off,	in_A,	off
> 	off,	out_A,	off
> 	off,	in_B,	off
> 	off,	out_B,	off
> 	in_A,	off,	off
> 	in_A,	in_B,	off
> 	in_A,	out_B,	off
> 	out_A,	off,	off
> 	out_A,	in_B,	off
> 	in_B,	off,	off
> 	in_B,	in_A,	off
> 	in_B,	out_A,	off
> 	out_B,	off,	off
> 	out_B,	in_A,	off
> 	off,	off,	in_A
> 	off,	out_A,	in_A
> 	off,	in_B,	in_A
> 	off,	out_B,	in_A
> 	out_A,	off,	in_A
> 	out_A,	in_B,	in_A
> 	in_B,	off,	in_A
> 	in_B,	out_A,	in_A
> 	out_B,	off,	in_A
> 	off,	off,	out_A
> 	off,	in_A,	out_A
> 	off,	in_B,	out_A
> 	off,	out_B,	out_A
> 	in_A,	off,	out_A
> 	in_A,	in_B,	out_A
> 	in_A,	out_B,	out_A
> 	in_B,	off,	out_A
> 	in_B,	in_A,	out_A
> 	out_B,	off,	out_A
> 	out_B,	in_A,	out_A
> 	off,	off,	in_B
> 	off,	in_A,	in_B
> 	off,	out_A,	in_B
> 	off,	out_B,	in_B
> 	in_A,	off,	in_B
> 	in_A,	out_B,	in_B
> 	out_A,	off,	in_B
> 	out_B,	off,	in_B
> 	out_B,	in_A,	in_B
> 	off,	off,	out_B
> 	off,	in_A,	out_B
> 	off,	out_A,	out_B
> 	off,	in_B,	out_B
> 	in_A,	off,	out_B
> 	in_A,	in_B,	out_B
> 	out_A,	off,	out_B
> 	out_A,	in_B,	out_B
> 	in_B,	off,	out_B
> 	in_B,	in_A,	out_B
> 	in_B,	out_A,	out_B
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] i40e: add support for PTP external synchronization clock
    https://git.kernel.org/netdev/net-next/c/1050713026a0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


