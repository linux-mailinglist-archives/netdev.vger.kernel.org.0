Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196513517DC
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhDARmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbhDARiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:38:06 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A348C031147
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 09:43:18 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id u9so3825637ejj.7
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 09:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuoOing0POgt3G2aAGBehC6xNmdh6vWH0bxlF60bJG0=;
        b=YytUH8KaMfAaB70edsF64nymHb5WKLnajP0YP+WUSqJzd/alTtwOyuqflknizusTJs
         AjUYRSUnwDST85VtDAAjvytDfXZGfD8CU03A9liNaisKbujN5EYVAwuT4pvESj2iIYit
         vtAiHiT23co4FCx+9+OFzFRi0q/VNs6Qumi6/ZMkP6wqvCoyFOaxCxbYkYh8AOCorL8+
         IvlkbxaE7q3mKHzWphi/PqtPl1k53CYK9QhEuMRqF+S0gUHT1pLZkHriLwxtl+x9fd0+
         qqcvMwdHHYioQ0+CcWvQHzFgRk4681J3IQlSjx962ty9sO7Yxp7kGYp++16oSYnIYa9w
         qQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuoOing0POgt3G2aAGBehC6xNmdh6vWH0bxlF60bJG0=;
        b=axdvZr4QWz29B6FouMJjkwFbaOnLTeXQYnrK31ob/LCHSn6jTDf0dlB8QZHQSuj/+n
         ClNrg3gWPUEvnlGfHuctnWVy/3q5XbhwX5rwosm/XjW44Z99CyYNrtswQBn/cbj/SaZA
         VYcXgU3Kuvk/bdxvhe0VhY4RuXRBJwmAUnR89vyOHoyJNNW4VBo8yUae3Cp/xBFwpEjs
         A/m+TsptC5pAc1w6XMIef7p2OfnsDVUxxRz5wccKTITMZHNIbL0Jq2MukVuOHKGJsdvl
         +QZH2h86Z903Xh7/roTm85DsH58JayP2CuMZ/g+ekMGnC2ucEOM3LkHfV9TxfDFTEe6d
         kSYg==
X-Gm-Message-State: AOAM5300kfZzVEmGu903T0SLl6Alfj7TvCru18IE1C0CA2tn0gv9Wdui
        5IuT8dUUqXxSz2mD+7/ePBk=
X-Google-Smtp-Source: ABdhPJznAh2bicifxPSUyzMIoImhPFVXmFDYbmET7OGGnw3lF0VVI3+GFHoKb3j3cLqPVn6WguDVmg==
X-Received: by 2002:a17:907:9482:: with SMTP id dm2mr10022328ejc.303.1617295397213;
        Thu, 01 Apr 2021 09:43:17 -0700 (PDT)
Received: from yoga-910.localhost (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id w24sm3821270edt.44.2021.04.01.09.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 09:43:16 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 0/3] dpaa2-eth: add rx copybreak support
Date:   Thu,  1 Apr 2021 19:39:53 +0300
Message-Id: <20210401163956.766628-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

DMA unmapping, allocating a new buffer and DMA mapping it back on the
refill path is really not that efficient. Proper buffer recycling (page
pool, flipping the page and using the other half) cannot be done for
DPAA2 since it's not a ring based controller but it rather deals with
multiple queues which all get their buffers from the same buffer pool on
Rx.

To circumvent these limitations, add support for Rx copybreak in
dpaa2-eth.

Ioana Ciornei (3):
  dpaa2-eth: rename dpaa2_eth_xdp_release_buf into dpaa2_eth_recycle_buf
  dpaa2-eth: add rx copybreak support
  dpaa2-eth: export the rx copybreak value as an ethtool tunable

 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 65 ++++++++++++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  | 10 ++-
 .../ethernet/freescale/dpaa2/dpaa2-ethtool.c  | 40 ++++++++++++
 3 files changed, 97 insertions(+), 18 deletions(-)

-- 
2.30.0

