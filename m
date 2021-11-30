Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94BB5462943
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 01:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234425AbhK3Auz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 19:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234389AbhK3Auz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 19:50:55 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E1C061714
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 16:47:37 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id 71so17861087pgb.4
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 16:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FNHzIeoNF4E/ChvY8iqCZpHku0EJ1HjjIEUDqrvYteE=;
        b=hdoyQm+SZqT3VqIFKhsA87GHz6tPX+yEJy7VUqZ1vOh1fbV0K8hdAD8xEfN4BSZijq
         UyhMIWU5P7CpypZVPwH7GbgIRGa04Hb+DK5SWapT9cbNBnpIqzg77bQj3AvHEk7ojrJh
         6xH4pD1x9Ltc9c5yLj5yuWR+HZqdVVal7S35g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FNHzIeoNF4E/ChvY8iqCZpHku0EJ1HjjIEUDqrvYteE=;
        b=64YuWPPPa2gdThvF4ClE6LwwlqDUcn6/NWUHEdicaqVzf+65EoLnBt5lP/Wt1h5U5l
         0+NdxkA81Nec4AWvgWXBT7Q/zrdU/zQRxQawepQFVjIMND0YWZKLkzX7u6Q+LCj3Hxph
         Me4PB4TQop2lUGSZLRsDMBzMmhXUZLLmK5f4fBJxiawegMx0he8cTdbRjlC6jQPM8gVb
         zVHk8pvnv7JA4aSQSbRDiLPQgwZvgbKdd7FrB/yHvzddkjyUE3OxwCm5zD/hs0JLIPGH
         M5jVChfBQn0/VfRdEJGQ8vYb0WfFOw/SrV3zo+Q2t0qHU9xq3MWIaVXP284JxIWzZDep
         DS1g==
X-Gm-Message-State: AOAM531tn73tB4Uc4pBcExgnlqkbyVTYWSJ0uMByRE3HL+Oj+nJUF1fg
        t+D53JLQ9qif95n430Vy7155og==
X-Google-Smtp-Source: ABdhPJzqbcpo6hlWldDlPjrL230SXiWqrqs/mRNPc8dujTRCS/HMUGkCX5XfHZw0PIVrhJ83oQCu0g==
X-Received: by 2002:a63:554:: with SMTP id 81mr34328310pgf.298.1638233256675;
        Mon, 29 Nov 2021 16:47:36 -0800 (PST)
Received: from google.com ([2620:15c:202:201:8b47:583d:a0:4f2d])
        by smtp.gmail.com with ESMTPSA id m12sm20441202pfk.27.2021.11.29.16.47.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 16:47:36 -0800 (PST)
Date:   Mon, 29 Nov 2021 16:47:34 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@codeaurora.org, David Miller <davem@davemloft.net>,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH] mwifiex: Fix possible ABBA deadlock
Message-ID: <YaV0pllJ5p/EuUat@google.com>
References: <0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jia-Ju Bai <baijiaju1990@gmail.com>:

  mwifiex_dequeue_tx_packet()
     spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 1432 (Lock A)
     mwifiex_send_addba()
       spin_lock_bh(&priv->sta_list_spinlock); --> Line 608 (Lock B)

  mwifiex_process_sta_tx_pause()
     spin_lock_bh(&priv->sta_list_spinlock); --> Line 398 (Lock B)
     mwifiex_update_ralist_tx_pause()
       spin_lock_bh(&priv->wmm.ra_list_spinlock); --> Line 941 (Lock A)

Similar report for mwifiex_process_uap_tx_pause().

While the locking expectations in this driver are a bit unclear, the
Fixed commit only intended to protect the sta_ptr, so we can drop the
lock as soon as we're done with it.

IIUC, this deadlock cannot actually happen, because command event
processing (which calls mwifiex_process_sta_tx_pause()) is
sequentialized with TX packet processing (e.g.,
mwifiex_dequeue_tx_packet()) via the main loop (mwifiex_main_process()).
But it's good not to leave this potential issue lurking.

Fixes: ("f0f7c2275fb9 mwifiex: minor cleanups w/ sta_list_spinlock in cfg80211.c")
Cc: Douglas Anderson <dianders@chromium.org>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Link: https://lore.kernel.org/linux-wireless/0e495b14-efbb-e0da-37bd-af6bd677ee2c@gmail.com/
Signed-off-by: Brian Norris <briannorris@chromium.org>
---

On Tue, Nov 23, 2021 at 11:31:34AM +0800, Jia-Ju Bai wrote:
> I am not quite sure whether these possible deadlocks are real and how to fix
> them if they are real.
> Any feedback would be appreciated, thanks :)

I think these are at least theoretically real, and so we should take
something like the $subject patch probably. But I don't believe we can
actually hit this due to the main-loop structure of this driver.

Anyway, see the surrounding patch.

Thanks,
Brian


 drivers/net/wireless/marvell/mwifiex/sta_event.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_event.c b/drivers/net/wireless/marvell/mwifiex/sta_event.c
index 80e5d44bad9d..7d42c5d2dbf6 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_event.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_event.c
@@ -365,10 +365,12 @@ static void mwifiex_process_uap_tx_pause(struct mwifiex_private *priv,
 		sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
 		if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
 			sta_ptr->tx_pause = tp->tx_pause;
+			spin_unlock_bh(&priv->sta_list_spinlock);
 			mwifiex_update_ralist_tx_pause(priv, tp->peermac,
 						       tp->tx_pause);
+		} else {
+			spin_unlock_bh(&priv->sta_list_spinlock);
 		}
-		spin_unlock_bh(&priv->sta_list_spinlock);
 	}
 }
 
@@ -400,11 +402,13 @@ static void mwifiex_process_sta_tx_pause(struct mwifiex_private *priv,
 			sta_ptr = mwifiex_get_sta_entry(priv, tp->peermac);
 			if (sta_ptr && sta_ptr->tx_pause != tp->tx_pause) {
 				sta_ptr->tx_pause = tp->tx_pause;
+				spin_unlock_bh(&priv->sta_list_spinlock);
 				mwifiex_update_ralist_tx_pause(priv,
 							       tp->peermac,
 							       tp->tx_pause);
+			} else {
+				spin_unlock_bh(&priv->sta_list_spinlock);
 			}
-			spin_unlock_bh(&priv->sta_list_spinlock);
 		}
 	}
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog
