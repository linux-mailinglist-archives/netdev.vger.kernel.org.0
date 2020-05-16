Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098FD1D5E60
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgEPEFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:05:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30385 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725797AbgEPEFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589601954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3GThcFJi6mjPq3yR/OkVZogFkUGUPuA1kG+DkwzxNmo=;
        b=gWYDT0nShZKyCnp6UeC3PacpmrHz5AFYwRW0yqr08BUpFtz6QmB8ODzShYVUQXL5NXWOO1
        CMEtnKlGxVEU0xlWsgHoevNbU0DWmythWSZNP+bsh/RE2yzNHaV8iJi1X4SYWHoByfpuMg
        ZRAkmy97lKaHh0zWI6TTOPXlCX3ofHc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-tFkabqqYO_OyUY77sZkaIg-1; Sat, 16 May 2020 00:05:46 -0400
X-MC-Unique: tFkabqqYO_OyUY77sZkaIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 670018005AD;
        Sat, 16 May 2020 04:05:43 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E58812A4D;
        Sat, 16 May 2020 04:05:29 +0000 (UTC)
Date:   Sat, 16 May 2020 00:05:26 -0400
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
        linux-kernel@vger.kernel.org, Ariel Elior <aelior@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-everest-linux-l2@marvell.com
Subject: Re: [PATCH v2 03/15] bnx2x: use new module_firmware_crashed()
Message-ID: <20200516040526.GC3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-4-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:34PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: Sudarsana Kalluru <skalluru@marvell.com>
> CC: GR-everest-linux-l2@marvell.com
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> index db5107e7937c..c38b8c9c8af0 100644
> --- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> +++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
> @@ -909,6 +909,7 @@ void bnx2x_panic_dump(struct bnx2x *bp, bool disable_int)
>  	bp->eth_stats.unrecoverable_error++;
>  	DP(BNX2X_MSG_STATS, "stats_state - DISABLED\n");
>  
> +	module_firmware_crashed();
>  	BNX2X_ERR("begin crash dump -----------------\n");
>  
>  	/* Indices */
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

