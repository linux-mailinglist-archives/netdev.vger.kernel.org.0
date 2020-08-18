Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F150248566
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgHRMxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:53:19 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:10162 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726729AbgHRMxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 08:53:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597755198; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=UshVlRQX3jZ8s1xPGct9LtJcj6s2/gfPz2Tpohm05y4=;
 b=p1DTfcqEc31oJYLNg0egbBpuDwEeA/dE9rrqqgMwoYleqJMkE+BmmMQebJUn1kcraeTYRN5x
 KSA5rNg0exyF/dilAw+aXCDUQpbkj2J8eH2m4CnremPJI6px8yj5+qj5fBnV/8mYcDs4XJHj
 NeQArQDXEC70iz1RbwJDBg1PcwA=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f3bcf2eba4c2cd367c98967 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 Aug 2020 12:53:02
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5F7B7C433A1; Tue, 18 Aug 2020 12:53:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08674C433CA;
        Tue, 18 Aug 2020 12:52:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08674C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rndis_wlan: tighten check of rndis_query_oid return
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200811140219.8412-1-trix@redhat.com>
References: <20200811140219.8412-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     jussi.kivilinna@iki.fi, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200818125301.5F7B7C433A1@smtp.codeaurora.org>
Date:   Tue, 18 Aug 2020 12:53:01 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis reports this problem
> 
> rndis_wlan.c:3147:25: warning: Assigned value is garbage or undefined
>                 wiphy->max_num_pmkids = le32_to_cpu(caps.num_pmkids);
>                                       ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The setting of caps happens here, with a call to rndis_query_oid()
> 
> 	retval = rndis_query_oid(usbdev,
> 	if (retval >= 0) {
> 
> Reviewing rndis_query_oid() shows that on success 0 is returned,
> failure is otherwise.  So the retval check is not tight enough.
> So tighten the retval check.  Similar problem in
> rndis_wlan_get_caps().
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

094dd0d73062 rndis_wlan: tighten check of rndis_query_oid return

-- 
https://patchwork.kernel.org/patch/11709263/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

