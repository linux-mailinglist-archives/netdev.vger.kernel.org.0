Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5F44D11D4
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 09:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344903AbiCHIM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 03:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344863AbiCHIMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 03:12:16 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71863EAA9
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 00:11:19 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t11so27137038wrm.5
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 00:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bUuwvQrXybXChtd344tucDAbC/YGVngRcc0ZDqCkqCM=;
        b=FOX5owV8RzTydaOm10xlR8P5JUbvjo/CFb/kM+h+EE4rb0970CllcVu7OwT3YZnsxM
         3wwkCScMrKpT6xVdU36PV5QVUpwnWNlUmeSgoTOVJfdhW4Vbvf66w9jQXdKrukZ5wxCO
         mKx01a+tMEzg/o21jrzYQQwpxbzT/QycYJxfu+ezOnNif28TjumqmoZxUDrlqQmckKHd
         7IqibmDYyuIugCo+VrhnhGPNf/jA6nRjHtYLD9y0lTybOcGB2GDHLhmN7qzudFV2Ajn1
         zMB9KGQ/pVrEDXg4+5gMMG7rZXtPWCS2W/5JOW/hwY+QgfQylJ7+SNNm8R/MurItEKbQ
         zDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bUuwvQrXybXChtd344tucDAbC/YGVngRcc0ZDqCkqCM=;
        b=WNDzXBl4lJ3PUDCSmookwGeTst8iWXaBm0eoV4C2IHj0qL2FlIgaBXH439ySTsmzhE
         uLCd6BtDwIp6mvyIXq0R4HF9sGvohFkA9ztqLpKY4qGnHo7j7T1QZzMbXwnlZFG4LXKF
         5N7vyJ19lU+30sdOf1obwEKWe0oWYWKuvm9CQYTUI0kERtH620lymUaGQwpCP7Z+sMon
         set4Z1DzTlL81aXK0B8I32YmBGrhDPTUjGyl6jJ+CGmr/XBqpmC3/JIKLs3XEBrnpUW7
         uyjBHWs8VEdLCvhJsndmU6+YP1jI57Pnn93UQSCqkDOFGmo5AuhRjJ/k30PNl0MmWSqI
         ROLQ==
X-Gm-Message-State: AOAM530hpMXPlxnAs4I0kaXQlD5M7hH5qReEGABUJwwDczV6HiSq+A/p
        OX71qbmy6gPoLCadpzuqbLyA/g==
X-Google-Smtp-Source: ABdhPJyhnQawWRN2eaq4CHOTm2Mk+XURsNwuQaphypHckXVzl4v3Ff4oimUI6+a7e/f2RNB++zpv0w==
X-Received: by 2002:a5d:69d0:0:b0:1f1:fd05:e863 with SMTP id s16-20020a5d69d0000000b001f1fd05e863mr5423384wrw.223.1646727078277;
        Tue, 08 Mar 2022 00:11:18 -0800 (PST)
Received: from google.com (cpc155339-bagu17-2-0-cust87.1-3.cable.virginm.net. [86.27.177.88])
        by smtp.gmail.com with ESMTPSA id p22-20020a1c5456000000b00389a558670fsm1446399wmi.11.2022.03.08.00.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 00:11:17 -0800 (PST)
Date:   Tue, 8 Mar 2022 08:11:15 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     mst@redhat.com, jasowang@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <YicPo5YmyzOvBNP2@google.com>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YicPXnNFHpoJHcUN@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Mar 2022, Lee Jones wrote:

> On Mon, 07 Mar 2022, Greg KH wrote:
> 
> > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > during virtqueue clean-up and we mitigate the reported issues.
> > > 
> > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > capture possible future race conditions which may pop up over time.
> > > 
> > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > 
> > > Cc: <stable@vger.kernel.org>
> > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/vhost/vhost.c | 10 ++++++++++
> > >  1 file changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > --- a/drivers/vhost/vhost.c
> > > +++ b/drivers/vhost/vhost.c
> > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > >  	int i;
> > >  
> > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > +		/* No workers should run here by design. However, races have
> > > +		 * previously occurred where drivers have been unable to flush
> > > +		 * all work properly prior to clean-up.  Without a successful
> > > +		 * flush the guest will malfunction, but avoiding host memory
> > > +		 * corruption in those cases does seem preferable.
> > > +		 */
> > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > 
> > So you are trading one syzbot triggered issue for another one in the
> > future?  :)
> > 
> > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > you want that to happen?
> 
> No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> 
> > And what happens if the mutex is locked _RIGHT_ after you checked it?
> > You still have a race...
> 
> No, we miss a warning that one time.  Memory is still protected.

I didn't mean those "no"s to sound so negative, sorry. :)

-- 
Lee Jones [李琼斯]
Principal Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
