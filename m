Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491EA605483
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiJTAd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJTAd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:33:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BDC199894
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 17:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D4EDB8244C
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 00:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01466C433C1;
        Thu, 20 Oct 2022 00:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666226033;
        bh=3Kr3dk5Rh7V30N8OyYKQlvaWnIyZfroVG+RvqE4eIsM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Osdns0xJ7CHzuyZOymiyKBxG0Wax84+vmAT9PKg/u5pLSyjRKlJuolZE8Ij0s/a+4
         zhjLHUFRlaroWk9Aet1RyHCBS9LXduzaQ2qaZ4wSqo2X0VWHEM4NDLtMwU89dcWw5M
         C/vdz81Ddgszb9ROOJgKo25p/ov+mV/LjlwhDEWcjNGOLT2T3XY6YFodkzTwzx8PMP
         4kK/dg7nimaYrsh3P1DbG+j5du6LHaphDgiojTHGdSzzpK1ifan8E/admV5DvI335N
         XDokCNSSPZgrE6koKvmZtMak07AcGEpNNOlD3wpiUToCAr+XVQ5FXmUcuTd5+UnbHc
         xy4z547+ljElg==
Date:   Wed, 19 Oct 2022 17:33:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shang XiaoJing <shangxiaojing@huawei.com>
Cc:     <bongsu.jeon@samsung.com>, <krzysztof.kozlowski@linaro.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] nfc: virtual_ncidev: Fix memory leak in
 virtual_nci_send()
Message-ID: <20221019173351.4e3a8ab7@kernel.org>
In-Reply-To: <20221018114935.8871-1-shangxiaojing@huawei.com>
References: <20221018114935.8871-1-shangxiaojing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 19:49:35 +0800 Shang XiaoJing wrote:
> --- a/drivers/nfc/virtual_ncidev.c
> +++ b/drivers/nfc/virtual_ncidev.c
> @@ -54,16 +54,19 @@ static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  	mutex_lock(&nci_mutex);
>  	if (state != virtual_ncidev_enabled) {
>  		mutex_unlock(&nci_mutex);
> +		consume_skb(skb);
>  		return 0;
>  	}
>  
>  	if (send_buff) {
>  		mutex_unlock(&nci_mutex);
> +		consume_skb(skb);
>  		return -1;

these two should be kfree_skb() as we're dropping a packet
