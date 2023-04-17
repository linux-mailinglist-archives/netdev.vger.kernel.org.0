Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633376E4E3D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 18:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjDQQZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 12:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbjDQQZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 12:25:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5068A8A49
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681748661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gebAtwnzCZoH2xTQLpQQoLDlDf/rmy7R2p6LUv+7PhE=;
        b=TrT1PgJdgnWiqTrZcs6zp8xEzWhDkL6pwtWgewpsOgiP97/0LV3Nx6pNTMdoWKN5nP4vJh
        oTNnVMtArbT05l5AKsdc4e2WjmYbx83wG0bIhCRXYwXIqhzuandZtlV9csfalqIoTBXC9s
        sMUjMorrOEGsjS2+HkJ4sIW7wX11s6A=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-529-37Wqt86QNeCWdTHl40mPGA-1; Mon, 17 Apr 2023 12:24:20 -0400
X-MC-Unique: 37Wqt86QNeCWdTHl40mPGA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-506a7b4f141so510174a12.2
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681748659; x=1684340659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gebAtwnzCZoH2xTQLpQQoLDlDf/rmy7R2p6LUv+7PhE=;
        b=PI6hwMDtnee6r5vb2J/hogg08ErXYf6+YLGDDwOzR67BSxnQJZIm02MyRDRIWKzZ24
         xMClouSSV/203hy7dd3TxhadBRf+FmNwz/yUG5kzXEdmxaxq+U8ZzoQczX8/VI5qPuy+
         hcl56bprDEaw4G93iaWL/QAeUNdcSDIm1rg02xTIN44fOq8r3/32qv+nzjuJqqA89FQ7
         YoPBOADSc0GssOS0I5jfXyedayg+5lItqGyqNEjJkQmnC02ROiOAjsFyZvSRWGfMGH4l
         m2x0KwtLPfCU/1XUMtUZ2MikwfvZk0aJ5610hk3OCa3J0j2O/k8P1THeibCAnGBbt+wo
         g8MQ==
X-Gm-Message-State: AAQBX9fvNp813DMS6jtdODM29eJpuosCaV8e2VziYZD1gqTDdNGmtp7Y
        TKLE6+Zh+NWZdD6q3TlNXrUjxoAyVKuccrBqvitXCuj0GbXarMRvztdOYhoUxlgCW5cS9ctAJ7J
        4gWLTcRWW6chtS7Cg4NwVo9eg0wo730rILhruTD0LGGQ=
X-Received: by 2002:aa7:d48a:0:b0:504:b313:5898 with SMTP id b10-20020aa7d48a000000b00504b3135898mr14524695edr.27.1681748659124;
        Mon, 17 Apr 2023 09:24:19 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZIFKZ+T1+M7w68kveccnHcbUct+5jSZO98c9lviD1jtBSifvFpsed3P3VyOK8lG0UtsXx+WfSU1afTEmW/ARg=
X-Received: by 2002:aa7:d48a:0:b0:504:b313:5898 with SMTP id
 b10-20020aa7d48a000000b00504b3135898mr14524668edr.27.1681748658830; Mon, 17
 Apr 2023 09:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230417130052.2316819-1-aahringo@redhat.com>
In-Reply-To: <20230417130052.2316819-1-aahringo@redhat.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 17 Apr 2023 12:24:07 -0400
Message-ID: <CAK-6q+iLvka6M7ag4ATMP40Cn+zetVW60XW+4kpn8HGZ=bnXKQ@mail.gmail.com>
Subject: Re: [PATCHv2 net] net: rpl: fix rpl header size calculation
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, alex.aring@gmail.com,
        daniel@iogearbox.net, ymittal@redhat.com, mcascell@redhat.com,
        torvalds@linuxfoundation.org, mcr@sandelman.ca,
        maxpl0it@protonmail.com
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

Hi,

On Mon, Apr 17, 2023 at 9:09=E2=80=AFAM Alexander Aring <aahringo@redhat.co=
m> wrote:
>
> This patch fixes a missing 8 byte for the header size calculation. The
> ipv6_rpl_srh_size() is used to check a skb_pull() on skb->data which
> points to skb_transport_header(). Currently we only check on the
> calculated addresses fields using CmprI and CmprE fields, see:
>
> https://www.rfc-editor.org/rfc/rfc6554#section-3
>
> there is however a missing 8 byte inside the calculation which stands
> for the fields before the addresses field. Those 8 bytes are represented
> by sizeof(struct ipv6_rpl_sr_hdr) expression.
>
> Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> Signed-off-by: Alexander Aring <aahringo@redhat.com>

Reported-by: maxpl0it <maxpl0it@protonmail.com>

I just got this information. Thanks for reporting it.

- Alex

