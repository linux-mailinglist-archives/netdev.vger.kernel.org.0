Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBD6A10E3A6
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 22:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfLAVkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 16:40:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:40186 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbfLAVkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 16:40:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575236441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tG5TIZfLOA8xt1lh5rIij2KaaBjofpenlumD9fhRM3E=;
        b=Lvb9nDuEoVKyKg8vUSi3eDVcdqROUOwoM1P96DigjEgH1b8eFfbwh+D5P3LEdK2TEJft19
        SlAvcY0X8kq9jQSOY5+TiSEQtVEpigH2MOmpPSRmH1h1MkZbgkdCtiAAHehQ7nS0aT+1l2
        Xpf8xnzJ1qJup4i+RjFaXQL8n3d/2IM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-PkB0CS5kPySmp6RpjaUkhQ-1; Sun, 01 Dec 2019 16:40:30 -0500
Received: by mail-qv1-f70.google.com with SMTP id g15so3759585qvq.20
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 13:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JTGzgGPMZkAos2frxTFOW4GGlQLGb9Frjb4++KqTi/M=;
        b=B5TarNwXdeaaQ1IxeCzhzaRIhB9yfugg1dIDJf2IPA3CF6sDwHIZLp6GoEVLRWdvBV
         qXvvDID8MdbYrHqulGrtK1vIqJhUgavNCJf2DhHS7uqPtBH0/hSmwEdYCFgyPRYGQtoN
         ToRZcvknR8ZMPJA85NoJitqllX6BQJ3QU4rkFmL58CAH1wBG+J4V6bOxsmt1fj729uqT
         SK4D/Kir/+c/qzwnowsuU/ypoFp6dsTym1s/C5RNOe4vsYrEdFe4PGzcYqiF6IrLcmFC
         V3V99kiwZs5EezKa7lkYlcpWCmwSpNBWAy+5szCds0g306pE6NYv7RG+22ZYR2Ogrb8R
         QvQg==
X-Gm-Message-State: APjAAAVldu3w9hj3KtSpofoI00ptrqoMpOoCQA22ae3/wK1NE4I9foIi
        RFOCUmkU5Y84BSKX67NuzMfbVCAUdY3uiIzxikeIDHE8H04srafRwuaxVCZpVOi3IETgIztlMfM
        inC8ciYMEEdIwGjyI
X-Received: by 2002:a0c:9304:: with SMTP id d4mr20056107qvd.12.1575236430593;
        Sun, 01 Dec 2019 13:40:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqwJvP9j5S9q3Ge/KOdZS8vWQSybrc86pCylj6ImGZeLhx1dUelTS/voklZcfzNpx7tuR/qMng==
X-Received: by 2002:a0c:9304:: with SMTP id d4mr20056096qvd.12.1575236430400;
        Sun, 01 Dec 2019 13:40:30 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id r48sm15329424qte.49.2019.12.01.13.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 13:40:29 -0800 (PST)
Date:   Sun, 1 Dec 2019 16:40:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@gmail.com, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
Message-ID: <20191201163730-mutt-send-email-mst@kernel.org>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126100744.5083-9-prashantbhole.linux@gmail.com>
 <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
 <20191201.125621.1568040486743628333.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20191201.125621.1568040486743628333.davem@davemloft.net>
X-MC-Unique: PkB0CS5kPySmp6RpjaUkhQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 01, 2019 at 12:56:21PM -0800, David Miller wrote:
> From: David Ahern <dsahern@gmail.com>
> Date: Sun, 1 Dec 2019 09:39:54 -0700
>=20
> > Below you just drop the packet which is going to be a bad user
> > experience. A better user experience is to detect XDP return codes a
> > program uses, catch those that are not supported for this use case and
> > fail the install of the program.
>=20
> This is not universally possible.
>=20
> Return codes can be calculated dynamically, come from maps potentially
> shared with other bpf programs, etc.
>=20
> So unfortunately this suggestion is not tenable.

Right. But it is helpful to expose the supported functionality
to guest in some way, if nothing else then so that
guests can be moved between different hosts.

Also, we need a way to report this kind of event to guest
so it's possible to figure out what went wrong.

--=20
MST

