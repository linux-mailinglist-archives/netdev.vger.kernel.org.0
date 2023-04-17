Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884C86E3DF2
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 05:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjDQDZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 23:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjDQDZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 23:25:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C9D2116
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 20:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681701869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zKGM0UuJktFVFn7nlGHkLlmdThLbMLf0gM6cQd9y1wc=;
        b=Mk6Q/6vnpo1NfdCcdIpMCQcu6bCQ7kymSBYZdSajBLShebzalUFZ+9O9Ew5AJqQpAc+/Ne
        C8skxbVxbVORfXb1uaHS+hRmVT26atEpqBR1sXpfuTmjA+8KQbfmF8UM7S8epbS3Rw5aWc
        BCI2n1zNOR3n7pEfwO4LcX9/6Vv6H34=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-HsJBjGZjNc6d-jhVI5DTZg-1; Sun, 16 Apr 2023 23:24:28 -0400
X-MC-Unique: HsJBjGZjNc6d-jhVI5DTZg-1
Received: by mail-ot1-f71.google.com with SMTP id b17-20020a056830105100b006a42f47618fso2746844otp.19
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 20:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681701867; x=1684293867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKGM0UuJktFVFn7nlGHkLlmdThLbMLf0gM6cQd9y1wc=;
        b=XGVqE3eYpQUELQdCpZ0lm2V/ZGVL4Hi8GMderRDNR89EPWXegZQAQHzfF7/cLhP33s
         5vkz8lWosRsXOBi6HbL81q6vusXMhEO1opTGjFSs2KXt3F8wPgJ32eLV6vRqBnlAhLJp
         yhtBfQsbJYQbzVtRHM1ga7QxMbDqONMQzh3HQ7ZvvKnYTbjD9Rris8HAWPBNBsQo2xjp
         5Rg4YBNNzOQDmtIm2uVtX/paJwkcKd8bkuV+++a5uea7EYRzdrHqCTqj40/0QRzdf5BL
         eDxjcHO5797r6Kih2qx8MP2Inf9VIY3UWUhHF+wCMuoL5kS3N8/CELSc9KGT062AOH1e
         aoxA==
X-Gm-Message-State: AAQBX9cxckckCU1+DEiJ28EL2YtAFfkMzp5EqZElYV/Fk2Nx+rEzD8YE
        Ke10y8GIj2N8zxI3MB3E3VCcOzpeUL2irV7luSkZGT0jg2BKCM1OVdREMI3laZN3PC8J90D7zlS
        5B7So2YA1vsksh6YKgBcxWdHQpgXSq1Z+
X-Received: by 2002:a05:6870:3489:b0:187:7f2e:98d6 with SMTP id n9-20020a056870348900b001877f2e98d6mr5063282oah.9.1681701867759;
        Sun, 16 Apr 2023 20:24:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350btdvSh+yfsA0KDTP5tl/3eCzJUDrZFp6vNFLcoded+JiAPxym7277acm9HPgpEBflChrr5DV/GvuTzFRR65KI=
X-Received: by 2002:a05:6870:3489:b0:187:7f2e:98d6 with SMTP id
 n9-20020a056870348900b001877f2e98d6mr5063275oah.9.1681701867587; Sun, 16 Apr
 2023 20:24:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230416074607.292616-1-alvaro.karsz@solid-run.com>
 <AM0PR04MB4723C6E99A217F51973710F5D49F9@AM0PR04MB4723.eurprd04.prod.outlook.com>
 <20230416164453-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230416164453-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 17 Apr 2023 11:24:16 +0800
Message-ID: <CACGkMEvFhVyWb5+ET_akPvnjUq04+ZbJC8o_GtNBWqSMGNum8A@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: reject small vring sizes
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 17, 2023 at 4:45=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Sun, Apr 16, 2023 at 04:54:57PM +0000, Alvaro Karsz wrote:
> > After further consideration, other virtio drivers need a minimum limit =
to the vring size too.
> >
> > Maybe this can be more general, for example a new virtio_driver callbac=
k that is called (if implemented) during virtio_dev_probe, before drv->prob=
e.
> >
> > What do you think?
> >
> > Thanks,
> > Alvaro
>
> Let's start with what you did here, when more than 2 drivers do it we'll
> move it to core.

I wonder how hard it is to let virtio support small vring size?

Thanks

>
> --
> MST
>

