Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF361D5E88
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgEPENF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:13:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:33574 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725885AbgEPENF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:13:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bdKPgDfEqRHaFGgl0l5EeNjW2TBnfhGDrlpUieGoaY=;
        b=ZgvgHP2x0ESak87U9hXzdM3vfjhacFwEeDrFC8pmbRWlqjIZdA/ww+G+s/vB9ROPxaloIa
        YlSrOkLLwKWG1cvZapZ0wKJD1y5q6r3wFC9vXFz74CZuOOv5uycakRHKbU4KheSjOzV4PV
        fUW6gRr4uRvM24SExFB4yT5zgVNim7w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-rxgNGu-MNmaHc0lwQ6C4lw-1; Sat, 16 May 2020 00:13:00 -0400
X-MC-Unique: rxgNGu-MNmaHc0lwQ6C4lw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4CE45BFC2;
        Sat, 16 May 2020 04:12:57 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AFC4F5C1B0;
        Sat, 16 May 2020 04:12:46 +0000 (UTC)
Date:   Sat, 16 May 2020 00:12:43 -0400
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
Subject: Re: [PATCH v2 13/15] ath6kl: use new module_firmware_crashed()
Message-ID: <20200516041243.GM3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-14-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-14-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:44PM +0000, Luis Chamberlain wrote:
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
>  drivers/net/wireless/ath/ath6kl/hif.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/hif.c b/drivers/net/wireless/ath/ath6kl/hif.c
> index d1942537ea10..cfd838607544 100644
> --- a/drivers/net/wireless/ath/ath6kl/hif.c
> +++ b/drivers/net/wireless/ath/ath6kl/hif.c
> @@ -120,6 +120,7 @@ static int ath6kl_hif_proc_dbg_intr(struct ath6kl_device *dev)
>  	int ret;
>  
>  	ath6kl_warn("firmware crashed\n");
> +	module_firmware_crashed();
>  
>  	/*
>  	 * read counter to clear the interrupt, the debug error interrupt is
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

