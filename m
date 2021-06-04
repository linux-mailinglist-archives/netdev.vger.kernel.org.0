Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D139BB88
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 17:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhFDPTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 11:19:45 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:54916 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhFDPTp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 11:19:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622819873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AwZdjbKF9le8V5qhs73EANVyYrWlAg30LtOuAvG4ItM=;
        b=VYsc8JosvXcUOT+DhAv6ASfQ4Ux0hsDfv29GqNOg0g01mv+k2sr09+MylzEDn5aVyxqC3Y
        ei6T/YIZGvCCmukIC+wx18t6Xgc3lkmKS3orUXRb7ffeQPokH4CnF2DxGT4h21jAbEUUfz
        gbkCV2e1kEZmfgxutnTBX5NCQf2Ybws=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id db6e493e (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 4 Jun 2021 15:17:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/9] wireguard fixes for 5.13-rc5
Date:   Fri,  4 Jun 2021 17:17:29 +0200
Message-Id: <20210604151738.220232-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub,

Here are bug fixes to WireGuard for 5.13-rc5:

1-2,6) These are small, trivial tweaks to our test harness.

3) Linus thinks -O3 is still dangerous to enable. The code gen wasn't so
   much different with -O2 either.

4) We were accidentally calling synchronize_rcu instead of
   synchronize_net while holding the rtnl_lock, resulting in some rather
   large stalls that hit production machines.

5) Peer allocation was wasting literally hundreds of megabytes on real
   world deployments, due to oddly sized large objects not fitting
   nicely into a kmalloc slab.

7-9) We move from an insanely expensive O(n) algorithm to a fast O(1)
     algorithm, and cleanup a massive memory leak in the process, in
     which allowed ips churn would leave danging nodes hanging around
     without cleanup until the interface was removed. The O(1) algorithm
     eliminates packet stalls and high latency issues, in addition to
     bringing operations that took as much as 10 minutes down to less
     than a second.

Thanks,
Jason
