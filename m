Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0555C2B3F
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 02:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732303AbfJAAU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 20:20:29 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40506 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfJAAU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 20:20:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A01F154F6387;
        Mon, 30 Sep 2019 17:20:28 -0700 (PDT)
Date:   Mon, 30 Sep 2019 17:20:27 -0700 (PDT)
Message-Id: <20190930.172027.1837315999928472989.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: sja1105: Fix sleeping while atomic in
 .port_hwtstamp_set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190928220745.23804-1-olteanv@gmail.com>
References: <20190928220745.23804-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Sep 2019 17:20:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 29 Sep 2019 01:07:45 +0300

> Currently this stack trace can be seen with CONFIG_DEBUG_ATOMIC_SLEEP=y:
 ...
> Enabling RX timestamping will logically disturb the fastpath (processing
> of meta frames). Replace bool hwts_rx_en with a bit that is checked
> atomically from the fastpath and temporarily unset from the sleepable
> context during a change of the RX timestamping process (a destructive
> operation anyways, requires switch reset).
> If found unset, the fastpath will just drop any received meta frame and
> not take the meta_lock at all.
> 
> Fixes: a602afd200f5 ("net: dsa: sja1105: Expose PTP timestamping ioctls to userspace")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Well, two things:

1) Even assuming #2 wasn't true, you're adding the missing initialization
   of meta_lock and that would need to be mentioned in the commit message.

2) After these changes meta_lock is no longer used so it should be removed.
