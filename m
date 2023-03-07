Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1A56AD321
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 01:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjCGAH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 19:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjCGAH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 19:07:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF294ECF6
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 16:06:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678147604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kiG8BgPH1QQ43j7yve5gAvlmd9pWIcu5Uac1q0tt6sI=;
        b=MnZ9kKnQu6pDOnzKFVTzWwYPqj8A+xm3gCgFCLQz6wRnkScwES4dsqbUQL4UG7FVmW3MxK
        C5Nt12oUSPzkA862mz/OaOIdFC3nRwvOLYelmpC6r7mFy7HWPZO2P7BT4G1TfqXbNgYoVU
        6LLmqtNtsFWygA5oEuYM6TdYpcNLing=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-mgNsjOSCObq8LqcgH8k0gA-1; Mon, 06 Mar 2023 19:06:43 -0500
X-MC-Unique: mgNsjOSCObq8LqcgH8k0gA-1
Received: by mail-ed1-f71.google.com with SMTP id k12-20020a50c8cc000000b004accf30f6d3so16187231edh.14
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 16:06:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678147602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kiG8BgPH1QQ43j7yve5gAvlmd9pWIcu5Uac1q0tt6sI=;
        b=GY3YK6SEoK9fdp2X2Dl2vp2sUM6iWlFpZEovvmuNdv6hew4QMxnZ/roieoVJBIAy+F
         Fybn+J9bWLdH+mQSsfERKi2f+0/YnKw6xelLlUJMks8ZmJfsHIR1h/mSlgkT2ZHFGRuK
         W8i8tI35PVow3Rgjq2hrdL2a3cCtmZUjFownb4yjQh3H5WF6mPjDrxchLcr3eHMfWtSt
         96NTuxVA+Pa7h2G1O6tWmtwuycKLlAbel9b558oaxDELnnV/WA39SALWk6spRFZHDrNT
         q6cn8VgzUne60cFWLZLxzNPsiy80lmJOY6Adp/EwXA3M9cgvkzpUqvJcTuCXiNvzq88F
         ztgA==
X-Gm-Message-State: AO0yUKX8I27+i2TRYTfVrt0YQVDwFi4iXI0FFLNZC2rXFickz9PBSwFk
        CPnAHLZX/mxt/Hxv/TOm8S9PWkNHKPHeKElwqebaWISIN3SgyWeY7Z5rP0v6io19Z3fX1hUXyWY
        LhgNUlPbzl4PTBP2RJOvTxv5gSGgy9fnN
X-Received: by 2002:a17:906:338e:b0:895:58be:963 with SMTP id v14-20020a170906338e00b0089558be0963mr6262946eja.3.1678147602616;
        Mon, 06 Mar 2023 16:06:42 -0800 (PST)
X-Google-Smtp-Source: AK7set+tlZyOLrVQtITvkM4aCSQgfCcDyTdnBcxy/a9AwJHlmGApYotDt8QLwad83Q2rJffmtyK+Fiuv9O7gGylkK+s=
X-Received: by 2002:a17:906:338e:b0:895:58be:963 with SMTP id
 v14-20020a170906338e00b0089558be0963mr6262936eja.3.1678147602324; Mon, 06 Mar
 2023 16:06:42 -0800 (PST)
MIME-Version: 1.0
References: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 6 Mar 2023 19:06:31 -0500
Message-ID: <CAK-6q+iHJouJc2WSuPipC8kieULYg02ipyHaOKDsnj4rT-gcyA@mail.gmail.com>
Subject: Re: [PATCH next] ca8210: Fix unsigned mac_len comparison with zero in ca8210_skb_tx()
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     error27@gmail.com, Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Mon, Mar 6, 2023 at 2:20=E2=80=AFPM Harshit Mogalapalli
<harshit.m.mogalapalli@oracle.com> wrote:
>
> mac_len is of type unsigned, which can never be less than zero.
>
>         mac_len =3D ieee802154_hdr_peek_addrs(skb, &header);
>         if (mac_len < 0)
>                 return mac_len;
>
> Change this to type int as ieee802154_hdr_peek_addrs() can return negativ=
e
> integers, this is found by static analysis with smatch.
>
> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver"=
)
> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Acked-by: Alexander Aring <aahringo@redhat.com>

sorry, I didn't see that... Thanks for sending this patch.

- Alex

