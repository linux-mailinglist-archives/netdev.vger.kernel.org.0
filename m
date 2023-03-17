Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5306BDFB3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 04:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCQDhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 23:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjCQDhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 23:37:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D003523328
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679024202;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kq7BvkG6r8mc5f/+Ki2Y2nBhbeMzRIKO9qsutt2z3SM=;
        b=b20ymZHWIABhKOJeYFmcWWRZEmWcS9bE+lIRypWQ6lQO99ePtSInEmgNugBha2jqCqt7do
        DmoYbKpWHHKnzyzvF2THItrB73JLk2q+Potuu8GVP0HJLmVZKQrZY38YuXN1rVOF/hLhNg
        vzJ5utWBtMb5CsDJIGZjSoHrMxoO/c0=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-LjB6BbhUNeamtG1euvqr9w-1; Thu, 16 Mar 2023 23:36:40 -0400
X-MC-Unique: LjB6BbhUNeamtG1euvqr9w-1
Received: by mail-oi1-f199.google.com with SMTP id bf30-20020a056808191e00b003843744eaecso1770848oib.0
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 20:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679024200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kq7BvkG6r8mc5f/+Ki2Y2nBhbeMzRIKO9qsutt2z3SM=;
        b=kWn/CBO4H/PMKJQRuhuI6AR3yeeRxP4nVxd1VXRdcSsyuiIDrbQszZtRTdD5+dWg73
         KliNqvBpP2G4fs/IJ4CWD6Pc2n+h+Ovf93niaE0v4DaJjvcs2NjfGZ2bv6u5RJ6XbwAf
         0NDhWTQc5NifvI0kQbMoaSl1P691IOcAfcR5ZfZeGdWGAJOEDUdH1s3k4dGJtyLt/6T+
         NlF0vqUQO+Nj0bCXKQ7dbu+LbcmAfc9Bfdxf/kglYN95CJc5aIsg9xebCjM01Y5rcKJ/
         0JULD9gV++1+atyOXGLbpvZbkIDdZK3eDxvcBXtCCN7IgI7VOg1nby52OmTy87o8wWA6
         HxCw==
X-Gm-Message-State: AO0yUKW9RgbqvmDYicgm8XiMr7wwHBtm2nNsj48dW2elVq41RomjXGqs
        7CZTfcpVjUPBxzTKTrWpc0rIEyUcj1+RrX5Mcwi8yYnxuYimGBgTpHTlVwCYvRRFf2bLsRMMRyc
        y0b9bPLX5bwntbYPkAoXx1bj1BQ1eWsDa
X-Received: by 2002:a54:470c:0:b0:383:fef9:6cac with SMTP id k12-20020a54470c000000b00383fef96cacmr2871250oik.9.1679024200058;
        Thu, 16 Mar 2023 20:36:40 -0700 (PDT)
X-Google-Smtp-Source: AK7set+T6KPM6IMRqEx8BDN7YTTwmjdxGsCZRqnpMabFawh1Uhlesv2xEI0Lnd7ukW16F+PlFKNRCdgdDI0dwHM7/E0=
X-Received: by 2002:a54:470c:0:b0:383:fef9:6cac with SMTP id
 k12-20020a54470c000000b00383fef96cacmr2871242oik.9.1679024199853; Thu, 16 Mar
 2023 20:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230309013046.23523-1-shannon.nelson@amd.com>
 <20230309013046.23523-5-shannon.nelson@amd.com> <CACGkMEtcm+VeTUKw_DF=bHFpYRUyqOkhh+UEfc+ppUp5zuNVkw@mail.gmail.com>
 <cde38f74-66da-7eb0-c933-d4848bd17bc1@amd.com>
In-Reply-To: <cde38f74-66da-7eb0-c933-d4848bd17bc1@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Mar 2023 11:36:28 +0800
Message-ID: <CACGkMEvm03ANeDKMQbVcoFzcgrHLEUXXXaar1JwYBG91J_THEQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2 virtio 4/7] pds_vdpa: add vdpa config client commands
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io
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

On Thu, Mar 16, 2023 at 11:25=E2=80=AFAM Shannon Nelson <shannon.nelson@amd=
.com> wrote:
>
> On 3/15/23 12:05 AM, Jason Wang wrote:
> > On Thu, Mar 9, 2023 at 9:31=E2=80=AFAM Shannon Nelson <shannon.nelson@a=
md.com> wrote:
> >>
> >> These are the adminq commands that will be needed for
> >> setting up and using the vDPA device.
> >
> > It's better to explain under which case the driver should use adminq,
> > I see some functions overlap with common configuration capability.
> > More below.
>
> Yes, I agree this needs to be more clearly stated.  The overlap is
> because the original FW didn't have the virtio device as well modeled
> and we had to go through adminq calls to get things done.

Does this mean the device could be actually probed by a virtio-pci driver?

>  Now that we
> have a reasonable virtio emulation and can use the virtio_net_config, we
> have a lot less need for the adminq calls.

Please add those in the changelog. Btw, adminq should be more flexible
since it's easier to extend for new features. If there's no plan to
model a virtio-pci driver we can even avoid mapping PCI capabilities
which may simplify the codes.

Thanks

