Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B57690AC3
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 14:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjBINo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 08:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjBINoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 08:44:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D18411641
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 05:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675950181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WRkmA+58FtIVH17mOea3hs+TvpzANZr2uPpdZvH0Ffk=;
        b=ctgLM1qJ1Gp442BzyvJbZ+bpmWOlGv0dKjVGgm3D6YfU384W2CnqBnKOc+1aVtD2BAComF
        Bi4CjWYzaZq4HDM9H02nw+el+u+muCD6I2VjGGa4g93qFnM1Est9zpZuLSL7A2c+4CiGjQ
        PfvlfTP2enyLNXCVqJBcgoZ3WfavgAM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-539-wAREgYlANy6fgEzk8qGYTg-1; Thu, 09 Feb 2023 08:43:00 -0500
X-MC-Unique: wAREgYlANy6fgEzk8qGYTg-1
Received: by mail-ed1-f69.google.com with SMTP id bq13-20020a056402214d00b004a25d8d7593so1506397edb.0
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 05:43:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WRkmA+58FtIVH17mOea3hs+TvpzANZr2uPpdZvH0Ffk=;
        b=PPdb7mvdrPDUBdT/VVNclMXhBxDG1/OYKWCOD2mtkSZC30shIluPC9WtOqGxVIWKmH
         /rf2hnRE9TlYQgR2ATDbMCRj8IOm1pXI3MQMaVSUDklJaLeqPCKrMvckbkYa1dafRBvr
         B2jBjxRa+lC0uChthSwsYKoC6JZLyF+R/tOcCCvynEOSOxzgIeHz2tMJrKS3+GBbwiNh
         VsYAs1TvasEucJRfqtPHIKJC8xkgasYAmRW+tPrrJEVf8BpUGPQJ+dx9IO0/RBEwot2U
         WNCdj7BjuaPe80gK14XLTyEORASTp7E0R5Rlyy/pRS933gZZio18YSTTXIpfYzc7RjMu
         vMxw==
X-Gm-Message-State: AO0yUKWCoUtyTcalxnPZfYOg39uU2SGK+0OYv9NhyC3vjgSBYWcNqE9l
        ybLkgYkr8drU4IEvjgOA3bwW7B7pLPdjP1s3oeCgQk3MlP/G2KVrjtgu7UhpSRUZgEA/j/v2sIf
        VoXEfU6Cb07kDsV0Z
X-Received: by 2002:a17:907:1dd9:b0:894:ad38:aafb with SMTP id og25-20020a1709071dd900b00894ad38aafbmr13288609ejc.18.1675950179619;
        Thu, 09 Feb 2023 05:42:59 -0800 (PST)
X-Google-Smtp-Source: AK7set/MFLk4hTkv6Y32Y683pPZO9/hJU4xSuEcAEf7gZixEomhdJvuza9BxOmgyQCVwNizScLm6Pw==
X-Received: by 2002:a17:907:1dd9:b0:894:ad38:aafb with SMTP id og25-20020a1709071dd900b00894ad38aafbmr13288596ejc.18.1675950179436;
        Thu, 09 Feb 2023 05:42:59 -0800 (PST)
Received: from [10.39.193.13] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906309500b0088a0d645a5asm898633ejv.99.2023.02.09.05.42.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Feb 2023 05:42:58 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Hangyu Hua <hbh25y@gmail.com>, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, xiangxia.m.yue@gmail.com, dev@openvswitch.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH v2] net: openvswitch: fix possible memory leak
 in ovs_meter_cmd_set()
Date:   Thu, 09 Feb 2023 14:42:57 +0100
X-Mailer: MailMate (1.14r5942)
Message-ID: <5C180FB7-5EAA-4AEB-BD69-9522F2CD73B5@redhat.com>
In-Reply-To: <Y+TR3sB4X5Yt79Tx@corigine.com>
References: <20230209093240.14685-1-hbh25y@gmail.com>
 <Y+TR3sB4X5Yt79Tx@corigine.com>
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



On 9 Feb 2023, at 11:58, Simon Horman wrote:

> On Thu, Feb 09, 2023 at 05:32:40PM +0800, Hangyu Hua wrote:
>> old_meter needs to be free after it is detached regardless of whether
>> the new meter is successfully attached.
>>
>> Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported nu=
mber")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>
>> v2: use goto label and free old_meter outside of ovs lock.
>>
>>  net/openvswitch/meter.c | 12 +++++++++---
>>  1 file changed, 9 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
>> index 6e38f68f88c2..9b680f0894f1 100644
>> --- a/net/openvswitch/meter.c
>> +++ b/net/openvswitch/meter.c
>> @@ -417,6 +417,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, =
struct genl_info *info)
>>  	int err;
>>  	u32 meter_id;
>>  	bool failed;
>> +	bool locked =3D true;
>>
>>  	if (!a[OVS_METER_ATTR_ID])
>>  		return -EINVAL;
>> @@ -448,11 +449,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb=
, struct genl_info *info)
>>  		goto exit_unlock;
>>
>>  	err =3D attach_meter(meter_tbl, meter);
>> -	if (err)
>> -		goto exit_unlock;
>>
>>  	ovs_unlock();
>>
>> +	if (err) {
>> +		locked =3D false;
>> +		goto exit_free_old_meter;
>> +	}
>>  	/* Build response with the meter_id and stats from
>>  	 * the old meter, if any.
>>  	 */
>> @@ -472,8 +475,11 @@ static int ovs_meter_cmd_set(struct sk_buff *skb,=
 struct genl_info *info)
>>  	genlmsg_end(reply, ovs_reply_header);
>>  	return genlmsg_reply(reply, info);
>>
>> +exit_free_old_meter:
>> +	ovs_meter_free(old_meter);
>>  exit_unlock:
>> -	ovs_unlock();
>> +	if (locked)
>> +		ovs_unlock();
>
> I see where you are going here, but is the complexity of the
> locked variable worth the benefit of freeing old_meter outside
> the lock?

Looking at the error path, I would agree with Simon, and just add an =E2=80=
=9Cexit_free_old_meter=E2=80=9D label as suggested in v1 and keep the loc=
k in place to make the error path more straightforward.

//Eelco

>>  	nlmsg_free(reply);
>>  exit_free_meter:
>>  	kfree(meter);
>> -- =

>> 2.34.1
>>
>> _______________________________________________
>> dev mailing list
>> dev@openvswitch.org
>> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
>>

