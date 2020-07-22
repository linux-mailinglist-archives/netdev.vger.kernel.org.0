Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D81229E22
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731992AbgGVROX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731480AbgGVROT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 13:14:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EE50206D7;
        Wed, 22 Jul 2020 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595438059;
        bh=jcsSkrKl56mMsUv3bNmSym5TlO5ncUHruDil1YOHBXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lcDv+vZGc3CVS1G/FBMQMK+FvNKTHd8JSfIrs7OgPoMSS24qEeEJPx8EZwlNcPypu
         nJmmHTIaIlslWOEEOGzOxax9cXGkt6PNqMq13ED5pfCRH3UjpFrMiLgmv+UI+8pFgE
         dt7b0xpTB2Wrp1r8wzvQAlGHoAiWCaU27fyaetwg=
Date:   Wed, 22 Jul 2020 10:14:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com
Subject: Re: [PATCH net-next] devlink: Always use user_ptr[0] for devlink
 and simplify post_doit
Message-ID: <20200722101417.40c5a1d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200722155711.976214-1-parav@mellanox.com>
References: <20200722155711.976214-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 18:57:11 +0300 Parav Pandit wrote:
> Currently devlink instance is searched on all doit() operations.
> But it is optionally stored into user_ptr[0]. This requires
> rediscovering devlink again doing post_doit().
> 
> Few devlink commands related to port shared buffers needs 3 pointers
> (devlink, devlink_port, and devlink_sb) while executing doit commands.
> Though devlink pointer can be derived from the devlink_port during
> post_doit() operation when doit() callback has acquired devlink
> instance lock, relying on such scheme to access devlik pointer makes
> code very fragile.
> 
> Hence, to avoid ambiguity in post_doit() and to avoid searching
> devlink instance again, simplify code by always storing devlink
> instance in user_ptr[0] and derive devlink_sb pointer in their
> respective callback routines.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Other options include having some static variable (since doit is always
under devlink_mutex AFAICS) or doing a tiny allocation to fit more
pointers. But whatever:

Acked-by: Jakub Kicinski <kuba@kernel.org>
