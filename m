Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C4A631DE0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiKUKMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbiKUKMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:12:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8691AFAED
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669025471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NwLjb0E2762mkBoRuKP5ZO/x2E2Yg04BUzrNFBoai9w=;
        b=ZLpKgzlFGZV/H7T1QT7oJc+wTz7c5+tfsKiBhyuxI6tV7xMMxyrHIkzMm6A0yxPu1LxuL1
        2M5Dqx3dUzdQJwQQBWhB5KALf/7h4nhbQIYNr9Zj1+wuC+P6qtJUE7TPxKMXcuM2W7HAvs
        5/bBI5qQGdHMlmNWKfMEIL75OkaXAFg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-561-17Yrc-9MO8yjH_f3EN9Apw-1; Mon, 21 Nov 2022 05:11:09 -0500
X-MC-Unique: 17Yrc-9MO8yjH_f3EN9Apw-1
Received: by mail-qk1-f197.google.com with SMTP id u5-20020a05620a0c4500b006fb30780443so15277777qki.22
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 02:11:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NwLjb0E2762mkBoRuKP5ZO/x2E2Yg04BUzrNFBoai9w=;
        b=qPMaQRXD0zwg7uX8CfGatOzC6jPsN6TIxMFY4X7HUIsNbLvtZ3WXzwhN1c6k98nCzf
         Oz8mSZ5O24fggRqYhmeTAgO1PKLWpu6aEc/NbCuOgTkeqws4FOpVjMevH4ORXdxCfrFJ
         zuqczOzlVA5nFjQDZ1OBJAyfnbAI+xGDQofLhay8PqwgbEMvxNtRVLtM7rhnqBLGGabF
         LcpxFK8InHa5Mzed/s74I9ARb9PYFiOh5f4/p5OtwZt7BMF76AWn3RcLd+4LsgdGtd/v
         xHDi/cxqigGOvWrdRiuDLkq4K10BErYAUCD/YRCOIXQHXqU5m5sSCowvhP4R7mm8v6pM
         9HLw==
X-Gm-Message-State: ANoB5pmIPqkJKgXNsvaWAdHTxLtzYM/jrv5mnvDbVROm2pmPeH2j8qzR
        k3sTAzPV5z+ieZ+wxlqcwVDhL85wrcIrq7RBFc6osMup4ec/V3TQ44E7iFKIUDc9S4x5Z5k06Sk
        THqGctTu9yPstdtk5
X-Received: by 2002:a37:5885:0:b0:6fa:1ef8:49dc with SMTP id m127-20020a375885000000b006fa1ef849dcmr15618251qkb.314.1669025469503;
        Mon, 21 Nov 2022 02:11:09 -0800 (PST)
X-Google-Smtp-Source: AA0mqf71eq5OjrF2ILYGHiO1RNCvRVc/hZiNHJD5N51HaDY3vkNB/0Mm+r5QjLEFpRdkiy8bI24xmA==
X-Received: by 2002:a37:5885:0:b0:6fa:1ef8:49dc with SMTP id m127-20020a375885000000b006fa1ef849dcmr15618235qkb.314.1669025469169;
        Mon, 21 Nov 2022 02:11:09 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id t7-20020a37ea07000000b006fa2cc1b0fbsm7906162qkj.11.2022.11.21.02.11.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 02:11:08 -0800 (PST)
Message-ID: <eebf1c5ae11db046256eeb1aa287a0019adc3606.camel@redhat.com>
Subject: Re: [PATCH net-next 0/2] veth: a couple of fixes
From:   Paolo Abeni <pabeni@redhat.com>
To:     Heng Qi <hengqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Date:   Mon, 21 Nov 2022 11:11:05 +0100
In-Reply-To: <ce5fe56b-bf1b-71c0-1e96-cff6fde40ff3@linux.alibaba.com>
References: <cover.1668727939.git.pabeni@redhat.com>
         <edc73e5d5cdb06460aea9931a6c644daa409da48.camel@redhat.com>
         <1669001595.7554848-1-xuanzhuo@linux.alibaba.com>
         <ce5fe56b-bf1b-71c0-1e96-cff6fde40ff3@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-11-21 at 11:55 +0800, Heng Qi wrote:
> 在 2022/11/21 上午11:33, Xuan Zhuo 写道:
> > On Fri, 18 Nov 2022 09:41:05 +0100, Paolo Abeni <pabeni@redhat.com> wrote:
> > > On Fri, 2022-11-18 at 00:33 +0100, Paolo Abeni wrote:
> > > > Recent changes in the veth driver caused a few regressions
> > > > this series addresses a couple of them, causing oops.
> > > > 
> > > > Paolo Abeni (2):
> > > >    veth: fix uninitialized napi disable
> > > >    veth: fix double napi enable
> > > > 
> > > >   drivers/net/veth.c | 6 ++++--
> > > >   1 file changed, 4 insertions(+), 2 deletions(-)
> > > @Xuan Zhuo: another option would be reverting 2e0de6366ac1 ("veth:
> > > Avoid drop packets when xdp_redirect performs") and its follow-up
> > > 5e5dc33d5dac ("bpf: veth driver panics when xdp prog attached before
> > > veth_open").
> > >  option would be possibly safer, because I feel there are other
> > > issues with 2e0de6366ac1, and would offer the opportunity to refactor
> > > its logic a bit: the napi enable/disable condition is quite complex and
> > > not used consistently mixing and alternating the gro/xdp/peer xdp check
> > > with the napi ptr dereference.
> > > 
> > > Ideally it would be better to have an helper alike
> > > napi_should_be_enabled(), use it everywhere, and pair the new code with
> > > some selftests, extending the existing ones.
> > > 
> > > WDYT?
> > I take your point.
> 
> I'll rewrite a patch as soon as possible and resubmit it.

Could you please first send the revert?

Thanks!

Paolo

