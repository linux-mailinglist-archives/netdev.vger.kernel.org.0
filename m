Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA21D5E81
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgEPELs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:11:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42871 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgEPELs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:11:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MsNAF+lEjVfoNNok+8GPXlzJnA9v2e+5s8MgqrPYvZU=;
        b=P1aLQ+VMAKzDyJAI7PvoFJBJbPnD7jb9W9eyW45DBF/nGHnamodDR+OdYL9x3lveqt64DL
        M4eqbPMj9+w5Il5DttCYx2nmEe/nWbrI7dsdYkiIJ8ECzXIovhW/5sNWf4K8kcOCZdRbvb
        /HKA/NOJAYT+zTi8El/RxCuQugQwb3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-268-d6X-AxzTN_epPz8es0IETQ-1; Sat, 16 May 2020 00:11:42 -0400
X-MC-Unique: d6X-AxzTN_epPz8es0IETQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D51E78015D2;
        Sat, 16 May 2020 04:11:39 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F468101F6D8;
        Sat, 16 May 2020 04:11:29 +0000 (UTC)
Date:   Sat, 16 May 2020 00:11:25 -0400
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
        linux-kernel@vger.kernel.org, linux-wimax@intel.com,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Subject: Re: [PATCH v2 11/15] wimax/i2400m: use new module_firmware_crashed()
Message-ID: <20200516041125.GK3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-12-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-12-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:42PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: linux-wimax@intel.com
> Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/wimax/i2400m/rx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
> index c9fb619a9e01..307a62ca183f 100644
> --- a/drivers/net/wimax/i2400m/rx.c
> +++ b/drivers/net/wimax/i2400m/rx.c
> @@ -712,6 +712,7 @@ void __i2400m_roq_queue(struct i2400m *i2400m, struct i2400m_roq *roq,
>  	dev_err(dev, "SW BUG? failed to insert packet\n");
>  	dev_err(dev, "ERX: roq %p [ws %u] skb %p nsn %d sn %u\n",
>  		roq, roq->ws, skb, nsn, roq_data->sn);
> +	module_firmware_crashed();
>  	skb_queue_walk(&roq->queue, skb_itr) {
>  		roq_data_itr = (struct i2400m_roq_data *) &skb_itr->cb;
>  		nsn_itr = __i2400m_roq_nsn(roq, roq_data_itr->sn);
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

