Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8074CBF8B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiCCOIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:08:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbiCCOIk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:08:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A738255229
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:07:52 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id s1so6720181edd.13
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 06:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wMXM1yQV++LJThvQIhi1YVvAF7tseUxoPNzTbioP/2I=;
        b=oQ12F2Wb8T18oRoZp7u6ATWb0bOsuy7Wt8M4sho0aq3peijbgUpBnE24RFMjnAYLX8
         d4aEHuIJGxvI/h9uVJiOb8Y5eiaqJIR2GLMgjXdoBdbWDMaCIxr+yZqZSPapL8CY+FbT
         6j42NrLmLEyeSGsqnoaN9L8E152vJriKC0s5ZsLaxUgqaYl+aJBiFQU6FTipFV4jU9vd
         nbO4rETDLJek7gSwza3dT1zCF1aGp2T+JeY/MCuUgdd8gle/rpj7l368Ld5+922hJQBE
         d0Ufqr6hFTCQS8kXBGa/Jk14XeW/lDAMu8kos5pJ93jlT4nXlW378BObrJC1e0uMnwaR
         zfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wMXM1yQV++LJThvQIhi1YVvAF7tseUxoPNzTbioP/2I=;
        b=N5NbDimsnRXGKG0MQ4MkYSU9roOhXwC2GfwqkDwWrAKzmMX8nvWZJqM0SMVz0t7fDx
         R0+z22w+IhKSypTQ405Jaxmqq14CVEOxqNu9eJkJOuCPNS2/Kfe1y3CPiKiztEtDDJUe
         Jk/1inG+sgf/VIwcMKpBqx8FQmszLNEEjwsUBt4IW07fEQO/WH+ara3aL/5fxHuMdYXr
         biYK8WsPWAl8/u5JM3k0wTmZzi1EIPecXqXRVI6v+mQogqUJvb87VkMcbl0zMtn6XW6i
         izMgNT34snnHzmH11VmzEcVfepn9Ay7hUIZZdUk2G1z1sdolwl7u6kql3jglFSHaANaB
         a9rA==
X-Gm-Message-State: AOAM533l8wP6fs7GbCIWA73fZCGelqam/5VI8xhi/tL2ny5/Iwd64KoZ
        0VD0EGEQ8NijSWD44yI/t2M=
X-Google-Smtp-Source: ABdhPJw9Ixy0QAMYcwa7nHjWXjMDxcRpRpFxvPWMNuUkBF35vr1Jr3rBRiaxkWipZ1jzF+BAVLQDyQ==
X-Received: by 2002:a05:6402:1d52:b0:415:bf04:28b4 with SMTP id dz18-20020a0564021d5200b00415bf0428b4mr7426256edb.83.1646316471076;
        Thu, 03 Mar 2022 06:07:51 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id fx13-20020a170906b74d00b006da9e406786sm325265ejb.189.2022.03.03.06.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 06:07:50 -0800 (PST)
Date:   Thu, 3 Mar 2022 16:07:49 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: unlock the rtnl_mutex when
 dsa_master_setup() fails
Message-ID: <20220303140749.uwirst2t37aog5xb@skbuf>
References: <20220303140608.1817631-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303140608.1817631-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 04:06:08PM +0200, Vladimir Oltean wrote:
> After the blamed commit, dsa_tree_setup_master() may exit without
> calling rtnl_unlock(), fix that.
> 
> Fixes: c146f9bc195a ("net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  net/dsa/dsa2.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
> index 030d5f26715a..4655e81138dd 100644
> --- a/net/dsa/dsa2.c
> +++ b/net/dsa/dsa2.c
> @@ -1072,7 +1072,7 @@ static int dsa_tree_setup_switches(struct dsa_switch_tree *dst)
>  static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
>  {
>  	struct dsa_port *dp;
> -	int err;
> +	int err = 0;
>  
>  	rtnl_lock();
>  
> @@ -1084,7 +1084,7 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
>  
>  			err = dsa_master_setup(master, dp);
>  			if (err)
> -				return err;
> +				break;
>  
>  			/* Replay master state event */
>  			dsa_tree_master_admin_state_change(dst, master, admin_up);
> -- 
> 2.25.1
> 

Bad patch, please discard. Will send v2 right now.
