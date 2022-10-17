Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDB6A60079D
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 09:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiJQHXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 03:23:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiJQHXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 03:23:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B240159734
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665991392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FhhgHZx8Q8PVEkqlrCIoTuz66eSUWuXu09HQr4MTm2s=;
        b=IIcd+l4Dt6xLrJCC+PNn29VHZFnfje7jSYuVSOo3HfEmVoYBWzuMSSptskxHKJPqpRJvQF
        D9YnOPoUl7mbk5SUPgJzwqtM3UiGtXINqXcGtCXDI8jKvTp7zQWlP5u3ox+WkSflGaMKD+
        QCvStuvTx8nXzU9uwtQcLkXt2aQ7uN0=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-401-xuA5fdlNP3OLCaQgReKKfA-1; Mon, 17 Oct 2022 03:23:11 -0400
X-MC-Unique: xuA5fdlNP3OLCaQgReKKfA-1
Received: by mail-vs1-f69.google.com with SMTP id h8-20020a056102104800b003a7cdc977c4so2250261vsq.21
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 00:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FhhgHZx8Q8PVEkqlrCIoTuz66eSUWuXu09HQr4MTm2s=;
        b=FDMlnFVvInewziE2/108SZ2U3a1KVK0vzBLrURvyqGkb/UXq45TArBty9f7JyH2Ph6
         s1I/vNj+LbhkbXGvXwH57i2pyp0/6wnCpfFQ9eLdqtACn5AGLf+hQB29CZ75yrnON7hu
         KEgdpYsyPsWxxMrQ/N7SOTErIdfQb+lzs3Gi5wC9CxsucVOX7+WWqxvOtvGRmbWRUPa/
         SjXV7hyaa7/Fbiz9E/Onk44ZbiTfqlcx12iQ6g4EPgpY9+Ts+0rDOwSs01nOFymOn3tP
         9tz1UtkPoa9vv0DM9NTHsuI3pH45qbVBXI8libVE5sUl8fVcN/7bSU/g6RoayzO6FxK9
         RvtA==
X-Gm-Message-State: ACrzQf1Qf9GOQkfujbdVNAWD/urqWdqVIYzyNEGV/H/NbF37ErBBNsJA
        vIGiFPpygLkcaVj70QXR8OQ0HggxbHpI7kPqTVli5AHhzy0W12CuavW/XzqIiYMGRz8Y8b/Tr8C
        ygFqhSETNJPb0T9m+LXh4TY81pYGJISE/
X-Received: by 2002:a67:ea07:0:b0:3a7:86ba:ef76 with SMTP id g7-20020a67ea07000000b003a786baef76mr3441288vso.44.1665991390903;
        Mon, 17 Oct 2022 00:23:10 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6yuCDsbY9foZJJq27YvdlieZRbwJsMZt7i7HhPMQS54y9BdhBDENTHkmbWswAdEcRxKU61qohsnLf3+bo+Qik=
X-Received: by 2002:a67:ea07:0:b0:3a7:86ba:ef76 with SMTP id
 g7-20020a67ea07000000b003a786baef76mr3441273vso.44.1665991390674; Mon, 17 Oct
 2022 00:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20221014103443.138574-1-ihuguet@redhat.com> <Y0lSYQ99lBSqk+eH@lunn.ch>
 <CACT4ouct9H+TQ33S=bykygU_Rpb61LMQDYQ1hjEaM=-LxAw9GQ@mail.gmail.com>
 <Y0llmkQqmWLDLm52@lunn.ch> <CACT4oudn-sS16O7_+eihVYUqSTqgshbbqMFRBhgxkgytphsN-Q@mail.gmail.com>
 <Y0rNLpmCjHVoO+D1@lunn.ch>
In-Reply-To: <Y0rNLpmCjHVoO+D1@lunn.ch>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Mon, 17 Oct 2022 09:22:58 +0200
Message-ID: <CACT4oucrz5gDazdAF3BpEJX8XTRestZjiLAOxSHGAxSqf_o+LQ@mail.gmail.com>
Subject: Re: [PATCH net] atlantic: fix deadlock at aq_nic_stop
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     irusskikh@marvell.com, dbogdanov@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Li Liang <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 5:10 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > > Maybe the lock needs to be moved closer to what actually needs to be
> > > protect? What is it protecting?
> >
> > It's protecting the operations of aq_macsec_enable and aq_macsec_work.
> > The locking was closer to them, but the idea of this patch is to move
> > the locking to an earlier moment so, in the case we need to abort, do
> > it before changing anything.
>
> aq_check_txsa_expiration() seems to be one of the issues? At least,
> the lock is taken before and released afterwards. So what in
> aq_check_txsa_expiration() requires the lock?

Basically everything in the file aq_macsec.c seems to be implicitly
protected by rtnl_lock. One group of functions are all callbacks of
the `struct macsec_ops aq_macsec_ops`, which are responsible for
configuring macsec offload, all called under rtnl_lock. The rest of
the functions in the file are called from ethtool, also protected by
rtnl_lock.

And part of the problem is that many of these operations are firmware
and/or phy configurations which I don't have documentation about how
they work. Despite this, it seems reasonable to think that they need
to be lock protected.

> I don't like the use of rtnl_trylock(). It suggests the basic design is
> wrong, or overly complex, and so probably not working correctly.
>
> https://blog.ffwll.ch/2022/07/locking-engineering.html
>
> Please try to identify what is being protected. If it is driver
> internal state, could it be replaced with a driver mutex, rather than
> RTNL? Or is it network stack as a whole state, which really does
> require RTNL? If so, how do other drivers deal with this problem? Is
> it specific to MACSEC? Does MACSEC have a design problem?

I already considered this possibility but discarded it because, as I
say above, everything else is already legitimately protected by
rtnl_lock.

The only alternative I can think of is to add a driver only mutex
(let's call it aq_macsec_mutex), as you say, and everytime that macsec
offload is to be changed both rtnl_lock and aq_macsec_mutex would be
taken. It's true that aq_macsec_mutex wouldn't be much contended
because almost always rtnl_lock needs to be acquired first. From the
workqueue and the threaded irq there wouldn't be any deadlock because
they only hold aq_macsec_mutex and ndo_stop only holds rtnl_lock. I
would also allow to put the locking close to what they protect.

I thought that this solution would be a bit overkill, but maybe it's
less overkill than the one I chose. If you're OK with this, I can
prepare an v2.


--
=C3=8D=C3=B1igo Huguet

