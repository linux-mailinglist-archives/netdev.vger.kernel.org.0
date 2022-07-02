Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF89A56413C
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 18:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbiGBP6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 11:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbiGBP6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 11:58:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCA8B7CA
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 08:58:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id d2so9146241ejy.1
        for <netdev@vger.kernel.org>; Sat, 02 Jul 2022 08:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LqTLNuT6chM3Pa1YncL1xGiDwO6ESZi6O9GCGne55J8=;
        b=1Nx/eC8GexkmAImR6c6m0xxvvLhe6cTDbwFLqOa74oVIcR3JKu1+eeG6FYmKYoxJee
         lpfzQ0AMoMlNU2CYjAXwyuXOLZwVuQ5C1rKRZb4ju4ZH/hAQ34MNbRZCQnuJmCjgCVrg
         uQd60bSrE//eOuot0VZbgcfwI3KlTfYBSp/sYf/8mXA0in5ZwBIoF9wgrq3PRotiswB/
         Bkn/2xtluSfMrn92TNNwbaBwfvAo620UWxfqNjn1k8OV2KnvF8gwJlFSZb41a2CrqUBM
         Tvq2CSdPtISixeDXT9/moOnVs61SM892QdFUkq8oQCG1FJvce3i9et3AUlFcjiplhxbC
         GCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LqTLNuT6chM3Pa1YncL1xGiDwO6ESZi6O9GCGne55J8=;
        b=HqVEMzqID30n13AEkuM9Z7gcLKNRQnfjelmKrBVOxEqFLFYPfAD7rAlQrHM8C7QMLs
         uKIRYjE1b6gcDH3p5BV1wgVw/O1n2bMRgCj08BFY39EApttR7+VO7J5hKzNcO5guVPqW
         IriPNOCyuCWonh1rL7GTf2zYvD7chNWUzVzl6AOrWJARB9EpUBVn+iHbUkySZalLBgA2
         JOHdoTRwPnOQsC09wLa4ryvkoeYPoG8pVGsZSmRNiNFjpYS7k0oupSwgYaz9QAlr73do
         7zzBGG/I2jAT5uheKA1ImUVCXXfdV7gP46N1xD281hE1j8huGeOKoxMoj1JvJl2k4KdH
         oOtQ==
X-Gm-Message-State: AJIora8HpO6GxmCTYkO40RT9mJc1UfKnd5t4MxKCK4kzZHvVGsdUU7fl
        Zm2XMUYQvjp/jmHGq+s5aeKH8A==
X-Google-Smtp-Source: AGRyM1vp40QRAMlLeo/GHi2khqXgGtcbpxRxhmO82tZAZrdNXQiWCG93kh+cV2Vm2iVEC1oqJGYWtg==
X-Received: by 2002:a17:907:778a:b0:70c:d67:578e with SMTP id ky10-20020a170907778a00b0070c0d67578emr19216986ejc.696.1656777487866;
        Sat, 02 Jul 2022 08:58:07 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id q25-20020a17090676d900b0072ab06bf296sm445187ejn.23.2022.07.02.08.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 08:58:07 -0700 (PDT)
Date:   Sat, 2 Jul 2022 17:58:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 2/3] net: devlink: call lockdep_assert_held()
 for devlink->lock directly
Message-ID: <YsBrDhZuV4j3uCk3@nanopsycho>
References: <20220701095926.1191660-1-jiri@resnulli.us>
 <20220701095926.1191660-3-jiri@resnulli.us>
 <20220701093316.410157f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701093316.410157f3@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jul 01, 2022 at 06:33:16PM CEST, kuba@kernel.org wrote:
>On Fri,  1 Jul 2022 11:59:25 +0200 Jiri Pirko wrote:
>> In devlink.c there is direct access to whole struct devlink so there is
>> no need to use helper. So obey the customs and work with lock directly
>> avoiding helpers which might obfuscate things a bit.
>
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 25b481dd1709..a7477addbd59 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -10185,7 +10185,7 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
>>  	struct devlink *devlink = devlink_port->devlink;
>>  	struct devlink_rate *devlink_rate;
>>  
>> -	devl_assert_locked(devlink_port->devlink);
>> +	lockdep_assert_held(&devlink_port->devlink->lock);
>
>I don't understand why. Do we use lockdep asserts directly on rtnl_mutex
>in rtnetlink.c?

Well:

1) it's been a long time policy not to use helpers for locks if not
   needed. There reason is that the reader has easier job in seeing what
   the code is doing. And here, it is not needed to use helper (we can
   access the containing struct)
2) lock/unlock for devlink->lock is done here w/o helpers as well
3) there is really no gain of using helper here.
4) rtnl_mutex is probably not good example, it has a lot of ancient
   history behind it.
