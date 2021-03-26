Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49BC34A55A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhCZKMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:12:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhCZKLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:11:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616753506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QRPmV37hKOtWKvN7ZDrppJeIqphV5UqLCnAOHgP7RWE=;
        b=HozYGIA5vlx+PpGxd6oxqEWl6U3blPllYrrro5vyScaBRiTAXIxNHhmAo395ybhuWqKYYS
        432KznYFa+Igfp8AbAseyUIFUo56+19bitjs3TMPN+LM257roZzwkJ4ZAk7o8nTYdMfCJU
        Nwi+ERk866lDNuyNgehPH9298/rehzY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-ugHgKNnePAiWIMBzgSiFNg-1; Fri, 26 Mar 2021 06:11:44 -0400
X-MC-Unique: ugHgKNnePAiWIMBzgSiFNg-1
Received: by mail-ej1-f71.google.com with SMTP id k16so3865550ejg.9
        for <netdev@vger.kernel.org>; Fri, 26 Mar 2021 03:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QRPmV37hKOtWKvN7ZDrppJeIqphV5UqLCnAOHgP7RWE=;
        b=fC7yceV81ZC/K8yk4GCuJauwWMkuBysSSki162JnFL+bzVCCoqgkkAXF4IqYxW02x0
         HEqtU/9e0Z3boqxnNPX+T1GROJlOuFLs+L0t9kjlVsRWQREM9rvl/xEkOX3/ZR4rpF4d
         6+1GidC9TdQPYb3hyjD1XF6Bo4B7J7svgPl1ZVclQVqjM6cLaNC3V6BwlMlXWf31F8Uo
         XOsYpv6ZHT7EWNkMQCe7rpZR+W9j+2xZ5QCjeEXiBgE8AjGd2jNNveBLoNY2O3JbjmL0
         ae7D6GCHic8hbynl8l2g4LPb0kZEIeWX/Tm+7saB6GZl5snhKEHq8Rt6cOczL4JHrpHC
         lm5Q==
X-Gm-Message-State: AOAM533sHAKg6CefmJCtnI70JHtKIEr/bbU0BZxRoSfS5RS3zahyrR8g
        eQ/gw44fU7TARtA5CWwkDbIMFJqu2XiojVRWkD/wHUNCBiRW4mvrqRzJrJ4CFQ4cdPy3k0mg7Gm
        53z13RiF2gJmRmN97
X-Received: by 2002:a17:907:7699:: with SMTP id jv25mr13899682ejc.363.1616753502857;
        Fri, 26 Mar 2021 03:11:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBBvYh/8qPf0D5bWSxDuRIl04pHyOhhyzPiTCbTiADUGIA3wLU9bL8fOA7aaXHlyFmiXPNMw==
X-Received: by 2002:a17:907:7699:: with SMTP id jv25mr13899660ejc.363.1616753502430;
        Fri, 26 Mar 2021 03:11:42 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id g20sm3904652edb.7.2021.03.26.03.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 03:11:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0F12E1801A3; Fri, 26 Mar 2021 11:11:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 bpf-next 03/14] bpf: Support bpf program calling
 kernel function
In-Reply-To: <20210325230940.2pequmyzwzv65sub@kafai-mbp.dhcp.thefacebook.com>
References: <20210325015124.1543397-1-kafai@fb.com>
 <20210325015142.1544736-1-kafai@fb.com> <87wntudh8w.fsf@toke.dk>
 <20210325230940.2pequmyzwzv65sub@kafai-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 26 Mar 2021 11:11:41 +0100
Message-ID: <87ft0icjhe.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau <kafai@fb.com> writes:

> On Thu, Mar 25, 2021 at 11:02:23PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Martin KaFai Lau <kafai@fb.com> writes:
>>=20
>> > This patch adds support to BPF verifier to allow bpf program calling
>> > kernel function directly.
>>=20
>> Hi Martin
>>=20
>> This is exciting stuff! :)
>>=20
>> Just one quick question about this:
>>=20
>> > [ For the future calling function-in-kernel-module support, an array
>> >   of module btf_fds can be passed at the load time and insn->off
>> >   can be used to index into this array. ]
>>=20
>> Is adding the support for extending this to modules also on your radar,
>> or is this more of an "in case someone needs it" comment? :)
>
> It is in my list.  I don't mind someone beats me to it though
> if he/she has an immediate use case. ;)

Noted ;)
No promises though, and at the rate you're going you may just get there
first. I'll be sure to ping you if I do start on this so we avoid
duplicating effort!

-Toke

