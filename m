Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73E7A58A8C1
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240562AbiHEJYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 05:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240600AbiHEJYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 05:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 882927822D
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 02:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659691459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=93roYeWayj4gr2/xAIvNWLsM3jylcU1Sy7fl13QiCUY=;
        b=EC1ED97F7yGi2d+SgqbEy2fguoYkNQISi0JADC6ied5GV3SSsJ+JJkFO7xN6YsK6DE0ka1
        SucapNnz5yDHEOXYblistJhQYKiady50oRh7d+rQFdYcpkAMiSt7JrVWFZ9jiP1dP0WCEo
        DwtBQurVJ341qkgyg6KZFFpE0UaaPa8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-50-3fF77WJZMqmdEpd2-SwPCQ-1; Fri, 05 Aug 2022 05:24:18 -0400
X-MC-Unique: 3fF77WJZMqmdEpd2-SwPCQ-1
Received: by mail-wm1-f70.google.com with SMTP id d10-20020a05600c34ca00b003a4f0932ec3so3967692wmq.0
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 02:24:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc;
        bh=93roYeWayj4gr2/xAIvNWLsM3jylcU1Sy7fl13QiCUY=;
        b=aPapQF7ZfZbjlGbHmP7woQ4KD3FMqVpNwdWaS9ployaQT5cbbJRXzH/ocyPD1r4dvh
         LGqgzHUU8kv25Dv4bsLieHMd4uZOkCS9rpcUewfm8lOGJiJl0Qi5ThXQtrXiT+HP5mEz
         zfot3+FYcps4fI1Yd3mUdNtKSvoSaV51eVJbIS4M0NtKDi+ZMlZT460p4XZXsGtdzimJ
         IwUrOW+yEtinr8F2Z4xQpMjSq6fbvDq3qY6hSbk8l9ZwPA7TwHyUsd3vAqHyz9WlHmD4
         poZqI2/3cmohgMBV3H/+pYxmj1cqCxHKv7gtaRatD6KlBg4Pf0zp4BVJydhVlDOoYBjz
         U8kg==
X-Gm-Message-State: ACgBeo1ok/sIKDMIl6kYhgy1EXRrCb1K5bVPKnexFtWPfW+IB6UCXuSm
        O6lHE2zOIpTSyycU1vncO0f4fRgyEg4zUIK0cwE+D5Rwuaap4tIH60S3H0VcNXcfrxp5eiOYt9a
        d2d1sIRBW8LM/4Fmu
X-Received: by 2002:a05:600c:384e:b0:3a4:f9e9:3407 with SMTP id s14-20020a05600c384e00b003a4f9e93407mr3929556wmr.177.1659691456358;
        Fri, 05 Aug 2022 02:24:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4yFEQ1bMKOq9nDBEsDH4+OUesoAWHNM6/ZZ0Cfe7O0+5BGdWHdOsoMq7w1WjfaEdrKA+cx5g==
X-Received: by 2002:a05:600c:384e:b0:3a4:f9e9:3407 with SMTP id s14-20020a05600c384e00b003a4f9e93407mr3929547wmr.177.1659691456152;
        Fri, 05 Aug 2022 02:24:16 -0700 (PDT)
Received: from 0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa (0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:ffda:0:2059:8730:b2:c370])
        by smtp.gmail.com with ESMTPSA id u11-20020a05600c19cb00b003a302fb9df7sm9120812wmq.21.2022.08.05.02.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 02:24:15 -0700 (PDT)
Message-ID: <6e86e31d1872a117c926afa099c7d14f9b11a1ba.camel@redhat.com>
Subject: Re: DECnet - end of a era!
From:   Steven Whitehouse <swhiteho@redhat.com>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Christine caulfield <ccaulfie@redhat.com>
Date:   Fri, 05 Aug 2022 10:24:14 +0100
In-Reply-To: <20220804132803.GA428101@francesco-nb.int.toradex.com>
References: <9351fc12c5acc7985fc2ab780fe857a47b7d9610.camel@redhat.com>
         <20220804132803.GA428101@francesco-nb.int.toradex.com>
Organization: Red Hat UK Ltd
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-08-04 at 15:28 +0200, Francesco Dolcini wrote:
> On Thu, Aug 04, 2022 at 11:19:27AM +0100, Steven Whitehouse wrote:
> > Still, it would be shame to let that happen without mentioning
> > some of the applications to which we have, over the time it was
> > functional, that people have used it for...
> 
> You should contribute a couple of lines to the CREDITS file in
> addition
> to this email ! :-)
> 
> Francesco
> 

I'm already listed there, but if others want to add themselves then
that seems reasonable to me,

Steve.


