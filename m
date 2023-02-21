Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA87369DCA3
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 10:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbjBUJNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 04:13:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233763AbjBUJNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 04:13:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CAF8693
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:13:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676970784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u9qPgJ9YfQaIBYxPeu9q0HF9PJcAGNOnIB/vKwxuzMc=;
        b=CtKSn+RJ5dB512rNTzIg5s0pqP87lWPmRF29WDZOmDOEaZxrz2AT1IeV3RpVKSsH7689q3
        Luw/JdObCTxjFlXVSkjvHKKqv5Pqh7njNNO8c6wj0dIrSi1gO1FXyE4f+kOEesCC2Xy2V3
        zysbS5LS5LK8ay3nlK+CFDHl2TF4RA4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-218-8y_tjaGDM7O7KBMHIQwFKw-1; Tue, 21 Feb 2023 04:13:01 -0500
X-MC-Unique: 8y_tjaGDM7O7KBMHIQwFKw-1
Received: by mail-qk1-f197.google.com with SMTP id l15-20020ae9f00f000000b007294677a6e8so1209211qkg.17
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 01:13:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u9qPgJ9YfQaIBYxPeu9q0HF9PJcAGNOnIB/vKwxuzMc=;
        b=6hbNZVDIfd0Z3AIQEWaErCJHmMaY6yqTkxgp1jmey+thGy4RivK2MfHSMCDMEvQtO7
         hzUxcfdy7b4sqW5kcNva83EAJcq6p0WsbXM/jtjt97OEi/ldjorQt/ioUF9+MY8Exm6E
         5lo1uGs6juO/AxWfbJZ8xi44VWUPWaeBFmzpL7H5txJt7yg/74pUtLwEU7xQ2Lb2OC1U
         Z2lJO3VE2vLZ3HN8qQ1OVqLH/xal16GlPBEvWpIFHIt0zdPzy64ymN4u99tTqJtYIOop
         ttwO6OGR4u5B5wkPYG63RTndl06jzIbp1HgrCnNYi6XxjzNluHv+CICISp6XqLzwIOxq
         GWow==
X-Gm-Message-State: AO0yUKVRBU5gPxSW9EfPOCNhIySNfbF//QSblJ/Wg7PXrnPMuuAkMXzg
        5q5zoUZ4nrjEdGbpJtVLLDMgu5kmhQk2PZtqkkSlIhhwBohxHEnTt0oZUj2gVz0o42NrNjXLPvW
        k+3psp0EjOC9UHmK44DrzSQ==
X-Received: by 2002:a05:622a:1387:b0:3b6:8ece:cab9 with SMTP id o7-20020a05622a138700b003b68ececab9mr9007217qtk.2.1676970780246;
        Tue, 21 Feb 2023 01:13:00 -0800 (PST)
X-Google-Smtp-Source: AK7set8kiVEBhsNJv0mZoYrOBkHxRKdqQSfVZHQqIki9/aW5Lspjg93ps58VyJ2p0giooT1AijNf/w==
X-Received: by 2002:a05:622a:1387:b0:3b6:8ece:cab9 with SMTP id o7-20020a05622a138700b003b68ececab9mr9007188qtk.2.1676970779965;
        Tue, 21 Feb 2023 01:12:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id y6-20020ac87086000000b003be56bdd3b1sm1966046qto.92.2023.02.21.01.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 01:12:59 -0800 (PST)
Message-ID: <815485547a20f80f6dce991b76a7b60aebf1a716.camel@redhat.com>
Subject: Re: [PATCH v3] page_pool: add a comment explaining the fragment
 counter usage
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org
Cc:     alexander.duyck@gmail.com, Alexander Duyck <alexanderduyck@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Date:   Tue, 21 Feb 2023 10:12:56 +0100
In-Reply-To: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
References: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2023-02-18 at 00:21 +0200, Ilias Apalodimas wrote:
> When reading the page_pool code the first impression is that keeping
> two separate counters, one being the page refcnt and the other being
> fragment pp_frag_count, is counter-intuitive.
>=20
> However without that fragment counter we don't know when to reliably
> destroy or sync the outstanding DMA mappings.  So let's add a comment
> explaining this part.
>=20
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.

