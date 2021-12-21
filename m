Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF6A47BFB9
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 13:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237583AbhLUMbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 07:31:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60536 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhLUMbj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 07:31:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81582B8167A;
        Tue, 21 Dec 2021 12:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67246C36AE2;
        Tue, 21 Dec 2021 12:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640089896;
        bh=aRJ72Tt/74M53TxT2OxpczsMwM+tVhnGCLhStYmdK/k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IJBirJBSycKfJ4lUKJrrxZxSzLZkwUAq0ACEDvV8ExcILnan4u+0BBUTcLn9TFkqq
         ROWCarGa1JebcuK58DHn/YEufZ/E4Wvk60GE+N/+7258YhqIs47Y9GyLzRwe+45EhO
         hRcVP7brTIM078SJo4/Na1e67bK4dsLsVwruz0cT1DtUbVXzXq7l29Yz+/uKkNsBH0
         9UEm6LIdF8DzY2qNsw/aE93856Vgj/FzYgwozsJqaCxaE1mJN2cZ1nzFFJwr4f8mtB
         qby1l/K1PxCO+er7akG6mgi98NKtiyeRJ0ze949WgytylPmphYNY0oovS+JNemufHu
         jUQn26FZbEwjA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Wen Gong <quic_wgong@quicinc.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
References: <20211221115004.1cd6b262@canb.auug.org.au>
Date:   Tue, 21 Dec 2021 14:31:31 +0200
In-Reply-To: <20211221115004.1cd6b262@canb.auug.org.au> (Stephen Rothwell's
        message of "Tue, 21 Dec 2021 11:50:04 +1100")
Message-ID: <8735mmm95o.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> After merging the mac80211-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/net/wireless/ath/ath10k/wmi.c: In function 'ath10k_wmi_event_mgmt_rx':
> drivers/net/wireless/ath/ath10k/wmi.c:2626:12: error: too few
> arguments to function 'cfg80211_get_ies_channel_number'
>  2626 |   ies_ch = cfg80211_get_ies_channel_number(mgmt->u.beacon.variable,
>       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> In file included from include/net/mac80211.h:21,
>                  from drivers/net/wireless/ath/ath10k/htt.h:16,
>                  from drivers/net/wireless/ath/ath10k/core.h:18,
>                  from drivers/net/wireless/ath/ath10k/wmi.c:11:
> include/net/cfg80211.h:6421:5: note: declared here
>  6421 | int cfg80211_get_ies_channel_number(const u8 *ie, size_t ielen,
>       |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Caused by commit
>
>   7f599aeccbd2 ("cfg80211: Use the HE operation IE to determine a 6GHz BSS channel")
>
> interacting with commit
>
>   3bf2537ec2e3 ("ath10k: drop beacon and probe response which leak from other channel")
>
> from the net-next tree.
>
> I have applied the following merge fix patch for today (which, on
> reflection, may not be correct, but builds).
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 21 Dec 2021 11:40:49 +1100
> Subject: [PATCH] fixup for "cfg80211: Use the HE operation IE to determine a 6GHz BSS channel"
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/ath/ath10k/wmi.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index 4733fd7fb169..657bd6a32a36 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2613,6 +2613,7 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
>  	if (ieee80211_is_beacon(hdr->frame_control) ||
>  	    ieee80211_is_probe_resp(hdr->frame_control)) {
>  		struct ieee80211_mgmt *mgmt = (void *)skb->data;
> +		enum cfg80211_bss_frame_type ftype;
>  		u8 *ies;
>  		int ies_ch;
>  
> @@ -2623,9 +2624,14 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
>  
>  		ies = mgmt->u.beacon.variable;
>  
> +		if (ieee80211_is_beacon(mgmt->frame_control))
> +			ftype = CFG80211_BSS_FTYPE_BEACON;
> +		else /* if (ieee80211_is_probe_resp(mgmt->frame_control)) */
> +			ftype = CFG80211_BSS_FTYPE_PRESP;
> +
>  		ies_ch = cfg80211_get_ies_channel_number(mgmt->u.beacon.variable,
>  							 skb_tail_pointer(skb) - ies,
> -							 sband->band);
> +							 sband->band, ftype);

I would remove the commented out code '/* if
(ieee80211_is_probe_resp(mgmt->frame_control)) */', otherwise looks good
to me.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
