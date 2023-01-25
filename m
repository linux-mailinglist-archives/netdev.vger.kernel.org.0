Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701A467C133
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 00:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbjAYXxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 18:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjAYXxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 18:53:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A62035B8
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 15:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674690772;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nme3G5CkNqvQnYkBip8EES1cBl2yl0jBhD5h1DF+Tbo=;
        b=E7hpB8G3KmnYy35mq1EnfmQPtDSSfq7UthxfsPq4sz+ZQ/NfgLO1J5zhP7sbkvMUF1GkzD
        iNrXuOp+Yi9PdRpuLDrxsfyDjeh3PWvjgNDQPsU9N7w/iYizJgMTNGgC9sr4HUZl5XSAX7
        F0XGFAAvyqpsfEN91hGTfiGM0qVKzrI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-543-vMNmFoxAN5WH2_8yR4gHyQ-1; Wed, 25 Jan 2023 18:52:51 -0500
X-MC-Unique: vMNmFoxAN5WH2_8yR4gHyQ-1
Received: by mail-qk1-f200.google.com with SMTP id y3-20020a05620a44c300b00709109448a3so187554qkp.19
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 15:52:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:organization
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nme3G5CkNqvQnYkBip8EES1cBl2yl0jBhD5h1DF+Tbo=;
        b=O5TX5WyzEVfuMZOehXQp+AFNGuYaD80o3SCLMXhW12OKM9CnJ3oHG/XxS/XvrpTQFU
         aUokCCQFkA2K4eBf95z/p5L86Bi905QAUzB867UD9F2me+CItTCEFOoj06EbQS1YRP77
         46fuW5O2FI77HpVakHozhCAXqKcFJk3nxmvhWPercWETeJmfyCgGgXgoQx+jVYqpYk6M
         Gr2J5qM3VgJQcpgBFji50PCsM3jJFU1fb8jO5lftk1tXh55RyJN/yMd0PUOk0Gruze70
         Wjwt2aYDKALB3y+zCNOVNT4yLlbgTptBa0BEdyEKbhN6AzNoTcBKLhKlfXqhSO1hcqt2
         0fHw==
X-Gm-Message-State: AO0yUKUbFJ5mRk8QVV2q3O3NCV/qDXQYeb1w1UAuCZ1IhZSXRz3KfMTW
        sM4OoPmjj2phwUyxU6wqybCaP7dQk85wq4AiODLPUvMz6e9t7nzPSrWq54DJMcxcbl/dBHsW8Gs
        WTT9PSadqoD9+F+5U
X-Received: by 2002:a05:622a:44f:b0:3b6:89b6:fb6e with SMTP id o15-20020a05622a044f00b003b689b6fb6emr8188057qtx.21.1674690770815;
        Wed, 25 Jan 2023 15:52:50 -0800 (PST)
X-Google-Smtp-Source: AK7set9cpL6BBouE9Fjqi+KXE3cCRgDJ4jJDoEU01f4Nop3J6sxNDzgtkTmxUMprW73RHrxVm0MBqA==
X-Received: by 2002:a05:622a:44f:b0:3b6:89b6:fb6e with SMTP id o15-20020a05622a044f00b003b689b6fb6emr8188040qtx.21.1674690770598;
        Wed, 25 Jan 2023 15:52:50 -0800 (PST)
Received: from 2603-7000-9400-fe80-0000-0000-0000-0318.res6.spectrum.com (2603-7000-9400-fe80-0000-0000-0000-0318.res6.spectrum.com. [2603:7000:9400:fe80::318])
        by smtp.gmail.com with ESMTPSA id g25-20020ac842d9000000b003b2365c9aa6sm4284760qtm.14.2023.01.25.15.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 15:52:50 -0800 (PST)
Message-ID: <b610a041864cf696a686ba00910c252713ace0fe.camel@redhat.com>
Subject: Re: [PATCH net-next 0/5] tls: implement key updates for TLS1.3
From:   Simo Sorce <simo@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Apoorv Kothari <apoorvko@amazon.com>, sd@queasysnail.net,
        borisp@nvidia.com, dueno@redhat.com, fkrenzel@redhat.com,
        gal@nvidia.com, netdev@vger.kernel.org, tariqt@nvidia.com
Date:   Wed, 25 Jan 2023 18:52:49 -0500
In-Reply-To: <20230125150836.590fae7a@kernel.org>
References: <Y8//pypyM3HAu+cf@hog>
         <20230125184720.56498-1-apoorvko@amazon.com>
         <20230125105743.16d7d4c6@kernel.org>
         <3e9dc325734760fc563661066cd42b813991e7ce.camel@redhat.com>
         <20230125144351.30d1d5ab@kernel.org>
         <b2079e8c46815eedf40987e3c967e356242e3c52.camel@redhat.com>
         <20230125150836.590fae7a@kernel.org>
Organization: Red Hat
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

On Wed, 2023-01-25 at 15:08 -0800, Jakub Kicinski wrote:
> On Wed, 25 Jan 2023 18:05:38 -0500 Simo Sorce wrote:
> > > > If it is not guaranteed, are you blocking use of AES GCM and any ot=
her
> > > > block cipher that may have very bad failure modes in a situation li=
ke
> > > > this (in the case of AES GCM I am thinking of IV reuse) ? =20
> > >=20
> > > I don't know what you mean. =20
> >=20
> > The question was if there is *any* case where re-transmission can cause
> > different data to be encrypted with the same key + same IV
>=20
> Not in valid use cases. With zero-copy / sendfile Tx technically=20
> the page from the page cache can change between tx and rtx, but=20
> the user needs to opt in explicitly acknowledging the application=20
> will prevent this from happening. If they don't opt-in we'll copy=20
> the data.

Uhmm is there a way to detect this happening and abort further crypto
operations in case it happens ?

Simo.

--=20
Simo Sorce
RHEL Crypto Team
Red Hat, Inc



