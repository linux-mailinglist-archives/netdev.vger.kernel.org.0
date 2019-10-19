Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635FFDD838
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 12:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfJSKvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 06:51:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfJSKvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Oct 2019 06:51:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 417FA60716; Sat, 19 Oct 2019 10:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571482296;
        bh=Zmkpjo/I5aAU8+rQ0bWrjNgIdtKvqhgADZlmRlXPBm8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JIVpdTb5hoQJW07ua7UwHE4TvwkRjQhxXAxRY5sG307Clow3ZH9z1xie9xYTZ/1Vs
         oJigZKG1victBwDsok7I7V9H89f68SGi2avSZGqF/A2S1Hnziw3ulvd82RpZvE2P5s
         73llfWQpu16kLQGa1J2+Ha922N1o45/2IpX0hIkA=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C01D16039E;
        Sat, 19 Oct 2019 10:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571482295;
        bh=Zmkpjo/I5aAU8+rQ0bWrjNgIdtKvqhgADZlmRlXPBm8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=itmLqvHzzIsUWuwGTlA7pacgaBs22Lo7f/HNrlCNoJY1SW9BeRo7Asd8cyAoFOIGp
         5H+Hx775cjy0eOeuPiDLD2ZaOaOA+sziSF4zU0yZWZGGiS+prjqUlBL9sOgfBxH16i
         PoRjcFqUNZK4gXhicUXrxYE4UMsASg5wWKck7OeU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C01D16039E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Laura Abbott <labbott@redhat.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nicolas Waisman <nico@semmle.com>
Subject: Re: [PATCH v2] rtlwifi: Fix potential overflow on P2P code
References: <20191018114321.13131-1-labbott@redhat.com>
Date:   Sat, 19 Oct 2019 13:51:30 +0300
In-Reply-To: <20191018114321.13131-1-labbott@redhat.com> (Laura Abbott's
        message of "Fri, 18 Oct 2019 07:43:21 -0400")
Message-ID: <871rv9xb2l.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Laura Abbott <labbott@redhat.com> writes:

> Nicolas Waisman noticed that even though noa_len is checked for
> a compatible length it's still possible to overrun the buffers
> of p2pinfo since there's no check on the upper bound of noa_num.
> Bound noa_num against P2P_MAX_NOA_NUM.
>
> Reported-by: Nicolas Waisman <nico@semmle.com>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> v2: Use P2P_MAX_NOA_NUM instead of erroring out.
> ---
>  drivers/net/wireless/realtek/rtlwifi/ps.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
> index 70f04c2f5b17..fff8dda14023 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/ps.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/ps.c
> @@ -754,6 +754,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
>  				return;
>  			} else {
>  				noa_num = (noa_len - 2) / 13;
> +				if (noa_num > P2P_MAX_NOA_NUM)
> +					noa_num = P2P_MAX_NOA_NUM;
> +
>  			}
>  			noa_index = ie[3];
>  			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode ==
> @@ -848,6 +851,9 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw, void *data,
>  				return;
>  			} else {
>  				noa_num = (noa_len - 2) / 13;
> +				if (noa_num > P2P_MAX_NOA_NUM)
> +					noa_num = P2P_MAX_NOA_NUM;

IMHO using min() would be cleaner, but I'm fine with this as well. Up to
you.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
