Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73F06E6619
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 15:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDRNiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 09:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbjDRNiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 09:38:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C09446B2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 06:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681825086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZAhC7ZdJaysYGSfjJpbZBcTrJMmolepzxRQWBXZQBkM=;
        b=Ojrp+GyxYNi1TH8pcds7d9AtVcpp7XnAwjqLZpDVYyOKY8jr5IYyiOVC4rwhVXDKOsXfA3
        JSz1ScKriULl607vR2ev4Hmg0Yk67iTz696YWNbGSEH7vGQW+V2SVZzNbgrQdjMfYokg9v
        sR5WPF8ImJBJZlNEYG/dp2r5OsvPKXM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-496-PzDcKuK1NhaKKyM-cNO9PA-1; Tue, 18 Apr 2023 09:38:04 -0400
X-MC-Unique: PzDcKuK1NhaKKyM-cNO9PA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-2f6cd27b991so781822f8f.2
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 06:38:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681825083; x=1684417083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAhC7ZdJaysYGSfjJpbZBcTrJMmolepzxRQWBXZQBkM=;
        b=TsX6dqGXrtd/4e53gV+liXW5AGMyVcmlHFDlUXYSkFC4mB2HTu63KbPWKsvj0dThap
         D6PxVf3nBzETY3F6gL+EeX1SrYyp7T9mUt4Ga0G0KYUaSumI/cRES7AbIm7xjWXjY2cN
         RbSr755zqgMRXOZ98ahLv/Q2Y/xS/AYXvZ/YtQBT4lvodsL1I31bsXl8g3a2SzcYb2IO
         B/8ILG197WaA46zuZfsZd5fpoXVEnU9QENYVXIqVTSNA15mCov27QW4rm8J9CxTfW6yi
         zx0Dv4KrAQiq9MWAols/LMt6dZCEANMP5LJQtg1rPtXbfcXpkRHFzspsuI7uekHRWQ+h
         0tFQ==
X-Gm-Message-State: AAQBX9frENC1mR14/lBed+w1Re9Ji9KdMbiS1WD+TpnF1JMHzd80l1Mz
        TSn5sdNmV5hYtURAHsevJG46EElCJ/WywUBGVZ7SbwFe0G/Al7wIfEtwgj7P/zVlEwlmfIl05Jt
        a4Qa2f1o9tGRUVifT
X-Received: by 2002:a5d:5141:0:b0:2fb:cbdf:fb48 with SMTP id u1-20020a5d5141000000b002fbcbdffb48mr1808078wrt.3.1681825083589;
        Tue, 18 Apr 2023 06:38:03 -0700 (PDT)
X-Google-Smtp-Source: AKy350aPtx6JemOL/ZAUA3CSIMFOXAwPyuMbBNOjlwcnlcNO3RvB3f+yLM18m91J8i9J7QgrGjtT5w==
X-Received: by 2002:a5d:5141:0:b0:2fb:cbdf:fb48 with SMTP id u1-20020a5d5141000000b002fbcbdffb48mr1808055wrt.3.1681825083281;
        Tue, 18 Apr 2023 06:38:03 -0700 (PDT)
Received: from debian ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id a8-20020a5d4568000000b002f61f08a9a6sm12769154wrc.50.2023.04.18.06.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:38:02 -0700 (PDT)
Date:   Tue, 18 Apr 2023 15:38:00 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Samuel Thibault <samuel.thibault@ens-lyon.org>,
        James Chapman <jchapman@katalix.com>, tparkin@katalix.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPPoL2TP: Add more code snippets
Message-ID: <ZD6dON0gl3DE8mYr@debian>
References: <20230416220704.xqk4q6uwjbujnqpv@begin>
 <ZD5V+z+cBaXvPbQa@debian>
 <20230418085323.h6xij7w6d2o4kxxi@begin>
 <ZD5dqwPblo4FOex1@debian>
 <20230418091148.hh3b52zceacduex6@begin>
 <ZD5uU8Wrz4cTSwqP@debian>
 <20230418103140.cps6csryl2xhrazz@begin>
 <ZD5+MouUk8YFVOX3@debian>
 <20230418115409.aqsqi6pa4s4nhwgs@begin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418115409.aqsqi6pa4s4nhwgs@begin>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 01:54:09PM +0200, Samuel Thibault wrote:
> Guillaume Nault, le mar. 18 avril 2023 13:25:38 +0200, a ecrit:
> > As I said in my previous reply, a simple L2TP example that goes until PPP
> > channel and unit creation is fine. But any more advanced use of the PPP
> > API should be documented in the PPP documentation.
> 
> When it's really advanced, yes. But here it's just about tunnel
> bridging, which is a very common L2TP thing to do.

I can't undestand why you absolutely want this covered in l2tp.rst.
This feature also works on PPPoE.

Also, it's probably a desirable feature, but certainly not a common
thing on Linux. This interface was added a bit more than 2 years ago,
which is really recent considering the age of the code. Appart from
maybe go-l2tp, I don't know of any user.

> > I mean, these files document the API of their corresponding modules,
> > their scope should be limitted to that (the PPP and L2TP layers are
> > really different).
> 
> I wouldn't call
> 
> +        ret = ioctl(ppp_chan_fd, PPPIOCBRIDGECHAN, &chindx2);
> +        close(ppp_chan_fd);
> +        if (ret < 0)
> +                return -errno;
> 
> documentation...

The documentation is in ppp_generic.rst. Does it really make sense to
you to have the doc there and the sample code in l2tp.rst?

Anyway, I'm not going to argue any longer. You have my opinion.
You're always free to ignore feedbacks.

> > That shouldn't preclude anyone from describing how to combine L2TP, PPP
> > and others to cover more advanced use cases. It's just better done in a
> > different file.
> 
> A more complete example, yes. I don't plan on taking time to do it.
> 
> Samuel
> 

