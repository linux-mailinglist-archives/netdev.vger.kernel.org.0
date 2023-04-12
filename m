Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2414E6DFDE6
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 20:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjDLSri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 14:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjDLSri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 14:47:38 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0765372BE
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 11:47:17 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id os24so1640175ejb.12
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 11:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dectris.com; s=google; t=1681325235; x=1683917235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s0hLAh9mU9VHOxUov5Uf9frqImRP9AP6WLF+5Rn0Y0o=;
        b=X24RC2mzqT0l9+1gYsl75cdRL18yXdDNES7bawysBwNrjksIt3RpbZ8zwDNSmSrMwg
         uvpBHJmjdQDyIFrST0aIskoYvNJYPjfO4TmMdfW1v4ldiEv0wBYBrj+R1ucWLHL/Km0Y
         ElvRnzfonbWRbE3EzT7SCHrsBM2EQtLg3GNew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681325235; x=1683917235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s0hLAh9mU9VHOxUov5Uf9frqImRP9AP6WLF+5Rn0Y0o=;
        b=YxyQjCXZIx+rXmwuk32nARnUMwSyvAc7U+54s989mVb3dy4VksbOc3AjVN+cPbALc0
         tdpeJ/j+8jxM5+I4nVwGh6v1OhFBOb3KMNgoVhe9ovUw1x7VimF+Yf4hfnYYCWkOSK1A
         UhzzYTRtwlf9+d9vIwTWqcpTo7xvPR6a8vyyoPWDSicDGd+SHm/jM6J0HkL9e9nRvCFa
         JZ4RzOMuuiGDUJcxLYjrBPhPlxoxbcV4edCY3ZnCT2SW4j9yoFlHHPpMe8KJISbL4UeS
         SjXdabUUb2E6cjYyoXqYcTgNSs2wNnAiRke9gCBGueDJKLuY6Kx602crXQ9IVl7e1oxp
         v7gw==
X-Gm-Message-State: AAQBX9fIcRtGg6P6FkPnOXdpk+V/87A6y5Lvfak01e8rDDlwIrPmM8xW
        QU3wTcuaeh7Uuiy/ccp2mcgjyscpNUsCrL5KNYeKUg==
X-Google-Smtp-Source: AKy350YgLwZMkVknp5hjWbeGYCBbl9EWrKYOiRo2+TDz0R/zGynE3Ljhr7SKrSRwL4xEEPlZYVnng9wrTT3CRoMb0gY=
X-Received: by 2002:a17:907:a44:b0:8b8:aef3:f2a9 with SMTP id
 be4-20020a1709070a4400b008b8aef3f2a9mr7140785ejc.0.1681325235509; Wed, 12 Apr
 2023 11:47:15 -0700 (PDT)
MIME-Version: 1.0
References: <20230410120629.642955-1-kal.conley@dectris.com> <CAJ8uoz1CmRNMdTu3on7VL2Jrvo9z3WvdmFE_hSEiZDLiO-xtFw@mail.gmail.com>
In-Reply-To: <CAJ8uoz1CmRNMdTu3on7VL2Jrvo9z3WvdmFE_hSEiZDLiO-xtFw@mail.gmail.com>
From:   Kal Cutter Conley <kal.conley@dectris.com>
Date:   Wed, 12 Apr 2023 20:51:59 +0200
Message-ID: <CAHApi-=UJz04Acq+4O+v7ZprkoBH=aRB01Ug1i5Y1PLz58DbAA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 0/4] xsk: Support UMEM chunk_size > PAGE_SIZE
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thank you so much Kal for implementing this feature. After you have
> fixed the three small things I had for patch #2, you have my ack for
> the whole set below. Please add it.
>
> For the whole set:
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
>
> It would be great if you have the time and desire to also take this to
> zero-copy mode. I have had multiple AF_XDP users mailing me privately
> that such a feature would be very useful for them. For some of them it
> was even a requirement to be able to get down to the latencies they
> were aiming for.

Yes. We need this to work with zero-copy so next I will look into
implementing this for the mlx5 driver since it has to work for us on
Mellanox adapters.

Roping in the Mellanox engineers in case they want to add something :-)
