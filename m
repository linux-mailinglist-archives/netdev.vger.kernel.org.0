Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFB01D5E80
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726966AbgEPELW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:11:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30550 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725997AbgEPELV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KA2V3BpgZ0c6dcuS+GWF6G6JZMOgBQvmv5cWM20/AUM=;
        b=iEgcQPFGsjIBCTCAWuzvgmLKWks90nejxy30EOvI/W5c2eSL+tXOlVQ4AmR6GEkAiqjafK
        ITlMRmnkayIcHE3eCRqPZxDFuew6T3V3IIge/mWZ1o1cMMTLrvpSI7RcGCaYR8Pq8ZpslZ
        l4K3GHxWQBUQkrsCrniPuZz60qu0Yio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-2HqC332BOx2tpp1tUsYgcw-1; Sat, 16 May 2020 00:11:12 -0400
X-MC-Unique: 2HqC332BOx2tpp1tUsYgcw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4180107ACF2;
        Sat, 16 May 2020 04:11:09 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 64C1099D8;
        Sat, 16 May 2020 04:10:59 +0000 (UTC)
Date:   Sat, 16 May 2020 00:10:55 -0400
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
        linux-kernel@vger.kernel.org, Alex Elder <elder@kernel.org>
Subject: Re: [PATCH v2 10/15] soc: qcom: ipa: use new
 module_firmware_crashed()
Message-ID: <20200516041055.GJ3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-11-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-11-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:41PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Alex Elder <elder@kernel.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ipa/ipa_modem.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
> index ed10818dd99f..1790b87446ed 100644
> --- a/drivers/net/ipa/ipa_modem.c
> +++ b/drivers/net/ipa/ipa_modem.c
> @@ -285,6 +285,7 @@ static void ipa_modem_crashed(struct ipa *ipa)
>  	struct device *dev = &ipa->pdev->dev;
>  	int ret;
>  
> +	module_firmware_crashed();
>  	ipa_endpoint_modem_pause_all(ipa, true);
>  
>  	ipa_endpoint_modem_hol_block_clear_all(ipa);
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

