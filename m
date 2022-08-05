Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D876B58A8C9
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 11:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbiHEJ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 05:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiHEJ1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 05:27:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 645E878235
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 02:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659691617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfuToroQyyfaR/ahFzb6T8E3ZKbXwRptm18OMFv0NxM=;
        b=FOZGckacqPybCjkg23lm7uYIsYjgIj5+z+wYaIN41mZ7cj6k01vNF+GPgCwc2nj+/PM8bg
        BqywkTGkc3m85yEC9VFwDUmiCOkrGkxm7+4T7vFa+1n6kcwoxY4/PFDK2625qLojZCZRMl
        WvVjFtwtA0NOOm74Z7jVNqwrTqP8PTQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-73-bk0BWwKQM725BFVb2AyQMQ-1; Fri, 05 Aug 2022 05:26:56 -0400
X-MC-Unique: bk0BWwKQM725BFVb2AyQMQ-1
Received: by mail-wm1-f71.google.com with SMTP id c66-20020a1c3545000000b003a37b7e0764so3938911wma.5
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 02:26:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc;
        bh=VfuToroQyyfaR/ahFzb6T8E3ZKbXwRptm18OMFv0NxM=;
        b=Ujg6WCfqPbA9vQa7Xd4f6FFmFJ+MIH3c3aX4lY8iR0GJUmNEwHqNlt2C3WqehHbyIU
         7va7zKE1oVMEc9WRzSimdVWRdZ6CIzsYGmhXu9y4VEoDqcbR0ZywzZMCo1pAEU+wVvgJ
         k2VI4uLF/YeOyD19opmwMYuihR2t6fAGidm6Y2O9f9WORsKPs9Pi+64Tshlm1Y/WthDk
         IN/JcSPExpzHNlwXWRlw4FLojSsa1y22ck10YSAlfi/CHiUx4GLtAEL1UpkXpI4b3jjd
         ZxYjQIVw3v4O4CF2CFDwJ5y5SkLBmeENGL5cQywZVZBWn/4KgLhX3agN+DzJYS2Go2lT
         IrVg==
X-Gm-Message-State: ACgBeo0xpRItIuKAht2EMaEc/CH6nz1EBXCuPam8eoTJdJWltp9DFMdJ
        TOTOaFwpgXfhfPO7iACbHF7dSMTSPLc3YJ8vZnOIJADHPG8IYMyZAny49yu4zIt5ACeq9hJnMC7
        q91ZpWbV+n57G2FUs
X-Received: by 2002:a05:6000:1102:b0:220:5c10:5cbe with SMTP id z2-20020a056000110200b002205c105cbemr3886607wrw.359.1659691614752;
        Fri, 05 Aug 2022 02:26:54 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7wqj06gg31jQS3M03BPkKpX4HeMsexNhDaurxi/7No6OjKOXdzdFq91+ukmJHOGEC+STXyhA==
X-Received: by 2002:a05:6000:1102:b0:220:5c10:5cbe with SMTP id z2-20020a056000110200b002205c105cbemr3886592wrw.359.1659691614561;
        Fri, 05 Aug 2022 02:26:54 -0700 (PDT)
Received: from 0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa (0.7.3.c.2.b.0.0.0.3.7.8.9.5.0.2.0.0.0.0.a.d.f.f.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:ffda:0:2059:8730:b2:c370])
        by smtp.gmail.com with ESMTPSA id p22-20020a05600c359600b003a31ca9dfb6sm6356606wmq.32.2022.08.05.02.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Aug 2022 02:26:53 -0700 (PDT)
Message-ID: <191529a93b7ef7afba1ae72a9519652f38b5d99e.camel@redhat.com>
Subject: Re: DECnet - end of a era!
From:   Steven Whitehouse <swhiteho@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Christine caulfield <ccaulfie@redhat.com>
Date:   Fri, 05 Aug 2022 10:26:52 +0100
In-Reply-To: <20220804075434.2379609a@hermes.local>
References: <9351fc12c5acc7985fc2ab780fe857a47b7d9610.camel@redhat.com>
         <20220804075434.2379609a@hermes.local>
Organization: Red Hat UK Ltd
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
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

Hi,

On Thu, 2022-08-04 at 07:54 -0700, Stephen Hemminger wrote:
> > Of course many others have contributed over the years, and we had a
> > lot
> > of support from the Linux network developers too. Many thanks to
> > all
> > who've helped along the way, we very much appreciate all the
> > assistance
> > that we've had. Alan Cox provided initial encouragement, with Davem
> > and
> > Alexey Kuznetsov later on, and with contributions from many
> > quarters
> > which were very gratefully received.
> > 
> > Farewell to the Linux DECnet stack :-)
> 
> So long and thanks for all the bits.
> 
> 
> Thanks, I was kind of hoping somebody was still using it and would
> jump in and volunteer to maintain it.
> 

Well we've been hoping that for years now, and eventually somebody has
to call time on it if that doesn't happen. It is a pity to see it go in
some ways, but I think it is probably the right thing in lieu of anyone
willing to take it on and maintain it,

Steve.


