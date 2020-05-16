Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B011D5E74
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgEPEIO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:08:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49346 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725867AbgEPEIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:08:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pzKGrP1dcY39C40zoZZuybJrD8WuaSa1VZ90S7jsI/c=;
        b=ZfZU+bDoVi25nxnueq90LhzYJL/q22JR5IShWx7MNiAKJLJmMWqkOjAvcDRbb65bmPdcDh
        sEXKmlYC6zbzFEhHjEOp7YjKTD3oGCuT8XQAGQd/wqx8RR9RTxKlzBZsxX2tVliCURqYHh
        vRtHcsZ/b4S5040YubyAGVkyQAcZmd0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-90-7693THB7NYWd8sy1S5ZWpw-1; Sat, 16 May 2020 00:08:06 -0400
X-MC-Unique: 7693THB7NYWd8sy1S5ZWpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9132D80B713;
        Sat, 16 May 2020 04:08:03 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C51F199D8;
        Sat, 16 May 2020 04:07:52 +0000 (UTC)
Date:   Sat, 16 May 2020 00:07:49 -0400
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
        linux-kernel@vger.kernel.org,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>
Subject: Re: [PATCH v2 06/15] liquidio: use new module_firmware_crashed()
Message-ID: <20200516040749.GF3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-7-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-7-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:37PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Derek Chickles <dchickles@marvell.com>
> Cc: Satanand Burla <sburla@marvell.com>
> Cc: Felix Manlunas <fmanlunas@marvell.com>
> Reviewed-by: Derek Chickles <dchickles@marvell.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/cavium/liquidio/lio_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> index 66d31c018c7e..f18085262982 100644
> --- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
> +++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
> @@ -801,6 +801,7 @@ static int liquidio_watchdog(void *param)
>  			continue;
>  
>  		WRITE_ONCE(oct->cores_crashed, true);
> +		module_firmware_crashed();
>  		other_oct = get_other_octeon_device(oct);
>  		if (other_oct)
>  			WRITE_ONCE(other_oct->cores_crashed, true);
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

