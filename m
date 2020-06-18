Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7E81FFD5C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730142AbgFRV0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFRV0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:26:01 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7893DC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 14:26:00 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q11so7634305wrp.3
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 14:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=I3qqwWDNWdYZFTyk8lsfQ7HHxO6TIbaKLHN6k/9uAIA=;
        b=fVrPd/l6BmuJJBGTW8nd2HhgKX7vV9w6LHjM0JT72TAry7tAtQMLx1wHdS/pPxob1D
         k8XeDki9erMFwbGhTNxdlFFSJ3hdYkRxmdOlZ+QYw/qS5U09qDLv43JwOyCNxeEM2+qk
         3icLcKiDaklKWsql99DfyrAtc2CCnt+TknoyJoY/uvYf1vTUgkMs4NWZAO2/+0MDHCqf
         sOs8+cxKLZ55YpqAo4x5o6ujkaEsyIfamzTMm7EUrAaKa9pxwJ0wp1a6F01OQYFjVo7z
         480YZIdQtFN1bmhZ8Y9S8DKHOYwa71snoMwAh1fKN6ueB1VTlECe8J4CTde3ELeTXkKu
         4GaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=I3qqwWDNWdYZFTyk8lsfQ7HHxO6TIbaKLHN6k/9uAIA=;
        b=a04vk/3pE1LGcvlaf5s0HiFnlaoZJeLkgL2DSWSeysYbPAYMGCfjsN3/pW4I4+uBVz
         /1gt7SpFrzP37zw6wyBuodCLbGWhBaoXi1x3W3kMtkXhwLnegINSfY5gP1mU5v/Ck7x6
         gbkuP89TTVcLqV9CYepFzQwR41+yZoMvPoOeIcarzVFQVefzkbQ8Lp/OmJLKmhv/BQUk
         gENQX0qc99MYlc3hJcChYCqVJFWoemVcHevLXsjbZNNR3Zw4xtmMmooEhd9niIkLgc/J
         B8Ee/aY2yD5uJI0D6VES2rpj6I3ZoX64jC6RXwvfaiEFbPx6fOUlD5SbS+tyOClSkhFN
         YvPA==
X-Gm-Message-State: AOAM533MtcEt3SbM5+EHLhF9BDNUBAmXYcE4CGwymQ/2N2IwxZzYfkwR
        86KanZakR4katUVpczn+vwp0rtHX
X-Google-Smtp-Source: ABdhPJx8PDHNUqvN4sNLuwMs/YUGqbfTiaxnwVFGsFPev0r0TDant/a0nSSF8q8dLA2ibv6BL7xHVg==
X-Received: by 2002:a5d:570a:: with SMTP id a10mr439381wrv.215.1592515558983;
        Thu, 18 Jun 2020 14:25:58 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:a51d:2e1e:1ddd:8088? (p200300ea8f235700a51d2e1e1ddd8088.dip0.t-ipconnect.de. [2003:ea:8f23:5700:a51d:2e1e:1ddd:8088])
        by smtp.googlemail.com with ESMTPSA id 104sm4950873wrl.25.2020.06.18.14.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2020 14:25:58 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Aaron Ma <mapengyu@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] r8169: fix firmware not resetting tp->ocp_base
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <fa7fd9bd-15c0-4533-b698-c4814406ad74@gmail.com>
Date:   Thu, 18 Jun 2020 23:25:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Typically the firmware takes care that tp->ocp_base is reset to its
default value. That's not the case (at least) for RTL8117.
As a result subsequent PHY access reads/writes the wrong page and
the link is broken. Fix this be resetting tp->ocp_base explicitly.

Fixes: 229c1e0dfd3d ("r8169: load firmware for RTL8168fp/RTL8117")
Reported-by: Aaron Ma <mapengyu@gmail.com>
Tested-by: Aaron Ma <mapengyu@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a3c4187d9..98391797b 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2116,8 +2116,11 @@ static void rtl_release_firmware(struct rtl8169_private *tp)
 void r8169_apply_firmware(struct rtl8169_private *tp)
 {
 	/* TODO: release firmware if rtl_fw_write_firmware signals failure. */
-	if (tp->rtl_fw)
+	if (tp->rtl_fw) {
 		rtl_fw_write_firmware(tp, tp->rtl_fw);
+		/* At least one firmware doesn't reset tp->ocp_base. */
+		tp->ocp_base = OCP_STD_PHY_BASE;
+	}
 }
 
 static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
-- 
2.27.0

