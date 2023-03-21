Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014526C3A50
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjCUTWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCUTWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:22:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080B54D601
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679426461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rB+PzEgnKkqk2k+vvj3p24uGcCixq7dziCTji95CjO8=;
        b=JZTM2TcenXgYefXqY/9urk03qu7mr1Tha+D35ixYMkKLjwMz8U3OsSXrcU1EfjSxT2xGjO
        u+ej/kn1cdOz7wbPi2NMShYlJomNuAtBoz8MjYLp0BUTub65mgM2ANXJ8Cz68ZTrcB1QCn
        mOXx9AKtZERQTVjYRA8ve4FV6URUTl8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-482-NUATBQ6QP-2CMiXtBbUHyQ-1; Tue, 21 Mar 2023 15:20:59 -0400
X-MC-Unique: NUATBQ6QP-2CMiXtBbUHyQ-1
Received: by mail-ed1-f71.google.com with SMTP id r19-20020a50aad3000000b005002e950cd3so23695930edc.11
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:20:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679426458;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rB+PzEgnKkqk2k+vvj3p24uGcCixq7dziCTji95CjO8=;
        b=xku2oX6UqqWx6wLdC9Pp4aYxVCG78IR1Y3bGo90VXrHry0iMKfvSPkl5z+HyNqWIIB
         v09wtDLWewtg7Ib1YJfmitSEu7XAjRCMOpAIAORs0/0CYcs1yotuNmUVzo79RBdA3T7Q
         3EG4e5eLeYyhEtEceI3au+C7UgcjLCJ7Cjt8QQZsY+AD4ala6Pz4KOSEF9bNmCmeVQP3
         r2pYx+8YQSzFyg6a0BSqUs4vk34Ed01tYuYBIy0OLiow1Al3D1NDhndlwV/LpDFZzSw5
         ssbQ1Phm1xXJVummtImp3k48H7de3j7CwefJs4L95Jok2x/eJ01kuMcnUNs75/T5qmcV
         KE5Q==
X-Gm-Message-State: AO0yUKXZFcxIHqp2A59NO5Wih0ULxriOqbwOGNc+O4UX6Yu2L56KVu/x
        PXe4tEKIlb5zFdmjZtaEkmSXf+DNPERlbsZquSpuhRBc7Kyn1Ln4nZdcjZgopfcYvhr8hCkK9oJ
        kjIJ2Tr5Ral6NGl4W
X-Received: by 2002:a17:906:fad5:b0:931:5630:a23 with SMTP id lu21-20020a170906fad500b0093156300a23mr3658980ejb.50.1679426458391;
        Tue, 21 Mar 2023 12:20:58 -0700 (PDT)
X-Google-Smtp-Source: AK7set9PAjldqIVfgFwiw/sf3tp8nVNBWfUz5CMSnpL+CdmdP5wxKPXBBH2ukPUBvKl8JW297p5lsg==
X-Received: by 2002:a17:906:fad5:b0:931:5630:a23 with SMTP id lu21-20020a170906fad500b0093156300a23mr3658943ejb.50.1679426457816;
        Tue, 21 Mar 2023 12:20:57 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b17-20020a17090630d100b009300424a2fdsm6180946ejb.144.2023.03.21.12.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:20:57 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D24AC9E34C5; Tue, 21 Mar 2023 20:20:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, alexandr.lobakin@intel.com,
        larysa.zaremba@intel.com, xdp-hints@xdp-project.net,
        anthony.l.nguyen@intel.com, yoong.siang.song@intel.com,
        boon.leong.ong@intel.com, intel-wired-lan@lists.osuosl.org,
        pabeni@redhat.com, jesse.brandeburg@intel.com, kuba@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, hawk@kernel.org,
        davem@davemloft.net
Subject: Re: [xdp-hints] [PATCH bpf V2] xdp: bpf_xdp_metadata use EOPNOTSUPP
 for no driver support
In-Reply-To: <167940675120.2718408.8176058626864184420.stgit@firesoul>
References: <167940675120.2718408.8176058626864184420.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Mar 2023 20:20:56 +0100
Message-ID: <87ttyd7vxj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> When driver doesn't implement a bpf_xdp_metadata kfunc the fallback
> implementation returns EOPNOTSUPP, which indicate device driver doesn't
> implement this kfunc.
>
> Currently many drivers also return EOPNOTSUPP when the hint isn't
> available, which is ambiguous from an API point of view. Instead
> change drivers to return ENODATA in these cases.
>
> There can be natural cases why a driver doesn't provide any hardware
> info for a specific hint, even on a frame to frame basis (e.g. PTP).
> Lets keep these cases as separate return codes.
>
> When describing the return values, adjust the function kernel-doc layout
> to get proper rendering for the return values.
>
> Fixes: ab46182d0dcb ("net/mlx4_en: Support RX XDP metadata")
> Fixes: bc8d405b1ba9 ("net/mlx5e: Support RX XDP metadata")
> Fixes: 306531f0249f ("veth: Support RX XDP metadata")
> Fixes: 3d76a4d3d4e5 ("bpf: XDP metadata RX kfuncs")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

