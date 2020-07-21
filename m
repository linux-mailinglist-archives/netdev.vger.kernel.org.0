Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B601A228C44
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbgGUWzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUWzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:55:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8B6C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 15:55:46 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 89EDF11E45904;
        Tue, 21 Jul 2020 15:39:00 -0700 (PDT)
Date:   Tue, 21 Jul 2020 15:55:44 -0700 (PDT)
Message-Id: <20200721.155544.425274580821501846.davem@davemloft.net>
To:     geffrey.guo@huawei.com
Cc:     kuba@kernel.org, maheshb@google.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ipvlan: add the check of ip header checksum
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1595336962-98677-1-git-send-email-geffrey.guo@huawei.com>
References: <1595336962-98677-1-git-send-email-geffrey.guo@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:39:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: guodeqing <geffrey.guo@huawei.com>
Date: Tue, 21 Jul 2020 21:09:22 +0800

> The ip header checksum can be error in the following steps.
 ...
> $ ip netns exec ns1 tc qdisc add dev ip1 root netem corrupt 50%

This is not valid.

The kernel internally already validated the ipv4 header checksum
before forwarding or sending it on egress to the ipvlan device.

The driver can legitimately depend upon this validation.

Besides, as Cong pointed out, so much other code in the ipvlan
driver has read various ipv4 header members such as the addresses
necessary to perform lookups.
