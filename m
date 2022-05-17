Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6EA529C9B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243419AbiEQIfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241839AbiEQIfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:35:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5C9C43AC8
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652776535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9Q3Ybr/A+KH6Q6IRTVG7OKDqcb8C3K/4ZYVZVJz/JQ=;
        b=i6iaUILcj/Y6+MdyLUIaCaxHFgYuqXWyBsh4eK2v6BxVQ4uJvYL54xo6soSUAmw6go8kVN
        DEy9lZtZ+moU7kDqWeum72cqjn+N/4x4kE7S5BZNsya5lcsaEMDHghG4z9Es5Scy3rmum0
        YwcNeIGzXmQ1Njk6VtcP2p5FEMIZGo4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-hAQSX4MsO3K0Cw3YU_kRrQ-1; Tue, 17 May 2022 04:35:29 -0400
X-MC-Unique: hAQSX4MsO3K0Cw3YU_kRrQ-1
Received: by mail-wr1-f69.google.com with SMTP id o13-20020adfa10d000000b0020c6fa5a77cso4394941wro.23
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:35:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=R9Q3Ybr/A+KH6Q6IRTVG7OKDqcb8C3K/4ZYVZVJz/JQ=;
        b=uhaqWloE2K7lrIwS1bzgrqGul7w3/i/jzpmN6QKX2UXeL6ji3wd4JqvDiwG0cCIKqp
         N8JDP0BeDmZEd35CXY7gwgQvh9cTore1+7NvPr7LFG+624rO/koZVZ5kG20FStX7PjNN
         1KytMMOMzmOGCRcBtuxu0KJ6dqY5bEU9TgijUYY66ahGjscSWM/uHv66EAKXlVJv+ZFT
         cXeRiAgOHJGoHd+72Xn+Si8JHzcdO4zuAZHZ/iJwD5g7HqQVrAj5096XJfMvttrrmt4O
         KjTs4KrvEl93G0qk7s+ewZW+WMfD0R8shZWx6kZGBvVxfoEri0du+VmPkDMkCAFu2hJK
         +LwA==
X-Gm-Message-State: AOAM530f1gfJ0mxgxp9x8U5z3h8ea57ptPwrvTnpIvKpWLTof/1lp7G3
        XoDl5dPKxyVMGs4tj/3L+8frmo0WPHMaU8dJhTXzv3t9v+qZKKoAehGI0if7gmVdpMMlP9XIe8M
        7Gwtd67yiOZVdx03a
X-Received: by 2002:a05:6000:18ab:b0:20c:8d82:52c3 with SMTP id b11-20020a05600018ab00b0020c8d8252c3mr17376049wri.701.1652776527979;
        Tue, 17 May 2022 01:35:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynNDaHlWT281tDMJcjSUvSYFm6lWCzrbIbx4uNhf1j1RzE3YF7n118/uFtQmBSHPZ318R+hg==
X-Received: by 2002:a05:6000:18ab:b0:20c:8d82:52c3 with SMTP id b11-20020a05600018ab00b0020c8d8252c3mr17376026wri.701.1652776527671;
        Tue, 17 May 2022 01:35:27 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id q4-20020adf9dc4000000b0020c6b78eb5asm11047086wre.68.2022.05.17.01.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:35:27 -0700 (PDT)
Message-ID: <eec880be771e75d60ead01cbf71d83fe070ccde8.camel@redhat.com>
Subject: Re: [PATCH 2/2] octeon_ep: Fix irq releasing in the error handling
 path of octep_request_irqs()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Veerasenareddy Burru <vburru@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Satananda Burla <sburla@marvell.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Date:   Tue, 17 May 2022 10:35:26 +0200
In-Reply-To: <20220517052859.GN4009@kadam>
References: <cover.1652629833.git.christophe.jaillet@wanadoo.fr>
         <a1b6f082fff4e68007914577961113bc452c8030.1652629833.git.christophe.jaillet@wanadoo.fr>
         <20220517052859.GN4009@kadam>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-17 at 08:28 +0300, Dan Carpenter wrote:
> On Sun, May 15, 2022 at 05:56:45PM +0200, Christophe JAILLET wrote:
> > For the error handling to work as expected, the index in the
> > 'oct->msix_entries' array must be tweaked because, when the irq are
> > requested there is:
> > 	msix_entry = &oct->msix_entries[i + num_non_ioq_msix];
> > 
> > So in the error handling path, 'i + num_non_ioq_msix' should be used
> > instead of 'i'.
> > 
> > The 2nd argument of free_irq() also needs to be adjusted.
> > 
> > Fixes: 37d79d059606 ("octeon_ep: add Tx/Rx processing and interrupt support")
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> > I think that the wording above is awful, but I'm sure you get it.
> > Feel free to rephrase everything to have it more readable.
> > ---
> >  drivers/net/ethernet/marvell/octeon_ep/octep_main.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > index 6b60a03574a0..4dcae805422b 100644
> > --- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > +++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
> > @@ -257,10 +257,12 @@ static int octep_request_irqs(struct octep_device *oct)
> >  
> >  	return 0;
> >  ioq_irq_err:
> > +	i += num_non_ioq_msix;
> >  	while (i > num_non_ioq_msix) {
> 
> This makes my mind hurt so badly.  Can we not just have two variables
> for the two different loops instead of re-using i?
> 
> >  		--i;
> >  		irq_set_affinity_hint(oct->msix_entries[i].vector, NULL);
> > -		free_irq(oct->msix_entries[i].vector, oct->ioq_vector[i]);
> > +		free_irq(oct->msix_entries[i].vector,
> > +			 oct->ioq_vector[i - num_non_ioq_msix]);
> >  	}
> 
> ioq_irq_err:
>         while (--j >= 0) {
>                 ioq_vector = oct->ioq_vector[j];
>                 msix_entry = &oct->msix_entries[j + num_non_ioq_msix];
> 
>                 irq_set_affinity_hint(msix_entry->vector, NULL);
>                 free_irq(msix_entry->vector, ioq_vector);
>         }
> 
> regards,
> dan carpenter

I agree the above would be more readable. @Christophe: could you please
refactor the code as per Dan's suggestion?

Thanks!

Paolo

