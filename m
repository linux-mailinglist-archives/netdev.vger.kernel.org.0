Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D134234B3A
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387882AbgGaSiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:38:25 -0400
Received: from mail2.candelatech.com ([208.74.158.173]:51824 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387676AbgGaSiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:38:25 -0400
Received: from [192.168.254.5] (unknown [50.34.202.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 342EA13C2B0;
        Fri, 31 Jul 2020 11:38:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 342EA13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1596220697;
        bh=0qBeodkViCQFY2Awt7MbLc4IcFIEjXjXkHdae8WCSKk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gjjMMDfFSkJOOhylBkDoMIfCzbfbfpAX9P0rDoC31s+cixVaU4ey+C/m1s0B+iVxV
         zRrhGAcxHXt78sgZ4N4nF05ULZDGfxKZvHPab2slUyif46aYgewq0s2NCVPhb/Mq4N
         u2kNicYnNEDoIAglakCzMsT5HnlpGsdAQQReHYJs=
Subject: Re: [PATCH v2 1/3] ath10k: Add history for tracking certain events
To:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
References: <1596220042-2778-1-git-send-email-pillair@codeaurora.org>
 <1596220042-2778-2-git-send-email-pillair@codeaurora.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <bedc5fe0-1904-d045-4a84-0869ee1b0b2e@candelatech.com>
Date:   Fri, 31 Jul 2020 11:38:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1596220042-2778-2-git-send-email-pillair@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 11:27 AM, Rakesh Pillai wrote:
> Add history for tracking the below events
> - register read
> - register write
> - IRQ trigger
> - NAPI poll
> - CE service
> - WMI cmd
> - WMI event
> - WMI tx completion
> 
> This will help in debugging any crash or any
> improper behaviour.
> 
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> ---
>   drivers/net/wireless/ath/ath10k/ce.c      |   1 +
>   drivers/net/wireless/ath/ath10k/core.h    |  74 +++++++++++++++++
>   drivers/net/wireless/ath/ath10k/debug.c   | 133 ++++++++++++++++++++++++++++++
>   drivers/net/wireless/ath/ath10k/debug.h   |  74 +++++++++++++++++
>   drivers/net/wireless/ath/ath10k/snoc.c    |  15 +++-
>   drivers/net/wireless/ath/ath10k/wmi-tlv.c |   1 +
>   drivers/net/wireless/ath/ath10k/wmi.c     |  10 +++
>   7 files changed, 307 insertions(+), 1 deletion(-)
> 

> +void ath10k_record_wmi_event(struct ath10k *ar, enum ath10k_wmi_type type,
> +			     u32 id, unsigned char *data)
> +{
> +	struct ath10k_wmi_event_entry *entry;
> +	u32 idx;
> +
> +	if (type == ATH10K_WMI_EVENT) {
> +		if (!ar->wmi_event_history.record)
> +			return;

This check above is duplicated below, add it once at top of the method
instead.

> +
> +		spin_lock_bh(&ar->wmi_event_history.hist_lock);
> +		idx = ath10k_core_get_next_idx(&ar->reg_access_history.index,
> +					       ar->wmi_event_history.max_entries);
> +		spin_unlock_bh(&ar->wmi_event_history.hist_lock);
> +		entry = &ar->wmi_event_history.record[idx];
> +	} else {
> +		if (!ar->wmi_cmd_history.record)
> +			return;
> +
> +		spin_lock_bh(&ar->wmi_cmd_history.hist_lock);
> +		idx = ath10k_core_get_next_idx(&ar->reg_access_history.index,
> +					       ar->wmi_cmd_history.max_entries);
> +		spin_unlock_bh(&ar->wmi_cmd_history.hist_lock);
> +		entry = &ar->wmi_cmd_history.record[idx];
> +	}
> +
> +	entry->timestamp = ath10k_core_get_timestamp();
> +	entry->cpu_id = smp_processor_id();
> +	entry->type = type;
> +	entry->id = id;
> +	memcpy(&entry->data, data + 4, ATH10K_WMI_DATA_LEN);
> +}
> +EXPORT_SYMBOL(ath10k_record_wmi_event);

> @@ -1660,6 +1668,11 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>   	ar->ce_priv = &ar_snoc->ce;
>   	msa_size = drv_data->msa_size;
>   
> +	ath10k_core_reg_access_history_init(ar, ATH10K_REG_ACCESS_HISTORY_MAX);
> +	ath10k_core_wmi_event_history_init(ar, ATH10K_WMI_EVENT_HISTORY_MAX);
> +	ath10k_core_wmi_cmd_history_init(ar, ATH10K_WMI_CMD_HISTORY_MAX);
> +	ath10k_core_ce_event_history_init(ar, ATH10K_CE_EVENT_HISTORY_MAX);

Maybe only enable this once user turns it on?  It sucks up a bit of memory?

> +
>   	ath10k_snoc_quirks_init(ar);
>   
>   	ret = ath10k_snoc_resource_init(ar);
> diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> index 932266d..9df5748 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
> @@ -627,6 +627,7 @@ static void ath10k_wmi_tlv_op_rx(struct ath10k *ar, struct sk_buff *skb)
>   	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
>   		goto out;
>   
> +	ath10k_record_wmi_event(ar, ATH10K_WMI_EVENT, id, skb->data);
>   	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
>   
>   	consumed = ath10k_tm_event_wmi(ar, id, skb);
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index a81a1ab..8ebd05c 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1802,6 +1802,15 @@ struct sk_buff *ath10k_wmi_alloc_skb(struct ath10k *ar, u32 len)
>   
>   static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
>   {
> +	struct wmi_cmd_hdr *cmd_hdr;
> +	enum wmi_tlv_event_id id;
> +
> +	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
> +	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
> +
> +	ath10k_record_wmi_event(ar, ATH10K_WMI_TX_COMPL, id,
> +				skb->data + sizeof(struct wmi_cmd_hdr));
> +
>   	dev_kfree_skb(skb);
>   }

I think guard the above new code with if (unlikely(ar->ce_event_history.record)) { ... }

All in all, I think I'd want to compile this out (while leaving other debug compiled
in) since it seems this stuff would be rarely used and it adds method calls to hot
paths.

That is a decision for Kalle though, so see what he says...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
