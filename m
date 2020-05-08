Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C55FB1CB9DA
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 23:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgEHVdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 17:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgEHVdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 17:33:06 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69476C05BD0A
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 14:33:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so3589414wrx.4
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 14:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Aca/976qWiqzQz319I/1ZeKQgri8fptuMZ4rzXYLtiM=;
        b=khfMGIxp7o/hGvcG6CwyGcMR9bk9/eSoAIl631d0LdHTX9to+lGbXYVzdvJ30nU+8s
         JZtZXdYEupiy2UOW1/N3wqE1Np0k00F8rCFzpP6Y7jiCfHJvwui+oqk+xl/oytIDDXUl
         fVD2v9SeC60PlaHMCHoGvKjwtuXTR9TsT7MQotpPiVmtWq4lNz692+/5wcSHiFuzD2km
         XoXPVczQ89UlqV5Dhgd69FXT5n324rr1I+s/7mQ1/uhOJBxh8JHky7OpE9l4bpWadpk0
         LtF2XlwHSoPLx5zHQ9MgN81007Yp9ONHAFmK8OH8tUA3gj+1m6K5VtaPekQpl9qhkA6q
         MIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Aca/976qWiqzQz319I/1ZeKQgri8fptuMZ4rzXYLtiM=;
        b=eJoBwtN9pLVIfj4958+68xHkq2fd/4Kkoa0I9zVZChWD0wrebeXZmZSgfjrDpv4h39
         WYCsHRcrb9ZzEtjQUwILPvVEBSsPln2WkxdW7b60nHX9nHQvDq3oI0PlJwhagJ33hHMT
         sH90yZUG7eY8kZHvSX+ra4DHIWC9kbDCFycHQ48DYgKXQvCryrlRAlRcnTELAGaV1I66
         xZfQ3PUVHrmH5Y1jJEXXMLPaR4cZWa8n3SHlg95UMuc7rSvMIh1qGt6NFSGrTDN3WS2a
         ZBH85rbFThLZnSID36xqSI/VC016oPaHPtQlY2dq6x3q8nWT5oe1u820n2sZ6DiIOV0k
         GwDQ==
X-Gm-Message-State: AGi0PuZdg2FqwNx23RvwBnDUjL7lV0LRvDYhlX1Vqik7eKOFdJ7V420Y
        3HyfjbMT+fFZ87GXU+J5yJMHdEE5
X-Google-Smtp-Source: APiQypL4ovWRo4TnYTGp6zXAmCumNk1XjbcgbaK8okQ91GCuGWPIKE8/vBAh1kc1mPiBUk4B9CWn0w==
X-Received: by 2002:adf:e802:: with SMTP id o2mr4986057wrm.110.1588973584890;
        Fri, 08 May 2020 14:33:04 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f28:5200:b9ec:f867:184c:fa95? (p200300EA8F285200B9ECF867184CFA95.dip0.t-ipconnect.de. [2003:ea:8f28:5200:b9ec:f867:184c:fa95])
        by smtp.googlemail.com with ESMTPSA id d13sm15226679wmb.39.2020.05.08.14.33.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 14:33:04 -0700 (PDT)
Subject: [PATCH net-next 4/4] r8169: improve reset handling for chips from
 RTL8168g
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Message-ID: <fdeb08fa-854a-ba65-e257-8da0393da0cb@gmail.com>
Date:   Fri, 8 May 2020 23:32:49 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <ae5fb819-26e4-d796-2783-2ed5212d0146@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync the reset preparation for chips from RTL8168g with the r8168 and
r8125 vendor drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7ea58bd9b..0e96d0de2 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2537,10 +2537,13 @@ static void rtl8169_hw_reset(struct rtl8169_private *tp)
 		rtl_loop_wait_low(tp, &rtl_npq_cond, 20, 2000);
 		break;
 	case RTL_GIGA_MAC_VER_34 ... RTL_GIGA_MAC_VER_38:
-	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_52:
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
 		rtl_loop_wait_high(tp, &rtl_txcfg_empty_cond, 100, 666);
 		break;
+	case RTL_GIGA_MAC_VER_40 ... RTL_GIGA_MAC_VER_61:
+		rtl_enable_rxdvgate(tp);
+		fsleep(2000);
+		break;
 	default:
 		RTL_W8(tp, ChipCmd, RTL_R8(tp, ChipCmd) | StopReq);
 		udelay(100);
-- 
2.26.2


