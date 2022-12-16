Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B2764EF11
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiLPQ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 11:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLPQ3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 11:29:31 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614CB25C8
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:29:30 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id s7so2825352plk.5
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 08:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kP/FoMB1Yj/qY7ZBSatxXAMle19ZjD4rvZ91q9C/PSM=;
        b=W/OL8VTWs3dVmAhVDxbmhuv9Rd7+/pdKHXI44Jpe/hfHlPvPzddof3IsVDLys9PoNw
         j0Uj8/uHeYac+sO4Lx4ScVVG2ZZ8mDyqCW1G7Jh1sV53Fm7nJNJDwbz5vYMnsSZTHR8Q
         uLg7j3bVCcp0ar4gCYBb4uf+sEB8vSY4le4wC43Pua74B68gtQeaMv7dInSVgVP381vx
         BG3rpIHlsA3RBzQnl2riakl6p0mdqy6S2GYUaYP1Z8YZIbDd6tvTfHguQIFSzXkI2OOy
         Telvj864fhJLJDKzDqAMAkNofeeSO2RGrzDhRU7Yg/js+GOD/CO5nKghMNnlgQZYLxHq
         qCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kP/FoMB1Yj/qY7ZBSatxXAMle19ZjD4rvZ91q9C/PSM=;
        b=kzfR6Eypa7BUM/bKaw1hgN0vdoMpw3tv2W5hZLVb30sOsf/96Yr0nXCyXB4ZeRAMpO
         UPAIx/yCOjXtdUbmEQHkhj38DlldK7jv9M/NfFb9bfhgsaCjoOcecJp6PoaZQ9CmqLMX
         MOpkD4sjOkj24YjGdyFgtqzdAYvUCA8rlQb1DtdzmYNGUVF0HVZN7txytyJ0JK47l5FE
         4u9nCk8qG7qmPvP3P6SRtJxPj5lFMVncSzsRpO7TgBIO7Mnr9et3aoI9IUczmw+BwasL
         i5uGzFpxOv6/8XcNnOxAJqE+Xx6E89Vh49WwxTL/B12lXD9uVce7cP7Wx8wub9T9lAu7
         rMbw==
X-Gm-Message-State: ANoB5pktGA2GC2GyJWqyVVLoHKBWeHv1gHC26iiqmuEIjYnhAj2L99y3
        rwyF/QqbFmMum6uG4tvgQRM=
X-Google-Smtp-Source: AA0mqf7/EWAwq/mPcEBrQBEIPEl7QKavJQnPIidVqOy2mCfvTOaaHp565ziXNcoVzGI6iysNBs6FCw==
X-Received: by 2002:a05:6a20:1be2:b0:a7:ce31:f342 with SMTP id cv34-20020a056a201be200b000a7ce31f342mr27044309pzb.52.1671208169840;
        Fri, 16 Dec 2022 08:29:29 -0800 (PST)
Received: from [192.168.0.128] ([98.97.117.20])
        by smtp.googlemail.com with ESMTPSA id s24-20020a63f058000000b00473c36ea150sm1659196pgj.92.2022.12.16.08.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:29:29 -0800 (PST)
Message-ID: <c4109e30b644df218b7e601071a64197bf17b1f4.camel@gmail.com>
Subject: Re: [PATCH net v2 0/2] iavf: fix temporary deadlock and failure to
 set MAC address
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Michal Schmidt <mschmidt@redhat.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Patryk Piotrowski <patryk.piotrowski@intel.com>
Date:   Fri, 16 Dec 2022 08:29:28 -0800
In-Reply-To: <20221215225049.508812-1-mschmidt@redhat.com>
References: <20221215225049.508812-1-mschmidt@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-12-15 at 23:50 +0100, Michal Schmidt wrote:
> This fixes an issue where setting the MAC address on iavf runs into a
> timeout and fails with EAGAIN.
>=20
> Changes in v2:
>  - Removed unused 'ret' variable in patch 1.
>  - Added patch 2 to fix another cause of the same timeout.
>=20
> Michal Schmidt (2):
>   iavf: fix temporary deadlock and failure to set MAC address
>   iavf: avoid taking rtnl_lock in adminq_task
>=20
>  drivers/net/ethernet/intel/iavf/iavf.h        |   4 +-
>  .../net/ethernet/intel/iavf/iavf_ethtool.c    |  10 +-
>  drivers/net/ethernet/intel/iavf/iavf_main.c   | 135 ++++++++++--------
>  .../net/ethernet/intel/iavf/iavf_virtchnl.c   |   8 +-
>  4 files changed, 86 insertions(+), 71 deletions(-)
>=20

The series looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
