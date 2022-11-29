Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB5C63C030
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbiK2Mgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiK2MgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:36:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329BF5E9CC
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 04:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669725320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z3z/3P7EXAd6weM4XrWvQhhzQHzQBGr4Dy+JGTyibWY=;
        b=P7Al+dF05OqX0HGUjQXRoJF24cT8M3rR3gMHf+x7xjfOzmR9HFa9bZY3J/tzlYa6JIWV4J
        SbSFrXFDICVtEsTEvoccHfiWHNoAcOr3pwmvGGB72FI//5VYzRbNz8P0XiEpHNbYJXOHwN
        J27xykfjGxJXoH9CC8W3zDzM8rPigS4=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-cHn7oO8IMPywSHreHK-6_A-1; Tue, 29 Nov 2022 07:35:19 -0500
X-MC-Unique: cHn7oO8IMPywSHreHK-6_A-1
Received: by mail-ed1-f69.google.com with SMTP id j11-20020aa7c40b000000b0046b45e2ff83so2746733edq.12
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 04:35:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3z/3P7EXAd6weM4XrWvQhhzQHzQBGr4Dy+JGTyibWY=;
        b=TN99+8+QGW+64v2CotwSUsh9Pxg1jB83xEkyLwlrsTP9F7bCDlAmNsnXZcn+V0CX71
         B7xqUXmSrGAXXjBD9t4EQk1C5WcPqs4tY4P0v7boM99U9yovADcDCWZBfXo7s11fVqPF
         HAhZhAqUtJffT7vSEV5uW31+IlrihOE3TsokcPf8XE/KF1ohn67Mefz+G65Q+JIWlK36
         1Xe5CBAUnohqw4hHeB30sUeKz8SzU1wKObRfuq4Tuu4X0mjjCr/ozrys9hBKJv4yQD62
         6zwGj6dNbR/2dzGNM7QkfA0ijyZLlTzbkkN934nQQLKC22FSSqVUrDXP3YdonGYLjKRO
         rtbA==
X-Gm-Message-State: ANoB5plW/oBG9BC2FjzHvsWx44LT5dhf+oAZZBEirnMvbHxAvwUBn4zX
        54mG50uJDuN67kszlsx8BrFxCssILjZWrDa88YIka7XJM4bZrdNV/r/Pr1SypRLE05ipvfciIT+
        hIjpmm5sfM4e4lBq+
X-Received: by 2002:a17:907:a50c:b0:7bc:98f6:35c4 with SMTP id vr12-20020a170907a50c00b007bc98f635c4mr18892144ejc.123.1669725317506;
        Tue, 29 Nov 2022 04:35:17 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7UvIa+uN5bK38BPNAL65BEU4ry1iF3k91kTluYD1IeRBeV3rNu0EWf/R/WOWwbGWtN5nVY5w==
X-Received: by 2002:a17:907:a50c:b0:7bc:98f6:35c4 with SMTP id vr12-20020a170907a50c00b007bc98f635c4mr18892121ejc.123.1669725317229;
        Tue, 29 Nov 2022 04:35:17 -0800 (PST)
Received: from [10.39.192.213] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id l17-20020a1709063d3100b0077b2b0563f4sm6175857ejf.173.2022.11.29.04.35.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Nov 2022 04:35:16 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     Tianyu Yuan <tianyu.yuan@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Date:   Tue, 29 Nov 2022 13:35:14 +0100
X-Mailer: MailMate (1.14r5928)
Message-ID: <80007094-D864-45F2-ABD5-1D22F1E960F6@redhat.com>
In-Reply-To: <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <PH0PR13MB4793DE760F60B63796BF9C5E94139@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZanoC6C6Xb-14fy6em8ZJaFnk+78ufOdb=gBfMn-ce2eA@mail.gmail.com>
 <FA3E42DF-5CA2-40D4-A448-DE7B73A1AC80@redhat.com>
 <CALnP8ZZiw9b_xOzC3FaB8dnSDU1kJkqR6CQA5oJUu_mUj8eOdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Nov 2022, at 14:33, Marcelo Leitner wrote:

> On Mon, Nov 28, 2022 at 02:17:40PM +0100, Eelco Chaudron wrote:
>>
>>
>> On 28 Nov 2022, at 14:11, Marcelo Leitner wrote:
>>
>>> On Mon, Nov 28, 2022 at 07:11:05AM +0000, Tianyu Yuan wrote:
> ...
>>>>
>>>> Furthermore, I think the current stats for each action mentioned in =
2) cannot represent the real
>>>> hw stats and this is why [ RFC  net-next v2 0/2] (net: flow_offload:=
 add support for per action
>>>> hw stats) will come up.
>>>
>>> Exactly. Then, when this patchset (or similar) come up, it won't
>>> update all actions with the same stats anymore. It will require a set=

>>> of stats from hw for the gact with PIPE action here. But if drivers
>>> are ignoring this action, they can't have specific stats for it. Or a=
m
>>> I missing something?
>>>
>>> So it is better for the drivers to reject the whole flow instead of
>>> simply ignoring it, and let vswitchd probe if it should or should not=

>>> use this action.
>>
>> Please note that OVS does not probe features per interface, but does i=
t per datapath. So if it=E2=80=99s supported in pipe in tc software, we w=
ill use it. If the driver rejects it, we will probably end up with the tc=
 software rule only.
>
> Ah right. I remember it will pick 1 interface for testing and use
> those results everywhere, which then I don't know if it may or may not
> be a representor port or not. Anyhow, then it should use skip_sw, to
> try to probe for the offloading part. Otherwise I'm afraid tc sw will
> always accept this flow and trick the probing, yes.

Well, it depends on how you look at it. In theory, we should be hardware =
agnostic, meaning what if you have different hardware in your system? OVS=
 only supports global offload enablement.

Tianyu how are you planning to support this from the OVS side? How would =
you probe kernel and/or hardware support for this change?

//Eelco

