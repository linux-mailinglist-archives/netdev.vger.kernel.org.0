Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCBE31D5E6F
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgEPEGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:06:39 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44647 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725997AbgEPEGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:06:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589601998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=X9enCBr7tW7yfSw0U2tAzbrHP1z4E5Xt7K+b3QrVp9c=;
        b=gAoha6SRbIqTK+yO0ZKZ7YGbKHRaTwY8E5+c5fsd22jnceQjv4nUdKNRsVJWoarlzeMn1a
        6ODIsq6PSYyC4o9RO8M3avCACTt95XmR9AvwS+PQ4JWLy9VVKBxJ2v7Ro3ByJv7v1L+XS6
        1nrtVbIPfTaCXiiDQ0IGRU4jJ88cCQY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-hRwK9iiHPoSApB9NyATYoQ-1; Sat, 16 May 2020 00:06:33 -0400
X-MC-Unique: hRwK9iiHPoSApB9NyATYoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 745B48018A2;
        Sat, 16 May 2020 04:06:30 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 326FB5C1B0;
        Sat, 16 May 2020 04:06:19 +0000 (UTC)
Date:   Sat, 16 May 2020 00:06:16 -0400
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
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 04/15] bnxt: use new module_firmware_crashed()
Message-ID: <20200516040616.GD3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-5-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-5-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:35PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index dd0c3f227009..5ba1bd0734e9 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -3503,6 +3503,7 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
>  
>  	dump->flag = bp->dump_flag;
>  	if (dump->flag == BNXT_DUMP_CRASH) {
> +		module_firmware_crashed();
>  #ifdef CONFIG_TEE_BNXT_FW
>  		return tee_bnxt_copy_coredump(buf, 0, dump->len);
>  #endif
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

