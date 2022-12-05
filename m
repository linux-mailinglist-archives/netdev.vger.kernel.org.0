Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5634F64366C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiLEVGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiLEVFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:05:45 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2D62B26A
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 13:05:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o12so12430698pjo.4
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 13:05:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ag1mVK17zcHb4b3ZZx2MGK4zU/r9kJMvqux56vJkGy0=;
        b=NFWKLqkriqWg5LUdhJ8hD9I4ypQ1Vm1MCkkk/R8sO67CTOF9oEZVpbGEgZKv4n/rf9
         Fv/M1zGxFjp4llT/Ixyd4lrV/bEGjJHvms3xmKWgVUYefEjhAfG7HrmcpZOj7uzdtJit
         tbERPrBdI4YRd/Ci6Pfhfd++spsXZ0+iSs0xDMBV8i1rzL6OGLdbgxT9owGuGfY5/fIa
         ed0xw5j2CAILF23zqgc5neYZ6unXyBRoeTzCE+KeNosJ5Jj+5WYZjP1jCvotPnkM92/8
         kGXowZcFNuVKUmvzxWgKMqYQjw0JTDeaCsybqfg62IkPLHU/9f3aBZPfUjt5dda8SjbH
         snYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ag1mVK17zcHb4b3ZZx2MGK4zU/r9kJMvqux56vJkGy0=;
        b=rdL8iWY7DsVFEUAfn58gDL1xZBrmWdHVgpi/fT6vEbeArNl65qSCEj0YsCfFSwSsMW
         DmkB0khBM1hg9+tvBSnw8t56aa2tRmleQ8sFD/i6iSmnKKxB21YGmlva2Ts0FjQiYmJd
         IZZYJ3IQLcaVACoWuYF6IMAYbxERaz7irpAPg/Fy32uTKyxFe6Mp+yiBQf6GdiPxJTL4
         h0YScrmrItWWwyuoP0JauprL0vAzZ3fJNduYXbAIhqBBUCoM1hQXi13O9piGY5koyzbl
         0UpfgQhZ+EQaNwSnzwEa5tsvUeK/4h5lJSW1XoMUZOML2dMW3bhGTLhcYhVn8xHBPkKr
         LQ2A==
X-Gm-Message-State: ANoB5pm9o+w4dRpB1lvyqBngRap6dTY3DUK3L0AL+2GD8OjMG6g3Q9pU
        W0L4EHn3p1aOHGYtOnh5qyOkhw==
X-Google-Smtp-Source: AA0mqf4tIDZdd1XhrhhSNTgQnKvkAGB3uG2MyPEL8Q8d1OMjV3EfBw7vmg0rylb1XkRrPY2jsV3HuA==
X-Received: by 2002:a17:90b:315:b0:219:c3be:b151 with SMTP id ay21-20020a17090b031500b00219c3beb151mr9373999pjb.97.1670274314639;
        Mon, 05 Dec 2022 13:05:14 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id 184-20020a6206c1000000b0056bcb102e7bsm10283785pfg.68.2022.12.05.13.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:05:14 -0800 (PST)
Date:   Mon, 5 Dec 2022 13:05:12 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     <Daniel.Machon@microchip.com>
Cc:     <netdev@vger.kernel.org>, <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Message-ID: <20221205130512.60e5badf@hermes.local>
In-Reply-To: <Y45G/t9V3luxRDGF@DEN-LT-70577>
References: <20221202092235.224022-1-daniel.machon@microchip.com>
        <20221202092235.224022-2-daniel.machon@microchip.com>
        <20221203090052.65ff3bf1@hermes.local>
        <Y40hjAoN4VcUCatp@DEN-LT-70577>
        <20221204175257.75e09ff1@hermes.local>
        <Y426Pzdw5341RbCP@DEN-LT-70577>
        <20221205082305.51964674@hermes.local>
        <Y45G/t9V3luxRDGF@DEN-LT-70577>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Dec 2022 19:19:35 +0000
<Daniel.Machon@microchip.com> wrote:

> > On Mon, 5 Dec 2022 09:19:06 +0000
> > <Daniel.Machon@microchip.com> wrote:
> >   
> > > > > Trying to understand your comment.
> > > > >
> > > > > Are you talking about not producing any JSON output with the symbolic
> > > > > PCP values? eg. ["1de", 1] -> [8, 1]. So basically print with PRINT_FP
> > > > > in case of printing in JSON context?
> > > > >
> > > > > /Daniel  
> > > >
> > > > What does output look like in json and non-json versions?  
> > >
> > > non-JSON: pcp-prio 1de:1
> > > JSON    : {"pcp_prio":[["1de",1]]}  
> > 
> > Would the JSON be better as:
> >         { "pcp_prio" :[ { "1de":1 } ] }
> > 
> > It looks like the PCP values are both unique and used in a name/value manner.  
> 
> In this case I think it would be best to stay consistent with the rest
> of the dcb app code. All priority mappings are printed using the
> dcb_app_print_filtered() (now also the pcp-prio), which creates an
> array, for whatever reason. 
> 
> If you are OK with this, I will go ahead and create v4, with the print
> warning removed.
> 
> /Daniel

I am ok with what ever you decide, just wanted to make sure you thought about it
