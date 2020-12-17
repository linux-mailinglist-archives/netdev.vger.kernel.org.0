Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30E32DD53F
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 17:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgLQQ3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 11:29:04 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:22396 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgLQQ3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 11:29:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608222520; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=wqAa7MT3zFP0xLdtRumGFpC0UDBG0GZ5SyJfKIcwDoU=; b=LxtldRppDGKA0VrkKRpE9fuwhb7Fn/KJ9Vgq+YiUqDgMRJmBZeDmIVOLtUMyf7Sxn6FC+nIb
 J37y+o4yRTQXdSfcrswXNVo4t1YSAFxNt2dDbk8tF/jYry8WmVME09F6l73CwXmAj3lJRdTq
 lO72uf70C0O4cdAB6fkfKPRMnFc=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fdb871c253011a4b80b296d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 17 Dec 2020 16:28:12
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 65459C43462; Thu, 17 Dec 2020 16:28:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3532C433C6;
        Thu, 17 Dec 2020 16:28:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3532C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "\<netdev\@vger.kernel.org\>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] mwifiex: Fix possible buffer overflows in mwifiex_config_scan
References: <20201208150951.35866-1-ruc_zhangxiaohui@163.com>
        <CA+ASDXPVu5S0Vm0aOcyqLN090u3BwA_nV358YwkpXuU223Ug9g@mail.gmail.com>
Date:   Thu, 17 Dec 2020 18:28:05 +0200
In-Reply-To: <CA+ASDXPVu5S0Vm0aOcyqLN090u3BwA_nV358YwkpXuU223Ug9g@mail.gmail.com>
        (Brian Norris's message of "Tue, 8 Dec 2020 11:12:00 -0800")
Message-ID: <87v9d0s8h6.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Tue, Dec 8, 2020 at 7:14 AM Xiaohui Zhang <ruc_zhangxiaohui@163.com> wrote:
>>
>> From: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>>
>> mwifiex_config_scan() calls memcpy() without checking
>> the destination size may trigger a buffer overflower,
>> which a local user could use to cause denial of service
>> or the execution of arbitrary code.
>> Fix it by putting the length check before calling memcpy().
>
> ^^ That's not really what you're doing any more, for the record. But
> then, describing "what" is not really the point of a commit message
> (that's what the code is for), so maybe that's not that important.
>
>> Signed-off-by: Zhang Xiaohui <ruc_zhangxiaohui@163.com>
>> ---
>>  drivers/net/wireless/marvell/mwifiex/scan.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
>> index c2a685f63..34293fd80 100644
>> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
>> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
>> @@ -931,7 +931,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
>>                                 wildcard_ssid_tlv->max_ssid_length = 0xfe;
>>
>>                         memcpy(wildcard_ssid_tlv->ssid,
>> -                              user_scan_in->ssid_list[i].ssid, ssid_len);
>> +                              user_scan_in->ssid_list[i].ssid, min_t(u32, ssid_len, 1));
>
> This *looks* like it should be wrong, because SSIDs are clearly longer
> than 1 byte in many cases, but you *are* right that this is what the
> struct is defined as:
>
> struct mwifiex_ie_types_wildcard_ssid_params {
> ...
>     u8 ssid[1];
> };
>
> This feels like something that could use some confirmation from
> NXP/ex-Marvell folks if possible, but if not that, at least some
> creative testing. Did you actually test this patch, to make sure
> non-wildcard scans still work?
>
> Also, even if this is correct, it seems like it would be more correct
> to use 'sizeof(wildcard_ssid_tlv->ssid)' instead of a magic number 1.

Xiaohui, please respond to Brian's comments. If you ignore review
comments I have a hard time trusting your patches.

Also when you submit a new version you should mark it as v2. See more in
the wiki link below.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
