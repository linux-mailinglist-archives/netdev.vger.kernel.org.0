Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C31E8964F
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfHLEgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:36:04 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38686 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfHLEgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:36:04 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CD28C145F1971;
        Sun, 11 Aug 2019 21:36:03 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:36:03 -0700 (PDT)
Message-Id: <20190811.213603.1213098548868873560.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        richardcochran@gmail.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: spectrum_ptp: Keep unmatched entries in a
 linked list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190811074837.28216-1-idosch@idosch.org>
References: <20190811074837.28216-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:36:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 11 Aug 2019 10:48:37 +0300

> From: Petr Machata <petrm@mellanox.com>
> 
> To identify timestamps for matching with their packets, Spectrum-1 uses a
> five-tuple of (port, direction, domain number, message type, sequence ID).
> If there are several clients from the same domain behind a single port
> sending Delay_Req's, the only thing differentiating these packets, as far
> as Spectrum-1 is concerned, is the sequence ID. Should sequence IDs between
> individual clients be similar, conflicts may arise. That is not a problem
> to hardware, which will simply deliver timestamps on a first comes, first
> served basis.
> 
> However the driver uses a simple hash table to store the unmatched pieces.
> When a new conflicting piece arrives, it pushes out the previously stored
> one, which if it is a packet, is delivered without timestamp. Later on as
> the corresponding timestamps arrive, the first one is mismatched to the
> second packet, and the second one is never matched and eventually is GCd.
> 
> To correct this issue, instead of using a simple rhashtable, use rhltable
> to keep the unmatched entries.
> 
> Previously, a found unmatched entry would always be removed from the hash
> table. That is not the case anymore--an incompatible entry is left in the
> hash table. Therefore removal from the hash table cannot be used to confirm
> the validity of the looked-up pointer, instead the lookup would simply need
> to be redone. Therefore move it inside the critical section. This
> simplifies a lot of the code.
> 
> Fixes: 8748642751ed ("mlxsw: spectrum: PTP: Support SIOCGHWTSTAMP, SIOCSHWTSTAMP ioctls")
> Reported-by: Alex Veber <alexve@mellanox.com>
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Applied.
