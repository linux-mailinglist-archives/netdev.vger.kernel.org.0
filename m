Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 620C75B78B7
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbiIMRu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbiIMRu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:50:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D73583BEA;
        Tue, 13 Sep 2022 09:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NYivW7kGXMdzt9vJTehSUvSt+4w7RPSokt3xYSE0iuE=; b=mNLXbpbGexsGm7Dl3VPIIsQLR9
        st3jg0j5fPR1VAeY+tHcbUE/gIALlzHoryZPRpi6q8xtCrkz3PxJMB4Z5QSaVsppUiJKPKV+2PYHR
        +BRZZutQnZd3T4wWxDrr2hN4jAjDgOewapVfbkFIdGZZfJXc8bWn2aAsWS2QwIrDS33hGZYXeKP4F
        82VBugtGPqAOqPwk/PiCjsMkMPkQ9+adpF6Hw3b+3kbppxAUQBVZwMARpeZL5Agud/X5NVF05mbY3
        Es7KG5sfg3k8T5pQ1AuMqtFxpAty+WU4r9CXPK9+SUfHlxfjrlWSzzTcwFeYYXPRPGFx9a8xhD0y+
        yxZ9MM4A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:34296)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oY95n-0003IX-FU; Tue, 13 Sep 2022 17:48:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oY95m-0000pK-3i; Tue, 13 Sep 2022 17:48:58 +0100
Date:   Tue, 13 Sep 2022 17:48:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        stable <stable@kernel.org>
Subject: Re: [PATCH 5.19 005/192] net: mvpp2: debugfs: fix memory leak when
 using debugfs_lookup()
Message-ID: <YyC0eveBK8UzeIdI@shell.armlinux.org.uk>
References: <20220913140410.043243217@linuxfoundation.org>
 <20220913140410.277221532@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140410.277221532@linuxfoundation.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 13, 2022 at 04:01:51PM +0200, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> commit fe2c9c61f668cde28dac2b188028c5299cedcc1e upstream.
> 
> When calling debugfs_lookup() the result must have dput() called on it,
> otherwise the memory will leak over time.  Fix this up to be much
> simpler logic and only create the root debugfs directory once when the
> driver is first accessed.  That resolves the memory leak and makes
> things more obvious as to what the intent is.
> 
> Cc: Marcin Wojtas <mw@semihalf.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Cc: stable <stable@kernel.org>
> Fixes: 21da57a23125 ("net: mvpp2: add a debugfs interface for the Header Parser")
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_debugfs.c
> @@ -700,10 +700,10 @@ void mvpp2_dbgfs_cleanup(struct mvpp2 *p
>  
>  void mvpp2_dbgfs_init(struct mvpp2 *priv, const char *name)
>  {
> -	struct dentry *mvpp2_dir, *mvpp2_root;
> +	static struct dentry *mvpp2_root;
> +	struct dentry *mvpp2_dir;
>  	int ret, i;
>  
> -	mvpp2_root = debugfs_lookup(MVPP2_DRIVER_NAME, NULL);
>  	if (!mvpp2_root)
>  		mvpp2_root = debugfs_create_dir(MVPP2_DRIVER_NAME, NULL);

This looks broken to me.

What happens if this is built as a module, and the module is loaded,
binds (and creates the directory), then is removed, and then re-
inserted?  Nothing removes the old directory, so doesn't
debugfs_create_dir() fail, resulting in subsequent failure to add
any subsequent debugfs entries?

I don't think this patch should be backported to stable trees until
this point is addressed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
