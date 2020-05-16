Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05831D5E77
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgEPEJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:09:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31323 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgEPEJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:09:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fN+VEqkILVlswcikE6MPnPo3xVym+4MtfDbcORo4dOM=;
        b=T72gTLrESNtU5DSlZ7jlQd0VKREnm9MhTkD4YjxKrZtaMVsYgEZImDjWQvLXGFEAw6qgWm
        nQdvjc2bpxBVQpZBbwtUAjDR4T9hfZPdpXphdKg9UVA4TmpyzSjX0ktr7OYlEUkGZic4jk
        1VsAyTpZdJbTo0Hbtx/NCgJSMDCkVaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-gIH87jxqOdu-0c4EJgalcA-1; Sat, 16 May 2020 00:09:35 -0400
X-MC-Unique: gIH87jxqOdu-0c4EJgalcA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE87F80B713;
        Sat, 16 May 2020 04:09:32 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8B3878B37;
        Sat, 16 May 2020 04:09:22 +0000 (UTC)
Date:   Sat, 16 May 2020 00:09:19 -0400
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
        linux-kernel@vger.kernel.org, Vishal Kulkarni <vishal@chelsio.com>
Subject: Re: [PATCH v2 07/15] cxgb4: use new module_firmware_crashed()
Message-ID: <20200516040919.GG3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-8-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-8-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:38PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Vishal Kulkarni <vishal@chelsio.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> index a70018f067aa..c67fc86c0e42 100644
> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
> @@ -3646,6 +3646,7 @@ void t4_fatal_err(struct adapter *adap)
>  	 * could be exposed to the adapter.  RDMA MWs for example...
>  	 */
>  	t4_shutdown_adapter(adap);
> +	module_firmware_crashed();
>  	for_each_port(adap, port) {
>  		struct net_device *dev = adap->port[port];
>  
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

