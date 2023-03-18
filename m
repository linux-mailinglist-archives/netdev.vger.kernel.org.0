Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4486BFBAF
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 17:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCRQzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 12:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCRQzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 12:55:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1289932503
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 09:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679158488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7PHuti/aIn/jDkzsfM7L4wYK0AWAIzyvHRDnVmmNwBI=;
        b=Tzuysw5kql06NF78eVM1Nlr3RBz4CUfTL9URMlBkof5CqGzNhFtd8zT1eJIsEXjSAUpMQl
        rBq1yE+MLArLS+V3FqCPG4VKBRfK7lS1CqQzb9yh/SHcg3wrEx/2T05fMJ3gzAgLhEWTD1
        T+jJxoJ9Xg00pO5FUYJW715OvcE5L6k=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-q5upkn8IM2eCTEmJDc4oMA-1; Sat, 18 Mar 2023 12:54:47 -0400
X-MC-Unique: q5upkn8IM2eCTEmJDc4oMA-1
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-544781e30easo78363167b3.1
        for <netdev@vger.kernel.org>; Sat, 18 Mar 2023 09:54:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679158486;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7PHuti/aIn/jDkzsfM7L4wYK0AWAIzyvHRDnVmmNwBI=;
        b=2NFBtnLZpNohN1KV2TJrZsTY3iSWoHoC1lNqbmta9BZtArefAL6d1Da/Tuo8UdD2Nu
         flCclpeiRMBRKPsXW2RJ8OdPCb3JJ/5p9fXW83Ja8bIF9jT8EAjYoEUIBc+gjVB5yVvI
         6VknViVntAj0rzgVyKP4MkdfL86PXQrFGT+9s8N7vmmVMmTqlxzlbVHhQ/G8AqNYXREZ
         4a6CjLE3oNGvcsHj9zBe4MOloMNnePC2A+4Z2UV70xybrqeXrQXnfvtFJ3fy3YxlhKcE
         tFt3dXf60b2cpBjn6RXnlPw+9Vx1HdTtceBOhFq5ZfcsfYboHnt2K0gleF+/FtRE3hgW
         Gmvw==
X-Gm-Message-State: AO0yUKVFw9lraZNfZ+juF715TGM9QZ5SbboW4exHWDt5y1YltONrcLa4
        dfO0eK/0i5pHQY5dn2Gujk7VRT2bpYk3dzJjtFSkNJvL3ex/zHOL4X629eVLx6G4pv6nqclk6x6
        wmCTSynCU6F2WhQNKH5fSJboKTn4RpCx59kleIU/4
X-Received: by 2002:a5b:181:0:b0:acd:7374:f15b with SMTP id r1-20020a5b0181000000b00acd7374f15bmr1696244ybl.13.1679158486005;
        Sat, 18 Mar 2023 09:54:46 -0700 (PDT)
X-Google-Smtp-Source: AK7set9eFHxfyfmBTSgAd70eGcUDvPbNGINJHkOuBEqoc2z/7alD/ojV7TDTShQV70NHO8uwDJ1nt5YHJmbb/CqIGRQ=
X-Received: by 2002:a5b:181:0:b0:acd:7374:f15b with SMTP id
 r1-20020a5b0181000000b00acd7374f15bmr1696240ybl.13.1679158485809; Sat, 18 Mar
 2023 09:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <20230316120142.94268-1-donald.hunter@gmail.com>
 <20230316120142.94268-3-donald.hunter@gmail.com> <20230317215228.68ad300a@kernel.org>
In-Reply-To: <20230317215228.68ad300a@kernel.org>
From:   Donald Hunter <donald.hunter@redhat.com>
Date:   Sat, 18 Mar 2023 16:54:35 +0000
Message-ID: <CAAf2ycne3nQ4Y_-tNihgMMtmDiNtQ7o7bGMjojrEUBJR_JsHMA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 2/2] netlink: specs: add partial specification
 for openvswitch
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Donald Hunter <donald.hunter@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Mar 2023 at 04:52, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 16 Mar 2023 12:01:42 +0000 Donald Hunter wrote:
> > +user-header: ovs_header
>
> Let's place this attr inside 'operations'?

Ah, good point - can it vary per operation and should it be a property
of each command?

> also s/_/-/ everywhere, we try to use - as a separator in the spec,
> the C codegen replaces it with underscores

Ack, will do.

