Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EBF1465D7
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbgAWKep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:34:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgAWKep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:34:45 -0500
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95DD3153DCD87;
        Thu, 23 Jan 2020 02:34:37 -0800 (PST)
Date:   Thu, 23 Jan 2020 11:34:31 +0100 (CET)
Message-Id: <20200123.113431.1301491947389006898.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_acl: Fix use-after-free during
 reload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200122180952.262582-1-idosch@idosch.org>
References: <20200122180952.262582-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Jan 2020 02:34:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 22 Jan 2020 20:09:52 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> During reload (or module unload), the router block is de-initialized.
> Among other things, this results in the removal of a default multicast
> route from each active virtual router (VRF). These default routes are
> configured during initialization to trap packets to the CPU. In
> Spectrum-2, unlike Spectrum-1, multicast routes are implemented using
> ACL rules.
> 
> Since the router block is de-initialized before the ACL block, it is
> possible that the ACL rules corresponding to the default routes are
> deleted while being accessed by the ACL delayed work that queries rules'
> activity from the device. This can result in a rare use-after-free [1].
> 
> Fix this by protecting the rules list accessed by the delayed work with
> a lock. We cannot use a spinlock as the activity read operation is
> blocking.
 ...
> Fixes: cf7221a4f5a5 ("mlxsw: spectrum_router: Add Multicast routing support for Spectrum-2")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable, thanks.
