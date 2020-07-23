Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B39D22BA01
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgGWXJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgGWXJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 19:09:07 -0400
X-Greylist: delayed 155 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jul 2020 16:09:06 PDT
Received: from mail.as201155.net (mail.as201155.net [IPv6:2a05:a1c0:f001::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6404C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 16:09:06 -0700 (PDT)
Received: from smtps.newmedia-net.de ([2a05:a1c0:0:de::167]:59700 helo=webmail.newmedia-net.de)
        by mail.as201155.net with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.82_1-5b7a7c0-XX)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jykIE-0001gh-0A; Fri, 24 Jul 2020 01:06:26 +0200
X-CTCH-RefID: str=0001.0A782F25.5F1A17F2.000D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=y7wndpGYNB6A7pAdmWmgEzm7i2bkmfDpsJHSV7MZfgM=;
        b=TIgX0JeeNnKHIGHrNifq/iTDlTtMkUsixAQ/YLRLOj1jeGFuITFO3JIW9GSSe3oHu3ND8uaslLfqfpMITVcZ2iSUIq+3X3hQ0hM7FjHyDvoKSYuuDNMvZpfx7q9EkEx9y7ARpvNpWOPpp5NPaf9WTcC1KvemDHhvi83jkp7byHI=;
Subject: Re: [RFC 7/7] ath10k: Handle rx thread suspend and resume
To:     Rakesh Pillai <pillair@codeaurora.org>, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dianders@chromium.org, evgreen@chromium.org
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-8-git-send-email-pillair@codeaurora.org>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <1540605b-c54e-d482-296f-8139eb07c195@dd-wrt.com>
Date:   Fri, 24 Jul 2020 01:06:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:79.0) Gecko/20100101
 Thunderbird/79.0
MIME-Version: 1.0
In-Reply-To: <1595351666-28193-8-git-send-email-pillair@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f22:a900:a9b6:9d0f:69f2:ec96]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1jykID-000JGc-FU; Fri, 24 Jul 2020 01:06:25 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

your patch seem to only affect the WCN3990 chipset. all other ath10k 
supported chipset are not supported here. so you see a chance to 
implement this more generic?

Sebastian

