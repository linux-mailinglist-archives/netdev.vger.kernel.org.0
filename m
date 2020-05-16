Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B731D5E8F
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 06:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgEPEOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 00:14:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725803AbgEPEOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 00:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589602448;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EuAgvOaqRInTUNhLQNW9x4ROuhA10g3Sfi1G9i+YTz0=;
        b=bLmqVZ2DH/V4fDaZqwsjzk94dKpQ1qQ7VJyrzTzaq5kxYT9AqqX+07ci7cfN5xdIQkEW90
        XnoZvE5ob8cHoY5NvQGJwormy885IkcaXHo1jOtNGJnHVNicKIKLOgMNrinKYAmXoTaYAh
        hH2DPQhR/LMI5jJaq7qBI4oArIZ58tE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-iKzLjf_JMVikURnUgz8A6w-1; Sat, 16 May 2020 00:14:02 -0400
X-MC-Unique: iKzLjf_JMVikURnUgz8A6w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97882835B43;
        Sat, 16 May 2020 04:13:59 +0000 (UTC)
Received: from x1-fbsd (unknown [10.3.128.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1199C3A2;
        Sat, 16 May 2020 04:13:47 +0000 (UTC)
Date:   Sat, 16 May 2020 00:13:44 -0400
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
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>
Subject: Re: [PATCH v2 15/15] mwl8k: use new module_firmware_crashed()
Message-ID: <20200516041344.GO3182@x1-fbsd>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-16-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-16-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 09:28:46PM +0000, Luis Chamberlain wrote:
> This makes use of the new module_firmware_crashed() to help
> annotate when firmware for device drivers crash. When firmware
> crashes devices can sometimes become unresponsive, and recovery
> sometimes requires a driver unload / reload and in the worst cases
> a reboot.
> 
> Using a taint flag allows us to annotate when this happens clearly.
> 
> Cc: linux-wireless@vger.kernel.org
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Ganapathi Bhat <ganapathi.bhat@nxp.com>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/net/wireless/marvell/mwl8k.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
> index 97f23f93f6e7..d609ef1bb879 100644
> --- a/drivers/net/wireless/marvell/mwl8k.c
> +++ b/drivers/net/wireless/marvell/mwl8k.c
> @@ -1551,6 +1551,7 @@ static int mwl8k_tx_wait_empty(struct ieee80211_hw *hw)
>  	 * the firmware has crashed
>  	 */
>  	if (priv->hw_restart_in_progress) {
> +		module_firmware_crashed();
>  		if (priv->hw_restart_owner == current)
>  			return 0;
>  		else
> -- 
> 2.26.2
> 
Acked-by: Rafael Aquini <aquini@redhat.com>

