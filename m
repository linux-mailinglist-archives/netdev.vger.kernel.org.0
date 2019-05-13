Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D60F1BAF3
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbfEMQZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:25:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39468 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729894AbfEMQZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:25:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3417D14E247DA;
        Mon, 13 May 2019 09:25:19 -0700 (PDT)
Date:   Mon, 13 May 2019 09:25:18 -0700 (PDT)
Message-Id: <20190513.092518.1403145356744752555.davem@davemloft.net>
To:     maximmi@mellanox.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, leonro@mellanox.com
Subject: Re: [RFC] inet6_validate_link_af improvements
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513150513.26872-1-maximmi@mellanox.com>
References: <20190513150513.26872-1-maximmi@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:25:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>
Date: Mon, 13 May 2019 15:05:28 +0000

> A recent bug in systemd [1] triggered the following kernel warning:
> 
>   A link change request failed with some changes committed already.
>   Interface eth1 may have been left with an inconsistent configuration,
>   please check.
> 
> do_setlink() performs multiple configuration updates, and if any of them
> fails, do_setlink() has no way to revert the previous ones. It is also
> not easy to validate everything in advance and perform a non-failing
> update then. However, do_setlink() has some basic validation that can be
> extended at least this case. IMO, it's better to fail before doing any
> changes than to perform a partial configuration update.
> 
> This RFC contains two patches that move some checks to the validation
> stage (inet6_validate_link_af() function). Only one of the patches (if
> any) should be applied. Patch 1 only checks the presence of at least one
> parameter, and patch 2 also moves the validation for addrgenmode that is
> currently part of inet6_set_link_af(). Of course, there are still many
> ways how do_setlink() can fail and perform a partial update, but IMO
> it's better to prevent at least some cases that we can.
> 
> Please express your opinions on this fix: do we need it, do we want to
> validate as much as possible (patch 2) or only basic stuff like the
> presence of parameters (patch 1)? I'm looking forward to hearing the
> feedback.

I think your patches should go in now.

And longer term for the other cases we should move to a prepare-->commit
model so that resources can be allocated in one pass and only commit the
result if all resources can be obtained together.
