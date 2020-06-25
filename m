Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C18B20A62C
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406879AbgFYTyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:54:01 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54916 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406798AbgFYTyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 15:54:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593114839;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cS7ZRqCXaXGLEgCdmvMXOz2AM+S+PTeNcCJzZKUNa0M=;
        b=JXzP24ludgSWdb1OjLL/54NrjYRLG4k8O+JBoui8uw0ILfBsxxVydFU8JjwFlJHbin0c5q
        GHKgUiy/zkwYqh1nq4ydA0sfVYG4223TOb4Gy1sVilIPbQqO3U+ExssnNCYpO8ScYw9OKU
        jMmFOGBLn3VcpQNk7UImw7WFVLB3oTw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-356-yvdvaRvxNV-H04khyhPlpA-1; Thu, 25 Jun 2020 15:53:57 -0400
X-MC-Unique: yvdvaRvxNV-H04khyhPlpA-1
Received: by mail-ed1-f72.google.com with SMTP id cn4so1569749edb.9
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 12:53:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=cS7ZRqCXaXGLEgCdmvMXOz2AM+S+PTeNcCJzZKUNa0M=;
        b=ML88WKXO5kpD6Mo1iRX+LFcogrTeEikB148SMUMTgI8RE7K6gAqYkxJ5JLdaMIz3UW
         zT3kQrDO3s9juR+DUj4vmiSqnkoRb79SwLO4xqsjYJNQYht+yOgnfjD0Y/h4qShjmbOm
         n23vX/rM/I1EB7gvgqX68wufZhwMs2K8Fx8mAGr6qbE4KoxFTeXCn9FuWTxqmjeJQ+MJ
         UXNkn/3GSvW/vm/EG8RufeeQKjZ9u2iYACoxCcd8CAKDd6PFVyDeHG39dgKR5Oe7SCj+
         Dz1+ARmixx/6kfV2mjYOsumIRStsatN695HUcXYpPHsfuOQcsCMNpPgoJrnCwMH/Y0zw
         V2sw==
X-Gm-Message-State: AOAM5328zujs9RlC0gPzh9X6iRp3tX0iedApwa7aAB9xVBU8mSvN5h5Y
        tutBtZfOarCHW7G1Q3h5La2CMbmKG5XBeVSoaMshRwL7bDPgpCYUR/dkV2zuCZ4xYz7a4BaeO4t
        vXRcv5RTAJhkSupop
X-Received: by 2002:aa7:c24d:: with SMTP id y13mr24219491edo.123.1593114835833;
        Thu, 25 Jun 2020 12:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxPpNmKIUZ03MOVPY6kzP3vRwyXHdLLFbQ9anv7+nD1LWLxtb1zeMHS+rbhu0pCCB+67BZMtg==
X-Received: by 2002:aa7:c24d:: with SMTP id y13mr24219479edo.123.1593114835649;
        Thu, 25 Jun 2020 12:53:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id m13sm7655147ejc.1.2020.06.25.12.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 12:53:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 92A201814F9; Thu, 25 Jun 2020 21:53:53 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, cake@lists.bufferbloat.net
Subject: Re: [PATCH net-next 1/5] sch_cake: fix IP protocol handling in the presence of VLAN tags
In-Reply-To: <20200625.122945.321093402617646704.davem@davemloft.net>
References: <159308610282.190211.9431406149182757758.stgit@toke.dk> <159308610390.190211.17831843954243284203.stgit@toke.dk> <20200625.122945.321093402617646704.davem@davemloft.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 25 Jun 2020 21:53:53 +0200
Message-ID: <87k0zuj50u.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Date: Thu, 25 Jun 2020 13:55:03 +0200
>
>> From: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
>>=20
>> CAKE was using the return value of tc_skb_protocol() and expecting it to=
 be
>> the IP protocol type. This can fail in the presence of QinQ VLAN tags,
>> making CAKE unable to handle ECN marking and diffserv parsing in this ca=
se.
>> Fix this by implementing our own version of tc_skb_protocol(), which will
>> use skb->protocol directly, but also parse and skip over any VLAN tags a=
nd
>> return the inner protocol number instead.
>>=20
>> Also fix CE marking by implementing a version of INET_ECN_set_ce() that
>> uses the same parsing routine.
>>=20
>> Fixes: ea82511518f4 ("sch_cake: Add NAT awareness to packet classifier")
>> Fixes: b2100cc56fca ("sch_cake: Use tc_skb_protocol() helper for getting=
 packet protocol")
>> Fixes: 046f6fd5daef ("sched: Add Common Applications Kept Enhanced (cake=
) qdisc")
>> Signed-off-by: Ilya Ponetayev <i.ponetaev@ndmsystems.com>
>> [ squash original two patches, rewrite commit message ]
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> First, this is a bug fix and should probably be steered to 'net'.
>
> Also, other users of tc_skb_protocol() are almost certainly hitting a
> similar problem aren't they?  Maybe fix this generically.

I think it depends a little on the use case; some callers actually care
about the VLAN tags themselves and handle that specially (e.g.,
act_csum). Whereas others (e.g., sch_dsmark) probably will have the same
issue. I guess I can trying going through them all and figuring out if
there's a more generic solution.

I'll split out the diffserv parsing fixes and send those for your net
tree straight away, then circle back to this one...

-Toke

