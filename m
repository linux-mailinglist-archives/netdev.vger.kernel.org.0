Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BE22D72CE
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 10:29:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405627AbgLKJ3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 04:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404425AbgLKJ2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 04:28:35 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1752FC0613D3
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 01:27:55 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id h16so8611364edt.7
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 01:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3AQCc2YDUQGFyXvCYo88ngSH0tYmn2xNHP0sLvl7GHY=;
        b=klrDEP8SZlgLNUXz3zJpAxCLGz4SX3eGMehKPiLNX3LTW6/iIdYv0tc/CaWickbBdl
         nLBM003DAL4wPyFCozEoMOjKBXO1+VwN5/paBouGBkKwaKYfE1x6zar08idXhOBO80UU
         WkqZQVU/aAXYbiS07EsI5tpHwB6qcf1c5QG9jXY3qfkggvg2+Jm09+YOj7MX+cSbIeES
         ONIFbjAaINcCzPIY89dWq1STJVAmvbEwu8G5m1pmZ13kuleOoQZ74XJ0SdO24XnDfzG8
         9nL5RD5Q5XAJlg1vYEz6m2qIClR4cTWZ2V7kq0cOGTOFtWup5ciMtphYtyP43Wkh/7B+
         x2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3AQCc2YDUQGFyXvCYo88ngSH0tYmn2xNHP0sLvl7GHY=;
        b=gM4fejMIJLRb0rIecQ3PSzDk2J+th331eZDV+X+LUKOhg1CzD1p1Uhd3ePXl5pooPf
         GiLtKSxac52ZfzOVzJKOpsPnQkYcadB8vwsL6EPOV8VSptlrP8Yg0n/e7PcR00lr7WBN
         d+ZuBWAYI0rKiIFynx1x1q1kSkMucAEudTnNjAAnDECtphv+bR5diduzddgxjyAUcbKg
         PeaDbINeoIk0J6JNGZQeDQERSAstNqLCSBuRCQR6XCwSfh1DfpkhKqn/GRQ57XYs+hAL
         dgipTn8onSkrkiTpHmLsvBXX2ZTUgKyrQ60jba1gPahDKQcImgJinsNzShBfFSWdHx7v
         zqqA==
X-Gm-Message-State: AOAM530wX455bzB5nrrq5CZsJPEtFSRWPbDyQjmCdUzUB3BQ7s7OVk6A
        R5LWwq6APW7IMIFM9yNU9nz8mm/FA+Xf/w==
X-Google-Smtp-Source: ABdhPJyxvwVqgZ8kKt4vvSnQVrY5/Gg1peOe2zJm5YIVF7diGRKtrPz2gWF0/bw3KLi3p1hhcDtgJg==
X-Received: by 2002:a50:ac86:: with SMTP id x6mr10856558edc.197.1607678873814;
        Fri, 11 Dec 2020 01:27:53 -0800 (PST)
Received: from madeliefje.horms.nl ([2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id a20sm7314730edr.70.2020.12.11.01.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 01:27:52 -0800 (PST)
From:   Simon Horman <simon.horman@netronome.com>
To:     David Miller <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Louis Peens <louis.peens@netronome.com>,
        netdev@vger.kernel.org, oss-drivers@netronome.com,
        Simon Horman <simon.horman@netronome.com>,
        wenxu <wenxu@ucloud.cn>
Subject: [PATCH net] nfp: do not send control messages during cleanup
Date:   Fri, 11 Dec 2020 10:27:38 +0100
Message-Id: <20201211092738.3358-1-simon.horman@netronome.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On cleanup the txbufs are freed before app cleanup. But app clean-up may
result in control messages due to use of common control paths. There is no
need to clean-up the NIC in such cases so simply discard requests. Without
such a check a NULL pointer dereference occurs.

Fixes: a1db217861f3 ("net: flow_offload: fix flow_indr_dev_unregister path")
Cc: wenxu <wenxu@ucloud.cn>
Signed-off-by: Simon Horman <simon.horman@netronome.com>
Signed-off-by: Louis Peens <louis.peens@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index b4acf2f41e84..d86f68aa89bf 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -2084,6 +2084,15 @@ nfp_ctrl_tx_one(struct nfp_net *nn, struct nfp_net_r_vector *r_vec,
 	dp = &r_vec->nfp_net->dp;
 	tx_ring = r_vec->tx_ring;
 
+	if (!tx_ring->txbufs)
+		/* On cleanup the txbufs are freed before app cleanup.
+		 * But app clean-up may result in control messages due to
+		 * use of common control paths. There is no need to
+		 * clean-up the NIC in such cases so simply discard
+		 * requests.
+		 */
+		goto err_free;
+
 	if (WARN_ON_ONCE(skb_shinfo(skb)->nr_frags)) {
 		nn_dp_warn(dp, "Driver's CTRL TX does not implement gather\n");
 		goto err_free;
-- 
2.20.1

