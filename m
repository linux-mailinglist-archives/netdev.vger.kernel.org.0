Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECB9D5FEEDC
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 15:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiJNNoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 09:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJNNox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 09:44:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8491BBC0F
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665755074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wM+FA5ST6g0IH1JFs3LDpNeDY4YfE0BpPkCDhwaLjKo=;
        b=F89+K7roWhA2qybp60brlBaTyKZmsNIOw00zbRLRexC2Ht0LRu3nXj4IpfxLw4q8yyt83j
        LJSUNNHRgGKRQqZiVO0v+jOmNewD8PXzvKFouav4mc48ptuudllAXmIBNP8Yr0bAl25RUT
        B7E3Q7kFWZ+7ns1KXtPT6TToB626HDc=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-387-_ZlZZQUfORGHh2oG9NZWog-1; Fri, 14 Oct 2022 09:44:32 -0400
X-MC-Unique: _ZlZZQUfORGHh2oG9NZWog-1
Received: by mail-pj1-f70.google.com with SMTP id z24-20020a17090abd9800b0020d43dcc8c3so5247969pjr.9
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 06:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wM+FA5ST6g0IH1JFs3LDpNeDY4YfE0BpPkCDhwaLjKo=;
        b=k9hsGlUvnEwJo6zGqgmLLhROzE/2pRYWh4RcRMXtycxj6fVnudmq+PoqncXUsQIxX7
         /4McmkqpdBL+W2IL5SYIx0k+aq2nCijys8Ur6zdNdkNgfm/+zvKlQRVacsRDTGRB0+Tu
         efURwKbJvcFEXPIkzRtDYmHkhnp9V/va9lArXRgPxowc7aJb7M+x66vhBo8lDZAmj7aU
         43ja718fpsLkvaR/wvtu+Y5GS56mwFWXDRK7xYrVfg81Ozke97Gi3GODz2XToYnjb21B
         4j++yKJo60gQecvrkzjHkniF6lo54AvBvs6IQIRNtnlUpTMvsO59k6G87DNZGtRBVusw
         Ul+Q==
X-Gm-Message-State: ACrzQf38T/+JSYk4hFYohc7rqRwhL3pD7Tg/8h/BblXZ5nVu3y9Z6Y57
        0g9ULAfM/byFXWr0A57pXkWCDprZcfAA4ffZHkziXjcrscr2/FArCB/fpgqJyRfbVWngMc3iwFA
        qCxKHnS7FS5IfYfnhYlSlubcushk0KQbo
X-Received: by 2002:a17:90a:a017:b0:20d:63bf:1714 with SMTP id q23-20020a17090aa01700b0020d63bf1714mr6093090pjp.82.1665755070886;
        Fri, 14 Oct 2022 06:44:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5q04E/4JakX9cxVFuZvAEZ15Dc1IP3m6/47EkaPvE1cIqsuEdnriLexMrma9u9BPHCY7HeaTgoej44wnOqx38=
X-Received: by 2002:a17:90a:a017:b0:20d:63bf:1714 with SMTP id
 q23-20020a17090aa01700b0020d63bf1714mr6093064pjp.82.1665755070595; Fri, 14
 Oct 2022 06:44:30 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com> <Y0llmkQqmWLDLm52@lunn.ch>
In-Reply-To: <Y0llmkQqmWLDLm52@lunn.ch>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 14 Oct 2022 15:44:19 +0200
Message-ID: <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 3:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Fri, Oct 14, 2022 at 02:43:47PM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > On Fri, Oct 14, 2022 at 2:14 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > Fix trying to acquire rtnl_lock at the beginning of those functions=
, and
> > > > returning if NIC closing is ongoing. Also do the "linkstate" stuff =
in a
> > > > workqueue instead than in a threaded irq, where sleeping or waiting=
 a
> > > > mutex for a long time is discouraged.
> > >
> > > What happens when the same interrupt fires again, while the work queu=
e
> > > is still active? The advantage of the threaded interrupt handler is
> > > that the interrupt will be kept disabled, and should not fire again
> > > until the threaded interrupt handler exits.
> >
> > Nothing happens, if it's already queued, it won't be queued again, and
> > when it runs it will evaluate the last link state. And in the worst
> > case, it will be enqueued to run again, and if linkstate has changed
> > it will be evaluated again. This will rarely happen and it's harmless.
> >
> > Also, I haven't checked it but these lines suggest that the IRQ is
> > auto-disabled in the hw until you enable it again. I didn't rely on
> > this, anyway.
> >         self->aq_hw_ops->hw_irq_enable(self->aq_hw,
> >                                        BIT(self->aq_nic_cfg.link_irq_ve=
c));
> >
> > Honestly I was a bit in doubt on doing this, with the threaded irq it
> > would also work. I'd like to hear more opinions about this and I can
> > change it back.
>
> Ethernet PHYs do all there interrupt handling in threaded IRQs. That
> can require a number of MDIO transactions. So we can be talking about
> 64 bits at 2.5MHz, so 25uS or more. We have not seen issues with that.
>
> > > If MACSEC is enabled, aq_nic_update_link_status() is called with RTNL
> > > held. If it is not enabled, RTNL is not held. This sort of
> > > inconsistency could lead to further locking bugs, since it is not
> > > obvious. Please try to make this consistent.
> >
> > This is not new in these patches, that's what was already happening, I
> > just moved it to get the lock a bit earlier. In my opinion, this is as
> > it should be: why acquire a mutex if you don't have anything to
> > protect with it? And it's worse with rtnl_lock which is held by many
> > processes, and can be held for quite long times...
>
> Maybe the lock needs to be moved closer to what actually needs to be
> protect? What is it protecting?

It's protecting the operations of aq_macsec_enable and aq_macsec_work.
The locking was closer to them, but the idea of this patch is to move
the locking to an earlier moment so, in the case we need to abort, do
it before changing anything.

>
>          Andrew
>


--=20
=C3=8D=C3=B1igo Huguet

