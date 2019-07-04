Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F37135F42A
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 09:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbfGDHxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 03:53:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58372 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727180AbfGDHxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 03:53:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5C24B609CD; Thu,  4 Jul 2019 07:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1562226790;
        bh=QP02RX+s+abAv40zJSQKeAupeAwqDfByWtGOQhkpzYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mgtpmyOCaZE5ynciK0snZPPCz1ArNV+E02B+bRVW/LCdgQ4tqPBQKZU7zkL3aodZC
         LUpAe+PB/ow+UklBfYWCISNBeK34lhkuvrDOl2LBt7I12RPR3BoaLsNK5ioK5hBuPD
         0y7Joh9oJPChhWSPCT68nIxuIQXLjMdIWDdn6jYs=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 90B1860746;
        Thu,  4 Jul 2019 07:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1562226789;
        bh=QP02RX+s+abAv40zJSQKeAupeAwqDfByWtGOQhkpzYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UfCRovyUB63eQs0AYtn62PvDY3v8N9wUpC0m4wLEAXeMNRTa8O1clQTw3MHeyFFNQ
         06dhZprHqkzdJMJC0h3pvtmVQ0z6Z8Stb0dqrvFiyUpXl6qiHctfy+gjIqq+wV50pT
         UsEKj7RyePFA8cjBG50TZKVu10QAaHJ+ANSUZwT8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 04 Jul 2019 10:53:09 +0300
From:   merez@codeaurora.org
To:     Colin King <colin.king@canonical.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] wil6210: fix wil_cid_valid with negative cid values
In-Reply-To: <20190702144026.13013-1-colin.king@canonical.com>
References: <20190702144026.13013-1-colin.king@canonical.com>
Message-ID: <787a6680930c6895d8ede457ec543fb7@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-02 17:40, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are several occasions where a negative cid value is passed
> into wil_cid_valid and this is converted into a u8 causing the
> range check of cid >= 0 to always succeed.  Fix this by making
> the cid argument an int to handle any -ve error value of cid.
> 
> An example of this behaviour is in wil_cfg80211_dump_station,
> where cid is assigned -ENOENT if the call to wil_find_cid_by_idx
> fails, and this -ve value is passed to wil_cid_valid.  I believe
> that the conversion of -ENOENT to the u8 value 254 which is
> greater than wil->max_assoc_sta causes wil_find_cid_by_idx to
> currently work fine, but I think is by luck and not the
> intended behaviour.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ath/wil6210/wil6210.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h
> b/drivers/net/wireless/ath/wil6210/wil6210.h
> index 6f456b311a39..25a1adcb38eb 100644
> --- a/drivers/net/wireless/ath/wil6210/wil6210.h
> +++ b/drivers/net/wireless/ath/wil6210/wil6210.h
> @@ -1144,7 +1144,7 @@ static inline void wil_c(struct wil6210_priv
> *wil, u32 reg, u32 val)
>  /**
>   * wil_cid_valid - check cid is valid
>   */
> -static inline bool wil_cid_valid(struct wil6210_priv *wil, u8 cid)
> +static inline bool wil_cid_valid(struct wil6210_priv *wil, int cid)
>  {
>  	return (cid >= 0 && cid < wil->max_assoc_sta);
>  }

Reviewed-by: Maya Erez <merez@codeaurora.org>

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
