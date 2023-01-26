Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9FD67C92C
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 11:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236815AbjAZKwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 05:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbjAZKwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 05:52:33 -0500
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BAFE6D343;
        Thu, 26 Jan 2023 02:52:14 -0800 (PST)
Received: by mail-wm1-f43.google.com with SMTP id d4-20020a05600c3ac400b003db1de2aef0so846713wms.2;
        Thu, 26 Jan 2023 02:52:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to:subject:cc
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IOSPX47jGZqGQas4IbYM6GOz6IDMCj2ICl08OpxNcuY=;
        b=fcQqr1yT+cMNzKLFD1IwdrECf/Wwq9yp1Z2+93zt4ndeBUrqUoi5gXkooJeBvilhlk
         LD1No3dosBKl6XHAVnpaZiP+xTPDnyMSg4iZILCPu7SDVQtetNWL2HZsbDmruurhei9a
         yomjvdvT/WK2hYrrNpldxBCUJsGSp96wag2+NNrsRMjpXAQS7xnYhn60QtK1/6U3mRSs
         hkDPWvB9Y0sVBEqciwjLoSwZwwRA2BCNJFMHfCJSEvwhO98lgAnOwPanCMkNgy0ufCU6
         OrwJZPk0DHLOysyyqjCKvrw0cicfpiurjv/RDs7u1Bk8QSVD7P32+yjnOnEBAWJ+3aC2
         WCjA==
X-Gm-Message-State: AFqh2kopG9ktGRd9qQmy4VR8hFkgNWUwHN/sou/MozCRz3nRhBPPilCm
        CWn2By+rqBtcAbrMH6THQF0=
X-Google-Smtp-Source: AMrXdXuQ3tJV9SQC8HYae0YTCAVV5NMk5ICiMvhhsjGRNl4D9dYEbb15NxbHR6rhwnY/LTfNP0Waww==
X-Received: by 2002:a05:600c:1695:b0:3d3:4ae6:a71b with SMTP id k21-20020a05600c169500b003d34ae6a71bmr33332402wmn.2.1674730332690;
        Thu, 26 Jan 2023 02:52:12 -0800 (PST)
Received: from ?IPV6:2620:10d:c0c3:1136:1486:5f6c:3f1:4b78? ([2620:10d:c092:400::5:b2d7])
        by smtp.gmail.com with ESMTPSA id w16-20020a05600c099000b003daf681d05dsm1123426wmp.26.2023.01.26.02.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 02:52:12 -0800 (PST)
Message-ID: <4eaff461-47d1-cb9e-b24f-3699a77c3a3d@debian.org>
Date:   Thu, 26 Jan 2023 10:52:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Cc:     leit@meta.com, "leit@fb.com" <leit@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael van der Westhuizen <rmikey@meta.com>
Subject: Re: [PATCH v3] netpoll: Remove 4s sleep during carrier detection
To:     David Laight <David.Laight@ACULAB.COM>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20230125185230.3574681-1-leitao@debian.org>
 <6d13242627e84bde8129e75b6324d905@AcuMS.aculab.com>
From:   Breno Leitao <leitao@debian.org>
In-Reply-To: <6d13242627e84bde8129e75b6324d905@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 09:04, David Laight wrote:

>> This patch removes the msleep(4s) during netpoll_setup() if the carrier
>> appears instantly.
>>
>> Here are some scenarios where this workaround is counter-productive in
>> modern ages:
>>
>> Servers which have BMC communicating over NC-SI via the same NIC as gets
>> used for netconsole. BMC will keep the PHY up, hence the carrier
>> appearing instantly.
>>
>> The link is fibre, SERDES getting sync could happen within 0.1Hz, and
>> the carrier also appears instantly.
>>
>> Other than that, if a driver is reporting instant carrier and then
>> losing it, this is probably a driver bug.
> 
> I can't help feeling that this will break something.

If we see breakages after this patch, then we can identify broken 
drivers, and fix the driver itself.

On the other side, if we keep this workaround, we are penalizing the 
boot of every modern machine in 4s, just because we might have some 
broken driver somewhere.
