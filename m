Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4398E32115B
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 08:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhBVHYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 02:24:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229886AbhBVHYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 02:24:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613978600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YIiIUfu4WH7DzTKvI2fH+0QfvRuPcc6ESx6PnhBmeAc=;
        b=PL/jHiwELsOQcDsNJ9ezZXnt0JSa/Qa0mJ2NBVxmqqJQSdD6Fe8j6DA72EyVVVX+/EJCQk
        K8DN3BKW9Bt0P2IfBrM5pEd8b7ZrHuQA4BRoZGfI9cSW9HbDlnj1ZffEcCxUiitlrfglyq
        Pe2C/lakbJKVqalhvXjb/wmnRiAjieA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-swFLTXLHMhm9RhJs-3EYEQ-1; Mon, 22 Feb 2021 02:23:17 -0500
X-MC-Unique: swFLTXLHMhm9RhJs-3EYEQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71881803F48;
        Mon, 22 Feb 2021 07:23:15 +0000 (UTC)
Received: from carbon (unknown [10.36.110.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F1A7A1002382;
        Mon, 22 Feb 2021 07:23:02 +0000 (UTC)
Date:   Mon, 22 Feb 2021 08:23:01 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     brouer@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBl?= =?UTF-8?B?bA==?= 
        <bjorn.topel@intel.com>, maciej.fijalkowski@intel.com,
        hawk@kernel.org, toke@redhat.com, magnus.karlsson@intel.com,
        john.fastabend@gmail.com, kuba@kernel.org, davem@davemloft.net
Subject: Re: [PATCH bpf-next v3 1/2] bpf, xdp: per-map bpf_redirect_map
 functions for XDP
Message-ID: <20210222082301.753ec8f0@carbon>
In-Reply-To: <20210221200954.164125-2-bjorn.topel@gmail.com>
References: <20210221200954.164125-1-bjorn.topel@gmail.com>
        <20210221200954.164125-2-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Feb 2021 21:09:53 +0100
Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> wrote:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> Currently the bpf_redirect_map() implementation dispatches to the
> correct map-lookup function via a switch-statement. To avoid the
> dispatching, this change adds one bpf_redirect_map() implementation per
> map. Correct function is automatically selected by the BPF verifier.
>=20
> v2->v3 : Fix build when CONFIG_NET is not set. (lkp)
> v1->v2 : Re-added comment. (Toke)
> rfc->v1: Get rid of the macro and use __always_inline. (Jesper)
>=20
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/linux/bpf.h    | 20 +++++++-------
>  include/linux/filter.h |  9 +++++++
>  include/net/xdp_sock.h |  6 ++---
>  kernel/bpf/cpumap.c    |  2 +-
>  kernel/bpf/devmap.c    |  4 +--
>  kernel/bpf/verifier.c  | 17 ++++++++----
>  net/core/filter.c      | 61 ++++++++++++++++++++++++++++--------------
>  7 files changed, 78 insertions(+), 41 deletions(-)

Love it! :-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

