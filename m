Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 454C66DD951
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 13:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDKLZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 07:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjDKLZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 07:25:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A365E3C16
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681212277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MtPLyLYKhvmRWrlscYidgNx3zT5WdNKDqiq0WkceOio=;
        b=DCQJK15HE9GvMgR8p9ezzKO4VJ+/0QJqug3Pj5G637RWC7SlsH0f+iQGfv0rQjVbaCKNBV
        h8zZIEol6ls+cYdGBVX2Ng9e9FxC4fwi1GCuqNmgb9EE5kTAhSsD3wRf6KfXQraBgJyRY/
        yFkjoJgOwRa2d0kjO+yuUfhLHIBEAmI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-650-psFAkZlVOv-md2j6z1BGRA-1; Tue, 11 Apr 2023 07:24:36 -0400
X-MC-Unique: psFAkZlVOv-md2j6z1BGRA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f083f439daso2979775e9.1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 04:24:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681212275; x=1683804275;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MtPLyLYKhvmRWrlscYidgNx3zT5WdNKDqiq0WkceOio=;
        b=GDMH9aU7Zq6gTpAb2Ntd83Phv4+KpPY+G/HhBoQNfjTCA8EQSm0TNdmpeavDikXCB3
         xaQ40mLdUqBc6iJQrfR+ACBm0pLtc6LdUbjljNRocOtFsU9s/Y7gLEhdRC6017/2V3Qu
         +TRiEDDdEGnQAMpKlpPGcn8mX45M1qTK04hiNnuSEnuKVPe2z8el0H9TJLvbLHt3gf+t
         KfqcsxUY1iC1mQEOs3KrphWH7Ue1jfsT6sKVDMr+KogPWA5QZgIzMtUGl2CwqfmvTnL7
         UOmVyTgeFeaTr+RjC7DBHk3sbMpRkC1xS/JGaljKz8haisuksYl+EloEoltJeqdr6M1e
         CC0w==
X-Gm-Message-State: AAQBX9eJ4Au46di8ztelbzGVrgUG3ThUuOl6OhdzhUiss/PosfEfx6Fx
        VikjAYOGJNC6heRqi+utmz15i83UszTKTAs9t2JzyQVSglB2kVQJPfZHZvQ/iIZy+8IDN4UeFpH
        zvOImBc/EFvEyVyXQ
X-Received: by 2002:a05:600c:3ca3:b0:3eb:2e2a:be95 with SMTP id bg35-20020a05600c3ca300b003eb2e2abe95mr7821406wmb.2.1681212275510;
        Tue, 11 Apr 2023 04:24:35 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZaJdY9wSGZcde9+lbsNZ2ANdpKdY7cuJ2dIOasA09jgWsCgaLNmGkfulMRAgdLTl46i2QGMA==
X-Received: by 2002:a05:600c:3ca3:b0:3eb:2e2a:be95 with SMTP id bg35-20020a05600c3ca300b003eb2e2abe95mr7821393wmb.2.1681212275209;
        Tue, 11 Apr 2023 04:24:35 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-96.dyn.eolo.it. [146.241.239.96])
        by smtp.gmail.com with ESMTPSA id s21-20020a05600c45d500b003f082388117sm10705154wmo.32.2023.04.11.04.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 04:24:34 -0700 (PDT)
Message-ID: <87eef8a06064dc895f183ba2a1cd649c213f3e37.camel@redhat.com>
Subject: Re: [PATCH net-next v2] qlcnic: check pci_reset_function result
From:   Paolo Abeni <pabeni@redhat.com>
To:     Denis Plotnikov <den-plotnikov@yandex-team.ru>,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, anirban.chakraborty@qlogic.com,
        sony.chacko@qlogic.com, GR-Linux-NIC-Dev@marvell.com,
        helgaas@kernel.org, simon.horman@corigine.com, manishc@marvell.com,
        shshaikh@marvell.com
Date:   Tue, 11 Apr 2023 13:24:33 +0200
In-Reply-To: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
References: <20230407071849.309516-1-den-plotnikov@yandex-team.ru>
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

On Fri, 2023-04-07 at 10:18 +0300, Denis Plotnikov wrote:
> Static code analyzer complains to unchecked return value.
> The result of pci_reset_function() is unchecked.
> Despite, the issue is on the FLR supported code path and in that
> case reset can be done with pcie_flr(), the patch uses less invasive
> approach by adding the result check of pci_reset_function().
>=20
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>=20
> Fixes: 7e2cf4feba05 ("qlcnic: change driver hardware interface mechanism"=
)
> Signed-off-by: Denis Plotnikov <den-plotnikov@yandex-team.ru>

Any special reason to target the net-next tree? This looks like a -net
candidate to me?

Thanks!

Paolo

