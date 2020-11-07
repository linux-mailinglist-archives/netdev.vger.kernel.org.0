Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77862AA4BA
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbgKGLhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:37:39 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:12977 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726832AbgKGLhi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:37:38 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604749057; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=j3N3cUP/epqCM8l1NiLYM5eaTMaL1gWjPmUJq6xTRWk=;
 b=AczA2fX7rl7HRkMiO3odv2nDNGN3T2w4rn2tyfBSSpaEpQYykaLeL1m3r5lsoFABpAgSoWBc
 5oj/PUj3GSuUN/Cv9NF9Acbx8aJWT9c/V4dFu8pzUMWcPy9U0OrIKNIqCrjRrbUExYaT9OJV
 daqn1v5yDgoG3uL+XKt2oVoHWgM=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fa687017d4f16f92fc7a66e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:37:37
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5961FC433FE; Sat,  7 Nov 2020 11:37:37 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69B49C433C9;
        Sat,  7 Nov 2020 11:37:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 69B49C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 02/11] net: hostap: fix function cast warning
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201026213040.3889546-2-arnd@kernel.org>
References: <20201026213040.3889546-2-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jouni Malinen <j@w1.fi>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201107113737.5961FC433FE@smtp.codeaurora.org>
Date:   Sat,  7 Nov 2020 11:37:37 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc -Wextra complains about the function type cast:
> 
> drivers/net/wireless/intersil/hostap/hostap_hw.c:3173:48: warning: cast between incompatible function types from ‘void (*)(struct tasklet_struct *)’ to ‘void (*)(long unsigned int)’ [-Wcast-function-type]
> 
> Avoid this by just using the regular tasklet_setup() function instead
> of the incorrect homegrown version.
> 
> Fixes: 7433c9690318 ("intersil: convert tasklets to use new tasklet_setup() API")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

3 patches applied to wireless-drivers-next.git, thanks.

9fdd02aa5988 net: hostap: fix function cast warning
ef41937631bf rtlwifi: fix -Wpointer-sign warning
6ac654697301 rtw88: remove extraneous 'const' qualifier

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20201026213040.3889546-2-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

