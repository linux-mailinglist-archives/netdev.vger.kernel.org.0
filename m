Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B92D582529
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232036AbiG0LIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0LIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:08:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B556167C9;
        Wed, 27 Jul 2022 04:08:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA2F8618DE;
        Wed, 27 Jul 2022 11:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A79C433D6;
        Wed, 27 Jul 2022 11:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658920117;
        bh=MpfBFstRnLCcTbNPcgHdxdONCKngkXjqk2XPLKKlK5w=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gU1sgJccFVQAnbthWfVWg92AR7Hibl6jYG1GS8p4gZ+mdEZpJWFw+OlwXAWK2Fr6T
         WPtmsCpcGJoIa1MMAUevkKnPghXzT+LxqPiMqqF+rJy3V6oC/oRotldpf83zTfeJr6
         ixXhSiVV3J5Z/obaUUfxhZQREJy0iCCHydbNKaUGH19IgcFx1LuqJuLC3P3XJ2TCgO
         kln6aKd79e5zZ23TF5/jo1Pz2tdNDFjauGWuBRPfmKBRIwT/Dp26sCCyEOQXTv7UX+
         EGKGKOgiJv/n97W2UAUxk6aUVhfwueXqRykw5fdZqjq362BKQC4Lr0LHxWMOP232Yf
         a5Azq04A5GB/g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     loic.poulain@linaro.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/4] wcn36xx: Add debugfs entry to read firmware feature strings
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org>
        <20220719143302.2071223-5-bryan.odonoghue@linaro.org>
        <87k07yq230.fsf@kernel.org>
        <582e56e7-87d1-e6b3-ac7a-00fe07a10a14@linaro.org>
Date:   Wed, 27 Jul 2022 14:08:30 +0300
In-Reply-To: <582e56e7-87d1-e6b3-ac7a-00fe07a10a14@linaro.org> (Bryan
        O'Donoghue's message of "Wed, 27 Jul 2022 11:41:48 +0100")
Message-ID: <877d3yq0cx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bryan O'Donoghue <bryan.odonoghue@linaro.org> writes:

> On 27/07/2022 11:31, Kalle Valo wrote:
>> Bryan O'Donoghue <bryan.odonoghue@linaro.org> writes:
>
>>> +static ssize_t read_file_firmware_feature_caps(struct file *file,
>>> +					       char __user *user_buf,
>>> +					       size_t count, loff_t *ppos)
>>> +{
>>> +	struct wcn36xx *wcn = file->private_data;
>>> +	unsigned long page = get_zeroed_page(GFP_KERNEL);
>>> +	char *p = (char *)page;
>>> +	int i;
>>> +	int ret;
>>> +
>>> +	if (!p)
>>> +		return -ENOMEM;
>>> +
>>> +	mutex_lock(&wcn->hal_mutex);
>>> +	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
>>> +		if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
>>> +			p += sprintf(p, "%s\n",
>>> +				     wcn36xx_firmware_get_cap_name(i));
>>> +		}
>>> +	}
>>> +	mutex_unlock(&wcn->hal_mutex);
>>> +
>>> +	ret = simple_read_from_buffer(user_buf, count, ppos, (char *)page,
>>> +				      (unsigned long)p - page);
>>> +
>>> +	free_page(page);
>>> +	return ret;
>>> +}
>>
>> Why not use the normal use kzalloc() and kfree()? That way you would not
>> need a separate page variable. What's the benefit from
>> get_zeroed_page()?
>
>
> TBH I did a copy/paste here from another driver... I forget which
>>
>> Also I don't see any checks for a memory allocation failure.
>>
>
> its there
>
> char *p = (char*) page;
>
> if (!p)
>     return -ENOMEM;

Ah, it's pretty evil to have the error handling so far away from the
actual call :)

> I can V2 this for kzalloc and kfree if you prefer though

Yes, please do that. We should use standard infrastructure as much as
possible.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
