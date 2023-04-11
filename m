Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812976DD170
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 07:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjDKFQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 01:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbjDKFQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 01:16:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7AA1FC4
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681190163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hU+qgshibA1QfkJQle3bVOxSYrB+boxQWnfu4An3Eok=;
        b=IPKi3560QFLoaVXLDCcHLoYQ+CkuN2q3CjT3JKjU8/MOFXtkI/oaExZtR2Aw0Mu3R0v+hs
        ImT5DyzhWvHpTOZGXK5s/RF4SvKIDAMsJxgxEEpYY8zDI2vmCetSwtL9VEiU/PCLC4Johy
        sdPiVYn2sxJkHbMye6Q6jqwAE8cKp0M=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-108-08fmdsSeMoKLBeoTRHjwLQ-1; Tue, 11 Apr 2023 01:16:01 -0400
X-MC-Unique: 08fmdsSeMoKLBeoTRHjwLQ-1
Received: by mail-ed1-f71.google.com with SMTP id y95-20020a50bb68000000b004fd23c238beso4146187ede.0
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 22:16:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681190160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hU+qgshibA1QfkJQle3bVOxSYrB+boxQWnfu4An3Eok=;
        b=UDIyFB284bj3DLisEc4OHEAJhAiw63XQDwQc5dD6WbPCTsb8S/Z1ukhubkOQY6cAgK
         0iTDf+qFUwsfTMGFmlTMLt7PaCSt7qcbxtn2L2dgBcGx2LsPWA5JtLfI4mNoeMLel15J
         XTLDZZ9tslkUZ0H1ggsvqkMTrpCQ7GiD+m/HPIXZxeGJhWLgjYjK3evvu0E5IQ6Ov0CA
         ZdyXq1WGMdqwPJhJBTOCguQxswy24AFogf37BwdaD7FtDTImMXiqCB3xoUzszo0HfJLg
         ZRZp33cTcYl2erD/7eqMRgmGhwANcOV68GJZQpOnAj+NL/8Nr1kKRhRnCLgAhINwGMTl
         TDSA==
X-Gm-Message-State: AAQBX9dgBUT9TZ81PWDBbm51Et3RzW3NbA2aGS+8KMz4JOvYy5qf0aSV
        mYMCravzMbRtC8nGmpzMqh4T4/jyrX+vtWSZRpfqkxGKD7vP44sJM/kecMz9qoxWGxVVJHeja7N
        x0cWnGH6dDCTHE/p9uYkBoEZDiJwqadLU
X-Received: by 2002:a17:906:f744:b0:931:7350:a7b6 with SMTP id jp4-20020a170906f74400b009317350a7b6mr608716ejb.10.1681190160820;
        Mon, 10 Apr 2023 22:16:00 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZSrOuTKyYCifxH4ItJKR+N8lT2bcDdBJFNQ6hbJX88RtxXv4hqkH9qsfUiOy9DoXNkBgz93DhO8D4e3MMOrZQ=
X-Received: by 2002:a17:906:f744:b0:931:7350:a7b6 with SMTP id
 jp4-20020a170906f74400b009317350a7b6mr608708ejb.10.1681190160585; Mon, 10 Apr
 2023 22:16:00 -0700 (PDT)
MIME-Version: 1.0
References: <CAKVySpzU_23Z6Gu1N=z0DRm+sUQDjyiyUc18r4rJ_YQ+YELuFg@mail.gmail.com>
 <27297.1681189100@famine>
In-Reply-To: <27297.1681189100@famine>
From:   Liang Li <liali@redhat.com>
Date:   Tue, 11 Apr 2023 13:15:49 +0800
Message-ID: <CAKVySpwe62hKhavEFuh6tHPWV=w_vAn0hEp0inV5XGTx73wdHQ@mail.gmail.com>
Subject: Re: [Question] About bonding offload
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        Paolo Abeni <pabeni@redhat.com>, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangbin Liu <haliu@redhat.com>,
        "Toppins, Jonathan" <jtoppins@redhat.com>
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

Thanks everyone! Glad to know this.

On Tue, Apr 11, 2023 at 12:58=E2=80=AFPM Jay Vosburgh
<jay.vosburgh@canonical.com> wrote:
>
> Liang Li <liali@redhat.com> wrote:
>
> >Hi Everyone,
> >
> >I'm a redhat network-qe and am testing bonding offload. e.g. gso,tso,gro=
,lro.
> >I got two questions during my testing.
> >
> >1. The tcp performance has no difference when bonding GRO is on versus o=
ff.
> >When testing with bonding, I always get ~890 Mbits/sec bandwidth no
> >matter whether GRO is on.
> >When testing with a physical NIC instead of bonding on the same
> >machine, with GRO off, I get 464 Mbits/sec bandwidth, with GRO on, I
> >get  897 Mbits/sec bandwidth.
> >So looks like the GRO can't be turned off on bonding?
>
>         Well, it's probably more correct to say that GRO is
> unimplemented for "stacked on top" interfaces like bonding (or bridge,
> vlan, team, etc).  GRO operates early in the receive processing, when
> the device driver is receiving packets, typically by calling
> napi_gro_receive() from its NAPI poll function.  This is well before
> bonding, bridge, et al, are involved, as these drivers don't do NAPI at
> all.
>
> >I used iperf3 to test performance.
> >And I limited iperf3 process cpu usage during my testing to simulate a
> >cpu bottleneck.
> >Otherwise it's difficult to see bandwidth differences when offload is
> >on versus off.
> >
> >I reported a bz for this: https://bugzilla.redhat.com/show_bug.cgi?id=3D=
2183434
> >
> >2.  Should bonding propagate offload configuration to slaves?
> >For now, only "ethtool -K bond0 lro off" can be propagated to slaves,
> >others can't be propagated to slaves, e.g.
> >  ethtool -K bond0 tso on/off
> >  ethtool -K bond0 gso on/off
> >  ethtool -K bond0 gro on/off
> >  ethtool -K bond0 lro on
> >All above configurations can't be propagated to bonding slaves.
>
>         The LRO case is because it's set in NETIF_F_UPPER_DISABLES, as
> checked in netdev_sync_upper_features() and netdev_sync_lower_features().
>
>         A subset of features is handled in bond_compute_features().
> Some feature changes, e.g., scatter-gather, do propagate upwards (but
> not downwards), as bonding handles NETDEV_FEAT_CHANGE events for its
> members (but not vice versa).
>
>         TSO, GSO, and GRO aren't handled in either of these situations,
> and so changes don't propagate at all.  Whether they should or not is a
> separate, complicated, question.  E.g., should features propagate
> upwards, or downwards?  How many levels of nesting?
>
>         -J
>
> >I reports a bz for this: https://bugzilla.redhat.com/show_bug.cgi?id=3D2=
183777
> >
> >I am using the RHEL with kernel 4.18.0-481.el8.x86_64.
> >
> >BR,
> >Liang Li
> >
>
> ---
>         -Jay Vosburgh, jay.vosburgh@canonical.com
>

