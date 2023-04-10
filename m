Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460676DC25E
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 03:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjDJBkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 21:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDJBkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 21:40:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84BE3585
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 18:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681090792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y7vvaahi7EtSEdZtxTNRZslDy7MErAqHXrjq5q/UMYw=;
        b=OFleB525f6g2uw8/UHult48kirtaTH/M0e2gj4ZdUWZeJWu+w0s8QDndPox+3o4KK8FgHr
        bHUCORx5vjolB1SKPIkRRgFt4C3sQFXSl81WrOTa4SWUaTR2ecZHNmD5Yxqe3HSbwnpHlj
        8kebWGcpJDPKnnIJHafTP/udUmJ+Kzs=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-rX5d8ZC1PCOIdJ2CAWSGcQ-1; Sun, 09 Apr 2023 21:39:50 -0400
X-MC-Unique: rX5d8ZC1PCOIdJ2CAWSGcQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-1843282ca4aso2150055fac.4
        for <netdev@vger.kernel.org>; Sun, 09 Apr 2023 18:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681090790; x=1683682790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y7vvaahi7EtSEdZtxTNRZslDy7MErAqHXrjq5q/UMYw=;
        b=3bWW8kR8ow1tAEwVlxcHz3BTmrqnVjtABA+iqfkKXn2AKWYtmpkqRSgEkvgwN+KqM9
         aPlpHSIg8vugecBMN6CpUwNFQNwXU0T+l9bJUQ2qmXC51/5W0+yTfr681Cjzar9bSDjS
         OtaIgTshdNreaoM/dCB3GshN43EWRHjm9b6l2ClmUCSHLFDfN0ZQweTlkfwrTZwpdw8s
         RlwDHjKPvLeeRLzBSuGbq8SI45DAzfF3mDATaNuMXAjEBjuip7W7gkrPdwGnYdfPVB9V
         KHYIid67tJRUcpRlNVhjpnxquYG4uyrF7pNAbQHGYVECcwTGrLF5CU2nX+hQRLQ9+4vC
         TUCA==
X-Gm-Message-State: AAQBX9e79zIk4kIiZDJ2LbCEiZclon9LtyW2fLE89xbQP2Ce20C0KXKO
        Q+7Ljz0Bn2jJHiPpE0ehE/bHZRxePoBDs/NowajUPUVcN4/KkccsiFoFAkXumugLaOCX4Vy+hrt
        tSIipWwRRxwGc67aQrnues4XHwYmOrSxD
X-Received: by 2002:a54:4115:0:b0:36e:f6f5:604c with SMTP id l21-20020a544115000000b0036ef6f5604cmr1609969oic.9.1681090790034;
        Sun, 09 Apr 2023 18:39:50 -0700 (PDT)
X-Google-Smtp-Source: AKy350afNrE3GBqcnN6kNnP5S+FQWaWxrFPoCbQFmfTlo/EgX44P29Xg43OeVii5W6AF4zXUT0rOOqPNCrxN/L7OSFk=
X-Received: by 2002:a54:4115:0:b0:36e:f6f5:604c with SMTP id
 l21-20020a544115000000b0036ef6f5604cmr1609954oic.9.1681090789821; Sun, 09 Apr
 2023 18:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230407081021.30952-1-gautam.dawar@amd.com> <20230409091325.GF14869@unreal>
In-Reply-To: <20230409091325.GF14869@unreal>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 10 Apr 2023 09:39:38 +0800
Message-ID: <CACGkMEur1xkFPxaiVVhnZqHzUdyyqw6a0vw=GHpYKJM7U3cj7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v4 00/14] sfc: add vDPA support for EF100 devices
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Gautam Dawar <gautam.dawar@amd.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-net-drivers@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 9, 2023 at 5:13=E2=80=AFPM Leon Romanovsky <leon@kernel.org> wr=
ote:
>
> On Fri, Apr 07, 2023 at 01:40:01PM +0530, Gautam Dawar wrote:
> > Hi All,
> >
> > This series adds the vdpa support for EF100 devices.
> > For now, only a network class of vdpa device is supported and
> > they can be created only on a VF. Each EF100 VF can have one
> > of the three function personalities (EF100, vDPA & None) at
> > any time with EF100 being the default. A VF's function personality
> > is changed to vDPA while creating the vdpa device using vdpa tool.
>
> Jakub,
>
> I wonder if it is not different approach to something that other drivers
> already do with devlink enable knobs (DEVLINK_PARAM_GENERIC_ID_ENABLE_*)
> and auxiliary bus.

I think the auxiliary bus fits here, and I've proposed to use that in
V2 of this series.

Thanks

>
> Thanks
>

