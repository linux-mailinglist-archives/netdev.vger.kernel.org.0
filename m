Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B115EF86B
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbiI2PL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbiI2PLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:11:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2020E127CA6
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664464313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eQg2QfkQVZ0jprfAYqOiT7fU785X28/7syfVqOkQBBE=;
        b=QGxak3eETIJ468Tqmjf/70sLXCynaKJvuUmW+oFtOW4xVVbtxHmWtX4WTDuf3LkTeo8n57
        XpwgYkU0el+zUQt+IxOLx2oj8RVzNamMl+oFnD/t+P0dNamrb9WMGV0Mi/KXuUzwAJeA+K
        vWkxFuddsNIiRKgV0FaRy8Lj8I/rEdg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-313-8a1qz8LdNUCgOBpn2f5QFw-1; Thu, 29 Sep 2022 11:11:50 -0400
X-MC-Unique: 8a1qz8LdNUCgOBpn2f5QFw-1
Received: by mail-wr1-f69.google.com with SMTP id e28-20020adfa45c000000b0022cc7d071b4so658831wra.23
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=eQg2QfkQVZ0jprfAYqOiT7fU785X28/7syfVqOkQBBE=;
        b=lyNTIKXke2+G31LaXBy4Uxak8rppQPsyaM//XfgdWrC6Au9eX/TNG5i5dl21Kb6Q+x
         Qai77mL52DZ2M+eBMyrQHRoRZoSH1p9jum+bdI1nSC/i8kSzOs1IBtmIRJwGbQYCsY5R
         SgQTWXXiBhIoRJgtyDdfII5Mlh1AGVkyzPZ4wzF45N4sZgKORjZfe4DGIYse1qcBxode
         VkPRiMFbVaatApxJ0bQlDWXkjBZUbP81448tEfWvRRJVn6zKYVoELW6Rfp6VicO9uq+0
         HkianOgduOlC5EzZaEELziurD95i7gv1c+WF0VRIYVaj20YU5Qo4Avi1zUCclzB6y/le
         0chA==
X-Gm-Message-State: ACrzQf38wPJnmWyVGVxzrRxwLusWYnatKoso/NIcHy4JmmxcN8SFfNdK
        0WXftfSWEsxv8eaMVOLpcaKWfjcVSau5Ge2GQQxliWo5maOK0O3QBDhzuQQwUx3kB5ypTMmMwOX
        r2Na26WRD2bH3Jxa/
X-Received: by 2002:adf:d1e1:0:b0:22a:cd3e:e98b with SMTP id g1-20020adfd1e1000000b0022acd3ee98bmr2854184wrd.510.1664464309312;
        Thu, 29 Sep 2022 08:11:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM40SEhh/jXUYfsK06jNUKEyuaF4LmijkPg5kb0pZK+3AGDuUY4mw3WXtxrie697Z/+ZVxUv1Q==
X-Received: by 2002:adf:d1e1:0:b0:22a:cd3e:e98b with SMTP id g1-20020adfd1e1000000b0022acd3ee98bmr2854162wrd.510.1664464309144;
        Thu, 29 Sep 2022 08:11:49 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bq21-20020a5d5a15000000b0022afe4fb459sm7142572wrb.51.2022.09.29.08.11.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 08:11:48 -0700 (PDT)
Date:   Thu, 29 Sep 2022 17:11:45 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 1/6] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20220929151145.GC6761@localhost.localdomain>
References: <20220929011122.1139374-1-kuba@kernel.org>
 <20220929011122.1139374-2-kuba@kernel.org>
 <20220929133413.GA6761@localhost.localdomain>
 <20220929073224.2f3869ca@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929073224.2f3869ca@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 07:32:24AM -0700, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 15:34:13 +0200 Guillaume Nault wrote:
> > > +Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
> > > +to take effect.  
> > 
> > Do you mean that netlink commands should properly handle NLM_F_ECHO,
> > although they should also design their API so that users don't need it?
> 
> Yes, ECHO should be supported but as an extra, not something that
> is crucial to write a basic script without assuming full ownership 
> of the system...
> 
> IOW support the logging use case you mentioned but don't do the NEWLINK
> thing.
> 
> Should I clarify or rephrase? The ECHO section needs to be read with
> the one above it to get the full answer.

Maybe we can make this more explicit.
Something like:

-Having to rely on ``NLM_F_ECHO`` is a hack, not a valid design.
+Users shouldn't have to use ``NLM_F_ECHO`` to get a handle on the created
+object.

(or keep both sentences, I feel they fit well together).

Then maybe explain in the next section why support for NLM_F_ECHO is
desirable anyway:

 Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
-to take effect.
+to take effect. This is usefull for programs that need precise feedback from
+ the kernel (for example for logging purpose).

