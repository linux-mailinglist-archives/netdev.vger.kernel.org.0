Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEB826DF3C
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 17:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgIQPLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 11:11:14 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:13871 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727901AbgIQPKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 11:10:43 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 11:10:41 EDT
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600355405; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=QuOovRlqqQ4imLlh/3CVPxCw7KlkSP4GZEYANQVrcVc=; b=b92Ux5UDEwLUwIudLlf50Z1QtcY09DpRbkEUGl6RxEpn1wTB2gbMDeYGhJnkSYO7mMtJqDFn
 zWCIlwiI5rxsIOKXcEnketaKw++AzdFx8jsreEpbPiFR9JZJq89Uel8O9POKmu61738w5Gou
 ocRSxLx7WtIYahzPNpUw3lncEk4=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f637af60915d30357e88d48 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 17 Sep 2020 15:04:22
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D40F4C433CA; Thu, 17 Sep 2020 15:04:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA653C433F1;
        Thu, 17 Sep 2020 15:04:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA653C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Carl Huang <cjhuang@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath11k@lists.infradead.org,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: ath11k: initialize wmi config based on hw_params
References: <480d8984-a5fb-be1b-b553-e01609601059@canonical.com>
Date:   Thu, 17 Sep 2020 18:04:16 +0300
In-Reply-To: <480d8984-a5fb-be1b-b553-e01609601059@canonical.com> (Colin Ian
        King's message of "Wed, 19 Aug 2020 12:05:17 +0100")
Message-ID: <875z8ch2bz.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.king@canonical.com> writes:

> Hi,
>
> static analysis with Coverity has detected a duplicated assignment issue
> with the following commit:
>
> commit 2d4bcbed5b7d53e19fc158885e7340b464b64507
> Author: Carl Huang <cjhuang@codeaurora.org>
> Date:   Mon Aug 17 13:31:51 2020 +0300
>
>     ath11k: initialize wmi config based on hw_params
>
> The analysis is as follows:
>
>
>  74        config->beacon_tx_offload_max_vdev = 0x2;
>  75        config->num_multicast_filter_entries = 0x20;
>  76        config->num_wow_filters = 0x16;
>
> Unused value (UNUSED_VALUE)
> assigned_value: Assigning value 1U to config->num_keep_alive_pattern
> here, but that stored value is overwritten before it can be used.
>  77        config->num_keep_alive_pattern = 0x1;
>
> value_overwrite: Overwriting previous write to
> config->num_keep_alive_pattern with value 0U.
>
>  78        config->num_keep_alive_pattern = 0;
>
>
> I'm not sure if one of these assignments is redundant, or perhaps one of
> the assignments is meant to be setting a different structure element.

0x1 assignment should be removed, I'll send a patch.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
