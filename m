Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35D9B5A19A1
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 21:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243339AbiHYTh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 15:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241530AbiHYThy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 15:37:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EF2BC824
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 12:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661456273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bPWa+tzTBG+iL60ZzcAk1+gPnoGOubAk1xJV1dc/DQY=;
        b=CC6Pc1HtQjTJ3s3HxMhLWhp9Bwqlx4Me76wyxREiVAqHW5vt8HVAL2qjamiGfA5cbKNtHv
        jyN26cTH7PL0mJ4dDyuZCZWihopSGG+Rs9xvxpWY13TKpaNc7lOZMtFmqWse0pz9e0KKsF
        MPrVSWinNdjxUQevtztK+lDkNYirjI0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-533-aSEdxCIjNpSbm_IzhbqawA-1; Thu, 25 Aug 2022 15:37:51 -0400
X-MC-Unique: aSEdxCIjNpSbm_IzhbqawA-1
Received: by mail-il1-f198.google.com with SMTP id o5-20020a056e02102500b002ddcc65029cso15501756ilj.8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 12:37:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=bPWa+tzTBG+iL60ZzcAk1+gPnoGOubAk1xJV1dc/DQY=;
        b=TUwi1XLJvlyr7WQKjr8V7+35EiuXlY+fnec4Lc0ptqxLMxvlxcyeVLqQ3EL4+Dv0Cm
         nyHzOv1eHbXsdswLv2NKvCZCfQJZUIZbWUyPc+VzvpdPB2f01cP9XwdrPepovBzj6hlt
         O7sTaaY3imazmb6YCGJliGd13tqfi8iVpm7HuA0XErfcqtCLwX3JQT3SgXIu/67y80Nl
         9dYwfTdLKDE93+422J7AP1H9zzciR6R8vfxlULk3t/+rkHZjFHUYel+Qo1ErEYARN5yf
         4FWJXjz8dRC5gf32CPhr1knMZ4wjlmcQ7m5Jm8fB/pyQT7EnyhRfnMKwD0I3cOdFNdtG
         fxzQ==
X-Gm-Message-State: ACgBeo0HOFgBdnPBDcPoZR8MFTwMF3prfk8K7LvbFpvv40VUBwOoGT4r
        kgtbz/l1tnF2qN9a2LZQ0auQu+mTIku7J4UX2wugLvMPSG4EArChTPRqLqiwzwUVEi7rnbc9VN7
        LEWQqnAig2ypelyT5
X-Received: by 2002:a02:caa6:0:b0:349:bbca:9a90 with SMTP id e6-20020a02caa6000000b00349bbca9a90mr2651626jap.203.1661456271132;
        Thu, 25 Aug 2022 12:37:51 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6uSXM7JpieCkAL/ZWJiy8snaZElDHAaeSiWAhWn8tGuMwjSwo6rhFGPS2VGsYxErUfUXGbsA==
X-Received: by 2002:a02:caa6:0:b0:349:bbca:9a90 with SMTP id e6-20020a02caa6000000b00349bbca9a90mr2651614jap.203.1661456270935;
        Thu, 25 Aug 2022 12:37:50 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id i13-20020a056e02054d00b002e4d61ca3e2sm159664ils.0.2022.08.25.12.37.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 12:37:50 -0700 (PDT)
Date:   Thu, 25 Aug 2022 13:37:49 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V4 vfio 00/10] Add device DMA logging support for mlx5
 driver
Message-ID: <20220825133749.34281d14.alex.williamson@redhat.com>
In-Reply-To: <e6e79361-a19c-9ad6-403b-9a08f8abcf34@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <e6e79361-a19c-9ad6-403b-9a08f8abcf34@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 14:13:01 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:
> Alex,
>=20
> Can we please proceed with sending PR for the series to be accepted ?=C2=
=A0=20
> (i.e. as of the first two net/mlx5 patches).
>=20
> The comments that were given in the previous kernel cycle were addressed=
=20
> and there is no open comment here for few weeks already.

Hmm, it's only been posted since last week.  I still find the iova
bitmap code to be quite a mess, I just sent comments.  Thanks,

Alex

