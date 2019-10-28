Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50CECE6CA8
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 08:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbfJ1HEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 03:04:50 -0400
Received: from gateway23.websitewelcome.com ([192.185.48.71]:28148 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730616AbfJ1HEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 03:04:49 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2019 03:04:49 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 79EEB2509
        for <netdev@vger.kernel.org>; Mon, 28 Oct 2019 02:04:49 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Oz57i0OB1BnGaOz57ieo49; Mon, 28 Oct 2019 02:04:49 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cc1Lq/1I6uaUptz7nqvA6hsrq7d4wgFlwqeS4oYmYzU=; b=WoVLRJRJ59aEd0sJv0mgkAnfA6
        ZwEXpix02KGKjEbIw+HFzZ4aiMfvGWbufEN5SopsynMu7MJPd5GpQW6fNuuYtWAmfY+PCptigBnoi
        HJmG4SsWFG4lsAg2cJE0v3UWQOJ2xyUtGnJMIqQOXmBNDO8n+662Yxg8MGnuQxq8DPLn29U1ttsN8
        C/ErRTaDE1Uv4APq0v0LvoX8voeiR/YCsggjKYKrFbRwoQoio6edcrjnRgmH58lr02y+2PzFcWScl
        Kenk96P6DgVuCtjE7REdkTLemeGS8AWPVkIZvaNBp2/6p5yDjyBJD61/zID6Dha8Vl5NSEeg98R0a
        r6TuMI0g==;
Received: from [187.192.2.30] (port=58482 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1iOz56-0046Kp-7m; Mon, 28 Oct 2019 02:04:48 -0500
Date:   Mon, 28 Oct 2019 02:04:47 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Egor Pomozov <epomozov@marvell.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sergey Samoilenko <sergey.samoilenko@aquantia.com>,
        Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH net-next] net: aquantia: fix error handling in aq_ptp_poll
Message-ID: <20191028070447.GA3659@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.2.30
X-Source-L: No
X-Exim-ID: 1iOz56-0046Kp-7m
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.2.30]:58482
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 6
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix currenty ignored returned error by properly checking *err* after
calling aq_nic->aq_hw_ops->hw_ring_hwts_rx_fill().

Addresses-Coverity-ID: 1487357 ("Unused value")
Fixes: 04a1839950d9 ("net: aquantia: implement data PTP datapath")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
index 3ec08415e53e..92b666f7d242 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
@@ -678,6 +678,8 @@ static int aq_ptp_poll(struct napi_struct *napi, int budget)
 
 		err = aq_nic->aq_hw_ops->hw_ring_hwts_rx_fill(aq_nic->aq_hw,
 							      &aq_ptp->hwts_rx);
+		if (err < 0)
+			goto err_exit;
 
 		was_cleaned = true;
 	}
-- 
2.23.0

