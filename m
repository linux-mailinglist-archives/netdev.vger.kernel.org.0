Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264F6141ECD
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgASPRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:17:34 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49144 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASPRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:17:34 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D42BE14EC582A;
        Sun, 19 Jan 2020 07:17:32 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:17:31 +0100 (CET)
Message-Id: <20200119.161731.777887504971898393.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [net-next 00/16][pull request] Mellanox, mlx5 E-Switch chains
 and prios
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 07:17:33 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Fri, 17 Jan 2020 00:06:50 +0000

> This series has two parts, 
> 
> 1) A merge commit with mlx5-next branch that include updates for mlx5
> HW layouts needed for this and upcoming submissions. 
> 
> 2) From Paul, Increase the number of chains and prios
> 
> Currently the Mellanox driver supports offloading tc rules that
> are defined on the first 4 chains and the first 16 priorities.
> The restriction stems from the firmware flow level enforcement
> requiring a flow table of a certain level to point to a flow
> table of a higher level. This limitation may be ignored by setting
> the ignore_flow_level bit when creating flow table entries.
> Use unmanaged tables and ignore flow level to create more tables than
> declared by fs_core steering. Manually manage the connections between the
> tables themselves.
> 
> HW table is instantiated for every tc <chain,prio> tuple. The miss rule
> of every table either jumps to the next <chain,prio> table, or continues
> to slow_fdb. This logic is realized by following this sequence:
> 
> 1. Create an auto-grouped flow table for the specified priority with
>     reserved entries
> 
> Reserved entries are allocated at the end of the flow table.
> Flow groups are evaluated in sequence and therefore it is guaranteed
> that the flow group defined on the last FTEs will be the last to evaluate.
> 
> Define a "match all" flow group on the reserved entries, providing
> the platform to add table miss actions.
> 
> 2. Set the miss rule action to jump to the next <chain,prio> table
>     or the slow_fdb.
> 
> 3. Link the previous priority table to point to the new table by
>     updating its miss rule.
> 
> Please pull and let me know if there's any problem.

Pulled, thanks Saeed.
