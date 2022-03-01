Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276434C8B50
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 13:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiCAMPX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 07:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiCAMPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 07:15:23 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780E0289B9;
        Tue,  1 Mar 2022 04:14:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2F84921997;
        Tue,  1 Mar 2022 12:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646136881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGsG5VqKCHUuIY8SnzAR6fRSr7cXp3NkUg17MAp4SVw=;
        b=2ROwDEwRpb08+/b9EEXsm/XHFq3Z5IVfmKml7MKYx4zzVilhbZTwYvOo5duUVaYhrF+iJ2
        t3oBunF76JBRz++W2KquDkxo2OljGO2dt1mmQcD2HChGS9YspCqPH81XOfMUtBKLlEVhDE
        qBAU7iivYIljxrjktooL/59jCBrBPPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646136881;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jGsG5VqKCHUuIY8SnzAR6fRSr7cXp3NkUg17MAp4SVw=;
        b=goXAgbaCkiSzxcdqs5wNKrSw4/CDjs3leAG8PcptQbeW9vDf7uoMNnwYVCRgiEaIVUs7Yz
        1C9D1ay6H0w/wEAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B4CAD13B56;
        Tue,  1 Mar 2022 12:14:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id H/TyJzAOHmLsKwAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Tue, 01 Mar 2022 12:14:40 +0000
Message-ID: <a87a691a-62c2-5b42-3be8-ee1161281ad8@suse.de>
Date:   Tue, 1 Mar 2022 15:14:16 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] dpaa2 ethernet switch driver: Fix memory leak in
 dpaa2_switch_acl_entry_add()
Content-Language: ru
To:     Q1IQ <fufuyqqqqqq@gmail.com>, ioana.ciornei@nxp.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lyz_cs@pku.edu.cn
References: <20220301093444.66863-1-fufuyqqqqqq@gmail.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
In-Reply-To: <20220301093444.66863-1-fufuyqqqqqq@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/1/22 12:34, Q1IQ пишет:
> [why]
> The error handling branch did not properly free the memory of cmd_buf
> before return, which would cause memory leak.
> 
> [how]
> Fix this by adding kfree to the error handling branch.
> 
> Signed-off-by: Q1IQ <fufuyqqqqqq@gmail.com>

You should use your real name and please add Fixes tag

> ---
>   drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> index cacd454ac696..4d07aee07f4c 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> @@ -132,6 +132,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
>   						 DMA_TO_DEVICE);
>   	if (unlikely(dma_mapping_error(dev, acl_entry_cfg->key_iova))) {
>   		dev_err(dev, "DMA mapping failed\n");
> +		kfree(cmd_buff);
>   		return -EFAULT;
>   	}
>   
> @@ -142,6 +143,7 @@ int dpaa2_switch_acl_entry_add(struct dpaa2_switch_filter_block *filter_block,
>   			 DMA_TO_DEVICE);
>   	if (err) {
>   		dev_err(dev, "dpsw_acl_add_entry() failed %d\n", err);
> +		kfree(cmd_buff);
>   		return err;
>   	}
>   
