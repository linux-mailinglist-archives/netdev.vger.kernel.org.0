Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D9D4607CF
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 18:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346922AbhK1RHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 12:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352769AbhK1RFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 12:05:12 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742E3C06175D
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 09:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=qodTO7vz1VyFH07+6LrHwDalv0kIEJyZxDnwQc5CPTs=;
        t=1638118904; x=1639328504; b=pcA2WfwvtCSbtvLPV0ikqtD37WmhsPYF7Q8Fm6KtJTmpzKD
        zey/KhDwP7arIYKritGXZRrusxosNeRSDbcnlub9ldBbG3ryCQGqdK8OvGZwgZH3tO1XsF8XkR9W6
        DE3tHzna86skvbwS+i0yJYaqgCKzgCXJ+De1HVJAly+2MSOvxnEtNtMT0lIHTtEHGltHmejEWZ4Es
        gPwiko8XlQmv5XAYGdjAuVAmhm+zLdClnzlvJ3yb1clwXIbC+yU019hb9ycVcbkXK4jr1ZXJDd7SV
        BWHknTmNIcZCmdULrUV/ncVboXQ7fZoprLWt9OHACmLvSIFDZJdMQZG/G2IpVrbg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mrNYW-0044hN-7P;
        Sun, 28 Nov 2021 18:01:36 +0100
Message-ID: <ac532d400cd61a0f86ad5b1931df87a83582323c.camel@sipsolutions.net>
Subject: Re: [PATCH RESEND net-next 5/5] net: wwan: core: make debugfs
 optional
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>
Date:   Sun, 28 Nov 2021 18:01:35 +0100
In-Reply-To: <20211128125522.23357-6-ryazanov.s.a@gmail.com>
References: <20211128125522.23357-1-ryazanov.s.a@gmail.com>
         <20211128125522.23357-6-ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-11-28 at 15:55 +0300, Sergey Ryazanov wrote:
> 
> +config WWAN_DEBUGFS
> +	bool "WWAN subsystem common debugfs interface"
> +	depends on DEBUG_FS
> +	help
> +	  Enables common debugfs infrastructure for WWAN devices.
> +
> +	  If unsure, say N.
> 

I wonder if that really should even say "If unsure, say N." because
really, once you have DEBUG_FS enabled, you can expect things to show up
there?

And I'd probably even argue that it should be

	bool "..." if EXPERT
	default y
	depends on DEBUG_FS

so most people aren't even bothered by the question?


>  config WWAN_HWSIM
>  	tristate "Simulated WWAN device"
>  	help
> @@ -83,6 +91,7 @@ config IOSM
>  config IOSM_DEBUGFS
>  	bool "IOSM Debugfs support"
>  	depends on IOSM && DEBUG_FS
> +	select WWAN_DEBUGFS
> 
I guess it's kind of a philosophical question, but perhaps it would make
more sense for that to be "depends on" (and then you can remove &&
DEBUG_FS"), since that way it becomes trivial to disable all of WWAN
debugfs and not have to worry about individual driver settings?


And after that change, I'd probably just make this one "def_bool y"
instead of asking the user.


johannes
