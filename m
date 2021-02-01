Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF72730AB37
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 16:27:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhBAP00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 10:26:26 -0500
Received: from linux.microsoft.com ([13.77.154.182]:33312 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBAPZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 10:25:56 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by linux.microsoft.com (Postfix) with ESMTPSA id DB30420B7192
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 07:25:14 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DB30420B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1612193114;
        bh=+HEob0Nx7B38kVp2m2Ktypj8UNYsxpQ+NbQkPLIPTLI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Qw8BjiAQHdmVHVYBRMjjo9zQ+DQngR1dldb9pZ5LSNJiTjrHSWKgVswKuJfWT1hd4
         dtTuyMKpXsBi7r7r5IfQDI9cdXzvLUKsNjEq2Mb0iJgAYENNuI50UDFS6fqPRB2aQZ
         +TO3ubtdeJBOLf5/yjuIyvzwheY3xzggUoTG8dOs=
Received: by mail-pl1-f172.google.com with SMTP id s15so10171449plr.9
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 07:25:14 -0800 (PST)
X-Gm-Message-State: AOAM531LyWImHgeZLLdMG4Gvj4ktyOgUK2hC13TEkCy3/+k54a6zFXvq
        9IUl84ZAu5EkNmojVoIjqUkduuw77S1aBTjE0y0=
X-Google-Smtp-Source: ABdhPJySr+qpx3Z8HKlaQrApAYbLZVmBum+PSczXUBNviZzZuRTvu1LpS/1cuhxrPHiO7erg+ptoP9AuFE4kmqu2S1A=
X-Received: by 2002:a17:90a:757:: with SMTP id s23mr17713136pje.39.1612193114416;
 Mon, 01 Feb 2021 07:25:14 -0800 (PST)
MIME-Version: 1.0
References: <846cdd41e6ad6ec88ef23fee1552ab39c2f5a3d1.1612184361.git.dcaratti@redhat.com>
In-Reply-To: <846cdd41e6ad6ec88ef23fee1552ab39c2f5a3d1.1612184361.git.dcaratti@redhat.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Mon, 1 Feb 2021 16:24:38 +0100
X-Gmail-Original-Message-ID: <CAFnufp3DQjwcgtoFuGN6qzecQqLyD8JkeJopqxJBxxKkMgZVEA@mail.gmail.com>
Message-ID: <CAFnufp3DQjwcgtoFuGN6qzecQqLyD8JkeJopqxJBxxKkMgZVEA@mail.gmail.com>
Subject: Re: [PATCH net-next v3] mptcp: fix length of MP_PRIO suboption
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 1, 2021 at 2:08 PM Davide Caratti <dcaratti@redhat.com> wrote:
>
> With version 0 of the protocol it was legal to encode the 'Subflow Id' in
> the MP_PRIO suboption, to specify which subflow would change its 'Backup'
> flag. This has been removed from v1 specification: thus, according to RFC
> 8684 =C2=A73.3.8, the resulting 'Length' for MP_PRIO changed from 4 to 3 =
byte.
>
> Current Linux generates / parses MP_PRIO according to the old spec, using
> 'Length' equal to 4, and hardcoding 1 as 'Subflow Id'; RFC compliance can
> improve if we change 'Length' in other to become 3, leaving a 'Nop' after
> the MP_PRIO suboption. In this way the kernel will emit and accept *only*
> MP_PRIO suboptions that are compliant to version 1 of the MPTCP protocol.
>
>  unpatched 5.11-rc kernel:
>  [root@bottarga ~]# tcpdump -tnnr unpatched.pcap | grep prio
>  reading from file unpatched.pcap, link-type LINUX_SLL (Linux cooked v1)
>  dropped privs to tcpdump
>  IP 10.0.3.2.48433 > 10.0.1.1.10006: Flags [.], ack 1, win 502, options [=
nop,nop,TS val 4032325513 ecr 1876514270,mptcp prio non-backup id 1,mptcp d=
ss ack 14084896651682217737], length 0
>
>  patched 5.11-rc kernel:
>  [root@bottarga ~]# tcpdump -tnnr patched.pcap | grep prio
>  reading from file patched.pcap, link-type LINUX_SLL (Linux cooked v1)
>  dropped privs to tcpdump
>  IP 10.0.3.2.49735 > 10.0.1.1.10006: Flags [.], ack 1, win 502, options [=
nop,nop,TS val 1276737699 ecr 2686399734,mptcp prio non-backup,nop,mptcp ds=
s ack 18433038869082491686], length 0
>
> Changes since v2:
>  - when accounting for option space, don't increment 'TCPOLEN_MPTCP_PRIO'
>    and use 'TCPOLEN_MPTCP_PRIO_ALIGN' instead, thanks to Matthieu Baerts.
> Changes since v1:
>  - refactor patch to avoid using 'TCPOLEN_MPTCP_PRIO' with its old value,
>    thanks to Geliang Tang.
>
> Fixes: 067065422fcd ("mptcp: add the outgoing MP_PRIO support")
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Reviewed-by: Matteo Croce <mcroce@linux.microsoft.com>

--=20
per aspera ad upstream
