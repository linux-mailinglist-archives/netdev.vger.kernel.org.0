Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C251D5E5D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726264AbgEPEFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:05:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44112 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725275AbgEPEFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:05:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589601911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qZFEaKrNvjcuFnNRasMkMJZvRQRsiJyBl8UOZqRrOZU=;
        b=aXs5Njcj6GJAu39wJzYHRAhwkJp/GSP0Q1r4XQMcQOoHzuub6hCp4EGqxpjbIKRKeejT7l
        yoq8aZyaTIZprDsh07xbzslj47BIcY5veXoImqEoYt7IlE6plheaIGJYxiwh9FKMyANp3Z
        tr4UBlMhGKkYHI7RGRFZ3Xx1I9gCVCs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-KgCfEaxZNay5LI_cG4WFNw-1; Sat, 16 May 2020 00:05:09 -0400
X-MC-Unique: KgCfEaxZNay5LI_cG4WFNw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 403701800D42;
        Sat, 16 May 2020 04:05:06 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91568100239A;
        Sat, 16 May 2020 04:04:52 +0000 (UTC)
Date:   Sat, 16 May 2020 00:04:48 -0400
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Shannon Nelson <snelson@pensando.io>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 02/15] ethernet/839: use new module_firmware_crashed()
Message-ID: <20200516040448.GB3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-3-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:33PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Shannon Nelson <snelson@pensando.io>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/8390/axnet_cs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
> index aeae7966a082..8ad0200db8e9 100644
> --- a/drivers/net/ethernet/8390/axnet_cs.c
> +++ b/drivers/net/ethernet/8390/axnet_cs.c
> @@ -1358,9 +1358,11 @@ static void ei_receive(struct net_device *dev)
>  		 */
>  		if ((netif_msg_rx_err(ei_local)) &&
>  		    this_frame != ei_local->current_page &&
> -		    (this_frame != 0x0 || rxing_page != 0xFF))
> +		    (this_frame != 0x0 || rxing_page != 0xFF)) {
> +			module_firmware_crashed();
>  			netdev_err(dev, "mismatched read page pointers %2x vs %2x\n",
>  				   this_frame, ei_local->current_page);
> +		}
>  		
>  		if (this_frame == rxing_page)	/* Read all the frames? */
>  			break;				/* Done for now */
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

