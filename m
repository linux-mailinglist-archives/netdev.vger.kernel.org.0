Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AD95429F4
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiFHIxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbiFHIws (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:52:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06E1137B537
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 01:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654675870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XqmyY+Jyf36estD3tB3kDr9KkDNvChj6A4+inMFN+qQ=;
        b=e+xvIfbsyy9G74PrHOz+3U1DxLxc2ru5coezSHyo/Di42g5iLY9rMHQKNHhifjx8dlaOd3
        3rGJ90FKWOScLge2vZ71WDg5gv/oSZJhtzUEKemIYkvn9nt1ZRtXHbc3ixRkuKHckzZZxX
        cmJjTmtinoaOQmC36KOQrNmKjtcGWZ8=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-l1nsfXL0NAOx_oA3TU2k_g-1; Wed, 08 Jun 2022 04:11:09 -0400
X-MC-Unique: l1nsfXL0NAOx_oA3TU2k_g-1
Received: by mail-qv1-f70.google.com with SMTP id jo22-20020a056214501600b004646309a886so12526706qvb.2
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 01:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XqmyY+Jyf36estD3tB3kDr9KkDNvChj6A4+inMFN+qQ=;
        b=BPnYgJyLObrR0S16DLh1nOExTAaI6fOss4s9HDQUz7yXdAlecCFl5PT8AxszaQNlqc
         Vm4nuLjkUKgW4XTgkFg2vjvfXTL1x1xaFJ1Agvt+/Moid0bDt+CQ2o21ry5sJbTeHpYe
         Si+scUhOzfNz4hoZrgul7FGtdF9xh4w6NX44pxYMXmOaHa9DuAy1cEKfnj4vYO25X2fo
         yrteU1KIU+deC83EMEwXX8egI/pUErv13xtXD2ZF8MTDiFJaMIL1FulY/nZebMK/dAeS
         VpePnys2xKyQY/jeij2dKbB06Wx+G8oOhCQ5kKy9VLeThpMwktgLxFxI6T7J1Ut65LJL
         uROQ==
X-Gm-Message-State: AOAM533GkH5MGimylYyX317qSY/oVdPvpZezf53j7LVhYnClbV3l0C1Q
        734MdOF2gj1VN5xj8BUnrZEzi/ANJSLLLVbv6VG8CHFf1KPlbouagOQWZ7VcqVPb0/eW65h0AML
        oj8UkYBkjkQKyADys
X-Received: by 2002:ac8:5a93:0:b0:304:ec80:7943 with SMTP id c19-20020ac85a93000000b00304ec807943mr11925907qtc.330.1654675868468;
        Wed, 08 Jun 2022 01:11:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxafg76CxJm3rvdA55kjtua/DL8MTX+u4dpuwo4IhaxuPDmvgZLRNVzSCHvCzz2IWH53JwUqQ==
X-Received: by 2002:ac8:5a93:0:b0:304:ec80:7943 with SMTP id c19-20020ac85a93000000b00304ec807943mr11925900qtc.330.1654675868214;
        Wed, 08 Jun 2022 01:11:08 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id v7-20020ac873c7000000b002f93be3ccfdsm9325249qtp.18.2022.06.08.01.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 01:11:07 -0700 (PDT)
Message-ID: <b3dda032cac1feafeffa89bb71c5b574d9e88845.camel@redhat.com>
Subject: Re: [PATCH net-next 4/8] net: use DEBUG_NET_WARN_ON_ONCE() in
 sk_stream_kill_queues()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Date:   Wed, 08 Jun 2022 10:11:02 +0200
In-Reply-To: <20220607211023.33a139b2@kernel.org>
References: <20220607171732.21191-1-eric.dumazet@gmail.com>
         <20220607171732.21191-5-eric.dumazet@gmail.com>
         <20220607211023.33a139b2@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-06-07 at 21:10 -0700, Jakub Kicinski wrote:
> On Tue,  7 Jun 2022 10:17:28 -0700 Eric Dumazet wrote:
> > sk_stream_kill_queues() has three checks which have been
> > useful to detect kernel bugs in the past.
> > 
> > However they are potentially a problem because they
> > could flood the syslog, and really only a developper
> > can make sense of them.
> > 
> > Keep the checks for CONFIG_DEBUG_NET=y builds,
> > and issue them once only.
> 
> I feel like 3 & 4 had caught plenty of bugs which triggered only 
> in production / at scale. 
> 
I have a somewhat similar experience: I hit a few races spotted by the
warnings in patches 3 and 4 observable only in non-debug build.

The checks in patch 4 are almost rendundant with the ones in patch 3 -
at least in my experience I could not trigger the first without hitting
the latter. Perhaps we could use WARN_ON_ONCE only in patch 3?

Thanks!

Paolo

