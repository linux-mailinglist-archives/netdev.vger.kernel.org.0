Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6366DE04
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 13:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236741AbjAQMr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 07:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236980AbjAQMra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 07:47:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A5B38B6A
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673959596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLjFI+cZ9jr5RlrvVD8oFfZXil5MeB4wNxOVoiVpd0I=;
        b=bM8QuIktUt6QnAQDGkSrzaH1obGJqdp64vCiZyt95j4UnLBwOi3zI48BcMct162tT0tPdQ
        dNq/KzYmRMFpAYTmEnY+W6DgmfahnJLH3krxSXaRCEu2HYv3/a+evYEzdG4UaghyFf9679
        2hvUAFe7LBI9qd9B7lzIAdcWNAjjgfc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-470-PxDZfqv8MHmv2StUaHfsYw-1; Tue, 17 Jan 2023 07:46:30 -0500
X-MC-Unique: PxDZfqv8MHmv2StUaHfsYw-1
Received: by mail-qk1-f200.google.com with SMTP id j10-20020a05620a288a00b0070630ecfd9bso7431895qkp.20
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 04:46:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gLjFI+cZ9jr5RlrvVD8oFfZXil5MeB4wNxOVoiVpd0I=;
        b=FXYhFgcI1jJYNr1bVV3pekgOmf6QSpFnzPGE9Fh04KSR0/0yoH4qtLOD5s9anb1aO9
         IzlHbiJEggBjI8NjMpjVs0Mov6f5a9dNvYi59ilNGeMKuXF7ngZ3y2XYbn+WSjD9MnsE
         6L7ldEc+nYE7NBjVkg57JH8/eI6mejAiIHHzlb3kp+KWlzGM+pP/yAnHA1QxU2KJkYlB
         ERQ47/7qSPqhL/8p8ypFqkOHCFZwuSrxKfgRIS5+Hgyeqpp7MNJN4adRGN0h6zVgSexq
         z2TQSb8wImIlEeN9H+S+qWhDnu5Ya+VTxBBsn6MtnEiJIX9IMbFhlNcy9TdNqsXBfkEd
         NFzg==
X-Gm-Message-State: AFqh2ko739S/UmkoSJPmXLoi6nn26RzWaOXtScA0K518zbgNY8En7x1H
        FJ49GHSjn+yjSMmrJRSqUxblsZj7ncxIKHOCLWLjQKzaAjRpJsuT/noA8mQOuTXEptdc6aqGWPm
        1rC7M/KNTXliyBZN+
X-Received: by 2002:a05:6214:8e7:b0:4c6:a49e:c255 with SMTP id dr7-20020a05621408e700b004c6a49ec255mr4261661qvb.35.1673959589850;
        Tue, 17 Jan 2023 04:46:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs9ZcFSpsJizntwd36YUdsmoe+6H6JHkKu/4v9/6vvkt16O7VlDKMtvhTP5Ei2eVAm5IICYGg==
X-Received: by 2002:a05:6214:8e7:b0:4c6:a49e:c255 with SMTP id dr7-20020a05621408e700b004c6a49ec255mr4261645qvb.35.1673959589600;
        Tue, 17 Jan 2023 04:46:29 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id bm37-20020a05620a19a500b00704d8ad2e11sm3122595qkb.42.2023.01.17.04.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:46:29 -0800 (PST)
Message-ID: <cb6a141d35c5f349fe4b653abe78eb7cc3cd979f.camel@redhat.com>
Subject: Re: [net-next] ipv6: Document that max_size sysctl is depreciated
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, martin.lau@kernel.org, joel@joelfernandes.org,
        paulmck@kernel.org, eyal.birger@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrea.mayer@uniroma2.it
Date:   Tue, 17 Jan 2023 13:46:25 +0100
In-Reply-To: <20230116002157.513502-1-jmaxwell37@gmail.com>
References: <20230116002157.513502-1-jmaxwell37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

Hi,

On Mon, 2023-01-16 at 11:21 +1100, Jon Maxwell wrote:
> Document that max_size is depreciated due to:
>=20
> af6d10345ca7 ipv6: remove max_size check inline with ipv4

I'm sorry for the nit picking, could you please use the standard commit
reference? commit <hash> ("<title>")

Thanks!

Paolo

