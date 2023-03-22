Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A5F6C4957
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjCVLli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjCVLlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:41:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4BB4FAB8
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679485249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BdHMTiAE+PN3GzSq9FiLR9q3XjL4KWEq8dCyo2zV+tg=;
        b=KqHANJlE/RV3XSHl4HUsVu9LxEUINSb1qOq0OL1jroQBQr9Og7hpYs7oPPASELEJibo/Qe
        clNr/qycpFpzLUKHzwkCs70hTS5MY3vq5KGyw/qRicwlVsrbmeK+q5gUbY3AIQoRlK0K/a
        7TnooQ1IDZy2+Rsv20H0pNhOc/Q7zPE=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-378-MAZzNMAhNVutzrtJrDAjEQ-1; Wed, 22 Mar 2023 07:40:48 -0400
X-MC-Unique: MAZzNMAhNVutzrtJrDAjEQ-1
Received: by mail-qv1-f70.google.com with SMTP id v8-20020a0ccd88000000b005c1927d1609so6388398qvm.12
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:40:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679485247;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BdHMTiAE+PN3GzSq9FiLR9q3XjL4KWEq8dCyo2zV+tg=;
        b=Ra1l8RUTmB33zc+z00SUt+XKCSO6Z3s4Ob1Kcb4HYczsu7vZW3phxZ1nkbQ3phi3CQ
         ou69DaXCMfOA1EuTtLuy9eurvcAS0K5FY2swWRhaJOnTW3OM0U0bqIEJzhj++vmpyEQ2
         XJS+kSp0rvU/ozOJR1l4svogZE23IhbcVvVjfxOk1i7zAXCF8g0uKZbfJWy+lQhZ0GPZ
         AF7jpuwf68XIkeWEfZHhMm16o+JvhGIDIt2nMlwbr5qr9R0WyoJ9mQGqkvQWOjIWmiUZ
         F9GeL1/hhg4xti1vp899xNGepayPCwMCtPGHAQEPSjb1V7oywjasBxZvIgks7y3ibsru
         5FsA==
X-Gm-Message-State: AO0yUKXxlwOXpsSrtYrrbqYedAHZRttJ6B1JCVXkyplhVcHiImpalQHg
        fgY7GI+UA1EF7v2uSmEJu8IJ5KsE8ITtM6pTHegwcY+03+Ah87bvjLfasMw4ssIHqMpzzXbMfNy
        rQ/N1cVCtBtYnbI0T
X-Received: by 2002:a05:622a:4cd:b0:3e2:4280:bc58 with SMTP id q13-20020a05622a04cd00b003e24280bc58mr9443524qtx.3.1679485247668;
        Wed, 22 Mar 2023 04:40:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set9DrP99ENKzleU94Q4isp4reabSKYEQTsQFVNEIkJ4etjYWZyRlL6TV1t67R5vjgnjlysGGXA==
X-Received: by 2002:a05:622a:4cd:b0:3e2:4280:bc58 with SMTP id q13-20020a05622a04cd00b003e24280bc58mr9443495qtx.3.1679485247366;
        Wed, 22 Mar 2023 04:40:47 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-168.dyn.eolo.it. [146.241.244.168])
        by smtp.gmail.com with ESMTPSA id r9-20020a37a809000000b007463509f94asm7294844qke.55.2023.03.22.04.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 04:40:46 -0700 (PDT)
Message-ID: <7755c026ea1f2c5f6d00aa4ba17233eb511ce3dd.camel@redhat.com>
Subject: Re: [PATCH] net/net_failover: fix queue exceeding warning
From:   Paolo Abeni <pabeni@redhat.com>
To:     Faicker Mo <faicker.mo@ucloud.cn>
Cc:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 22 Mar 2023 12:40:44 +0100
In-Reply-To: <20230321022952.1118770-1-faicker.mo@ucloud.cn>
References: <20230321022952.1118770-1-faicker.mo@ucloud.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-21 at 10:29 +0800, Faicker Mo wrote:
> If the primary device queue number is bigger than the default 16,
> there is a warning about the queue exceeding when tx from the
> net_failover device.
>=20
> Signed-off-by: Faicker Mo <faicker.mo@ucloud.cn>

This looks like a fixes, so it should include at least a fixes tag.

More importantly a longer/clearer description of the issue is needed,
including the warning backtrace.

I think this warning:

https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#L3=
542

should not be ignored/silenced: it's telling that the running
configuration is not using a number of the available tx queues, which
is possibly not the thing you want.

Instead the failover device could use an higher number of tx queues and
eventually set real_num_tx_queues equal to the primary_dev when the
latter is enslaved.

Thanks,

Paolo



