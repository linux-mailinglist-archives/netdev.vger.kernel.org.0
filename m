Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2DD6A054C
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 10:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbjBWJxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 04:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjBWJxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 04:53:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5CE53EC5
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 01:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677145938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hiWA9MAreXUI6IRZzfTpL89haVwrA8zEt2E8eApKBoQ=;
        b=JIXS6NMIJ/oFowtH5inLVyK+qc3eEwA3UIaP2T08d+Hfwd3uTqD/QyGpsa3B7mThNJWZ4T
        qWrWh9Y2cYcAiWFINBT9rJ6y5Nxm8f1Yw9mSLscaTn6EAoaTe3AkPSv7iBfHdts3oBPhvh
        Urx+s+2HmtiI7F1zNnw/BZAu0rBrNM8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-169-PT97PsAOM0yURBtX2Y9fOg-1; Thu, 23 Feb 2023 04:52:17 -0500
X-MC-Unique: PT97PsAOM0yURBtX2Y9fOg-1
Received: by mail-qv1-f69.google.com with SMTP id jy22-20020a0562142b5600b005710b856106so5428366qvb.0
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 01:52:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677145936;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hiWA9MAreXUI6IRZzfTpL89haVwrA8zEt2E8eApKBoQ=;
        b=IbbXACaSdXwwoGke0Ad572Yfu38iOVaNjnD7FukEPQmOhz/hdDcxOAXF358v5VQgYZ
         pk2TrL6Qpxkn1oBHpVF5gm7haBOaM4RxaOsqkvfyvj/tQ1uZGt09Op5uN2aGSrlOnEES
         RIvh2Il8kE8RlF4+0VzngItb6Fspr+kNWfGX/6S7KlfgwWZAIijEQD4sZK6pnboMbunX
         WEOkclK6nPEl5H+q7doKmJeC1WtoEXapfPqUSGSObmrAnnwGupBY3lW6pJzf2noU0ECj
         cFsKrf/pUBPoktXo4Knom2+eYkwdGBRZSN0f2JYKk+9eJrDuTvQOgBV5+3WlNrsbqkIL
         VpoA==
X-Gm-Message-State: AO0yUKVCCGOVUNUW6L/zzWLNk5lJnOVFMRqXNpTRz712OywKOrTtawDS
        6W79hLHuHPdw7nAqfIB4jd0rzHJ+QmBOfxcqd0a+9r2HaIK+PVyWnFtEq7f4R6zR830nyviwhv/
        hxnEdY3iC3LSxq3cb
X-Received: by 2002:a05:622a:118f:b0:39c:da22:47b8 with SMTP id m15-20020a05622a118f00b0039cda2247b8mr24571218qtk.1.1677145936724;
        Thu, 23 Feb 2023 01:52:16 -0800 (PST)
X-Google-Smtp-Source: AK7set+8cQmNNnQVUSxvHo9JVgmb+kjKrxF67imPwpha8hzRWci5qd3zoqSBgG5eIJ9xBrhDRma/NQ==
X-Received: by 2002:a05:622a:118f:b0:39c:da22:47b8 with SMTP id m15-20020a05622a118f00b0039cda2247b8mr24571198qtk.1.1677145936408;
        Thu, 23 Feb 2023 01:52:16 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id a14-20020a05622a064e00b003b9b41a32b7sm3834484qtb.81.2023.02.23.01.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 01:52:16 -0800 (PST)
Message-ID: <8e05cf636937ad59e32b4ae7f1e7e8732c694421.camel@redhat.com>
Subject: Re: [net PATCH] octeontx2-af: Unlock contexts in the queue context
 cache in case of fault detection
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sai Krishna <saikrishnag@marvell.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        sumang@marvell.com
Date:   Thu, 23 Feb 2023 10:52:12 +0100
In-Reply-To: <20230222065921.1852686-1-saikrishnag@marvell.com>
References: <20230222065921.1852686-1-saikrishnag@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-02-22 at 12:29 +0530, Sai Krishna wrote:
> From: Suman Ghosh <sumang@marvell.com>
>=20
> NDC caches contexts of frequently used queue's (Rx and Tx queues)
> contexts. Due to a HW errata when NDC detects fault/poision while
> accessing contexts it could go into an illegal state where a cache
> line could get locked forever. To makesure all cache lines in NDC
> are available for optimum performance upon fault/lockerror/posion
> errors scan through all cache lines in NDC and clear the lock bit.
>=20
> Fixes: 4a3581cd5995 ("octeontx2-af: NPA AQ instruction enqueue support")
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>

After the net-next merge, this does not apply cleanly to net anymore.

Please rebase and re-post, thanks!

Paolo

