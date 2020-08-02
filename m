Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0F823580D
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 17:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgHBPSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 11:18:52 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:31783 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726899AbgHBPSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 11:18:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596381531; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=lF5CK9APGgA84oCW0O2cjEHYiYVBHxTZBI+qtWD5O9Q=;
 b=U38o+KbpvJOA+hYLPTJd+8kADpotYtT7eGyzyvVJ6EWJwtJfP3+m90HeJCvjggEQSbO02Yl5
 iJiGE4VOH//+Wzwy9TW7QA38Z/hT0OBe3kGdVgE9XIYlIl84C/7guM/xc6yaJt44EB3kzQ94
 rOBXPsQemIxpMWcaF1gRoHkIGic=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-east-1.postgun.com with SMTP id
 5f26d949798b102968010183 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 02 Aug 2020 15:18:33
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 65606C433CA; Sun,  2 Aug 2020 15:18:32 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 569C5C433C6;
        Sun,  2 Aug 2020 15:18:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 569C5C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v1] hostap: use generic power management
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200721150547.371763-1-vaibhavgupta40@gmail.com>
References: <20200721150547.371763-1-vaibhavgupta40@gmail.com>
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, Jouni Malinen <j@w1.fi>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200802151832.65606C433CA@smtp.codeaurora.org>
Date:   Sun,  2 Aug 2020 15:18:32 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vaibhav Gupta <vaibhavgupta40@gmail.com> wrote:

> Drivers using legacy power management .suspen()/.resume() callbacks
> have to manage PCI states and device's PM states themselves. They also
> need to take care of standard configuration registers.
> 
> Switch to generic power management framework using a single
> "struct dev_pm_ops" variable to take the unnecessary load from the driver.
> This also avoids the need for the driver to directly call most of the PCI
> helper functions and device power state control functions as through
> the generic framework, PCI Core takes care of the necessary operations,
> and drivers are required to do only device-specific jobs.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

99aaa1aafa5c hostap: use generic power management

-- 
https://patchwork.kernel.org/patch/11675851/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

