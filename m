Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F34556F0356
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 11:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243313AbjD0JZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 05:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243254AbjD0JZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 05:25:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8DAC3
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682587498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L0O0igeMSQGLMEnBfzsh0MXVaNX4GEBVOhYMjLuzzkc=;
        b=iVJIwaKnzwFehSCRqPqeV1WiPyhM/cM9bxtD5mskJhz3E7S5Bsfe3OvYIvFuX3KjjNmFRx
        XDuxe6dN7TANpYdABE5gyo4wo2MT2b5r3/f09ycaPx+yXuo78q6uFw2b+0FmHhi9mUQqcX
        PH4G88BulI4Ui2CrOReczy/nMmcuepU=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-46-8aG6pd5GPbquluWUFd_e3g-1; Thu, 27 Apr 2023 05:24:57 -0400
X-MC-Unique: 8aG6pd5GPbquluWUFd_e3g-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3ef2cb3bfbfso23298871cf.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 02:24:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682587496; x=1685179496;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L0O0igeMSQGLMEnBfzsh0MXVaNX4GEBVOhYMjLuzzkc=;
        b=YRkcf3/H3uSiL83BdziapIZKB1nXYhbdOYUT+fN3cFBXmNkSaTvYIU2NlD+PbHFEL/
         Vscrrfg514TdsrOB8QazGdEwkdnBPuB+kvlgfKsolGdQQ8HJizkr5qv4Jdm4gBScbF4/
         cDtix6KQJjH7Ab2pUuum8cr7e38rvfiipbCxIUt6WBVhuUWBRBX91KZs0t7KT5WbZ/rQ
         wXI6Fm1FiheYTlt2I+Ap3HEqThrjgYV2NA5noWlPKQxEmBqWw9b40DUQrlyP2uChAZw+
         2ePA0FaUJwTZtFapnUNoy9RWFBsrripgsaZs93FqgQDDwnkjK3jMnqX1dOtQssSiPEe/
         dDdA==
X-Gm-Message-State: AC+VfDz9UR07j5PhazDyKCnYSX4XPclKC1X/J0ueVB3TzsI1dGNcdUEm
        2cR1gMJu8DNf2zzopdzOuRGmPdegcqC7flrheDXMTYiehv/dHCeiccn1N04/fJbAtuYzzsaasVQ
        QP4G/rpKok+sCf0ksmLp368LR4Gk=
X-Received: by 2002:a05:622a:4d3:b0:3ef:4614:d0e9 with SMTP id q19-20020a05622a04d300b003ef4614d0e9mr1246972qtx.5.1682587496658;
        Thu, 27 Apr 2023 02:24:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5f5uHqyMx2vL/NEFVqZMESMnKiMrL0YvMf9QVdVeR+hESJ51Zw9nqpowEwjDTXpdEbHVO/bg==
X-Received: by 2002:a05:622a:4d3:b0:3ef:4614:d0e9 with SMTP id q19-20020a05622a04d300b003ef4614d0e9mr1246956qtx.5.1682587496406;
        Thu, 27 Apr 2023 02:24:56 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-21.dyn.eolo.it. [146.241.243.21])
        by smtp.gmail.com with ESMTPSA id ga21-20020a05622a591500b003e4f1b3ce43sm5077353qtb.50.2023.04.27.02.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 02:24:56 -0700 (PDT)
Message-ID: <a67aa5c2997a816c2573a7f9da3215dbac20b32a.camel@redhat.com>
Subject: Re: [PATCH net 2/3] ice: Fix ice VF reset during iavf initialization
From:   Paolo Abeni <pabeni@redhat.com>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wesierski, DawidX" <dawidx.wesierski@intel.com>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>,
        "Romanowski, Rafal" <rafal.romanowski@intel.com>
Date:   Thu, 27 Apr 2023 11:24:52 +0200
In-Reply-To: <CO1PR11MB5089EE31C5E298306B8BF7A5D6659@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
         <20230425170127.2522312-3-anthony.l.nguyen@intel.com>
         <20230426064941.GF27649@unreal>
         <CO1PR11MB5089EE31C5E298306B8BF7A5D6659@CO1PR11MB5089.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-04-26 at 16:22 +0000, Keller, Jacob E wrote:
> > From: Leon Romanovsky <leon@kernel.org>
>=20
> > But what I see is that ICE_VF_STATE_ACTIVE bit check is racy and
> > you
> > don't really fix the root cause of calling to reset without proper
> > locking.
> >=20
>=20
> I think there's some confusing re-use of words going on in the commit
> message. It describes what the VF does while recovering and re-
> initializing from a reset. I think the goal is to prevent starting
> another reset until the first one has recovered.=C2=A0

Uhmm... it looks like the current patch does not prevent two concurrent
resets, I think the goal of this patch is let other vf related ndo
restart gracefully when a VF reset is running.

> I am not sure we can use a standard lock here because we likely do
> want to be able to recover if the VF driver doesn't respond in a
> sufficient time.
>=20
> I don't know exactly what problem this commit claims to fix.

I think this patch could benefit from at least a more
descriptive/clearer commit message.

Thanks,

Paolo

