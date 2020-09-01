Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62413258BA9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 11:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgIAJeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 05:34:16 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:26528 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726167AbgIAJeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 05:34:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1598952854; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=5ev5CbyXt+DzMyxbawpgmMJHFPkqjEdsYxGp0U0ejh4=;
 b=wAcmxom8djm1Ya5C9tWdQ7sdl2OX03jJHsoMxd7at+zt1BSsHGXxBu+urXxIUvjhSFtJmNtP
 rwGqoqgwji3sSEd7V3kGKB1g+etOdIK+6m2FEHTZqTZA6TWqIL6WdCckSC3r3EHhgQ5XCWSQ
 WeNO5q3AkwkPEDzvpj98O3P9Mn8=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 5f4e158c4ba82a82fd8522bc (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 01 Sep 2020 09:34:04
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 47364C433CB; Tue,  1 Sep 2020 09:34:04 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12E10C433CA;
        Tue,  1 Sep 2020 09:34:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 12E10C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: p54: avoid accessing the data mapped to streaming DMA
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200802132949.26788-1-baijiaju@tsinghua.edu.cn>
References: <20200802132949.26788-1-baijiaju@tsinghua.edu.cn>
To:     Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Cc:     chunkeey@googlemail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200901093404.47364C433CB@smtp.codeaurora.org>
Date:   Tue,  1 Sep 2020 09:34:04 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju@tsinghua.edu.cn> wrote:

> In p54p_tx(), skb->data is mapped to streaming DMA on line 337:
>   mapping = pci_map_single(..., skb->data, ...);
> 
> Then skb->data is accessed on line 349:
>   desc->device_addr = ((struct p54_hdr *)skb->data)->req_id;
> 
> This access may cause data inconsistency between CPU cache and hardware.
> 
> To fix this problem, ((struct p54_hdr *)skb->data)->req_id is stored in
> a local variable before DMA mapping, and then the driver accesses this
> local variable instead of skb->data.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

478762855b5a p54: avoid accessing the data mapped to streaming DMA

-- 
https://patchwork.kernel.org/patch/11696391/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

