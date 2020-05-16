Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2881D5E72
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgEPEH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:07:27 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42356 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725807AbgEPEH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:07:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZKhAzAY/Ms4yM0fdVfvs34Q0bnqFpJ/yjv/lIPKQ6rM=;
        b=gjaL0T9mhjd6bboIQxCFGaaXBTps9Yfj5QL8jA/7D9UbGuqLcMpHI8dlyF+SH08to9/XIb
        F/xneL7jWjYHIJLmo+rEi1hmYvVmGk0IOwa8IwIVuc/qQx5Gh+NUR1LtEwumD1EoMUHllH
        CD0fdO96kj1bfClGuo8kYuZGOIIFYYs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-rOcQ92s7NWWX88hKbyuuCw-1; Sat, 16 May 2020 00:07:20 -0400
X-MC-Unique: rOcQ92s7NWWX88hKbyuuCw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D60BC80B713;
        Sat, 16 May 2020 04:07:16 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE1065C1B0;
        Sat, 16 May 2020 04:07:05 +0000 (UTC)
Date:   Sat, 16 May 2020 00:07:02 -0400
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
        linux-kernel@vger.kernel.org, Rasesh Mody <rmody@marvell.com>,
        Sudarsana Kalluru <skalluru@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com
Subject: Re: [PATCH v2 05/15] bna: use new module_firmware_crashed()
Message-ID: <20200516040702.GE3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-6-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-6-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:36PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Rasesh Mody <rmody@marvell.com>
> Cc: Sudarsana Kalluru <skalluru@marvell.com>
> Cc: GR-Linux-NIC-Dev@marvell.com
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/brocade/bna/bfa_ioc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/brocade/bna/bfa_ioc.c b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
> index e17bfc87da90..b3f44a912574 100644
> --- a/drivers/net/ethernet/brocade/bna/bfa_ioc.c
> +++ b/drivers/net/ethernet/brocade/bna/bfa_ioc.c
> @@ -927,6 +927,7 @@ bfa_iocpf_sm_disabled(struct bfa_iocpf *iocpf, enum iocpf_event event)
>  static void
>  bfa_iocpf_sm_initfail_sync_entry(struct bfa_iocpf *iocpf)
>  {
> +	module_firmware_crashed();
>  	bfa_nw_ioc_debug_save_ftrc(iocpf->ioc);
>  	bfa_ioc_hw_sem_get(iocpf->ioc);
>  }
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

