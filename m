Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14A8B1E46B6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389501AbgE0PBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:01:22 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389419AbgE0PBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:01:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590591681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FyJKrIw1CrnW6A8RoV6krfHUwL+5u7uAIuDAT1bP2Y4=;
        b=e0TLWhGCk7Dg3cjNK1QPmRCCR++rDRZRQ9nT9opYJ4QtHq6DahorREWcQhhgjUF/ln3uuh
        wKraXa4vhJeXz4KO9na5Rk7nBFFOGc1TTAFmt+xxTI5Ddq7Jj/di2zFQV6hRpHz82dlHyE
        muHz3CwoIYxVV1h7yOKpndjnOM4voyU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-Haueb3rOOUO2XTig2GaqPA-1; Wed, 27 May 2020 11:01:14 -0400
X-MC-Unique: Haueb3rOOUO2XTig2GaqPA-1
Received: by mail-ed1-f70.google.com with SMTP id k21so10211954edq.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 08:01:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FyJKrIw1CrnW6A8RoV6krfHUwL+5u7uAIuDAT1bP2Y4=;
        b=RpeX7mwtcRcf+D6MNy80Xx4BVo4gEuXae+gxLZAxlGhEj5wJychYbOLWbc4E79Pe3b
         F/UB2lO5iFlYuarMwBQpEOu52TTROFNvllj4cNf8Q3GizJZeZU7Z/s84Z31QqjgzkMhr
         qqFezbOyg66PdJZWsfhtr7Dk7AiETvM/eoCtDrBeVvlGMo2m9GEQRBdydY6dw/Q/yhdU
         P2NgRSrUT110cPFSqjIx1PNVxt+3vl3LoAOaPLsS4z9r49M5NdvWKxH6sRnOrS0L/WcC
         kd3I2naxghsy2UFhwOUM4h90p3RyRaOVwFen1lvkhe18aleklIDYSAlj6/ZVJFrfwI0l
         aFfA==
X-Gm-Message-State: AOAM531Cf+SALBI3J/Ln+OpLANG7InTqWy3LxwXsFP4iHuPxsHkiAlJa
        zEDcoOE2HaDxfYqgThTAur4G5fat/9D6O577D2XYewJeOrB40srl0unRpHC9+6NVN7rkzpRNv/d
        wQl9t/xgYSLJZkNJ1
X-Received: by 2002:a17:906:41a:: with SMTP id d26mr6704618eja.217.1590591672203;
        Wed, 27 May 2020 08:01:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFo9kZXADSdcLyilVxy8fmDIdkt1zP24HiTrWOtf7UYSDyM98j1j0yroBRYojyNEGo1Lgetw==
X-Received: by 2002:a17:906:41a:: with SMTP id d26mr6704547eja.217.1590591671759;
        Wed, 27 May 2020 08:01:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id dd7sm2452550edb.19.2020.05.27.08.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 08:01:11 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BB6031804EB; Wed, 27 May 2020 17:01:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
Subject: Re: [PATCH bpf-next 4/5] bpftool: Add SEC name for xdp programs attached to device map
In-Reply-To: <18823a44-09ba-0b45-2ce3-f34c08c6ea5f@gmail.com>
References: <20200527010905.48135-1-dsahern@kernel.org> <20200527010905.48135-5-dsahern@kernel.org> <87367l3dcd.fsf@toke.dk> <18823a44-09ba-0b45-2ce3-f34c08c6ea5f@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 27 May 2020 17:01:10 +0200
Message-ID: <87o8q91ky1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/27/20 4:02 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@kernel.org> writes:
>>=20
>>> Support SEC("xdp_dm*") as a short cut for loading the program with
>>> type BPF_PROG_TYPE_XDP and expected attach type BPF_XDP_DEVMAP.
>>=20
>> You're not using this in the selftest; shouldn't you be? Also, the
>> prefix should be libbpf: not bpftool:, no?
>>=20
>
> The selftest is exercising kernel APIs - what is allowed and what is
> not.

Sure, but they also de facto serve as example code for features that are
not documented anywhere else, so just seemed a bit odd to me that you
were not using this to mark the programs.

Anyway, not going to insist if you prefer explicitly setting
expected_attach_type...

-Toke

