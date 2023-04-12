Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E38A36E0119
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjDLVnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDLVnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:43:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA5BD1993
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681335743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UUfDZnIWOthneXGTaILvqN+i7MqHfilowJVWxFfgEBY=;
        b=ZehJzCDu6aTMj/P5BjnhLvg43ASlX/Byxgvt2Vw8sISnLHQxwDLdPVzewK3MNHvtpVf01Z
        IdiKU3ALlPYIEsqUAe0/dBugCLUIm2rMoEJWzvkwyyU5uYXFWZbgvR+Edli+mneJHapf7z
        6PZbnrdiW8SXHegfb81yxvU93/gzjLs=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518--LoepB1tP2OM4bYrWJQ5vQ-1; Wed, 12 Apr 2023 17:42:19 -0400
X-MC-Unique: -LoepB1tP2OM4bYrWJQ5vQ-1
Received: by mail-qk1-f199.google.com with SMTP id p63-20020a374242000000b007468eaf866aso16940563qka.17
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 14:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335739; x=1683927739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUfDZnIWOthneXGTaILvqN+i7MqHfilowJVWxFfgEBY=;
        b=MK5mdZPpHdvOZMfeuNJOOJlc1Qf1OZPC2JtA2Uv3tDmlTGIXJ79Dwn/9Iu6qH4BZpS
         YDtTyNirWKnxHKFsorJ1p5XhwaY207Masd1mUXLtzJ2IoD+vYasWsV3QrPeyal8Qrot3
         5+DVhzF9ahdstQ1NVjGfHDIeqMm/mXcZM/I7ZXej7V/xAy6DdiC5fh+HdA2VSQkdajcK
         n0ESbN/y+OnFIRAG6XIOStMCSZ/U3wtdL5xWGhwfV5JqBB6osXSfDK76taNoJO4E5kB2
         s7usu/GjGLDQD4VxY4C+j4eX7I83vZn85OMA3+zyOSDfODz0EgwYgmYLB2CwGSJlTffB
         vj7g==
X-Gm-Message-State: AAQBX9eM/fJCAj5nnYBtvCswfq4ajtbISHJvQCHQ/92sv4qqP+VwR/0+
        E/dKVuzKP0Z2VW/UaaCY4ycIW5eJEaq+R2k/aoYY7IvPkHcXdO+Z/JmjdAM928QxrSQOzC5l2M0
        LkZGW8Da/SgXZ1sgq
X-Received: by 2002:a05:6214:19ca:b0:5ef:4c5e:fbd6 with SMTP id j10-20020a05621419ca00b005ef4c5efbd6mr17718qvc.44.1681335738825;
        Wed, 12 Apr 2023 14:42:18 -0700 (PDT)
X-Google-Smtp-Source: AKy350aedoJE2OhbKEiERyNNZb3nilwXG9zAv/ua6apRg188tSD4ottZKmCfa7svkYQqj2mRhyiVQA==
X-Received: by 2002:a05:6214:19ca:b0:5ef:4c5e:fbd6 with SMTP id j10-20020a05621419ca00b005ef4c5efbd6mr17694qvc.44.1681335738587;
        Wed, 12 Apr 2023 14:42:18 -0700 (PDT)
Received: from debian ([2001:4649:fcb8:0:eefe:db50:3cfa:deab])
        by smtp.gmail.com with ESMTPSA id u5-20020a0cee85000000b005dd8b9345bdsm5165491qvr.85.2023.04.12.14.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 14:42:18 -0700 (PDT)
Date:   Wed, 12 Apr 2023 23:42:14 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Martin Willi <martin@strongswan.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] rtnetlink: Restore RTM_NEW/DELLINK notification
 behavior
Message-ID: <ZDcltmGmTr6XOlsN@debian>
References: <20230411074319.24133-1-martin@strongswan.org>
 <ZDUtwwNBLfDuo9dq@Laptop-X1>
 <ec3a6209cdb2bc42e3af457fcee92de92eae9e6d.camel@strongswan.org>
 <ZDavJCLutKC/+oHZ@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDavJCLutKC/+oHZ@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 09:16:20PM +0800, Hangbin Liu wrote:
> On Wed, Apr 12, 2023 at 11:21:33AM +0200, Martin Willi wrote:
> > Hi,
> > 
> > > > Fixes: f3a63cce1b4f ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_delete_link")
> > > > Fixes: d88e136cab37 ("rtnetlink: Honour NLM_F_ECHO flag in rtnl_newlink_create")
> > > > Signed-off-by: Martin Willi <martin@strongswan.org>
> > > 
> > > Not sure if the Fixes tag should be
> > > 1d997f101307 ("rtnetlink: pass netlink message header and portid to rtnl_configure_link()")
> > 
> > While this one adds the infrastructure, the discussed issue manifests
> 
> Yes
> 
> > only with the two commits above. Anyway, I'm fine with either, let me
> > know if I shall change it.
> 
> In my understanding the above 2 commits only pass netlink header to
> rtnl_configure_link. The question code in 1d997f101307 didn't check if
> NLM_F_ECHO is honoured, as your commit pointed.

That's right, but personally I find it clearer to cite the commits that
brought the actual behaviour change.

> Thanks
> Hangbin
> 

