Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D66A019F4DE
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgDFLjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:39:37 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:45844 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727192AbgDFLjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 07:39:36 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id A35072E14E8;
        Mon,  6 Apr 2020 14:39:33 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id sX88qFixUn-dXiqsfHL;
        Mon, 06 Apr 2020 14:39:33 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1586173173; bh=Udgck5hZl7iY8rk7tJBnajnqAtzBoXXAebBFLAw1OM8=;
        h=Message-ID:Date:To:From:Subject:Cc;
        b=0IKqwrP0baovIK3RCualDi6GobR3G3k/do+aWVt0ZSJFwKoIV9r1UU4OnMtkPlCHm
         XCIRM12rKidSHVVoYSArzG+p1ruaguPHCNoCtplLqNfpVaCxmqoNrxa8z2DnKcs7Ae
         dUjehR169vpBHIAtzv13cL6MWuvG71j7Nl/WyNvA=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [2a02:6b8:b080:6407::1:5])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id FtB5uheCc4-dWW40PVT;
        Mon, 06 Apr 2020 14:39:32 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Subject: [PATCH] net: revert default NAPI poll timeout to 2 jiffies
From:   Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Dmitry Yakunin <zeil@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Matthew Whitehead <tedheadster@gmail.com>
Date:   Mon, 06 Apr 2020 14:39:32 +0300
Message-ID: <158617317267.1170.12944758673162826206.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For HZ < 1000 timeout 2000us rounds up to 1 jiffy but expires randomly
because next timer interrupt could come shortly after starting softirq.

For commonly used CONFIG_HZ=1000 nothing changes.

Fixes: 7acf8a1e8a28 ("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
Reported-by: Dmitry Yakunin <zeil@yandex-team.ru>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 net/core/dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9c9e763bfe0e..df8097b8e286 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4140,7 +4140,8 @@ EXPORT_SYMBOL(netdev_max_backlog);
 
 int netdev_tstamp_prequeue __read_mostly = 1;
 int netdev_budget __read_mostly = 300;
-unsigned int __read_mostly netdev_budget_usecs = 2000;
+/* Must be at least 2 jiffes to guarantee 1 jiffy timeout */
+unsigned int __read_mostly netdev_budget_usecs = 2 * USEC_PER_SEC / HZ;
 int weight_p __read_mostly = 64;           /* old backlog weight */
 int dev_weight_rx_bias __read_mostly = 1;  /* bias for backlog weight */
 int dev_weight_tx_bias __read_mostly = 1;  /* bias for output_queue quota */

