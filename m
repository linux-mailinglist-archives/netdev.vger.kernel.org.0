Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6027164E88B
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiLPJSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPJSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:18:07 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6663F04C
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:18:06 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o15so1394865wmr.4
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 01:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LofBPkCpnVs+y4TLuttIFSIFQ7Ww5t0ibtXB8wwWo2A=;
        b=vD47iYvaaUmjs428onIIDmPlvkZdSG0zm2uc5VLVCjJ31Vb/kNmw7QEgkabuAyoPpD
         JvEJD5cjVNgof1kKhJ05H0SVF3M2CadkbL9Xeo643CoJ7SFGXCAepCGE1R87q420o4xf
         B2OqOBBKKEdDoUKTuRzvkXcQUZr/dkAtH+mj6SPkhPr0BL+pLVa40tM/komq+fusokzL
         qFrGcxADtQ2OGPfBsVwRJq6qJci0I8VFViW72Ojsw+RetXb6/txrnbNoLr+G990pZjDi
         8faz0o21OF2Mwx+imoM5fbC59TTVdojzlpz7UvmK36SzJOzxspGLVltRnbMyiPEe2+zO
         gImA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LofBPkCpnVs+y4TLuttIFSIFQ7Ww5t0ibtXB8wwWo2A=;
        b=NbElRAvR9pJ1j6lNuMjnIYOKCNXOtVRSUhfplWnp5Kfq3TKmVQSVVPcixJ+cbQxQoD
         3B7slQ0H1jfNzFdajzw61Ehx5igonEoP9zjnGrrtzpsFalJyV49CRAavXp3BeHVNm7uc
         nCB43EESNwH4qH8hlnF06FEqgtMdVwV4xxzyEDmrz/sudlqis7B0AC85Vw1AfTaXXbsB
         pm1Jpd1iipUaxF6eDReJ2Yrxker5Xm9mMaWCphgSAWgYyy7wpL9T7RzytobFtOM4KUJx
         TpVrsUIDDuuFcS2/DrWgF53lKoY/vmwg+p/UIVQbdCEPhdtOTQomMJ4q55B1/73SFC2+
         4YKw==
X-Gm-Message-State: ANoB5pm8QhP2pZARzesZRJigId8VyrC/liN4M4sT8x35bgF+WosDqgLr
        hbl9bvWkKYATjKLw/etTilV9mg==
X-Google-Smtp-Source: AA0mqf6mr8N2g5bYDkzciMCBHrLVuMD302G7Po/dD1SByKEXsRmGBUGUw8E+hpr8/ZdwS8Br69vNKQ==
X-Received: by 2002:a05:600c:3c8d:b0:3d0:6d39:c62e with SMTP id bg13-20020a05600c3c8d00b003d06d39c62emr25657546wmb.12.1671182285128;
        Fri, 16 Dec 2022 01:18:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h15-20020a05600c350f00b003c71358a42dsm12880790wmq.18.2022.12.16.01.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 01:18:04 -0800 (PST)
Date:   Fri, 16 Dec 2022 10:18:03 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, jiri@nvidia.com,
        moshe@mellanox.com
Subject: Re: [PATCH net] devlink: protect devlink dump by the instance lock
Message-ID: <Y5w3y1BU8cLAMTny@nanopsycho>
References: <20221216044122.1863550-1-kuba@kernel.org>
 <20221215204447.149b00e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215204447.149b00e6@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 16, 2022 at 05:44:47AM CET, kuba@kernel.org wrote:
>On Thu, 15 Dec 2022 20:41:22 -0800 Jakub Kicinski wrote:
>> Take the instance lock around devlink_nl_fill() when dumping,
>> doit takes it already.
>> 
>> We are only dumping basic info so in the worst case we were risking
>> data races around the reload statistics. Also note that the reloads
>> themselves had not been under the instance lock until recently, so
>> the selection of the Fixes tag is inherently questionable.
>> 
>> Fixes: a254c264267e ("devlink: Add reload stats")
>
>On second thought, the drivers can't call reload, so until we got rid
>of the big bad mutex there could have been no race. I'll swap the tag
>for:
>
>Fixes: d3efc2a6a6d8 ("net: devlink: remove devlink_mutex")
>
>when/if applying.

You are right.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks!
