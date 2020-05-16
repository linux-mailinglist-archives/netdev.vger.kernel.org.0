Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D81A91D5E79
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgEPEKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:10:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38205 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725853AbgEPEKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:10:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vIxHfO81N+03vuMfHp47HPc/YBphFIdNIRkmQNFD2rA=;
        b=b8UxdUyihUpiZ66oI9CFvhI2L1OR6NMSR6iMd0Tn5SlOZY67uUFrCuzvrOESwBHpSgwWau
        cd/7Q+z0Dlk+V70ePbnX1dSrtV+/MoIQnQECixU7K/3almmDJgkQWOS6OzGLAeLveb8rYZ
        Ljz6W9O7QO76d1XrLwKaYXEB/Hf4gVU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-6heSXt0zPhOn6WGvQjSr9Q-1; Sat, 16 May 2020 00:10:06 -0400
X-MC-Unique: 6heSXt0zPhOn6WGvQjSr9Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64035460;
        Sat, 16 May 2020 04:10:03 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D6EA05C1B0;
        Sat, 16 May 2020 04:09:52 +0000 (UTC)
Date:   Sat, 16 May 2020 00:09:49 -0400
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
        Douglas Miller <dougmill@linux.ibm.com>
Subject: Re: [PATCH v2 08/15] ehea: use new module_firmware_crashed()
Message-ID: <20200516040949.GH3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-9-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-9-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:39PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: Douglas Miller <dougmill@linux.ibm.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/ethernet/ibm/ehea/ehea_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> index 0273fb7a9d01..6ae35067003f 100644
> --- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
> +++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
> @@ -3285,6 +3285,8 @@ static void ehea_crash_handler(void)
>  {
>  	int i;
>  
> +	module_firmware_crashed();
> +
>  	if (ehea_fw_handles.arr)
>  		for (i = 0; i < ehea_fw_handles.num_entries; i++)
>  			ehea_h_free_resource(ehea_fw_handles.arr[i].adh,
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

