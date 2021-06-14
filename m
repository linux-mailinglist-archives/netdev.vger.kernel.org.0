Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0228B3A68DA
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhFNOVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:21:55 -0400
Received: from mail-ej1-f46.google.com ([209.85.218.46]:39867 "EHLO
        mail-ej1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbhFNOVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 10:21:54 -0400
Received: by mail-ej1-f46.google.com with SMTP id l1so16909954ejb.6
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 07:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COnCPtHCcI3Qv4JMFKxzmgOA68D1K0kt6WrgWjfo6mU=;
        b=FUufj0rNeBjhyk/TlBGoQXnqvlCQjl9OXsWRUA07kZRqt1TqJq/YrGad0xrmfK3sHw
         Eovjx8Qs39+dg0m66zseDvA8+Pl7XY9vAFJdn5zgipYRRPxUhRuAiB42j3BT5skFSnY4
         ONdn8LfPvR7QG3m+EvZtd5qtCSKEd1cK9qZgdmn52NO1KHqz0k3zM7TB/dyKMNfOet19
         nwSLps/FGFA7xWu2/0VmSgoLfVCEJmIz1oGLxjGyIaJISHqYlEwBbLj7P/skN8l1gMI0
         xxtmfG0MkJESaEKrGCspMjtjOXNJQYSEROu73GH2ioeZRrBGjSVhumYGDtqWkfFKNjB9
         gk2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=COnCPtHCcI3Qv4JMFKxzmgOA68D1K0kt6WrgWjfo6mU=;
        b=r4fZzSX+9yk2HEXE2vtWmHcJzrpCpHDjCQbCfyWcjAfsfhGU4FTnhYQAIohgxjHmzh
         7N9T+PqNrmXLAX9PVg+RdTwTZjUaZmSVaME28kAJ9Dp2dkuiXxqjdapru1uBsP8ZGnns
         TKRtKF2ZW65eQc+xpBREm5HEoC3J8Z3q6Tz1/HqdVA1uCIDJnUxgx00nAm+FUaKNfB1E
         mWV1jjGlhf5w8XYOgFnBcTGWX91Xvq51lSQgNLqitv5gKtNCnaBqqBWzj0NRyevGwFEb
         deeyYYX1fIo/uic3PNbFlYFIOhTvt77D+cFCrYRte7p0tFog33Bod1Nfl7EqIYFKxZOm
         fq2Q==
X-Gm-Message-State: AOAM5334zd+ezUSsz6EeEYDv7g3cvpxT/obycrcUJV4Z5ORi2pUPhDjW
        fXJZsJ1qupLvN8+XyF3aUWVc/PxpeME=
X-Google-Smtp-Source: ABdhPJz6TOJwn43qsHynL/Ih15/WMqzl9i/DIc0y88xDak72Y8f+6B01pi80LZ+pJPOjt5qfa3UIiw==
X-Received: by 2002:a17:906:5285:: with SMTP id c5mr15230751ejm.282.1623680330836;
        Mon, 14 Jun 2021 07:18:50 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan ([185.55.104.154])
        by smtp.gmail.com with ESMTPSA id h23sm8777322eds.73.2021.06.14.07.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 07:18:50 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     bjorn@mork.no, netdev@vger.kernel.org, subashab@codeaurora.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH net] qmi_wwan: Clone the skb when in pass-through mode
Date:   Mon, 14 Jun 2021 16:18:49 +0200
Message-Id: <20210614141849.3587683-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The skb that we pass to the rmnet driver is owned by usbnet and is freed
soon after the rx_fixup() callback is called (in usbnet_bh()).  There is
no guarantee that rmnet is done handling the skb before it is freed. We
should clone the skb before we call netif_rx() to prevent use-after-free
and misc. kernel oops.

Fixes: 59e139cf0b32 ("net: qmi_wwan: Add pass through mode")

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index db8d3a4f2678..5ac307eb0bfd 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -620,6 +620,10 @@ static int qmi_wwan_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		return qmimux_rx_fixup(dev, skb);
 
 	if (info->flags & QMI_WWAN_FLAG_PASS_THROUGH) {
+		skb = skb_clone(skb, GFP_ATOMIC);
+		if (!skb)
+			return 0;
+
 		skb->protocol = htons(ETH_P_MAP);
 		return (netif_rx(skb) == NET_RX_SUCCESS);
 	}
-- 
2.25.1

