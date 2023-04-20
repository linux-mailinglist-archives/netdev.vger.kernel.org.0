Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9C86E8CFA
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbjDTIlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbjDTIk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:40:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BBE468A
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681980014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+KPqvhftdM3ihv59m9bKICRYUUJfa3URowkmjQtZA5c=;
        b=Eb9FLPNtfigxi4XbbwoKUqK4Lv9aTucurkKzjkuFswRawcYpJSDgEYh0to+ImC5DRBtsuZ
        kalk9Y2Y9qBO1rO15az+XzecQZZ7dj78vRQ72wdK08z9GSnSJH09ulo60WRfY1LJpcoWR+
        Cy25Qvg6h8UF46Tbv0J3xQ59hgJaIkY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-nV-AGoSBMWuw3bT3FUgUuw-1; Thu, 20 Apr 2023 04:40:13 -0400
X-MC-Unique: nV-AGoSBMWuw3bT3FUgUuw-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-74cf009f476so13821285a.0
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:40:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681980013; x=1684572013;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+KPqvhftdM3ihv59m9bKICRYUUJfa3URowkmjQtZA5c=;
        b=PP9fUDbavOI+84fk2NpriOIKI7fTvi/dqYjeEPvIRDwVhBK04iYEJU5Zr3OSMcfuJU
         iA4es8z4hUY3YMvtbp0kE6CuJUoF4Q2d4AmT2xyKZRc4PuVFBqR1GcwLWea8NK8k21Mb
         SxBKBBUMIpdcXhoHOAsiICMpzojcBXQgBix2hJwCJFP4NzNwQwvYAvFHoU7RL1ATbkJo
         ktnEh3zYxVtdHZcQG7QWB/2ynp2/n2kqrPBit4gi7RzrXg26pe37vz1HTEgktyhgKfmC
         A5w5UjZJiH111rWKCp0nr6tlQ4r2ebgDtLlBDm9clU85u4S4AWNNKliUaER8SDJCI2N1
         UF3g==
X-Gm-Message-State: AAQBX9eAUXjI62ZktCG6qOqIyjxtIBHEOgtdFsU+a+82Y9uTnnShw6/d
        6kN3jvBdDZpcP+E7+K+PzZZwYXCjy3Kgj7CQUnpApCQiwyT5spUDt5XyPcZiw9W9CerWrQ+MNw3
        m7EJpkRbqDv0DU3gQ
X-Received: by 2002:a05:6214:4106:b0:5ef:4de8:fb0d with SMTP id kc6-20020a056214410600b005ef4de8fb0dmr690029qvb.5.1681980013020;
        Thu, 20 Apr 2023 01:40:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZFPV3V96jY72YJIdowt7aqc4KyLuhbmZbJ38BM2/U/bW9LziAorEyzueX4wTRznwwJCHLa8Q==
X-Received: by 2002:a05:6214:4106:b0:5ef:4de8:fb0d with SMTP id kc6-20020a056214410600b005ef4de8fb0dmr690007qvb.5.1681980012667;
        Thu, 20 Apr 2023 01:40:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-230-117.dyn.eolo.it. [146.241.230.117])
        by smtp.gmail.com with ESMTPSA id w12-20020a0ce10c000000b005ef6e99d598sm263474qvk.133.2023.04.20.01.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:40:12 -0700 (PDT)
Message-ID: <68d139bdc5c2cc267864b2136efb591948f61c91.camel@redhat.com>
Subject: Re: [PATCH v2] net: amd: Fix link leak when verifying config failed
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gencen Gan <gangecen@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     hust-os-kernel-patches@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 20 Apr 2023 10:40:09 +0200
In-Reply-To: <20230419065829.4077082-1-gangecen@hust.edu.cn>
References: <20230419065829.4077082-1-gangecen@hust.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2023-04-19 at 14:58 +0800, Gencen Gan wrote:
> From: Gan Gecen <gangecen@hust.edu.cn>
>=20
> After failing to verify configuration, it returns directly without=20
> releasing link, which may cause memory leak.
>=20
> Signed-off-by: Gan Gecen <gangecen@hust.edu.cn>

Please include a suitable Fixes tag and specify the target tree in the
subj - see the documentation for the details.

More importantly, skimming over the relevant code I think that at least
a netdev is still leaked in the relevant error path.

Generally speaking the whole code of this driver is quite "suboptimal"
and looks unmainatained since at least ~15y, just receiving tree-wide
related changes.

I'm wondering if we could simply remove the whole driver?

Thanks

Paolo

