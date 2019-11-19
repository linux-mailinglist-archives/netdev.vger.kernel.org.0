Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC522101FB8
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 10:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfKSJMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 04:12:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26960 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726170AbfKSJMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 04:12:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574154750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=56y7kkudD7CbdgMyxGZkhBkFd2RlhLUxyg0zNxoDgd8=;
        b=hazgf3SYbSTgYO+9XcMGK2z+MMUCRhEMrMnWzjp0C00Pcu5QpvqYfXpMDBAZKiwYUUcTfv
        26dfTObHWexnd1Cc47mEJVcqgyZxv+s/wb9MIy/7w9CcH1SjQtlhBA39QS0Ea+2dih76pY
        oKybVgi+37vqqaBImc4k4f8qFw5bQQ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-61-qsd2p0DVOnO7meu3idVowQ-1; Tue, 19 Nov 2019 04:12:29 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3D688026A4;
        Tue, 19 Nov 2019 09:12:27 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-117-86.ams2.redhat.com [10.36.117.86])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F91E4647C;
        Tue, 19 Nov 2019 09:12:27 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 29941A80A4E; Tue, 19 Nov 2019 10:12:26 +0100 (CET)
Date:   Tue, 19 Nov 2019 10:12:26 +0100
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next] r8169: disable TSO on a single version of
 RTL8168c to fix performance
Message-ID: <20191119091226.GJ3372@calimero.vinschen.de>
Mail-Followup-To: Heiner Kallweit <hkallweit1@gmail.com>,
        netdev@vger.kernel.org, nic_swsd@realtek.com,
        David Miller <davem@davemloft.net>
References: <20191118095503.25611-1-vinschen@redhat.com>
 <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
MIME-Version: 1.0
In-Reply-To: <44352432-e6ad-3e3c-4fea-9ad59f7c4ae9@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: qsd2p0DVOnO7meu3idVowQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Nov 18 20:33, Heiner Kallweit wrote:
> On 18.11.2019 10:55, Corinna Vinschen wrote:
> > During performance testing, I found that one of my r8169 NICs suffered
> > a major performance loss, a 8168c model.
> >=20
> > Running netperf's TCP_STREAM test didn't return the expected
> > throughput of > 900 Mb/s, but rather only about 22 Mb/s.  Strange
> > enough, running the TCP_MAERTS and UDP_STREAM tests all returned with
> > throughput > 900 Mb/s, as did TCP_STREAM with the other r8169 NICs I ca=
n
> > test (either one of 8169s, 8168e, 8168f).
> >=20
> > Bisecting turned up commit 93681cd7d94f83903cb3f0f95433d10c28a7e9a5,
> > "r8169: enable HW csum and TSO" as the culprit.
> >=20
> > I added my 8168c version, RTL_GIGA_MAC_VER_22, to the code
> > special-casing the 8168evl as per the patch below.  This fixed the
> > performance problem for me.
> >=20
> > Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
> > Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
>=20
> Thanks for reporting and the fix. Just two small nits:
> - fix should be annotated "net", not "net-next"
> - comment blocks in net subsystem don't have /* on a separate line

See my v2 patch.

> Apart from that:
> Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
>=20
> Out of curiosity: Did you test also with iperf3? If yes,
> do you see the same issue?

I didn't test with iperf3 originally, but I did so now.  The results are
the same.  941 Mbits/sec vs. 23.3 Mbits/sec.


Thanks,
Corinna

