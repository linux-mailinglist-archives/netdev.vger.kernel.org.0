Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A99836457D6
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbiLGK2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbiLGK1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:27:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B1763B2
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:26:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670408818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sl7ZkZKZiHSlbw4B4KJ5Z2VQTqLGIn8DjZOU7SMMFyU=;
        b=XDs/cIZP0pg7nK5e8QEJWs0d+ef1lfjkJHp5uro8Ev0dG3nr5P//tEqgi9Sb3/Qp/E2aXO
        jyPcXIdwbEuo8WWxZwDc5aeb8lPivwTIMoTNA9I3q1BYcba74I8eMjhhwIyctjVUfgXCb7
        mvwbwl1ai1aayXn8opda0ya54z0kCs8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-632-NaGbgqQ5NjOBgoBhNNbCbg-1; Wed, 07 Dec 2022 05:26:56 -0500
X-MC-Unique: NaGbgqQ5NjOBgoBhNNbCbg-1
Received: by mail-wm1-f72.google.com with SMTP id s24-20020a7bc398000000b003d087485a9aso442766wmj.1
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 02:26:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sl7ZkZKZiHSlbw4B4KJ5Z2VQTqLGIn8DjZOU7SMMFyU=;
        b=x7A90MzbuODwcub1+C9OP7x0Af3wuiCPrzdkRKIjFmvC3s4Bd0FADCP0EPixFxldI3
         A8e52NXPkKtmVLh/mQRW7rNCo6a0PHb60u2VsPOjxuXHs1WFW/8tMDgLO6u75ovTvRH3
         Rz3QEnfreCv3oMeBh5T/U5wFGrl2IO3KiPnw+KJVLiIJpzeFGcOHaYNwcSOTvJBRoWEv
         Tp7LNN4lsG1S2psnEAeBv07Wcb21SFHksFW8A25FLYHm3fen3Q46ADBJZK3d4fYo9IWc
         mg66iHq+nfNT75kkTVvZ9+LbGkMSUCcCIo3c7iDmZRDjGQ1I15m2IpPZkec3towntWH8
         jGSg==
X-Gm-Message-State: ANoB5pmH2UduEsTTjC9fdFft+ymWzMS0DERIk+T8kzXEIWEb4hCunzby
        Js93x931G0CaRbskCT8TfzGFNcNVuuOTWFV4kLnrpxNJs3atalzWyWdp9jlwukbDyN54kHAMjrc
        zvPW15kQZdd+eMHLO
X-Received: by 2002:a5d:6b8a:0:b0:242:248a:a7c9 with SMTP id n10-20020a5d6b8a000000b00242248aa7c9mr22493587wrx.57.1670408815642;
        Wed, 07 Dec 2022 02:26:55 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5Dsg4TGfhL2Cv/1eglm3fO6XYoXLJiTR62jdhwp51aRaeh+VbVjfokmXoyisqu3+FtTzNEYQ==
X-Received: by 2002:a5d:6b8a:0:b0:242:248a:a7c9 with SMTP id n10-20020a5d6b8a000000b00242248aa7c9mr22493567wrx.57.1670408815352;
        Wed, 07 Dec 2022 02:26:55 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-106-100.dyn.eolo.it. [146.241.106.100])
        by smtp.gmail.com with ESMTPSA id r22-20020a05600c35d600b003a84375d0d1sm1281842wmq.44.2022.12.07.02.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 02:26:55 -0800 (PST)
Message-ID: <619913f8fc11ab502e73d526eee7ada6066843a2.camel@redhat.com>
Subject: Re: [PATCH net-next 2/6] tsnep: Add XDP TX support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
Date:   Wed, 07 Dec 2022 11:26:53 +0100
In-Reply-To: <20221203215416.13465-3-gerhard@engleder-embedded.com>
References: <20221203215416.13465-1-gerhard@engleder-embedded.com>
         <20221203215416.13465-3-gerhard@engleder-embedded.com>
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

On Sat, 2022-12-03 at 22:54 +0100, Gerhard Engleder wrote:
> For complete TX support tsnep_xdp_xmit_back() is already added, which is
> used later by the XDP RX path if BPF programs return XDP_TX.

Oops, I almost forgot... It's better to introduce tsnep_xdp_xmit_back()
in the patch using it: this patch introduces a build warning fixed by
the later patch, and we want to avoid it.

Cheers,

Paolo

