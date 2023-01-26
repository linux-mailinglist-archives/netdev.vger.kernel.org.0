Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC07167CB5E
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 13:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbjAZMyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 07:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbjAZMyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 07:54:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9F93C2E
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674737608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jBM9XBklFHpBUqeZTmTKzlvdF89qkTzpVZ/4QTS/EmE=;
        b=RidI12cu0CYoFn/uim114xampnFc78OhxCq7hRwFWJha8hJM85J46eHt2Umfwi/ESZrMSJ
        AWDWXoIGSM/ghb7JX2TGQMk9nY6Py5P88UY7oMVP7GicxGSEnCMRYbDuyCe6T/qIBuzQ6/
        e1RulQn1Q7HB18iOQxK9xc9eUlN1nEc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-61-EZJnaoQQNOKN7y-WG3Fg3Q-1; Thu, 26 Jan 2023 07:53:27 -0500
X-MC-Unique: EZJnaoQQNOKN7y-WG3Fg3Q-1
Received: by mail-qk1-f200.google.com with SMTP id j11-20020a05620a410b00b007066f45a99aso983675qko.1
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 04:53:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jBM9XBklFHpBUqeZTmTKzlvdF89qkTzpVZ/4QTS/EmE=;
        b=NK5w2O3RqPWkheHRH8aPLabiu98nHRErUbQWnf6Qoc34ySd8lTDJnDnCLXvYUOiqRn
         LwfdHqz7lZQq/IF91hyaiPme6z5y3a6YRxI+IKtYtvdjWDGRF5itMFl46Th1nkwWsuC1
         HecCbk7692RaeSiU9XXsBKNhlxAka7RqKuVlgCd0Oi79AjCx+Hm1LT3O0oeZvXmd62Dw
         cZeF+HVwacD9VqsUKxvvcBrNK+TmZuolNsJu7E+aP+MrgQpwJfdqrSf0Ra7moCudcaeP
         M6UV6aLvX8T5RvxaMN+31aZBI8yNqROyuwhXYCCU0KemYPyseetmxr4eeoFIer/gcgFT
         lcjA==
X-Gm-Message-State: AFqh2koGHtICpabrlyezYYhNYaFssFlSWw+e2cm0XOMPjY4DuJr+hAVp
        vpRY9Bitr1Bdc7sMEY4ipoDXdd/CySaqNfFDcAiI2m4fMrLkz52VhcxqXRDLx4mmqYxNFLIXhcG
        un/jb7VRVvIM6MUnt
X-Received: by 2002:ac8:4c84:0:b0:3a6:a89d:9ee with SMTP id j4-20020ac84c84000000b003a6a89d09eemr47284078qtv.33.1674737606897;
        Thu, 26 Jan 2023 04:53:26 -0800 (PST)
X-Google-Smtp-Source: AMrXdXttQddN8vjdNtkpVaAfR3lrW7h9IqUzywDhn69oFRraVJegevMVrlO1sYItr19mK26qc+jS+Q==
X-Received: by 2002:ac8:4c84:0:b0:3a6:a89d:9ee with SMTP id j4-20020ac84c84000000b003a6a89d09eemr47284056qtv.33.1674737606621;
        Thu, 26 Jan 2023 04:53:26 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id s24-20020ac85ed8000000b003b2d890752dsm641205qtx.88.2023.01.26.04.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 04:53:26 -0800 (PST)
Message-ID: <0344d6af4d953c24d4ef20c3ea48e738ee8682fb.camel@redhat.com>
Subject: Re: [PATCH v9 01/25] net: Introduce direct data placement tcp
 offload
From:   Paolo Abeni <pabeni@redhat.com>
To:     Shai Malin <smalin@nvidia.com>, Aurelien Aptel <aaptel@nvidia.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>
Date:   Thu, 26 Jan 2023 13:53:22 +0100
In-Reply-To: <DM6PR12MB3564D7C8E60D51464F00A5F1BCCF9@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20230117153535.1945554-1-aaptel@nvidia.com>
         <20230117153535.1945554-2-aaptel@nvidia.com>
         <e279ebf025b62b8ce8878d16d1a77afb2e59ca7e.camel@redhat.com>
         <DM6PR12MB3564D7C8E60D51464F00A5F1BCCF9@DM6PR12MB3564.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, 2023-01-26 at 09:47 +0000, Shai Malin wrote:
> On Fri, 20 Jan 2023 at 10:52, Paolo Abeni wrote:
>=20
> > Have you considered avoiding adding the above fields here, and instead
> > pass them as argument for the setup() H/W offload operation?
>=20
> After researching the implication of such a change, we don=E2=80=99t beli=
eve it's right.
> This entire work was designed to be based on the sock structure, and this=
 approach
> will be needed also for the next part of our work (Tx), in which we will =
use the=20
> ops and the queue also from the socket.
>=20
> We defined the ULD_DDP as a generic layer that can support different=20
> vendors/devices and different ULPs so using only one ops will make it=20
> more difficult to maintain from our point of view.

I'm fine with the above.=20

> I will also add that we are addressing review comments for 1.5 years in o=
rder=20
> to fine tune this design, and such a change will open the fundamentals.

I understand my above comment landed quite too late, but I guessed it
was better to ask the question this late then never.

No opposition to the current design on my side.

Thanks,

Paolo

