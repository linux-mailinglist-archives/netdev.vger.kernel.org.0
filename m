Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71BC1D5E83
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgEPEMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:12:18 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:54203 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725797AbgEPEMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:12:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IwuWWBVv+jTpH4Rgey2IZ0hFppu2enqJexmcQ9Ok+RE=;
        b=DhJvBR6w62XDWu24+9ilAAdiAjDSnPGVcMYt7nMVf+pXax2Grt/bffrB3OLTCTWLZ1/lry
        1an5oayDVyZaT1lYiQmk/Ksb16iTCm0HdGpZmzJBzoNi8iannO1k357i766F3a3DYxWFma
        2EOOItXDXxX4qc5h6BvRuQ7KO49RZ+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-1MYiB0_zOUqjM_lISOG_KQ-1; Sat, 16 May 2020 00:12:12 -0400
X-MC-Unique: 1MYiB0_zOUqjM_lISOG_KQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 545EF460;
        Sat, 16 May 2020 04:12:09 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FF831053B1D;
        Sat, 16 May 2020 04:11:58 +0000 (UTC)
Date:   Sat, 16 May 2020 00:11:55 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     jeyu@kernel.org, akpm@linux-foundation.org, arnd@arndb.de,
        rostedt@goodmis.org, mingo@redhat.com, cai@lca.pw,
        dyoung@redhat.com, bhe@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, gpiccoli@canonical.com, pmladek@suse.com,
        tiwai@suse.de, schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200516041155.GL3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-13-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-13-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:43PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: linux-wireless@vger.kernel.org
> Cc: ath10k@lists.infradead.org
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/wireless/ath/ath10k/pci.c  | 2 ++
>  drivers/net/wireless/ath/ath10k/sdio.c | 2 ++
>  drivers/net/wireless/ath/ath10k/snoc.c | 1 +
>  3 files changed, 5 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
> index 1d941d53fdc9..6bd0f3b518b9 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -1767,6 +1767,7 @@ static void ath10k_pci_fw_dump_work(struct work_struct *work)
>  		scnprintf(guid, sizeof(guid), "n/a");
>  
>  	ath10k_err(ar, "firmware crashed! (guid %s)\n", guid);
> +	module_firmware_crashed();
>  	ath10k_print_driver_info(ar);
>  	ath10k_pci_dump_registers(ar, crash_data);
>  	ath10k_ce_dump_registers(ar, crash_data);
> @@ -2837,6 +2838,7 @@ static int ath10k_pci_hif_power_up(struct ath10k *ar,
>  	if (ret) {
>  		if (ath10k_pci_has_fw_crashed(ar)) {
>  			ath10k_warn(ar, "firmware crashed during chip reset\n");
> +			module_firmware_crashed();
>  			ath10k_pci_fw_crashed_clear(ar);
>  			ath10k_pci_fw_crashed_dump(ar);
>  		}
> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
> index e2aff2254a40..d34ad289380f 100644
> --- a/drivers/net/wireless/ath/ath10k/sdio.c
> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
> @@ -794,6 +794,7 @@ static int ath10k_sdio_mbox_proc_dbg_intr(struct ath10k *ar)
>  
>  	/* TODO: Add firmware crash handling */
>  	ath10k_warn(ar, "firmware crashed\n");
> +	module_firmware_crashed();
>  
>  	/* read counter to clear the interrupt, the debug error interrupt is
>  	 * counter 0.
> @@ -915,6 +916,7 @@ static int ath10k_sdio_mbox_proc_cpu_intr(struct ath10k *ar)
>  	if (cpu_int_status & MBOX_CPU_STATUS_ENABLE_ASSERT_MASK) {
>  		ath10k_err(ar, "firmware crashed!\n");
>  		queue_work(ar->workqueue, &ar->restart_work);
> +		module_firmware_crashed();
>  	}
>  	return ret;
>  }
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 354d49b1cd45..7cfc123c345c 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -1451,6 +1451,7 @@ void ath10k_snoc_fw_crashed_dump(struct ath10k *ar)
>  		scnprintf(guid, sizeof(guid), "n/a");
>  
>  	ath10k_err(ar, "firmware crashed! (guid %s)\n", guid);
> +	module_firmware_crashed();
>  	ath10k_print_driver_info(ar);
>  	ath10k_msa_dump_memory(ar, crash_data);
>  	mutex_unlock(&ar->dump_mutex);
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

