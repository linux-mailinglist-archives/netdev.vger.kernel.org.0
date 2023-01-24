Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33C4679533
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 11:31:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232823AbjAXKbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 05:31:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjAXKbB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 05:31:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF561710
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674556209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gE6RrMNzmZS7ybaJ3k9jp16YpeIMyFtfxc7Ij1LgomY=;
        b=c5QnzOkWFOFImijZ/QnwGovC9GUArYGJtbhDhDJCqo4OXY4AbUSriteDkaXs+G/3TQvm16
        F1HhUEGJKkbLuE01yKGdtED4WInabbMb2/8AvmM9M899+KxFKkc2Oum3dxH34kX9J7VdAF
        8e6/DiffoX7tLWtS5T4Pimfey84T27E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-92-0CDsDBr-Pp6L4hoDocdnVw-1; Tue, 24 Jan 2023 05:30:08 -0500
X-MC-Unique: 0CDsDBr-Pp6L4hoDocdnVw-1
Received: by mail-qk1-f197.google.com with SMTP id q21-20020a05620a0d9500b0070572ccdbf9so10719020qkl.10
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 02:30:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gE6RrMNzmZS7ybaJ3k9jp16YpeIMyFtfxc7Ij1LgomY=;
        b=q/qZcrcPOatOO/TaizxC5EkX+/bp9diWT6XVcayjNutYA8Dft6w3iod3xSblWQBjh0
         Jf4gJuE0Nj5Gs8ypJHY6NJgH0kugIyPhzxtbXXs4btdWR20kQutGkRP0yOuM6rkYcB39
         qQ9rplqfAXxOzL+DmdcVkqNJ5t9y7kSyO0Z89dorNXjBEg8ymkFZgJKuRLAzwaLN9A3h
         1LNj/Yc4/yZqZ2e9DUaxbz8f3Ol37Opof60WGIzuXtF2pwsqQNW7qH7Cqw1VQmx0kaic
         eRETFOpTDlBUw+3b+9Sitgh+e9k0ylDIonfhdXLeh/pDiExSXld7wPhgw6UfFKpvElYc
         hwfg==
X-Gm-Message-State: AFqh2kpDRpmpR4GuPy0fm+c8rqt3T6mY8y+0bGRBEN+jOH67STGXbLZL
        8BRVrvWpryMHeH2ZHCyVK647WTIkK66KuXwmdR7ifugLdeDJfV0fxawd5ydBk7sZJUYRc19Hpi2
        pT6A4qUpDrsHerq60
X-Received: by 2002:ac8:7ee6:0:b0:3a8:28fb:b076 with SMTP id r6-20020ac87ee6000000b003a828fbb076mr36536513qtc.31.1674556205118;
        Tue, 24 Jan 2023 02:30:05 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs/aw10vutO5iLbCj/8fXlV7eIS/fKjhVMMxih8szWVQpFxZRKFIQ6yQ2WFku9UqiOy9NwgBw==
X-Received: by 2002:ac8:7ee6:0:b0:3a8:28fb:b076 with SMTP id r6-20020ac87ee6000000b003a828fbb076mr36536484qtc.31.1674556204835;
        Tue, 24 Jan 2023 02:30:04 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id a17-20020ac86111000000b003b68c7aeebfsm1048894qtm.3.2023.01.24.02.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 02:30:04 -0800 (PST)
Message-ID: <2aee59dccbcafb32cefdf164fd1d58eb6038b01a.camel@redhat.com>
Subject: Re: [PATCH net-next v4 0/8] Netlink protocol specs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, robh@kernel.org,
        johannes@sipsolutions.net, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com
Date:   Tue, 24 Jan 2023 11:29:59 +0100
In-Reply-To: <20230120175041.342573-1-kuba@kernel.org>
References: <20230120175041.342573-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2023-01-20 at 09:50 -0800, Jakub Kicinski wrote:
> I think the Netlink proto specs are far along enough to merge.
> Filling in all attribute types and quirks will be an ongoing
> effort but we have enough to cover FOU so it's somewhat complete.
>=20
> I fully intend to continue polishing the code but at the same
> time I'd like to start helping others base their work on the
> specs (e.g. DPLL) and need to start working on some new families
> myself.
>=20
> That's the progress / motivation for merging. The RFC [1] has more
> of a high level blurb, plus I created a lot of documentation, I'm
> not going to repeat it here. There was also the talk at LPC [2].
>=20
> [1] https://lore.kernel.org/all/20220811022304.583300-1-kuba@kernel.org/
> [2] https://youtu.be/9QkXIQXkaQk?t=3D2562
> v2: https://lore.kernel.org/all/20220930023418.1346263-1-kuba@kernel.org/
> v3: https://lore.kernel.org/all/20230119003613.111778-1-kuba@kernel.org/1

My understanding is that there is agreement on this, so merging as-is.

As possible follow-ups, I think it would be nice to drop the generated
files from the source tree and instead trigger the re-generation on-
demand. Additionally the yaml files could include an SPDX-License-
Identifier in an initial comments, I think.

Thanks,

Paolo

p.s. I guess we have new todo item for the mptcp protocol ;)

