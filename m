Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3535F4D3BFF
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbiCIVXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234273AbiCIVXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:23:11 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 479C89D07F;
        Wed,  9 Mar 2022 13:22:12 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id q5so5031181ljb.11;
        Wed, 09 Mar 2022 13:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=VLgjqBH7y19p60K4Q2Ak7wtKmRZ855mtbsvRlPCnkqo=;
        b=JV7uq62mN7i7UY+NhyIwrofK7K7yFAIp5nBtQTM4ofMVYrsQ5p3JtLKfsksnYMy5i0
         +G2KQlWUZ408FTElUX6qI3mVTxva7PfFjrY87KL6FXrDUyjFoT4bW2eiR0zlWTMQgwbB
         us0F+bMEG3/iDEkQu+CMMm+oaXH8g+hwMy8zrrb96nDIEPNwYHvyhrfZV5KTRxGNFNrz
         MquuR+V7GmpvpR4peeqIUozmbtVEvmQZyHqPQMlp2NTNDf9vz/9687bzI327w9J9TG2J
         MxqI3JLktNaXMaKSa+LZpABInarWyXgEGEGC8B8UQ/co5gqWFwUDgxyCT+C73btA6Ek0
         aA0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=VLgjqBH7y19p60K4Q2Ak7wtKmRZ855mtbsvRlPCnkqo=;
        b=O+7pNEfCyCtUKxpmW55a+e2iyWrDLzka5sK44gsFpTe6VhST51IUgZzsZt6sfo1tdS
         NfcqVLjXAlY+L1Oc8mMfCPBL5y0Cl1wWX4QowcRbCEVRv2N4HTmmOW0TCo7jCtumt9gA
         cQeB++MkrujnuDwSNufO/RK2D3yWY7oVkv5GeAprUoIqdTfUPqztjblgluEfqWK9HPi2
         /SzWif+ZZYR5ar/FceYdBPxV5JX3aaw1AwEHw5UPnPAL75/Pe0KV0jBFCLhrHqxIcWNT
         NbxIJjpQovW6V1crMjtuIecgKUDTP44HFY4DwFL0g1Az8Bnq/CUqyfHDIw82/64ADMd/
         BAUQ==
X-Gm-Message-State: AOAM531xqg3/RCbDG7DwUowMAhLQ9azK6qAASjX32XbhgvDGWPHqNmTi
        CZWUJbzP788bhcVID91wru9vJ8I2siQ=
X-Google-Smtp-Source: ABdhPJwZG6GbW1AJfUAfYnSZnqYhCOE/OvJ7F6ZhFw538NDlqCRw//Jr6J9eBxJKOfQD0RBttEf0LQ==
X-Received: by 2002:a2e:3e15:0:b0:247:d94b:c004 with SMTP id l21-20020a2e3e15000000b00247d94bc004mr954489lja.428.1646860930274;
        Wed, 09 Mar 2022 13:22:10 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id bq30-20020a056512151e00b0044313dc8e74sm587455lfb.197.2022.03.09.13.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 13:22:09 -0800 (PST)
Message-ID: <4078dca8-b5d7-7f84-5605-2f5a98563137@gmail.com>
Date:   Thu, 10 Mar 2022 00:22:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] NFC: port100: fix use-after-free in port100_send_complete
Content-Language: en-US
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
References: <20220308185007.6987-1-paskripkin@gmail.com>
 <cbdd5e41-7538-6d8f-344a-54a816c6d511@canonical.com>
 <b46bfa75-2c87-61d9-c0fc-33efb2678f27@gmail.com>
In-Reply-To: <b46bfa75-2c87-61d9-c0fc-33efb2678f27@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 21:27, Pavel Skripkin wrote:
> Hi Krzysztof,
> 
> On 3/9/22 12:52, Krzysztof Kozlowski wrote:
>> 
>> 
>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> 
>> Thanks, this looks good. I think I saw similar patterns also in other
>> drivers, e.g. pn533. I will check it later, but if you have spare time,
>> feel free to investigate.
>> 
>> Similar cases (unresolved):
>> https://syzkaller.appspot.com/bug?extid=1dc8b460d6d48d7ef9ca

This one is crazy :) No logs from driver at all. Even can't find where 
probe failure comes from (or even is there any failures...)

>> https://syzkaller.appspot.com/bug?extid=abd2e0dafb481b621869

Looks like this patch fixes it.

>> https://syzkaller.appspot.com/bug?extid=dbec6695a6565a9c6bc0
>> 

This one is already fixed. Fix bisection is bogus, but this bug is not 
reproducible anymore.



With regards,
Pavel Skripkin
