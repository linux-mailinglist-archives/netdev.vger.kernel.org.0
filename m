Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35971D5E7D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgEPEKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:10:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55944 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgEPEKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3tmLpZ8CvWIjnKIMwWMeNMlLXGs5w+dOh2/iHoJ1qjI=;
        b=IKd6YIB9EQ1E6t17uS7Ax2b8viDpCquek3w1k4gJVAfymWIWYP/vxLv5Q+xKJmeym2p5gR
        j1QS97ShezcYe34RobRWg2JunZrAxGTBxb18suGL+PuERCBm+tuhCJsXeJkm29jqAg9veH
        659AfIt4/AflAtVsZoM6U5cjRE/z9PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-ChYwfd3SOq-j5sDGwOCCcw-1; Sat, 16 May 2020 00:10:39 -0400
X-MC-Unique: ChYwfd3SOq-j5sDGwOCCcw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B09F1800D42;
        Sat, 16 May 2020 04:10:36 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7E28A100239A;
        Sat, 16 May 2020 04:10:25 +0000 (UTC)
Date:   Sat, 16 May 2020 00:10:21 -0400
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
        GR-everest-linux-l2@marvell.com,
        Igor Russkikh <irusskikh@marvell.com>
Subject: Re: [PATCH v2 09/15] qed: use new module_firmware_crashed()
Message-ID: <20200516041021.GI3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-10-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-10-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:40PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> Reviewed-by: Igor Russkikh <irusskikh@marvell.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_mcp.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> index 9624616806e7..aea200d465ef 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> @@ -566,6 +566,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
>  		DP_NOTICE(p_hwfn,
>  			  "The MFW failed to respond to command 0x%08x [param 0x%08x].\n",
>  			  p_mb_params->cmd, p_mb_params->param);
> +		module_firmware_crashed();
>  		qed_mcp_print_cpu_info(p_hwfn, p_ptt);
>  
>  		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

