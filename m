Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059BA6651BA
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 03:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbjAKC0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 21:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbjAKC0M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 21:26:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E19F1168
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 18:26:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A1B5B81A9C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 02:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9B7C433EF;
        Wed, 11 Jan 2023 02:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673403968;
        bh=d5Nwk+cB3rbmhsM5YkZwZ3Z1FTo/sexZC/I5snZnaVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BXkU72AHBTBpZ/+s/BlNuXTEulukVbMCY05hU0PMyZbZab5RGDjwnc/7rzb4R1Tqr
         K0RZlxtHY+lHu/Hq2fd/vHuF6pZdccEQ1swTv5Tv/lnxYBGT3JZWLo8NEPwsEmkgoT
         KKeKFi8dz/SNRq/QJ1BhwzhevPPpsNj9q4GBEB3BRomLKsRB9JdHa2Avp1rR1LFlSQ
         cAz7AZa/px5Orhsgc11mx22qZLf9FbvNR3Cp5D32sP9fxOuXgO4mwUSQHdvCbZ9vSX
         kCJyIuTudms/cJWJfYBCiIccnZf/yHumVlz6ms3Mk3dj4u6IilOiwwGMgGAUDPhzL+
         lnIx6MikP/nEA==
Date:   Tue, 10 Jan 2023 18:26:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: Re: [PATCH net 2/2] ice: Add check for kzalloc
Message-ID: <20230110182607.3a41ab85@kernel.org>
In-Reply-To: <20230109225358.3478060-3-anthony.l.nguyen@intel.com>
References: <20230109225358.3478060-1-anthony.l.nguyen@intel.com>
        <20230109225358.3478060-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Jan 2023 14:53:58 -0800 Tony Nguyen wrote:
> @@ -470,21 +473,23 @@ static struct tty_driver *ice_gnss_create_tty_driver(struct ice_pf *pf)
>  	err = tty_register_driver(tty_driver);
>  	if (err) {
>  		dev_err(dev, "Failed to register TTY driver err=%d\n", err);
> -
> -		for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++) {
> -			tty_port_destroy(pf->gnss_tty_port[i]);
> -			kfree(pf->gnss_tty_port[i]);
> -		}
> -		kfree(ttydrv_name);
> -		tty_driver_kref_put(pf->ice_gnss_tty_driver);
> -
> -		return NULL;
> +		goto err_out;

FTR I think that depending on i == ICE_GNSS_TTY_MINOR_DEVICES
here is fragile. I can merge as is, since the code is technically
correct, but what you should have done is crate a new label, say
err_unreg_all_ports, do:

	goto err_unreg_all_ports;

>  	}
>  
>  	for (i = 0; i < ICE_GNSS_TTY_MINOR_DEVICES; i++)
>  		dev_info(dev, "%s%d registered\n", ttydrv_name, i);
>  
>  	return tty_driver;
> +

And here add:

err_unreg_all_ports:
	i = ICE_GNSS_TTY_MINOR_DEVICES;
> +err_out:
> +	while (i--) {
> +		tty_port_destroy(pf->gnss_tty_port[i]);
> +		kfree(pf->gnss_tty_port[i]);
> +	}
> +	kfree(ttydrv_name);
> +	tty_driver_kref_put(pf->ice_gnss_tty_driver);
> +
> +	return NULL;
