Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7225399209
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhFBSAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 14:00:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57581 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230030AbhFBSAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 14:00:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622656737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y/SQoG6L/Ht21nVVEnMXlRoDJN/utaABvt/IswwuD4Y=;
        b=glF3zIyF69e5O+Ux3/JyEm9ociuwHrkks9fu8miuLPVKKl8AbQptoklaqvKvjTuqBUgHzo
        BC6df3NlZNgHaWfPyvyFmD9l7QIdzwhGGlTBoyQLhO5j+f4L8uSfV/9eZZlhG+/RENbHZ8
        D8J2LVK3DlyMKlP25GG8TwHS5u5/7mY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-XY1n7tPiNv2bw5gTuhk07Q-1; Wed, 02 Jun 2021 13:58:54 -0400
X-MC-Unique: XY1n7tPiNv2bw5gTuhk07Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04BEE6414C;
        Wed,  2 Jun 2021 17:58:53 +0000 (UTC)
Received: from oldenburg.str.redhat.com (ovpn-113-228.ams2.redhat.com [10.36.113.228])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 29CB85D6DC;
        Wed,  2 Jun 2021 17:58:50 +0000 (UTC)
From:   Florian Weimer <fweimer@redhat.com>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Subject: Re: [PATCH net-next V6 1/6] icmp: add support for RFC 8335 PROBE
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
        <ba81dcf8097c4d3cc43f4e2ed5cc6f5a7a4c33b6.1617067968.git.andreas.a.roeseler@gmail.com>
Date:   Wed, 02 Jun 2021 19:58:49 +0200
In-Reply-To: <ba81dcf8097c4d3cc43f4e2ed5cc6f5a7a4c33b6.1617067968.git.andreas.a.roeseler@gmail.com>
        (Andreas Roeseler's message of "Mon, 29 Mar 2021 18:45:15 -0700")
Message-ID: <87im2wup0m.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Andreas Roeseler:

> diff --git a/include/uapi/linux/icmp.h b/include/uapi/linux/icmp.h
> index fb169a50895e..222325d1d80e 100644
> --- a/include/uapi/linux/icmp.h
> +++ b/include/uapi/linux/icmp.h
> @@ -20,6 +20,9 @@
>=20=20
>  #include <linux/types.h>
>  #include <asm/byteorder.h>
> +#include <linux/in.h>
> +#include <linux/if.h>
> +#include <linux/in6.h>

We have received a report that this breaks compiliation of trinity
because it includes <netinet/in.h> and <linux/icmp.h> at the same time,
and there is no multiple-definition guard for struct in_addr and other
definitions:

In file included from include/net.h:5,
                 from net/proto-ip-raw.c:2:
/usr/include/netinet/in.h:31:8: error: redefinition of =E2=80=98struct in_a=
ddr=E2=80=99
   31 | struct in_addr
      |        ^~~~~~~
In file included from /usr/include/linux/icmp.h:23,
                 from net/proto-ip-raw.c:1:
/usr/include/linux/in.h:89:8: note: originally defined here
   89 | struct in_addr {
      |        ^~~~~~~
In file included from /usr/include/netinet/in.h:37,
                 from include/net.h:5,
                 from net/proto-ip-raw.c:2:
/usr/include/bits/in.h:150:8: error: redefinition of =E2=80=98struct ip_mre=
qn=E2=80=99
  150 | struct ip_mreqn
      |        ^~~~~~~~
In file included from /usr/include/linux/icmp.h:23,
                 from net/proto-ip-raw.c:1:
/usr/include/linux/in.h:178:8: note: originally defined here
  178 | struct ip_mreqn {
      |        ^~~~~~~~

(More conflicts appear to follow.)

I do not know what the correct way forward is.  Adding the
multiple-definition guards is quite a bit of work and requires updates
in glibc and the kernel to work properly.

Thanks,
Florian

