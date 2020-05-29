Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2341E8528
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 19:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbgE2RjP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 13:39:15 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:19157 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbgE2RjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 13:39:14 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1590773951; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=n5Q3O7Qj1s+IMMzJhVxucgSmGDGOFWJ8QL4ROWr7YZw=;
 b=V0Okq1jvjQMVxGfBUp3nVvOu3C72SSMcrLZQ9t0uWw7u3+F2MqtZCUzvUbRkUsh8LVRj+ZHt
 Le9Qh+IDf+cf3RBuu8gxoqWFwNcVYsseON2MxKdjBXoAlZC3w4XoKYj8bNu+X/1xhXXdDnsA
 ZTmjbjqyRPMNaFx+yq4QeMEMkPA=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 5ed148a437a454afcb4b1c21 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 29 May 2020 17:38:44
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2FF0AC433A0; Fri, 29 May 2020 17:38:44 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E58B6C433C6;
        Fri, 29 May 2020 17:38:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E58B6C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: fix runtime pm imbalance in wlcore_irq_locked
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200522044906.29564-1-dinghao.liu@zju.edu.cn>
References: <20200522044906.29564-1-dinghao.liu@zju.edu.cn>
To:     Dinghao Liu <dinghao.liu@zju.edu.cn>
Cc:     dinghao.liu@zju.edu.cn, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>, Guy Mishol <guym@ti.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200529173844.2FF0AC433A0@smtp.codeaurora.org>
Date:   Fri, 29 May 2020 17:38:44 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dinghao Liu <dinghao.liu@zju.edu.cn> wrote:

> When wlcore_fw_status() returns an error code, a pairing
> runtime PM usage counter decrement is needed to keep the
> counter balanced. It's the same for all error paths after
> wlcore_fw_status().
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

da74b6933b3b wlcore: fix runtime pm imbalance in wlcore_irq_locked

-- 
https://patchwork.kernel.org/patch/11564675/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