Am 21.07.2020 um 19:14 schrieb Rakesh Pillai:
> During the system suspend or resume, the rx thread
> also needs to be suspended or resume respectively.
>
> Handle the rx thread as well during the system
> suspend and resume.
>
> Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1
>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
> ---
>   drivers/net/wireless/ath/ath10k/core.c | 23 ++++++++++++++++++
>   drivers/net/wireless/ath/ath10k/core.h |  5 ++++
>   drivers/net/wireless/ath/ath10k/snoc.c | 44 +++++++++++++++++++++++++++++++++-
>   3 files changed, 71 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index 4064fa2..b82b355 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -668,6 +668,27 @@ static unsigned int ath10k_core_get_fw_feature_str(char *buf,
>   	return scnprintf(buf, buf_len, "%s", ath10k_core_fw_feature_str[feat]);
>   }
>   
> +int ath10k_core_thread_suspend(struct ath10k_thread *thread)
> +{
> +	ath10k_dbg(thread->ar, ATH10K_DBG_BOOT, "Suspending thread %s\n",
> +		   thread->name);
> +	set_bit(ATH10K_THREAD_EVENT_SUSPEND, thread->event_flags);
> +	wait_for_completion(&thread->suspend);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ath10k_core_thread_suspend);
> +
> +int ath10k_core_thread_resume(struct ath10k_thread *thread)
> +{
> +	ath10k_dbg(thread->ar, ATH10K_DBG_BOOT, "Resuming thread %s\n",
> +		   thread->name);
> +	complete(&thread->resume);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(ath10k_core_thread_resume);
> +
>   void ath10k_core_thread_post_event(struct ath10k_thread *thread,
>   				   enum ath10k_thread_events event)
>   {
> @@ -700,6 +721,8 @@ int ath10k_core_thread_init(struct ath10k *ar,
>   
>   	init_waitqueue_head(&thread->wait_q);
>   	init_completion(&thread->shutdown);
> +	init_completion(&thread->suspend);
> +	init_completion(&thread->resume);
>   	memcpy(thread->name, thread_name, ATH10K_THREAD_NAME_SIZE_MAX);
>   	clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN, thread->event_flags);
>   	ath10k_info(ar, "Starting thread %s\n", thread_name);
> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
> index 596d31b..df65e75 100644
> --- a/drivers/net/wireless/ath/ath10k/core.h
> +++ b/drivers/net/wireless/ath/ath10k/core.h
> @@ -976,6 +976,7 @@ enum ath10k_thread_events {
>   	ATH10K_THREAD_EVENT_SHUTDOWN,
>   	ATH10K_THREAD_EVENT_RX_POST,
>   	ATH10K_THREAD_EVENT_TX_POST,
> +	ATH10K_THREAD_EVENT_SUSPEND,
>   	ATH10K_THREAD_EVENT_MAX,
>   };
>   
> @@ -983,6 +984,8 @@ struct ath10k_thread {
>   	struct ath10k *ar;
>   	struct task_struct *task;
>   	struct completion shutdown;
> +	struct completion suspend;
> +	struct completion resume;
>   	wait_queue_head_t wait_q;
>   	DECLARE_BITMAP(event_flags, ATH10K_THREAD_EVENT_MAX);
>   	char name[ATH10K_THREAD_NAME_SIZE_MAX];
> @@ -1296,6 +1299,8 @@ static inline bool ath10k_peer_stats_enabled(struct ath10k *ar)
>   
>   extern unsigned long ath10k_coredump_mask;
>   
> +int ath10k_core_thread_suspend(struct ath10k_thread *thread);
> +int ath10k_core_thread_resume(struct ath10k_thread *thread);
>   void ath10k_core_thread_post_event(struct ath10k_thread *thread,
>   				   enum ath10k_thread_events event);
>   int ath10k_core_thread_shutdown(struct ath10k *ar,
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 3eb5eac..a373b2b 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -932,13 +932,31 @@ int ath10k_snoc_rx_thread_loop(void *data)
>   					    rx_thread->event_flags) ||
>   			 test_and_clear_bit(ATH10K_THREAD_EVENT_TX_POST,
>   					    rx_thread->event_flags) ||
> +			 test_bit(ATH10K_THREAD_EVENT_SUSPEND,
> +				  rx_thread->event_flags) ||
>   			 test_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
>   				  rx_thread->event_flags)));
>   
> +		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SUSPEND,
> +				       rx_thread->event_flags)) {
> +			complete(&rx_thread->suspend);
> +			ath10k_info(ar, "rx thread suspend\n");
> +			wait_for_completion(&rx_thread->resume);
> +			ath10k_info(ar, "rx thread resume\n");
> +		}
> +
>   		ath10k_htt_txrx_compl_task(ar, thread_budget);
>   		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SHUTDOWN,
>   				       rx_thread->event_flags))
>   			shutdown = true;
> +
> +		if (test_and_clear_bit(ATH10K_THREAD_EVENT_SUSPEND,
> +				       rx_thread->event_flags)) {
> +			complete(&rx_thread->suspend);
> +			ath10k_info(ar, "rx thread suspend\n");
> +			wait_for_completion(&rx_thread->resume);
> +			ath10k_info(ar, "rx thread resume\n");
> +		}
>   	}
>   
>   	ath10k_dbg(ar, ATH10K_DBG_SNOC, "rx thread exiting\n");
> @@ -1133,15 +1151,30 @@ static int ath10k_snoc_hif_suspend(struct ath10k *ar)
>   	if (!device_may_wakeup(ar->dev))
>   		return -EPERM;
>   
> +	if (ar->rx_thread_enable) {
> +		ret = ath10k_core_thread_suspend(&ar->rx_thread);
> +		if (ret) {
> +			ath10k_err(ar, "failed to suspend rx_thread, %d\n",
> +				   ret);
> +			return ret;
> +		}
> +	}
> +
>   	ret = enable_irq_wake(ar_snoc->ce_irqs[ATH10K_SNOC_WAKE_IRQ].irq_line);
>   	if (ret) {
>   		ath10k_err(ar, "failed to enable wakeup irq :%d\n", ret);
> -		return ret;
> +		goto fail;
>   	}
>   
>   	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device suspended\n");
>   
>   	return ret;
> +
> +fail:
> +	if (ar->rx_thread_enable)
> +		ath10k_core_thread_resume(&ar->rx_thread);
> +
> +	return ret;
>   }
>   
>   static int ath10k_snoc_hif_resume(struct ath10k *ar)
> @@ -1158,6 +1191,15 @@ static int ath10k_snoc_hif_resume(struct ath10k *ar)
>   		return ret;
>   	}
>   
> +	if (ar->rx_thread_enable) {
> +		ret = ath10k_core_thread_resume(&ar->rx_thread);
> +		if (ret) {
> +			ath10k_err(ar, "failed to suspend rx_thread, %d\n",
> +				   ret);
> +			return ret;
> +		}
> +	}
> +
>   	ath10k_dbg(ar, ATH10K_DBG_SNOC, "snoc device resumed\n");
>   
>   	return ret;
