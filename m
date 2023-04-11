Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98FD6DD7CD
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 12:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjDKKWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 06:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjDKKWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 06:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB1042D67
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681208526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PUMbgMjwD7b2P0gwuvSsNcb0l2NG5Em13UpqkAEDfpw=;
        b=aKw1yldeZjebLrrXxDkicBQlMtVbrM0sUL/xfySFP4Y5VYLt6NJv2PwUGevha5Mo5yfQw6
        uFdJD53FRGtaPDvWchK1lLJeDtiLWjhhnQtWRK8cPmJxe3QKYKSZtd8JcVf/xhXpHalNvx
        VGcRKOwlFCALMeL+UAGUMSEF+f3Sk/8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-njOWaYZFMZ6IeT4N2uvaZg-1; Tue, 11 Apr 2023 06:22:04 -0400
X-MC-Unique: njOWaYZFMZ6IeT4N2uvaZg-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-74a90355636so46273685a.0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 03:22:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681208524; x=1683800524;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PUMbgMjwD7b2P0gwuvSsNcb0l2NG5Em13UpqkAEDfpw=;
        b=76quiKO44/kqqZ9ZieUxi8yf0kuaplwYXxhetPpKTFs8hzophTBenADgxNE8BUCqBS
         DQI+4SjkPBd3ANS5n+9RhE5yLDjBX6MKQFX+O3lZmI1ATbUPeUWQL+e2MqIOO4/yV/gm
         ddze/3yvQuYllMFIeytm0i4wShIhyXJLuNlCTHl1Fdpf5iQAXga0793zyS8wTH9GsbPg
         d7btNWDfvMgRTtpX4/JpW0Buke21KvT5VOPKmYNQkRApcQ3DcUTjx1N5tyOpnsolaQsZ
         mgsVv7x8xHW+JLj2Ck7zgV8/cqI1s06ud+YmSNriz8nKquXxKSOYdtGDnideYXL7OSKt
         rPkQ==
X-Gm-Message-State: AAQBX9fMZfDTxiRBUX8pSYy5vzEoky+5R17+4JHDCESXRLokUxNDwbN/
        IteXAiiBYaEwUAep/I5Yl46w/Gc3sCpBGc6nVDzwL2WIdo+Hm4ZhLcCPwHI8HspfOXNMWSZ0X2G
        bvxkvDEH/2DVQMrDA
X-Received: by 2002:a05:622a:189a:b0:3d1:16f4:ae58 with SMTP id v26-20020a05622a189a00b003d116f4ae58mr23574826qtc.2.1681208524511;
        Tue, 11 Apr 2023 03:22:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350YmA7/BDSARvwq5FagGqxA8JCUOFm69nLP0mnKYCkxo989nniOqmMTDd4A60O3KEjfF2cw8EA==
X-Received: by 2002:a05:622a:189a:b0:3d1:16f4:ae58 with SMTP id v26-20020a05622a189a00b003d116f4ae58mr23574807qtc.2.1681208524236;
        Tue, 11 Apr 2023 03:22:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-239-96.dyn.eolo.it. [146.241.239.96])
        by smtp.gmail.com with ESMTPSA id s125-20020a374583000000b007436d0e9408sm3857214qka.127.2023.04.11.03.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 03:22:03 -0700 (PDT)
Message-ID: <258624e7ffa7bfc3960e727c451cdabe4e7f3efe.camel@redhat.com>
Subject: Re: [PATCH net-next] bnxt_en: Allow to set switchdev mode without
 existing VFs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org
Cc:     mschmidt@redhat.com, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Tue, 11 Apr 2023 12:22:00 +0200
In-Reply-To: <20230406130455.1155362-1-ivecera@redhat.com>
References: <20230406130455.1155362-1-ivecera@redhat.com>
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

On Thu, 2023-04-06 at 15:04 +0200, Ivan Vecera wrote:
> Remove an inability of bnxt_en driver to set eswitch to switchdev
> mode without existing VFs by:
>=20
> 1. Allow to set switchdev mode in bnxt_dl_eswitch_mode_set() so
>    representors are created only when num_vfs > 0 otherwise just
>    set bp->eswitch_mode
> 2. Do not automatically change bp->eswitch_mode during
>    bnxt_vf_reps_create() and bnxt_vf_reps_destroy() calls so
>    the eswitch mode is managed only by an user by devlink.
>    Just set temporarily bp->eswitch_mode to legacy to avoid
>    re-opening of representors during destroy.
> 3. Create representors in bnxt_sriov_enable() if current eswitch
>    mode is switchdev one
>=20
> Tested by this sequence:
> 1. Set PF interface up
> 2. Set PF's eswitch mode to switchdev
> 3. Created N VFs
> 4. Checked that N representors were created
> 5. Set eswitch mode to legacy
> 6. Checked that representors were deleted
> 7. Set eswitch mode back to switchdev
> 8. Checked that representros were re-created

Could you please update the commit message and re-post?

Thanks!

Paolo

