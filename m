Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A9F6C4B4D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 14:09:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjCVNJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 09:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCVNJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 09:09:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6A928D0A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679490524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B/qTj/CR/P8toNku1F2rSJCL567n91Rdrj6XCHder5E=;
        b=AfHZcvQAJEcbA9ltdcB1XjBZkpWWLgynlCsCsffBSsp7j9y3BkWH2h3xTdHKSdfBTLAk8y
        qJ7NYfRz/qnrYjlndSbW21oNhGYwrcCR7H+VAxUkpKgk5a8+dNCUv4L4rP7mGdT/Rliwww
        K5AS2DbOzZq8bjOINsqAaXjIPjwpAXY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536--CFANjieNRSls8RyE_padg-1; Wed, 22 Mar 2023 09:08:40 -0400
X-MC-Unique: -CFANjieNRSls8RyE_padg-1
Received: by mail-qv1-f72.google.com with SMTP id jo13-20020a056214500d00b004c6c72bf1d0so9190383qvb.9
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 06:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679490519; x=1682082519;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B/qTj/CR/P8toNku1F2rSJCL567n91Rdrj6XCHder5E=;
        b=Zeozfq/uth8fL9a+7yYvsFK1uHmmnBrulERxm5tb++1KaS78Qqwy8BGxWGXOTl1Rdv
         by1insiyAGFaZV5Q6PoKMH9ZYY3mRfMJhxNchrCCwPIUTkOc++uY8XT//X7PcFHwJCrm
         imw3wsPWGIX4LE8r4fzBptgTphK/2JfveQ3dGEMH3P7nAa90QF22n1BsoFSrGdda6Ihj
         L/3a6koEajMrtH5bnPvFUfnQ6Ih5YzZukRweh65k0cxWwlBKPgWK2szt+aj1RtPomzfh
         2ioWiMxwRRXTqe7vQ3yq36/egAqCL5mQCDvY/FVpsZ4psebRRL/1twYkWpf0Mm5GgoAQ
         OffA==
X-Gm-Message-State: AO0yUKVJhvZsBkgmeE+TiEOYFGtr1VB2nSeBLcGLvXk65EA/STpl6p+q
        PJHjWPPswvfuugplcByYK7brrMCXQwWKT0XAwpP/gdo6CfQgkSD1SdSrutNAa3TeLz1inoWgFVi
        +yMKwtafV3mH2fMMjbMeT2mxX
X-Received: by 2002:a05:622a:1ba6:b0:3bf:a3d0:9023 with SMTP id bp38-20020a05622a1ba600b003bfa3d09023mr9839481qtb.5.1679490518805;
        Wed, 22 Mar 2023 06:08:38 -0700 (PDT)
X-Google-Smtp-Source: AK7set8BplPahQbCnWKiKMft+baibysjjTwWtI3aCzJY2m/60IP8OZzIl2kBLJuT+hOG6SbaWsA/rg==
X-Received: by 2002:a05:622a:1ba6:b0:3bf:a3d0:9023 with SMTP id bp38-20020a05622a1ba600b003bfa3d09023mr9839444qtb.5.1679490518441;
        Wed, 22 Mar 2023 06:08:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id f25-20020ac84659000000b003e37db253c6sm3765802qto.57.2023.03.22.06.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 06:08:38 -0700 (PDT)
Message-ID: <8f4bd9333117eda4c5ff324f92b969d9a6b57b65.camel@redhat.com>
Subject: Re: [PATCH net-next] net/smc: introduce shadow sockets for fallback
 connections
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kai Shen <KaiShen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, kuba@kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Date:   Wed, 22 Mar 2023 14:08:34 +0100
In-Reply-To: <20230321071959.87786-1-KaiShen@linux.alibaba.com>
References: <20230321071959.87786-1-KaiShen@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-21 at 07:19 +0000, Kai Shen wrote:
> SMC-R performs not so well on fallback situations right now,
> especially on short link server fallback occasions. We are planning
> to make SMC-R widely used and handling this fallback performance
> issue is really crucial to us. Here we introduce a shadow socket
> method to try to relief this problem.
>=20
> Basicly, we use two more accept queues to hold incoming connections,
> one for fallback connections and the other for smc-r connections.
> We implement this method by using two more 'shadow' sockets and
> make the connection path of fallback connections almost the same as
> normal tcp connections.
>=20
> Now the SMC-R accept path is like:
>   1. incoming connection
>   2. schedule work to smc sock alloc, tcp accept and push to smc
>      acceptq
>   3. wake up user to accept
>=20
> When fallback happens on servers, the accepting path is the same
> which costs more than normal tcp accept path. In fallback
> situations, the step 2 above is not necessary and the smc sock is
> also not needed. So we use two more shadow sockets when one smc
> socket start listening. When new connection comes, we pop the req
> to the fallback socket acceptq or the non-fallback socket acceptq
> according to its syn_smc flag. As a result, when fallback happen we
> can graft the user socket with a normal tcp sock instead of a smc
> sock and get rid of the cost generated by step 2 and smc sock
> releasing.
>=20
>                +-----> non-fallback socket acceptq
>                |
> incoming req --+
>                |
>                +-----> fallback socket acceptq
>=20
> With the help of shadow socket, we gain similar performance as tcp
> connections on short link nginx server fallback occasions as what
> is illustrated below.

It looks like only the shadow sockets' receive queue is needed/used.

Have you considered instead adding 2 receive queues to smc_sock, and
implement a custom accept() variant fetching the accepted sockets from
there?

That will allow better encapsulating the changes into the smc code and
will avoid creating that 2 non-listening but almost listening sockets
which look quite strange.

Cheers,

Paolo

