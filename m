Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1EF6D0269
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 13:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjC3LCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 07:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbjC3LCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 07:02:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F24E0903D
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680174097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XGbfN1W3Kwf6sp2kgyQhaTWhRNIKeR5/vaFI9hlCa40=;
        b=ih7pt34n16cdhm6kh/0Zzy1S0eemPwqsWWOt3+Tnek1xste7p3FhnIDhdlp4PlC9mT43yk
        o9FOn8A7LQlpEQOwg/DqY+9yaFKNDf+xRDUVZHjrCf6NqszJFeJ/ZbdU547HJM+7eiQpY8
        RShkafnNfNw+Yt/ImHPrYFRc/hV4RQw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-580-CJ-YHKBoMP2n3c7kxpLUog-1; Thu, 30 Mar 2023 07:01:35 -0400
X-MC-Unique: CJ-YHKBoMP2n3c7kxpLUog-1
Received: by mail-qt1-f197.google.com with SMTP id v7-20020a05622a188700b003e0e27bbc2eso12153599qtc.8
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:01:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680174095;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XGbfN1W3Kwf6sp2kgyQhaTWhRNIKeR5/vaFI9hlCa40=;
        b=pS/PG9uNAnbK5+VNXTq0alsODfyusPP3Lgt21JcckFUF1DgUgosVoJtq+4KMo5W0Lh
         h0pfSk8Bzif4X6itEmpOXeYZ11g3mZlNvVowR4KuvHGyMqtKZQAG9mNrzSQOSLC7vN19
         PXCbECePqGDyDJz7+JvAXFbwzcQ9kJXP7mdyo2e1zHA+ADPAX0oxgbR40cScwL30BnET
         ooq9m3Mh0zICx3tLb6ovy+VGVi+uI/CO06/CkE0/UP8MN91uBLpMJtwqmPMt3ZPaOO/U
         /6/W2bnRcqthxNORqMeU8PKUm3uG3gsB1duNzI8bF7cif0g9YfW+kc6gvMsa/M7C0vKO
         ZAcw==
X-Gm-Message-State: AAQBX9fp2yU0QvGoxnKvBsupnFZ8fbnujfFlwUFk9iHH/gBb9pCVZKZo
        5zK1BaY1Wf+3xG0JTjvW2UgbMcOFW0jSVplnvZGFu7VTEzBaxSpYY2XgDwvMThMoOWesudCI1Tz
        Xl+mlgULg3FMd9ehK
X-Received: by 2002:a05:6214:2608:b0:5ac:463b:a992 with SMTP id gu8-20020a056214260800b005ac463ba992mr2120036qvb.0.1680174095213;
        Thu, 30 Mar 2023 04:01:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZkERrlJSsp9Gcbng9jDefFXi6Cw3WbVbDVKIZE+wkr8Ik77FNVusUA1P05bBuGiUaxnsZWMA==
X-Received: by 2002:a05:6214:2608:b0:5ac:463b:a992 with SMTP id gu8-20020a056214260800b005ac463ba992mr2119959qvb.0.1680174094523;
        Thu, 30 Mar 2023 04:01:34 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-228-125.dyn.eolo.it. [146.241.228.125])
        by smtp.gmail.com with ESMTPSA id a18-20020a0cefd2000000b005dd8b93456esm5340732qvt.6.2023.03.30.04.01.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 04:01:34 -0700 (PDT)
Message-ID: <e9e362e3a571bc32afb344cf35b54395e741de90.camel@redhat.com>
Subject: Re: [PATCH net-next v2] net/core: add optional threading for
 backlog processing
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 30 Mar 2023 13:01:31 +0200
In-Reply-To: <20230328161642.3d2f101c@kernel.org>
References: <20230328195925.94495-1-nbd@nbd.name>
         <20230328161642.3d2f101c@kernel.org>
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

On Tue, 2023-03-28 at 16:16 -0700, Jakub Kicinski wrote:
> On Tue, 28 Mar 2023 21:59:25 +0200 Felix Fietkau wrote:
> > When dealing with few flows or an imbalance on CPU utilization, static =
RPS
> > CPU assignment can be too inflexible. Add support for enabling threaded=
 NAPI
> > for backlog processing in order to allow the scheduler to better balanc=
e
> > processing. This helps better spread the load across idle CPUs.
>=20
> Can you share some numbers vs a system where RPS only spreads to=20
> the cores which are not running NAPI?
>=20
> IMHO you're putting a lot of faith in the scheduler and you need=20
> to show that it actually does what you say it will do.

I have the same feeling. From your description I think some gain is
possible if there are no other processes running except
ksoftirq/rps/threaded napi.=C2=A0

I guess that the above is expect average state for a small s/w router,
but if/when routing daemon/igmp proxy/local web server kicks-in you
should notice a measurable higher latency (compared to plain RPS in the
same scenario)???

Cheers,

Paolo

