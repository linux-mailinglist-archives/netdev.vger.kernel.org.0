Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F07D262EFCA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiKRImP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241047AbiKRImO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:42:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65BD248F9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668760871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VxJK3krzQCXprKpSThdN9LgrB2uKPe//SEcroxij9ZU=;
        b=HQxN7/wuqHLcG4oYKbjTKjk7OD4VucjTiE2DfRjlsJRHjIjnZJOacgzJMaYb5X5Mr+6BEe
        LAuVd6+9TA6ALJ65CXV+3fQMw0rDvev3K03m/BaDl/SbmP4t2+ONmtYSfjYEpoPZpEWjYo
        EGyB7nUay8aas91GYsrKWCj21d5AkM8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-552-teWK0dVDM2On6oT5iyz_GA-1; Fri, 18 Nov 2022 03:41:10 -0500
X-MC-Unique: teWK0dVDM2On6oT5iyz_GA-1
Received: by mail-qk1-f197.google.com with SMTP id i17-20020a05620a249100b006fa2e10a2ecso5338797qkn.16
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:41:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VxJK3krzQCXprKpSThdN9LgrB2uKPe//SEcroxij9ZU=;
        b=Z5bC9TJjRs2kdz/mL2pLOtjceO1Mved6l9ssXSwa86Ar0/EJ/q24A+4m5/NSMHaPod
         jeMTPwVGqBZQ+rTeeaqiAkC9zfq4owL3oAffkxfNmJDEnyLK2yrDAOhKQhyS4/UHAzR8
         wvrbGsOnytUHuIkah+GmbUdOVizTILSciF8ZsrD9d2rioAyjwrWJZOTEiCgFrz7D6jst
         4mes7FvfjtfL5vQZ2Paip4llSDLMoDckb531qGcsjY4QxcFdgxw2jtiFqXhi0rF/ku+z
         wrV1Ql5ltDz5HlY1lPeQ5V1NkZlaTjtzZngVx1rOtUPyyaujfeVBhbzauRwJkxaTFXi6
         jAhQ==
X-Gm-Message-State: ANoB5plHwVBeA02wY+aivUDBRJ+/WgprbgrImRw82PcDCsI8vUjDgqfK
        bX6ys+JSaCW/Ce3A81WCGOJcFFWXnlvVHqUCy3aWFYtwU92A5NFNm+eCbg5ltgIC4CO2lZEqVCR
        kR7pPPOgem8hyN4z08lYC7UhLEabxu0tv8kzwkXedJVVL+doMl43LcjUzJRGpZxrgFg==
X-Received: by 2002:a0c:f743:0:b0:4c6:9351:275d with SMTP id e3-20020a0cf743000000b004c69351275dmr1828193qvo.90.1668760869618;
        Fri, 18 Nov 2022 00:41:09 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7oOB2nAVCvhAexKIF8st6wvz6YOcC6GooAQ6ZLPt6aBI0l4EIRWQZpIddj4H81Kdruo53/GQ==
X-Received: by 2002:a0c:f743:0:b0:4c6:9351:275d with SMTP id e3-20020a0cf743000000b004c69351275dmr1828177qvo.90.1668760869339;
        Fri, 18 Nov 2022 00:41:09 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id e9-20020ac81309000000b003a56796a764sm1692590qtj.25.2022.11.18.00.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 00:41:08 -0800 (PST)
Message-ID: <edc73e5d5cdb06460aea9931a6c644daa409da48.camel@redhat.com>
Subject: Re: [PATCH net-next 0/2] veth: a couple of fixes
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Heng Qi <henqqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Date:   Fri, 18 Nov 2022 09:41:05 +0100
In-Reply-To: <cover.1668727939.git.pabeni@redhat.com>
References: <cover.1668727939.git.pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-18 at 00:33 +0100, Paolo Abeni wrote:
> Recent changes in the veth driver caused a few regressions
> this series addresses a couple of them, causing oops.
> 
> Paolo Abeni (2):
>   veth: fix uninitialized napi disable
>   veth: fix double napi enable
> 
>  drivers/net/veth.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

@Xuan Zhuo: another option would be reverting 2e0de6366ac1 ("veth:
Avoid drop packets when xdp_redirect performs") and its follow-up
5e5dc33d5dac ("bpf: veth driver panics when xdp prog attached before
veth_open").

That option would be possibly safer, because I feel there are other
issues with 2e0de6366ac1, and would offer the opportunity to refactor
its logic a bit: the napi enable/disable condition is quite complex and
not used consistently mixing and alternating the gro/xdp/peer xdp check
with the napi ptr dereference.

Ideally it would be better to have an helper alike
napi_should_be_enabled(), use it everywhere, and pair the new code with
some selftests, extending the existing ones.

WDYT?

Side notes:
- Heng Qi address is bouncing 
- the existing veth self-tests would have caught the bug addressed
here, if commit afef88e65554 ("selftests/bpf: Store BPF object files
with .bpf.o extension") would not have broken them meanwhile :(

/P

