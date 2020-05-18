Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDA21D7303
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 10:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgERIcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 04:32:43 -0400
Received: from rere.qmqm.pl ([91.227.64.183]:41544 "EHLO rere.qmqm.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726624AbgERIcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 04:32:43 -0400
Received: from remote.user (localhost [127.0.0.1])
        by rere.qmqm.pl (Postfix) with ESMTPSA id 49QXMF2Xdpz39;
        Mon, 18 May 2020 10:32:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rere.qmqm.pl; s=1;
        t=1589790761; bh=Jr5Zo+YXDkImAFSg05rgVF6mfscUpFg6TKNrzRojcl0=;
        h=Date:From:To:Cc:Subject:From;
        b=pIL7Pedr6bOJWKq5kxN4K1fIt0f0WQUYkyZSpP9ob4kNiHMtK6nMHuJRZesrpyPtE
         4RiYq74w9jTJ04aW366UIZV6kdkHGY9+U+5LZNS9EZiPQdECU2qqc3XTcVlgPS8BYI
         0LpBq8nhHpUD2gEJ7+/FDYAOUn/F4xsMl4wuTv2HtUdKB7zrUOuvRhfjxb95G9HDTw
         ++YY5btuIuGn4/I9D2w0ZPxd4/viMS/K8ZyBQN0TVnorJNwD/569iovMZrT98gVULj
         uq38hV/v+uEcF2kfVAvsKDbjzYpbX2XsQVHj1ArNfhttH6wBSSPLmui1GLodlV6p8z
         WDAnZ4E3uS/ew==
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 0.102.2 at mail
Date:   Mon, 18 May 2020 10:32:39 +0200
From:   =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jarod Wilson <jarod@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: net: netdev_sync_lower_features()
Message-ID: <20200518083239.GA28855@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

I just saw commit dd912306ff008 ("net: fix a potential recursive
NETDEV_FEAT_CHANGE") landing in Linux master. The problem with it (or
rather: with the netdev_sync_lower_features() function) is that
netdev_update_features() is allowed to change more than one feature
at a time, including force-enabling other feature than one that is
being disabled. I think that a better fix would be to trigger
notification only after all features are updated (outside of the loop).
When you consider net effect of the function, the loop's added value
is only to print debug messages. Other than that it's equivalent to:

lower->wanted_features &= ~upper_disables;
netdev_update_features(lower);

The problem of spurious notification can be fixed in
__netdev_update_features() by saving dev->features at the start and
only return -1 when it really changed.

BTW, I don't remember seeing the original commit fd867d51f889 ("net/core:
generic support for disabling netdev features down stack"). It looks
like it could have be implemented just by recursively calling
netdev_update_features() for lower devices - netdev_sync_upper_features()
called on their behalf should do just what netdev_sync_lower_features()
is doing now in the context of upper device, and also respect all the
other constraints we have on features.

Best Regards,
Micha³ Miros³aw
