Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 674335261A7
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 14:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380179AbiEMMRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 08:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380172AbiEMMRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 08:17:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 821965D18D
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 05:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652444222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ouGdyRe8UyIVf/HXw4oa1UwTNpHx7ZaHNy4q5Gp7oU0=;
        b=L6VDf5zWoO40B0lkVmYemHv4fRe4F5h8VnvpbiMQW52TCGgTQLA7SqmY4C8fZFNwV3eY2w
        3ponamE0RVnUTRaHxdQxMoBfw6xSZ+dFIp7HqWLva9C8fNrpXnZrfudn/NlDXHSNF1Dv+7
        oUNCaswZcvIXLjGvJiUUGcNK1NN1Odg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-cDTIlksBOriIPshuDzwFBQ-1; Fri, 13 May 2022 08:16:59 -0400
X-MC-Unique: cDTIlksBOriIPshuDzwFBQ-1
Received: by mail-wm1-f72.google.com with SMTP id c125-20020a1c3583000000b0038e3f6e871aso2858606wma.8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 05:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ouGdyRe8UyIVf/HXw4oa1UwTNpHx7ZaHNy4q5Gp7oU0=;
        b=MeTTM63q1avBo6PTKwPPGVFUKtaCc6Oj3UnUNPmaG2pfbuwa4ilmF0RpKOUZDkTq9W
         PUADcg6TF51GUoNjvyOGGp7HX+ycol1RPE0/dNd55fErMPjpgaGMhL847+UQm3KZVWHs
         bHff17NMngPDXMtp0VJFk3CnKKRwwNyOQ6WvgS3+ou8ru4N4f4ssSrepWUYnDca2MrmY
         FKGzYq/LBLMnPw5OuvQNpFXfgAOvhckrnr8W+/AzPO/VBM+X66L174ghvmMqcchybG7S
         rD6S0ie4nsuEiLcQZSYSKYwnrZZ/+10HDeyqyktS8J2D9X18uAYeOzovl2o8n32oorlU
         Ze3g==
X-Gm-Message-State: AOAM531C1ClcugI9C2ZN9P53YudqKuMlm/pfxCU+8HTOGFhQl6TS17lY
        3EZWBwSEQ9K7viu0TSDHNtCx/jqzyRVwn8QwfBPiUBYksu+ttqg4cWB9tvK+4wpO7gbc9ZpQkd4
        DpiHLNgZv5aXhJU2M
X-Received: by 2002:a05:600c:358c:b0:394:8522:e28 with SMTP id p12-20020a05600c358c00b0039485220e28mr4317114wmq.92.1652444218260;
        Fri, 13 May 2022 05:16:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwcCkLBgswrm9r0RR11RPAgrWbq6nMU8hzJ6+dShUaXBgNrjxY30r+aEHSeNuC11eC8S0NYpw==
X-Received: by 2002:a05:600c:358c:b0:394:8522:e28 with SMTP id p12-20020a05600c358c00b0039485220e28mr4317096wmq.92.1652444218049;
        Fri, 13 May 2022 05:16:58 -0700 (PDT)
Received: from redhat.com ([2.53.15.195])
        by smtp.gmail.com with ESMTPSA id r15-20020a7bc08f000000b00394615cf468sm5266090wmh.28.2022.05.13.05.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 05:16:57 -0700 (PDT)
Date:   Fri, 13 May 2022 08:16:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <20220513081456-mutt-send-email-mst@kernel.org>
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
 <Ynuq9wMtJKBe8WOk@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ynuq9wMtJKBe8WOk@8bytes.org>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 02:24:23PM +0200, Jörg Rödel wrote:
> On Tue, May 10, 2022 at 11:23:11AM -0700, Linus Torvalds wrote:
> > And - once again - I want to complain about the "Link:" in that commit.
> 
> I have to say that for me (probably for others as well) those Link tags
> pointing to the patch submission have quite some value:
> 
> 	1) First of all it is an easy proof that the patch was actually
> 	   submitted somewhere for public review before it went into a
> 	   maintainers tree.
> 
> 	2) The patch submission is often the entry point to the
> 	   discussion which lead to this patch. From that email I can
> 	   see what was discussed and often there is even a link to
> 	   previous versions and the discussions that happened there. It
> 	   helps to better understand how a patch came to be the way it
> 	   is. I know this should ideally be part of the commit message,
> 	   but in reality this is what I also use the link tag for.
> 
> 	3) When backporting a patch to a downstream kernel it often
> 	   helps a lot to see the whole patch-set the change was
> 	   submitted in, especially when it comes to fixes. With the
> 	   Link: tag the whole submission thread is easy to find.
> 
> I can stop adding them to patches if you want, but as I said, I think
> there is some value in them which make me want to keep them.
> 
> Regards,
> 
> 	Joerg

Yea, me too ... Linus, will it be less problematic if it's a different
tag, other than Link? What if it's Message-Id: <foo@bar>? Still a
problem?


-- 
MST

