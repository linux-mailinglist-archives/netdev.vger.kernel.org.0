Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 172432B54F7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbgKPX3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:29:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbgKPX3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:29:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605569356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=29i5jFbCpMBjOMLduGjN9Ff1FImT1jBsomcSSYB+Xa0=;
        b=Fvv49v+8GNvI9X0+J6ofByj+n+gzafASWH8VmAlEBlhPIZi2kvAur9ahJvNJX63VRZ+1Bh
        EZ+qJccHWySY/6X1wSygnvlyWApvhBwzUYexwhqrHFZ/rz3/xhOhkS2LmROqLuey82SIqa
        Yc+ub2COSCOKJXxdSJ/0bqfx/jyMB3A=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-DdjSMRxTOjKQcD7FzDkjlA-1; Mon, 16 Nov 2020 18:29:14 -0500
X-MC-Unique: DdjSMRxTOjKQcD7FzDkjlA-1
Received: by mail-wr1-f72.google.com with SMTP id y2so11874449wrl.3
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 15:29:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=29i5jFbCpMBjOMLduGjN9Ff1FImT1jBsomcSSYB+Xa0=;
        b=jhhoUuGEiFkbv0TMwoI3PQivDQERbhyVZsd73D/hKusDrxeGM9Cy3e4KZ0oBVkV4kD
         3bor1mxCq6N0EE7Z2CAjaN41waDa6TUtob2pQPkZKQJAUCibBEeFBkmvNq5E8hSI616z
         vqFk0RbEkrRS1h5Tohj6AtqYYgAf5d6lFv61GxX4x6cjGDA8IPn95CMvvAmxZAflQ7sc
         K7TaN2AvoSBDFEFTT3PZPHbv60mKRkuF8iK7qDMlBWDeSqmX/HGr4dId1VDh0hjRtBeH
         opqQvsIXYfh7ylsLiUyE8CmkguWNcg+t3psI7FYdGsoG/YZn9up64BjECeTV8VoU0M7O
         D3TA==
X-Gm-Message-State: AOAM532mDXZBSJvKmLJ1oVx2/w1ERqZ8Natzvr0HHbLyRJVG4suG6TR/
        6bBpREA/wJSDXFBHgaV1o4vK0R3L5j9VA2JhPh7NmMz0NkJN97qPABMZi/wh4E610YnOnVv58g6
        21LcVUQyWAeh4VtQZ
X-Received: by 2002:a1c:9a12:: with SMTP id c18mr1237657wme.22.1605569353686;
        Mon, 16 Nov 2020 15:29:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwWxGtBfVK/PtwsEclUDT2ZDsuscK/pAbuvbQtVTslUxVNOxAbVUElLBYTRnCOnIIhk1a8TsQ==
X-Received: by 2002:a1c:9a12:: with SMTP id c18mr1237648wme.22.1605569353538;
        Mon, 16 Nov 2020 15:29:13 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f11sm24314892wrs.70.2020.11.16.15.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 15:29:12 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6DD6E1833E0; Tue, 17 Nov 2020 00:29:11 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Hangbin Liu <haliu@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        brouer@redhat.com
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
In-Reply-To: <20201116155446.16fe46cf@carbon>
References: <20201109070802.3638167-1-haliu@redhat.com>
 <20201116065305.1010651-1-haliu@redhat.com>
 <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
 <20201116155446.16fe46cf@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 Nov 2020 00:29:11 +0100
Message-ID: <87tuto3mpk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> When compiled against dynamic libbpf, then I would use 'ldd' command to
> see what libbpf lib version is used.  When compiled/linked statically
> against a custom libbpf version (already supported via LIBBPF_DIR) then
> *I* think is difficult to figure out that version of libbpf I'm using.
> Could we add the libbpf version info in 'tc -V', as then it would
> remove one of my concerns with static linking.

Agreed, I think we should definitely add the libbpf version to the tool
version output.

-Toke

