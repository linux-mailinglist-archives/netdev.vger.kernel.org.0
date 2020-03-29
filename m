Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D80196E77
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 18:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgC2Q2y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 12:28:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35348 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbgC2Q2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 12:28:54 -0400
Received: by mail-wr1-f66.google.com with SMTP id d5so18095687wrn.2
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 09:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9ZgR7IotLdbbYnYPXHGp1p0DPCwYmlxBgG40gY36a8E=;
        b=uEd7YkPlPwd/Qij8UmDrqITB+L06OV21qTmIjARMw/eI+227pU4fh3pF6OUAnz6iDG
         DZH0/MOrKWBIUgnNoinuNljisAVxgsy5zPW0YZ8+vQ1LHshxfSrEnTp5F3YrLU6qMujL
         zHxv7I9lUeAutoxenMtcPzGzcumZpKVRfNo3OybKH2N/eIzvd9iQPAihkdYLuDDEYHUW
         cKNUnGfol7H4qGesAFpX8KhZJio8JN2yuvtD7p/BIy3/HpnhSpaC31BdaGPfiPLdb0En
         KISQl7+sxpU/eWOtZK2rlZ/QtLJ+XDOM5RKinKEmnj9+MoxV+0HOtBfjQwvul9lDicXA
         55rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9ZgR7IotLdbbYnYPXHGp1p0DPCwYmlxBgG40gY36a8E=;
        b=eQsk8MQFslnEZG04Nvc+Y/YJMsluAzYpmQp1zyvuYtSMzKHFB/rnjw6Tya9sNZ265U
         yNW2Nmkfh+bzWjrEffCUDjNXMBo9XQcpCIwWtfd66je/oLjmoL3fhOWwl/XhcXughUT9
         V1cp6eqsRHzGxs5rBWvlb6AJr7bTAQjZpfhPl0/daTQiKxgxsVJrps51L4CP4aA+yzu+
         hpEmKBokPb4fL/4tPBS48DvfOaTfXOC+akaGZIVhOp40B60aXEtMPZy4srfEA/8bYKfG
         +bRH9RDBxIPkZZq07N4wUjahRXsx/ZhvXub07+UY0LrJv6CzgcSbDdmYfARGpzWyJmah
         KSMA==
X-Gm-Message-State: ANhLgQ2jqC4JRoU1zP4udXgMtDuPQBv+b58pg75TlqLB0X5ZC67vMSYV
        9juZILS1mqEi1milIOAdq41TsAs0
X-Google-Smtp-Source: ADFU+vuqnxaJeyzmf/20omZRorZF0PNmtNrS29yNxm9GCBCncT59tsP4FTfNIaPsZmbO7lxMjR4zPQ==
X-Received: by 2002:adf:a319:: with SMTP id c25mr10465828wrb.197.1585499331963;
        Sun, 29 Mar 2020 09:28:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:186:fda7:a83:def2? (p200300EA8F2960000186FDA70A83DEF2.dip0.t-ipconnect.de. [2003:ea:8f29:6000:186:fda7:a83:def2])
        by smtp.googlemail.com with ESMTPSA id h81sm19147194wme.42.2020.03.29.09.28.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 09:28:51 -0700 (PDT)
To:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve handling of TD_MSS_MAX
Message-ID: <eda95a7b-2873-538a-567a-4fe9e1ca2bb2@gmail.com>
Date:   Sun, 29 Mar 2020 18:28:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the mtu is greater than TD_MSS_MAX, then TSO is disabled, see
rtl8169_fix_features(). Because mss is less than mtu, we can't have
the case mss > TD_MSS_MAX in the TSO path.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9971135a7..5990147c0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4106,7 +4106,7 @@ static void rtl8169_tso_csum_v1(struct sk_buff *skb, u32 *opts)
 
 	if (mss) {
 		opts[0] |= TD_LSO;
-		opts[0] |= min(mss, TD_MSS_MAX) << TD0_MSS_SHIFT;
+		opts[0] |= mss << TD0_MSS_SHIFT;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		const struct iphdr *ip = ip_hdr(skb);
 
@@ -4145,7 +4145,7 @@ static bool rtl8169_tso_csum_v2(struct rtl8169_private *tp,
 		}
 
 		opts[0] |= transport_offset << GTTCPHO_SHIFT;
-		opts[1] |= min(mss, TD_MSS_MAX) << TD1_MSS_SHIFT;
+		opts[1] |= mss << TD1_MSS_SHIFT;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		u8 ip_protocol;
 
-- 
2.26.0

