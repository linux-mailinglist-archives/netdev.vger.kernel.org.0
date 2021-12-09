Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F1346EC88
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhLIQJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:09:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30139 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236564AbhLIQJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:09:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639065959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZejQbQDCxehKZqduIxF41twQj65ihf/hPSBd0mgmYQ=;
        b=TOcouUbZDlTsjU3+b6z8N1G4xEtSuTWIrtWx2P9LkZXXyu3S2lLjYDGbNkbtg8orAd9kMm
        Np0KU+QNRRC76V3AA3dKdd2ujbgOmQrvjnEu7sq+u3jpAd4G+gPdNaoiKGQpjPN50X3XsC
        m1QtnhS0lfMVcOXUx++Dy2Zz+VogmlE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325--BSkgDX5ODu4PFfA26H9Cw-1; Thu, 09 Dec 2021 11:05:56 -0500
X-MC-Unique: -BSkgDX5ODu4PFfA26H9Cw-1
Received: by mail-ed1-f70.google.com with SMTP id n11-20020aa7c68b000000b003e7d68e9874so5677029edq.8
        for <netdev@vger.kernel.org>; Thu, 09 Dec 2021 08:05:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=AZejQbQDCxehKZqduIxF41twQj65ihf/hPSBd0mgmYQ=;
        b=wvqmn8p/YMKfjVFDujipLg6/5gZw6faktrLr/EcEhXw5QITPCNIUy08qrN5awn/iXg
         UOolxAxgdmNTFb3LhvwRrZlpptMThpjbKqXSathC8M5tVMIPhGgLSuImoZg4rIPPoV0a
         qlKicKguTa6MFMn7N8JyRpHHHV80JfUpadrzsxj7rkwGpRjXWfFRLbHU5h9JeNA4YIHG
         Yk0pJRZi8r3NNvmrw+KgT/qAACGLbOTX8rryvBeQn/oPo7s7bdz1jU9fRDZYbu/DRF3k
         gP66BTbQOy6zOCdM6sKQy+/DVKkWG0E3oXCW7xrCmnUVEDvCrOhPaxm9sQ5eZitkU0Pk
         8anA==
X-Gm-Message-State: AOAM532lptD2wJh2Dims9rGfxzPgz0hSYcH7gAbIX8wpz3U/Ytw6CXSR
        fdSmsbpL1UhxaCKlDELRPnHybHYNyzSK1EJhl8HJN5GTB+tWG2Qs0s/W1vmdTDywib1Pgm8UUie
        BJ5TxKB1uBmdFkzyK
X-Received: by 2002:aa7:c946:: with SMTP id h6mr30995693edt.190.1639065954380;
        Thu, 09 Dec 2021 08:05:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJywPn7TyRBgssPXLO3mnJ5AguEajLMBmJ5OYDuwDzh1EfBliQ/j7l5loknTbVgPUAk23MYu/A==
X-Received: by 2002:aa7:c946:: with SMTP id h6mr30995549edt.190.1639065953388;
        Thu, 09 Dec 2021 08:05:53 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id gt18sm126238ejc.88.2021.12.09.08.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 08:05:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 355B8180471; Thu,  9 Dec 2021 17:05:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: RE: [PATCH bpf-next 5/8] xdp: add xdp_do_redirect_frame() for
 pre-computed xdp_frames
In-Reply-To: <61b14e4ae483b_979572082c@john.notmuch>
References: <20211202000232.380824-1-toke@redhat.com>
 <20211202000232.380824-6-toke@redhat.com>
 <61b14e4ae483b_979572082c@john.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 09 Dec 2021 17:05:52 +0100
Message-ID: <87wnkdwyov.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Add an xdp_do_redirect_frame() variant which supports pre-computed
>> xdp_frame structures. This will be used in bpf_prog_run() to avoid having
>> to write to the xdp_frame structure when the XDP program doesn't modify =
the
>> frame boundaries.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  include/linux/filter.h |  4 ++++
>>  net/core/filter.c      | 28 +++++++++++++++++++++-------
>>  2 files changed, 25 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index b6a216eb217a..845452c83e0f 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -1022,6 +1022,10 @@ int xdp_do_generic_redirect(struct net_device *de=
v, struct sk_buff *skb,
>>  int xdp_do_redirect(struct net_device *dev,
>>  		    struct xdp_buff *xdp,
>>  		    struct bpf_prog *prog);
>> +int xdp_do_redirect_frame(struct net_device *dev,
>> +			  struct xdp_buff *xdp,
>> +			  struct xdp_frame *xdpf,
>> +			  struct bpf_prog *prog);
>
> I don't really like that we are passing both the xdp_buff ptr and
> xdp_frame *xdpf around when one is always null it looks like?

Yeah, the problem is basically that AF_XDP uses xdp_buff all the way
through, so we can't pass xdp_frame to that. I do agree that it's a bit
ugly, though; maybe we can just do the XSK disambiguation in the caller;
will take another look at this - thanks!

-Toke

