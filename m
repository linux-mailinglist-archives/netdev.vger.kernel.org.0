Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2AB6D0439
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 14:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbjC3MBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 08:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbjC3MBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 08:01:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC610A24F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680177617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y4kBL+83QToteVgKil7VO5tgjxZqNxgaDRNr3gcrywg=;
        b=ENMSWLoTjVs1LrAvziK5C5RSczhBFWJKD5LtXB4vRmV7hGgtx9qnCCes0k5qkVIY7MujD+
        NBMPpOUsZK6M08YghFb9ZFKYRqnZJPy1EdDdo9oknbbSw3nh8RRrmyqT1lzhny3c1bG+Y4
        yjh8dhItAWX+u7zturFc3/it6dHIGTg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-319-K-6tmKRzORCJ3zA-bcv5Tw-1; Thu, 30 Mar 2023 08:00:15 -0400
X-MC-Unique: K-6tmKRzORCJ3zA-bcv5Tw-1
Received: by mail-qk1-f198.google.com with SMTP id c186-20020a379ac3000000b007484744a472so8439915qke.22
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:00:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680177615; x=1682769615;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y4kBL+83QToteVgKil7VO5tgjxZqNxgaDRNr3gcrywg=;
        b=g7aKOnTU1uigL6gplX60/cnRn5BrQTsE32VzhI7Xvysv35bonJuicxIrP4EEO3cMgT
         8KyIUclwTmnRC6BOMOVlA4uMmVcc/CyVDRZTbRMKeaC6oQvuaSc/C0wXHWL953LM09vs
         bP/ENbaYXbGxUvYOuBHEr2MF+vZh+AgM17f5FRIrhpbQnyg2Zl5WMePGKb0bpE++T6/m
         ThiI7QsD1QkBs9jj8x1KzfMk/76E8No648bTfdNTtwXx1CvsBTyEicE6QY7cq9F6Z8Dg
         acNmNb4DiLJwCgSKy48RgzIbGAN645gZgR0WRu3xJH4G/bvQSMfUZlGa6TDJeKRHisDa
         VWeg==
X-Gm-Message-State: AAQBX9dfQI1WueKPv2NedmyJbjhPmNKO9icF5Aov5nPZzqnUS4M+enIc
        NILlTxOAPzezg4h0KwugCsE2ag5d44LA3amlM6bGK99gFWHGfw2aERTE47JRP8120VP7o+KRYwv
        f61Le5+GR48Rc6ExWTTrInMXp
X-Received: by 2002:a05:622a:1815:b0:3e6:30c4:656f with SMTP id t21-20020a05622a181500b003e630c4656fmr3382252qtc.3.1680177615248;
        Thu, 30 Mar 2023 05:00:15 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZsHaKjIuC84GXaAXjkM9JM90iIamxuSWXB5xzRL6fwcpPAZ7ZkIYl8hCrmXXt/5ZFlO14V9w==
X-Received: by 2002:a05:622a:1815:b0:3e6:30c4:656f with SMTP id t21-20020a05622a181500b003e630c4656fmr3382202qtc.3.1680177614894;
        Thu, 30 Mar 2023 05:00:14 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-228-125.dyn.eolo.it. [146.241.228.125])
        by smtp.gmail.com with ESMTPSA id 4-20020a05620a048400b007468bf8362esm13619101qkr.66.2023.03.30.05.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 05:00:14 -0700 (PDT)
Message-ID: <4c10487da3a217bcfa9f5d7c515ab4a300c84949.camel@redhat.com>
Subject: Re: [PATCH v3] xen/netback: use same error messages for same errors
From:   Paolo Abeni <pabeni@redhat.com>
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, Jan Beulich <jbeulich@suse.com>
Date:   Thu, 30 Mar 2023 14:00:11 +0200
In-Reply-To: <20230329080259.14823-1-jgross@suse.com>
References: <20230329080259.14823-1-jgross@suse.com>
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

Hello,

On Wed, 2023-03-29 at 10:02 +0200, Juergen Gross wrote:
> Issue the same error message in case an illegal page boundary crossing
> has been detected in both cases where this is tested.
>=20
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

As this was intended to be part of:

xen/netback: fix issue introduced recently

I'm going to apply this one on net, unless someone screams very loudly,
very soon :)

thanks!

Paolo

