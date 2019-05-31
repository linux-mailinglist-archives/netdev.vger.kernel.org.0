Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25E230BE9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfEaJpb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:45:31 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33921 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfEaJpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 05:45:31 -0400
Received: by mail-qt1-f194.google.com with SMTP id h1so86767qtp.1;
        Fri, 31 May 2019 02:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LDcV29/qPVGpkB//OjeTrEbRfiUxEsIxdkaAJ+VTQlY=;
        b=soYhSBPo9zzMlghT0xaIhtrvfwo+dvXn44UcaDSKYqb2Ef++Fmyy/0YqlcDWpyQFwP
         hBOk9ZWTdbgBkgoO/HJ4SB0N2sz9eJ+1RggnIvEM6fJiLu+oIeYeytmgSg7yt4ksIPQL
         XVP0ABj8tOmn4FPvB1WwN8s9tf09LmN6nB3Jkr19OPdoom3im/j4/2+E38OYWAwO1JWE
         4iq/9wvzBtmdDTuehIp30J3W7mLolf6xY8HUb3GFSaZZFKYAk/GurDU89XCRyDVkjzrj
         WTt4E/2jJMVGR50m6SkYBODSWuf/uMg0hkKR5H1V+/l61Pup9z/SCZw/42zofu1KknuG
         cP7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LDcV29/qPVGpkB//OjeTrEbRfiUxEsIxdkaAJ+VTQlY=;
        b=XvQJdpjINCYBxzIri9mfIwfSNrnJZ7RwPOYhWyVsn9D8VlJtiBKkOTvOBH8H7d8I8v
         pGEDC6sLcbG/eCAEyHTdmEVZiiZ21DL2zCaRjH7NuIaMM7i3mOJ41G0kZ7ExzUbgQPzP
         4GwKdqqQ/jfGNAhPhsV1VSDX+jvb1MgIyZp/dOtLphdoPGvz0CRJN70gVP4y1FYDZijq
         k0ttGN5SVX0YBbz4IgsQy9y/+Iz+qWaBFmItXNx+A+j5cdYFWH6vHzVd9XTkFQJmZhvD
         vPoCGsc/lOpBrsVs0TUwrJZs5QEnzAMMy3EEEGOnrnmATk0p2z5WmwMDSeAvw3jlMfzi
         Gelw==
X-Gm-Message-State: APjAAAUT+ild73aEcl81lySQHCqu2/XuwlbDElX58f0J4WrBFWRAewbK
        bJQqdRWEMibuYN71lQ66J6d1NieWJWlDgH2tXd0=
X-Google-Smtp-Source: APXvYqwcPBfngY4jZ93UJIISh5+JRS/dCURkKMRSrEYGeaEFwabMz8dEQSjRgPAEiqCY9ezxPe4urkaBH4/aWoqrtDE=
X-Received: by 2002:a0c:d610:: with SMTP id c16mr7974447qvj.22.1559295930740;
 Fri, 31 May 2019 02:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190531094215.3729-1-bjorn.topel@gmail.com>
In-Reply-To: <20190531094215.3729-1-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 31 May 2019 11:45:19 +0200
Message-ID: <CAJ+HfNhE3X3nt7bsfgFC7UwahKtd4_SVJtGoSXAOsNw8MEZVFw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/2] net: xdp: refactor the XDP_QUERY_PROG and
 XDP_QUERY_PROG_HW code
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 May 2019 at 11:42, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>=
 wrote:
>
[...]
>
> I, hopefully, addressed all comments from Jakub and Saeed, except one;
> I did not move the XDP struct net_device into a struct of its own.
>

Uhm, the last sentence was weird.

What I meant was: I did not move the newly introduced XDP members
(flags/hw prog) into a struct of its own.
