Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08DAD234928
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 18:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbgGaQ0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 12:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbgGaQ0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 12:26:24 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FDEC061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 09:26:24 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id jp10so5425820ejb.0
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 09:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3R+cTgvNGR4d5qwNZBWz6QFgT0E4GOZrozc/V1EzkDQ=;
        b=Zqj6VVsn44sb7ltN6Ckj4AyGr6v9s+IKNZe8OOuAkxevz0E7n2G98Rk7gQdIxQVpEV
         LxUmn5YkWv9zCDIw9Vyr1E13ntsiUBYATBcta18srKPyTOlsPpypz76NJ520IcZtniQc
         pyEZK5bkKME1tsBErUJEhM8SxELMH6K81jEH8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3R+cTgvNGR4d5qwNZBWz6QFgT0E4GOZrozc/V1EzkDQ=;
        b=MCAlyrr9viSlCV2+qcc3Fri/GnHkefbHpWdj6V/sk5Rb2wdHayDRN1RiSjZqGzByv/
         ZHBilvCufIITEe18XjbqfRtA9vCR9ULz8TmAMMkbIEd768ePzBwJG7OAB8KYzNyJkTCl
         ySp01lORIglSPkfiAGEdObmXIbrJ1w50QxVYmGA/klI1PhafWQyS9HElvImfXejQ41YN
         lfGuth4dHnPN78blmzEIFDL1VRisuPfUHCg/2tufiCYkJqV1wHTQAP14pUddzYEA5vJR
         6xQdRhgQqwe+vdcEdOd2A5GiGFdQsW6R79d6MSS+z4in7wva/vOw8HTOUFjSu2kwNZNt
         o/zw==
X-Gm-Message-State: AOAM530pDvEY0+YQvEhE5sG9Q3W7LpcqoqnzTBSO7+vawhDIif0TT1VG
        FwWVrv87yFeEXwxHgXtmP6lNf3X2NRg=
X-Google-Smtp-Source: ABdhPJypEr97RyaRZvgOwlOX/rKccKoucneB1QYhznA79kwu4RCzjBD/q0fF19oXpPus5Zc41ZQY9A==
X-Received: by 2002:a17:906:b046:: with SMTP id bj6mr5025237ejb.349.1596212782615;
        Fri, 31 Jul 2020 09:26:22 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id f21sm9649523edv.66.2020.07.31.09.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2020 09:26:21 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, roopa@cumulusnetworks.com,
        davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net] net: bridge: clear bridge's private skb space on xmit
Date:   Fri, 31 Jul 2020 19:26:16 +0300
Message-Id: <20200731162616.345380-1-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to clear all of the bridge private skb variables as they can be
stale due to the packet being recirculated through the stack and then
transmitted through the bridge device. Similar memset is already done on
bridge's input. We've seen cases where proxyarp_replied was 1 on routed
multicast packets transmitted through the bridge to ports with neigh
suppress which were getting dropped. Same thing can in theory happen with
the port isolation bit as well.

Fixes: 821f1b21cabb ("bridge: add new BR_NEIGH_SUPPRESS port flag to suppress arp and nd flood")
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8c7b78f8bc23..9a2fb4aa1a10 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -36,6 +36,8 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	const unsigned char *dest;
 	u16 vid = 0;
 
+	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
+
 	rcu_read_lock();
 	nf_ops = rcu_dereference(nf_br_ops);
 	if (nf_ops && nf_ops->br_dev_xmit_hook(skb)) {
-- 
2.25.4

