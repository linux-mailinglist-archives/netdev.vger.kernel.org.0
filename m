Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 756C86C6C29
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 16:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbjCWPTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 11:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232071AbjCWPT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 11:19:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058E425E0D
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679584717;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9JfTMOmWgVFviT3j1h1ZVlXRJuPtZf94XGhzCpT7TZI=;
        b=RvJm2ZH+uaMxtLGD7/vtmT+vJFPZmJC1ZvKTdMyeI4F0dVJvWSBuHGg8UuVUnr1dj2D3PH
        jOOeDRsECh7OXjrtVgfDiMhpvyV91ORJNelpJnSOAODZyshhsr8a6zQSrQZ1TjS1GM89MO
        uA6Gwu6FrxwUByF03yb29jcQd80K7qg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-8kYVuB48OnGHqEQ429sLXw-1; Thu, 23 Mar 2023 11:18:12 -0400
X-MC-Unique: 8kYVuB48OnGHqEQ429sLXw-1
Received: by mail-qk1-f199.google.com with SMTP id x80-20020a376353000000b0074681bc7f42so6408798qkb.8
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:18:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679584685;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JfTMOmWgVFviT3j1h1ZVlXRJuPtZf94XGhzCpT7TZI=;
        b=rCJosr/G0NRBwqZ388QapAAj5jG/sOokeLc1mNOBnaiD42v7iGJrGmySc5NfM9Iu5/
         jjkSGjC0D2JMZ12xJXgDyF+jSmfFP3hB91wHxhyzei2VjHMKcP4shFcz+S/wlgy1Bv6B
         AtG2R2A/EHjYGCoJM2Eu8arJ392vjJUTMct5aS5Pw5ro4hme2eyeXpLx4hidP1+Fxub2
         RZgFI7PQwMu/qQnu9iYgzrnnSiZu0MHVRT0ZX/QxWIgGXCB+6JMQZLG9nv6sFA7ctAE8
         7UMfszLL1fwFWCAMoU4ExG0PpWdG0tM882f5svSMApls/rqTyvOuWHEPYH99yKVnOGZj
         8pTQ==
X-Gm-Message-State: AO0yUKVVGmTTvf89lTkR5AtE868JY2VtPYGQIm4nSOM2jK62uYO89G8/
        u7/lIhVPExtWG1rg3/QMESmhDLHzYpLDmeG4MLFoPiLGuHpIJZhJdwdjN7eZ+HrKPmMEd/3uiWY
        ScHGVooVGuD8vPD8R9Ncv20SU
X-Received: by 2002:ac8:5bcc:0:b0:3e1:65f5:4a85 with SMTP id b12-20020ac85bcc000000b003e165f54a85mr13130751qtb.58.1679584685580;
        Thu, 23 Mar 2023 08:18:05 -0700 (PDT)
X-Google-Smtp-Source: AK7set8LNOQxfUqAJQEgzeCPGIWCE6BE+k4IT7L6mRJOClAlDS0h+wmBxg2TVB0f+9BHgFC2x3KR1g==
X-Received: by 2002:ac8:5bcc:0:b0:3e1:65f5:4a85 with SMTP id b12-20020ac85bcc000000b003e165f54a85mr13130718qtb.58.1679584685365;
        Thu, 23 Mar 2023 08:18:05 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id w8-20020a05620a424800b0073b587194d0sm13656463qko.104.2023.03.23.08.18.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Mar 2023 08:18:04 -0700 (PDT)
Subject: Re: [PATCH] mISDN: remove unused vpm_read_address function
To:     Simon Horman <simon.horman@corigine.com>
Cc:     isdn@linux-pingi.de, nathan@kernel.org, ndesaulniers@google.com,
        kuba@kernel.org, alexanderduyck@fb.com, yangyingliang@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230321120127.1782548-1-trix@redhat.com>
 <ZBsArtzFkgz+05LK@corigine.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <bfc6db20-e094-7fd5-21b5-3d0b81fb494f@redhat.com>
Date:   Thu, 23 Mar 2023 08:18:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <ZBsArtzFkgz+05LK@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/22/23 6:20 AM, Simon Horman wrote:
> On Tue, Mar 21, 2023 at 08:01:27AM -0400, Tom Rix wrote:
>> clang with W=1 reports
>> drivers/isdn/hardware/mISDN/hfcmulti.c:667:1: error: unused function
>>    'vpm_read_address' [-Werror,-Wunused-function]
>> vpm_read_address(struct hfc_multi *c)
>> ^
>> This function is not used, so remove it.
> Yes, agreed.
>
> But with this patch applied, make CC=clang W=1 tells me:
>
>    CALL    scripts/checksyscalls.sh
>    CC [M]  drivers/isdn/hardware/mISDN/hfcmulti.o
> drivers/isdn/hardware/mISDN/hfcmulti.c:643:1: error: unused function 'cpld_read_reg' [-Werror,-Wunused-function]
>
> So perhaps cpld_read_reg should be removed too?

Yes, i will add and respin.

Thanks,

Tom


>

