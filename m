Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 092D54E7CAD
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiCYTw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiCYTwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:52:16 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F1D17B8AB;
        Fri, 25 Mar 2022 12:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+YSGzMp9SBuqTEcUN1kImZMU6TG8MWr4+adML0IsDwo=; b=NNUVZcwrNcGvZqy+FtCK+vjHK1
        rGuWH6snGdJqekmk4+kkJzT56eR4JXYWoV1Nf3dHY290fUeHpSPOdUuTzo2Q7oIO7jh/jRev7qE9J
        ToiSYUW+8thZXi3GzQlflUF9VcBYHkDAPqmRDkVW1Lz6KME2HQGPqdd1RL3rzVGLVBB4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nXpkn-00CgP5-1I; Fri, 25 Mar 2022 20:37:45 +0100
Date:   Fri, 25 Mar 2022 20:37:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     stas.yakovlev@gmail.com, kvalo@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipw2200: Fix permissions setted by DEVICE_ATTR
Message-ID: <Yj4aCUlGY12VvuI/@lunn.ch>
References: <20220325074141.17446-1-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325074141.17446-1-tangmeng@uniontech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 03:41:41PM +0800, Meng Tang wrote:
> Because xcode_version and rtc only implement the show function
> and do not provide the store function, so ucode_version and rtc
> only need the read permission, not need the write permission more.
> 
> So, remove the write permission from xcode_version and rtc.
> 
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  drivers/net/wireless/intel/ipw2x00/ipw2200.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> index 6830e88c4ed6..fa4f38d54d0a 100644
> --- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> +++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
> @@ -1578,7 +1578,7 @@ static ssize_t show_ucode_version(struct device *d,
>  	return sprintf(buf, "0x%08x\n", tmp);
>  }
>  
> -static DEVICE_ATTR(ucode_version, 0644, show_ucode_version, NULL);
> +static DEVICE_ATTR(ucode_version, 0444, show_ucode_version, NULL);

DEVICE_ATTR_RO() exists to make this more obvious. But it looks like
you would need to rename the show_ucode_version() to
ucode_version_show() in order to use it.

     Andrew
