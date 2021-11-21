Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A390458628
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 20:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhKUTlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 14:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhKUTlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 14:41:10 -0500
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBFDC061574;
        Sun, 21 Nov 2021 11:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X4ZdQLsHRGdzyKd89uTk5n2iF2RS6Cx5daUk9p5dFhU=; b=ZUdyI7Gp2CHH++7KcHrMBoQi7E
        k3tHGmyvut+DI6fM3O7a71dCjKh/stiVfCfTVmSsfmOgmfCSAvPajyUXml/tInCjP+jhQtzjmJyzj
        WkObs9kC4QT7bQig/f7j1V5dI4s1/AE8nkimoKJbcpSDqBdBXxIVDFWHf0XgyZjq8K3s=;
Received: from p54ae9f3f.dip0.t-ipconnect.de ([84.174.159.63] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mosex-0007Z5-Ld; Sun, 21 Nov 2021 20:37:55 +0100
Message-ID: <31021122-d1c1-181b-0b95-2ef1c1592452@nbd.name>
Date:   Sun, 21 Nov 2021 20:37:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [BISECTED REGRESSION] Wireless networking kernel crashes
Content-Language: en-US
To:     Aaro Koskinen <aaro.koskinen@iki.fi>,
        Johannes Berg <johannes.berg@intel.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
References: <20211118132556.GD334428@darkstar.musicnaut.iki.fi>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20211118132556.GD334428@darkstar.musicnaut.iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-11-18 14:25, Aaro Koskinen wrote:
> Hello,
> 
> I have tried to upgrade my wireless AP (Raspberry Pi with rt2x00usb)
> from v5.9 to the current mainline, but now it keeps crashing every hour
> or so, basically making my wireless network unusable.
> 
> I have bisected this to:
> 
> commit 03c3911d2d67a43ad4ffd15b534a5905d6ce5c59
> Author: Ryder Lee <ryder.lee@mediatek.com>
> Date:   Thu Jun 17 18:31:12 2021 +0200
> 
>      mac80211: call ieee80211_tx_h_rate_ctrl() when dequeue
> 
> With the previous commit the system stays up for weeks...
> 
> I just tried today's mainline, and it crashed after 10 minutes:
Please test if this patch fixes the issue:

---
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1822,15 +1822,15 @@ static int invoke_tx_handlers_late(struct ieee80211_tx_data *tx)
  	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
  	ieee80211_tx_result res = TX_CONTINUE;
  
+	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
+		CALL_TXH(ieee80211_tx_h_rate_ctrl);
+
  	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
  		__skb_queue_tail(&tx->skbs, tx->skb);
  		tx->skb = NULL;
  		goto txh_done;
  	}
  
-	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
-		CALL_TXH(ieee80211_tx_h_rate_ctrl);
-
  	CALL_TXH(ieee80211_tx_h_michael_mic_add);
  	CALL_TXH(ieee80211_tx_h_sequence);
  	CALL_TXH(ieee80211_tx_h_fragment);
