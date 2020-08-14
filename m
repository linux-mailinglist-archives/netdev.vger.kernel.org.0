Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2098B244B95
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 17:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728571AbgHNPFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 11:05:39 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:55623 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728132AbgHNPFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 11:05:36 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597417535; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=7FCVfLxxmii9ov0dCHs81K5wnCBYwV2wRwZYNb84Q9E=;
 b=sSSh9becd6gQ5GM+/StrVG1gOHPhQtFu8rmIdts6/nNUVWvsgZSZ/0jeYRuC36XmD/scGFTd
 KoMQqY4LO4/KsMUQgaEpb3/0FFa+4DUFuU1FcCFOqJ+sm4osL2Rbc7TGICfAvRmWUj/y1BTL
 ZTmOKbH/YCkkz3yFHDHXNRxaPvQ=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5f36a8331e4d3989d476e07b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 15:05:23
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C0936C43391; Fri, 14 Aug 2020 15:05:22 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78CDAC433C9;
        Fri, 14 Aug 2020 15:05:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78CDAC433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 7/7] ath: drop unnecessary list_empty
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1595761112-11003-8-git-send-email-Julia.Lawall@inria.fr>
References: <1595761112-11003-8-git-send-email-Julia.Lawall@inria.fr>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200814150522.C0936C43391@smtp.codeaurora.org>
Date:   Fri, 14 Aug 2020 15:05:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julia Lawall <Julia.Lawall@inria.fr> wrote:

> list_for_each_entry{_safe} is able to handle an empty list.
> The only effect of avoiding the loop is not initializing the
> index variable.
> Drop list_empty tests in cases where these variables are not
> used.
> 
> Note that list_for_each_entry{_safe} is defined in terms of
> list_first_entry, which indicates that it should not be used on an
> empty list.  But in list_for_each_entry{_safe}, the element obtained
> by list_first_entry is not really accessed, only the address of its
> list_head field is compared to the address of the list head, so the
> list_first_entry is safe.
> 
> The semantic patch that makes this change for the list_for_each_entry
> case is as follows: (http://coccinelle.lip6.fr/)
> 
> <smpl>
> @@
> expression x,e;
> statement S;
> identifier i;
> @@
> 
> -if (!(list_empty(x)))
>    list_for_each_entry(i,x,...) S
>  ... when != i
> ? i = e
> </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

18c25b4019ca ath: drop unnecessary list_empty

-- 
https://patchwork.kernel.org/patch/11685677/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

