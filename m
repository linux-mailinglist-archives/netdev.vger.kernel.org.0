Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8E857A0DA
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbiGSOL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238707AbiGSOLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:11:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9D6980508
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658237546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s4t4lP9F+gFhkuqe3lAyPfoePFSA2zpeRXhDf6Qf1WE=;
        b=U18EY7NIqeauOk96fQOKF0Fd9lYJfFbXghXSmUDXE+ZltLSp9eUEhYX5HewtilmLBOJZdK
        7UvIhjdrzivz3SeoqFhikE/K8hRAR0ZeRbLyG4TxUKskXyxvpyGIoGZOx/vxD6fjDPJ3mf
        +zQkuJ1mwNxToVBjPoc6LNzc0bgKQbA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-qN68vMJEPYKMiAyPwuuLuw-1; Tue, 19 Jul 2022 09:32:25 -0400
X-MC-Unique: qN68vMJEPYKMiAyPwuuLuw-1
Received: by mail-qt1-f198.google.com with SMTP id ay25-20020a05622a229900b0031ef5fdf8f8so2770272qtb.7
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:32:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=s4t4lP9F+gFhkuqe3lAyPfoePFSA2zpeRXhDf6Qf1WE=;
        b=C9DNH5Q1GwGJZSKQxfXLsz01KuXUFMs8xe4DT10lIHB2eoU9QxudBOO9BtVzcj8OfS
         GteDjHm3tLEVsmXFJsce4Tmmo95PwVRpnPxxXvsmqj6mXwg+FZlMqv1kAXW76cLeP+j0
         P1z72Tqh6CAHbKUD2U9U7WMU6nj/7rZJHj5odSpkYiHdwqSTFqy/IiYjp7iCKpzZtlWF
         xd4ejAGJnXGeyUFPKgAW0NvfmDHtuEI7s7N3vKHyOWp1UK2ReGG6j9bE+1h+juw+qvwt
         HB28IdCK1qCs8p5NtdeGE2U9vMSs04Hktr5fMWlbKaUwb+l83OhV7NyInCBtaq4mh+iJ
         PUSw==
X-Gm-Message-State: AJIora+/rr+TGT9ZK3qUMz4Qmwgpgxbk425IhH2c/NODfRj15HF8Xo/m
        n7ZDR4H39jl22uCZkce8EJUnkBzv7lRV5gLnwU7w8eTf7m+KfZagTjRrmWzgz2ieVC9oU/jnK5D
        Er3ehaOTTPf6Tqqca
X-Received: by 2002:a05:620a:24d1:b0:6b5:9210:163f with SMTP id m17-20020a05620a24d100b006b59210163fmr9567217qkn.136.1658237544245;
        Tue, 19 Jul 2022 06:32:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ufMCMrjjF/F600a7OAC0QiTQXCelGDm+1vqsdpi+1ystBuEeGrP3159Njzg/8bt1GdfBwdOQ==
X-Received: by 2002:a05:620a:24d1:b0:6b5:9210:163f with SMTP id m17-20020a05620a24d100b006b59210163fmr9567191qkn.136.1658237543983;
        Tue, 19 Jul 2022 06:32:23 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id k13-20020a05620a414d00b006a981a2c483sm14228363qko.39.2022.07.19.06.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 06:32:23 -0700 (PDT)
Message-ID: <8da535a285499af67b7d4ca5e67f71d66ce89743.camel@redhat.com>
Subject: Re: [net-next 03/14] net/mlx5e: Expose rx_oversize_pkts_buffer
 counter
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Tue, 19 Jul 2022 15:32:20 +0200
In-Reply-To: <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
References: <20220717213352.89838-1-saeed@kernel.org>
         <20220717213352.89838-4-saeed@kernel.org>
         <20220718202504.3d189f57@kernel.org>
         <24bd2c21-87c2-0ca9-8f57-10dc2ae4774c@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2022-07-19 at 14:13 +0300, Gal Pressman wrote:
> On 19/07/2022 06:25, Jakub Kicinski wrote:
> > On Sun, 17 Jul 2022 14:33:41 -0700 Saeed Mahameed wrote:
> > > From: Gal Pressman <gal@nvidia.com>
> > > 
> > > Add the rx_oversize_pkts_buffer counter to ethtool statistics.
> > > This counter exposes the number of dropped received packets due to
> > > length which arrived to RQ and exceed software buffer size allocated by
> > > the device for incoming traffic. It might imply that the device MTU is
> > > larger than the software buffers size.
> > Is it counted towards any of the existing stats as well? It needs 
> > to end up in struct rtnl_link_stats64::rx_length_errors somehow.
> 
> Probably makes sense to count it in rx_over_errors:
>  *   The recommended interpretation for high speed interfaces is -
>  *   number of packets dropped because they did not fit into buffers
>  *   provided by the host, e.g. packets larger than MTU or next buffer
>  *   in the ring was not available for a scatter transfer.
> 
> It doesn't fit the rx_length_errors (802.3) as these packets are not
> dropped on the MAC.
> Will change.

I read the above as you are going to send a new revision of this PR, so
I'm setting this to 'Changes Requested' in PW.

Please correct me otherwise.

Paolo

