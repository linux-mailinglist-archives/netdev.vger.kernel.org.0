Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5940764DCEF
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 15:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLOOhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 09:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiLOOhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 09:37:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D282E683
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 06:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671114994;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LrlmfDhbKiauy9xEo45UHyZTDkdDc8udBCCj9dDmlf8=;
        b=WLis2T9cBi/CxRB1u+mGkXfgrMXWwjfETCUXfEoYacU0q4sATtpzesqtPkdX4aSCWZt2x3
        7GdrUYbIC2lPL/UGX1ggaSNIweR1S05gM9g84q7/682CR8ZltA6AFlgOjWLY2vGob05cSp
        hurd4x7mYqDfAFBCVLTA+zjE7+ihtC4=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-369-UJorhu-GM2GzXHiROG2J2g-1; Thu, 15 Dec 2022 09:36:32 -0500
X-MC-Unique: UJorhu-GM2GzXHiROG2J2g-1
Received: by mail-ed1-f71.google.com with SMTP id y20-20020a056402271400b0046c9a6ec30fso11933017edd.14
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 06:36:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LrlmfDhbKiauy9xEo45UHyZTDkdDc8udBCCj9dDmlf8=;
        b=52DAEhJG8v8YTE3wgfc6UTQs2oyjwaxwk1sRJBQUKHimzFOiCeMofGlJRsXfHglOON
         6FvzZawCuPhedPvCzIGLTUPqQm8htDFkXuN87MM2ab+CdT5FmybSdLMS6n78gOfcbyW0
         nsG/PoJVmpTH/yk7pgONzMHVxsCX5tsWrTKcpX3EEfrbqUA0marH0Wzx7XyRBbtSSxZ5
         y43xE8BERGe3pNlkkho4ItcQnbe6PP6Us2qLLLX0q5Ps6YuDwkAK+VaMMw7AjTPUescL
         QgFfJxt4sH9tWJCxkTAa9gWuQU6PabpHxA0qFINh7JEsvzZ6SDaMWIcluT9W1XBy5yqC
         yRdQ==
X-Gm-Message-State: ANoB5pmCFek4BQ49vM2pNNzsaJLnF/bY/itTc1JDKyP9iQsquzhJbmce
        yFff0JtwSOQJtpwZgtGhXPxTCx2QD6NJkGbGQENLTUFfla1eLiFTet6/jGuAEpTr8UVkX1BDyAp
        iucNLCB5ZOYhy8RbP
X-Received: by 2002:a50:ff0a:0:b0:46b:1231:3858 with SMTP id a10-20020a50ff0a000000b0046b12313858mr22746974edu.40.1671114991591;
        Thu, 15 Dec 2022 06:36:31 -0800 (PST)
X-Google-Smtp-Source: AA0mqf515ZI92vewamRB9Zd7kFMmOy3EYq/IZv9mDMOjzghe3RU2Q/hX4jqzpSIQhCbafRNVCccS8g==
X-Received: by 2002:a50:ff0a:0:b0:46b:1231:3858 with SMTP id a10-20020a50ff0a000000b0046b12313858mr22746956edu.40.1671114991315;
        Thu, 15 Dec 2022 06:36:31 -0800 (PST)
Received: from [10.39.192.185] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id i7-20020aa7c707000000b0047466e46662sm279577edq.39.2022.12.15.06.36.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Dec 2022 06:36:30 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        dev@openvswitch.org, aconole@redhat.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v2] openvswitch: Fix flow lookup to use unmasked key
Date:   Thu, 15 Dec 2022 15:36:30 +0100
X-Mailer: MailMate (1.14r5933)
Message-ID: <3142B112-D79A-48D2-970A-6B2DF45ACD30@redhat.com>
In-Reply-To: <920bc474-d5d8-2d8d-d9eb-fd237cba723d@ovn.org>
References: <167103556314.309509.17490804498492906420.stgit@ebuild>
 <920bc474-d5d8-2d8d-d9eb-fd237cba723d@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15 Dec 2022, at 12:45, Ilya Maximets wrote:

> On 12/14/22 17:33, Eelco Chaudron wrote:
>> The commit mentioned below causes the ovs_flow_tbl_lookup() function
>> to be called with the masked key. However, it's supposed to be called
>> with the unmasked key.
>
> Hi, Eelco.  Thanks for the fix!
>
> Could you, please, add more information to the commit message on
> why this is a problem, with some examples?  This will be useful
> for someone in the future trying to understand why we actually
> have to use an unmasked key here.

ACK will add the same description as in the OVS dpif-netdev commit.

> Also, I suppose, 'Cc: stable@vger.kernel.org' tag is needed in the
> commit message since it's a fix for a bug that is actually impacts
> users and needs to be backported.

Will do in the v3.

> Best regards, Ilya Maximets.
>
>>
>> This change reverses the commit below, but rather than having the key
>> on the stack, it's allocated.
>>
>> Fixes: 190aa3e77880 ("openvswitch: Fix Frame-size larger than 1024 bytes warning.")
>>
>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
>>
>> ---
>> Version history:
>>  - v2: Fixed ENOME(N/M) error. Forgot to do a stg refresh.
>>
>>  net/openvswitch/datapath.c |   25 ++++++++++++++++---------
>>  1 file changed, 16 insertions(+), 9 deletions(-)

