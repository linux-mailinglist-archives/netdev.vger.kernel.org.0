Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F23351A355
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351782AbiEDPPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbiEDPPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3CDB82898D
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 08:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651677091;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BkylOVWAmR6RBBpyZ1dVO9U8LRiKZ5t1MzDmPxwV1VU=;
        b=jNn6Qmu2JCspCN3QHTaYnxG4c2FCSG84W+CDtOjqn+sgJ74za6KXVNpDMmJDHwv2kgOCv0
        MX8pXUuVXkwVBbB+a8cIYRHr30HmpoT93ESmknDpJx9GYUG3kiW8sB3PnN0fDz9LScP7ao
        yyCovebabSj/VfUv4goC2mT+acuoW/I=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-54-0q9JiiaXNEGmP6ztuuTGfw-1; Wed, 04 May 2022 11:11:30 -0400
X-MC-Unique: 0q9JiiaXNEGmP6ztuuTGfw-1
Received: by mail-qv1-f72.google.com with SMTP id d13-20020a05621421cd00b0045a99874ae5so1069769qvh.14
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 08:11:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=BkylOVWAmR6RBBpyZ1dVO9U8LRiKZ5t1MzDmPxwV1VU=;
        b=LbLrtuXE+pjfsXQkehpvHw4RCli9KaUHac2qA8IZWy+Ny+9pCTOEWzdXBqlV+gp3Db
         VWwlWcaoTFfoQoIpk6LqG77E+rWmz5tc/8CXm+RgJw0S+GK4dytXdWc5/oBIza4x8VmO
         xBilgvFrWA1Gq8MIhzd4qa2QnpE6ytYx1M0C+yVsd3EcRqk3KVgjZA5mW3ZgnI10Loeu
         khlAfphdnnPAZOJHlX5MNN7a/8p6wHN3ZNHGqA5JZuAym/CIb7/8/kz64G9xQf55Q0Im
         vR0X6peWLUQJx16mSVSAugFsSRGDzrPKUCDKybtWcGm7GV+b6oGqKDXDL50kzyLsZ5lw
         qC/Q==
X-Gm-Message-State: AOAM532SLlFVgEO2pkjfOQEvErU/EWpo3uapIiZWbkK8KHQCNnwZmzzx
        rkV1kCVJRHzAzl3AotWZZM8JQYnjjdaupShdS6BfUnpa6utc3AtNW8FHbnAxJmo4zjSqwROyPkx
        VG/u4U+WLSiqbbT28
X-Received: by 2002:a05:622a:1213:b0:2f3:a79a:2ccc with SMTP id y19-20020a05622a121300b002f3a79a2cccmr11957456qtx.376.1651677089608;
        Wed, 04 May 2022 08:11:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxa+DaVJAfFN0UoYefqAkzq7A3HJG0WjmWUFxRfqURf2l+JIcv/x5k5MOkPr/D+KNWQXjvOwQ==
X-Received: by 2002:a05:622a:1213:b0:2f3:a79a:2ccc with SMTP id y19-20020a05622a121300b002f3a79a2cccmr11957426qtx.376.1651677089333;
        Wed, 04 May 2022 08:11:29 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-115-66.dyn.eolo.it. [146.241.115.66])
        by smtp.gmail.com with ESMTPSA id w4-20020a05620a128400b0069fc6484c06sm7080847qki.23.2022.05.04.08.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:11:28 -0700 (PDT)
Message-ID: <a8abc239076eb96ed88680dab1a1abe50a5dac7b.camel@redhat.com>
Subject: Re: [PATCH net] net/sched: act_pedit: really ensure the skb is
 writable
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Date:   Wed, 04 May 2022 17:11:25 +0200
In-Reply-To: <20220504074718.146a5724@kernel.org>
References: <6c1230ee0f348230a833f92063ff2f5fbae58b94.1651584976.git.pabeni@redhat.com>
         <7e4682da-6ed6-17cf-8e5a-dff7925aef1d@mojatatu.com>
         <cac58f4ead1cac145d5a2005bcd3556851807f86.camel@redhat.com>
         <20220504074718.146a5724@kernel.org>
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

On Wed, 2022-05-04 at 07:47 -0700, Jakub Kicinski wrote:
> On Wed, 04 May 2022 10:52:59 +0200 Paolo Abeni wrote:
> > On Tue, 2022-05-03 at 16:10 -0400, Jamal Hadi Salim wrote:
> > > What was the tc pedit command that triggered this?  
> > 
> > From the mptcp self-tests, mptcp_join.sh:
> > 
> > tc -n $ns2 filter add dev ns2eth$i egress \
> > 		protocol ip prio 1000 \
> > 		handle 42 fw \
> > 		action pedit munge offset 148 u8 invert \
> > 		pipe csum tcp \
> > 		index 100 || exit 1
> > 
> > It's used to corrupt a packet so that TCP csum is still correct while
> > the MPTCP one is not.
> > 
> > The relevant part is that the touched offset is outside the skb head.
> > 
> > > Can we add it to tdc tests?  
> > 
> > What happens in the mptcp self-tests it that an almost simultaneous
> > mptcp-level reinjection on another device using the same cloned data
> > get unintentionally corrupted and we catch it - when it sporadically
> > happens - via the MPTCP mibs.
> > 
> > While we could add the above pedit command, but I fear that a
> > meaningful test for the issue addressed here not fit the tdc
> > infrastructure easily.
> 
> For testing stuff like this would it be possible to inject packets
> with no headers pulled and frags in pages we marked read-only?
> We can teach netdevsim to do it.

We additionally need to ensure that the crafted packets are cloned,
otherwise the current code is AFAICS fine. And at the point we likely
want to configure the packet layout (hdrs/address) created by
netdevsim. 

> Obviously not as a pre-requisite for this patch.

I agree it looks a bit out-of-scope here ;)

Paolo 

