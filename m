Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C965247DC
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351424AbiELI10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237176AbiELI1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:27:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCB75819BE
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 01:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652344042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UKp9aLk27aL43H7c2N2+dMv60Nwmc08LYvDNv9z3Fuw=;
        b=HGk2Xh/Q7dRpsSJSc/hJaLGIw1dSE3IP2FA3V92VrV6EkiSfyr3SGl3Q2D7JEinGkF/3Tr
        awCwuUeFx32NVMkH7v39DrHOJQwzFZPcdofuvCRSdPRWmKQPVfxmVWOLzbZbePUEpDHXLb
        xWBR+iLHaLxVecf7LMIQ/QXd2RMeFq4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-fOocyOjlOwSW0HPL_fXCOQ-1; Thu, 12 May 2022 04:27:21 -0400
X-MC-Unique: fOocyOjlOwSW0HPL_fXCOQ-1
Received: by mail-wm1-f70.google.com with SMTP id h6-20020a7bc926000000b0039470bcb9easo1394873wml.1
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 01:27:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=UKp9aLk27aL43H7c2N2+dMv60Nwmc08LYvDNv9z3Fuw=;
        b=aN3b7Pk8yHkf9Hu2daN0NWTLYMXLJ50wNpWIm+xrJcddo72NAjxlvJzA00l7qPJbkZ
         l12LZfRnL27QzScXmRaPUEzqZhgLABrcMr2ZhQbRH8kl2rKdq8ZVwuqw3vLzZ5U0zAL9
         cSJT9AmV/1AUGeU1tqql2/TmbPmzSTcDHs/jNebhW/JTSI0ERM62ekehTSewYehnfKj8
         XIRbuhMrdJBm3jk1d3/RkfM8j8TbF7bW2P9JfN+df1pX3ALIPRVLjY43vgCUucJsgKFs
         tx8Yd2CiJ6nXngyunr2CQAXNUyssGe5agNLZEIXqrmGT9tnbgEl3Nxx64WTelJ9FjMfn
         L6zg==
X-Gm-Message-State: AOAM533FNRSSn5imlcXsdWAbA+k1mWGhaxFt/k72C9qA/mPcVj9C6iHk
        Vq31+diRNIRVAcWRF5bbY3umomV9v6iq7H6DfNuZWEpE67OK+xtA8XZz/SY971qg/Zl27+rHpy0
        VIGTWjyJ3V8c3w4dI
X-Received: by 2002:a05:6000:188a:b0:20c:e43e:83f3 with SMTP id a10-20020a056000188a00b0020ce43e83f3mr2638230wri.621.1652344040100;
        Thu, 12 May 2022 01:27:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJKp/EGxLuFwK2435tzLC+FszxD5/D2QoHQy3dbiyqh5SVzzFU/Rf/vZO6yE8G7CspN33WEQ==
X-Received: by 2002:a05:6000:188a:b0:20c:e43e:83f3 with SMTP id a10-20020a056000188a00b0020ce43e83f3mr2638213wri.621.1652344039853;
        Thu, 12 May 2022 01:27:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id l7-20020a056000022700b0020c5253d8ecsm3470186wrz.56.2022.05.12.01.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 01:27:19 -0700 (PDT)
Message-ID: <4f7e80c47826315e498edf45e7c1442cd54e95c7.camel@redhat.com>
Subject: Re: [PATCH net-next] net: wwan: t7xx: Fix return type of
 t7xx_dl_add_timedout()
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>,
        YueHaibing <yuehaibing@huawei.com>,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        chiranjeevi.rapolu@linux.intel.com, haijun.liu@mediatek.com,
        m.chetan.kumar@linux.intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 12 May 2022 10:27:17 +0200
In-Reply-To: <add45b0e-3081-3ca0-d03c-fe306526cc01@linux.intel.com>
References: <20220511071907.29120-1-yuehaibing@huawei.com>
         <add45b0e-3081-3ca0-d03c-fe306526cc01@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-05-11 at 17:35 -0700, Martinez, Ricardo wrote:
> On 5/11/2022 12:19 AM, YueHaibing wrote:
> > t7xx_dl_add_timedout() now return int 'ret', but the return type
> > is bool. Change the return type to int for furthor errcode upstream.
> > 
> > Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> > ---
> >   drivers/net/wwan/t7xx/t7xx_dpmaif.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wwan/t7xx/t7xx_dpmaif.c b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
> > index c8bf6929af51..8ee15af1a1ce 100644
> > --- a/drivers/net/wwan/t7xx/t7xx_dpmaif.c
> > +++ b/drivers/net/wwan/t7xx/t7xx_dpmaif.c
> > @@ -1043,7 +1043,7 @@ unsigned int t7xx_dpmaif_dl_dlq_pit_get_wr_idx(struct dpmaif_hw_info *hw_info,
> >   	return value & DPMAIF_DL_RD_WR_IDX_MSK;
> >   }
> >   
> > -static bool t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
> > +static int t7xx_dl_add_timedout(struct dpmaif_hw_info *hw_info)
> yes, int is the right return type, thanks!
> 

Changing the return type without using the different error code in the
caller is quite useless. Additionally t7xx_dl_add_timedout() (via
ioread32_poll_timeout_atomic()) can produce a single error value
(ETIMEOUT). IMHO this change is not needed.

You may want to remove the 'ret' local variable instead (in the same
function)

Cheers,

Paolo

