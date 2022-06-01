Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFBA539EB4
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350372AbiFAHrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343726AbiFAHrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:47:47 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F05532F6;
        Wed,  1 Jun 2022 00:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1654069632;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:Message-ID:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=9TczPh2ye+CJ8GtYFJSne4FSC2NTbNH+NU7EnCqZ18w=;
        b=D35LycFD+mvLMX83hWZ9dF2BUC1OWf7Rra5au3PiApuEwyrB3MPc0aAHS1eZ8Es/
        ak0aU+6ZQLZ4U221uENcEwkb4FyIx20T5ZctmyeOIGTos9RxfnPN9cVgzoosumJbZEH
        FShu5qOOLisxjDvMcGeksJuDFoEG9zVvkLocy2sc=
Received: from [192.168.255.10] (113.108.77.71 [113.108.77.71]) by mx.zoho.com.cn
        with SMTPS id 1654069629528896.3577145683946; Wed, 1 Jun 2022 15:47:09 +0800 (CST)
Date:   Wed, 1 Jun 2022 15:47:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/6] netlink: fix missing destruction of rhash table in
 error case
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
References: <20220529153456.4183738-1-cgxu519@mykernel.net>
 <20220529153456.4183738-2-cgxu519@mykernel.net>
 <e530dc2021d43a29b64f985d7365319eab0d5595.camel@redhat.com>
 <20220531112551.GT2146@kadam>
From:   Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <5a5d847c-f8e6-48a7-85ad-75e76105122d@mykernel.net>
In-Reply-To: <20220531112551.GT2146@kadam>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E5=9C=A8 2022/5/31 19:25, Dan Carpenter =E5=86=99=E9=81=93:
> On Tue, May 31, 2022 at 10:43:09AM +0200, Paolo Abeni wrote:
>> Hello,
>>
>> On Sun, 2022-05-29 at 23:34 +0800, Chengguang Xu wrote:
>>> Fix missing destruction(when '(--i) =3D=3D 0') for error case in
>>> netlink_proto_init().
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>>> ---
>>>   net/netlink/af_netlink.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
>>> index 0cd91f813a3b..bd0b090a378b 100644
>>> --- a/net/netlink/af_netlink.c
>>> +++ b/net/netlink/af_netlink.c
>>> @@ -2887,7 +2887,7 @@ static int __init netlink_proto_init(void)
>>>   =09for (i =3D 0; i < MAX_LINKS; i++) {
>>>   =09=09if (rhashtable_init(&nl_table[i].hash,
>>>   =09=09=09=09    &netlink_rhashtable_params) < 0) {
>>> -=09=09=09while (--i > 0)
>>> +=09=09=09while (--i >=3D 0)
>>>   =09=09=09=09rhashtable_destroy(&nl_table[i].hash);
>>>   =09=09=09kfree(nl_table);
>>>   =09=09=09goto panic;
>> The patch looks correct to me, but it looks like each patch in this
>> series is targeting a different tree. I suggest to re-send, splitting
>> the series into individual patches, and sending each of them to the
>> appropriate tree. You can retain Dan's Review tag.
> Since it looks like you're going to be resending these then could you
> add Fixes tags?  Please keep my Review tag.
>

OK, no problem.

Thanks,
Chengguang



