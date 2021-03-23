Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6967734660D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 18:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhCWRMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 13:12:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51953 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230091AbhCWRMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 13:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616519545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OIQp4HhPuum0LR8G6COtimK4BCBBdtsRsBIz5CKvco8=;
        b=F/LxRH/WtUC6HE0kD4gDFb7+YIswQY6Fd/iCOnvcZTEZSjXqWgY86vFttoUawykWsVRB2r
        w3E+hRVqf5xMAoM3sUCcEe3k57z8WzWowQkRVxmxJaLgBmwwwoioi1omPVKMNp5igSOd2r
        ZyzYixi2v6TnZgeBmapwY61OcO8PMow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-n16PgW9kMkytFSwUMpsLMQ-1; Tue, 23 Mar 2021 13:12:20 -0400
X-MC-Unique: n16PgW9kMkytFSwUMpsLMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E0C09107ACCD;
        Tue, 23 Mar 2021 17:12:18 +0000 (UTC)
Received: from ovpn-114-241.ams2.redhat.com (ovpn-114-241.ams2.redhat.com [10.36.114.241])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1451C6087C;
        Tue, 23 Mar 2021 17:12:16 +0000 (UTC)
Message-ID: <38b220f86f8544e65183945ba716d19158bf3f69.camel@redhat.com>
Subject: Re: [PATCH net-next 8/8] selftests: net: add UDP GRO forwarding
 self-tests
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Date:   Tue, 23 Mar 2021 18:12:15 +0100
In-Reply-To: <CA+FuTSc6u_YfhTzoHPtzJSkLGMhSsDW5mWvR4-o=YB8e6ieYKQ@mail.gmail.com>
References: <cover.1616345643.git.pabeni@redhat.com>
         <a9791dcc26e3f70858eee5d14506f8b36e747960.1616345643.git.pabeni@redhat.com>
         <CA+FuTSc6u_YfhTzoHPtzJSkLGMhSsDW5mWvR4-o=YB8e6ieYKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2021-03-22 at 09:44 -0400, Willem de Bruijn wrote:
> > diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
> > new file mode 100755
> > index 0000000000000..ac7ac56a27524
> > --- /dev/null
> > +++ b/tools/testing/selftests/net/udpgro_fwd.sh
> > @@ -0,0 +1,251 @@
> > +#!/bin/sh
> > +# SPDX-License-Identifier: GPL-2.0
> > +
> > +readonly BASE="ns-$(mktemp -u XXXXXX)"
> > +readonly SRC=2
> > +readonly DST=1
> > +readonly DST_NAT=100
> > +readonly NS_SRC=$BASE$SRC
> > +readonly NS_DST=$BASE$DST
> > +
> > +# "baremetal" network used for raw UDP traffic
> > +readonly BM_NET_V4=192.168.1.
> > +readonly BM_NET_V6=2001:db8::
> > +
> > +# "overlay" network used for UDP over UDP tunnel traffic
> > +readonly OL_NET_V4=172.16.1.
> > +readonly OL_NET_V6=2002:db8::
> 
> is it okay to use a prod64 prefix for this? should this be another
> subnet of 2001:db8:: instead? of fd..

It looks like this comment slipped out of my sight... yep, I'll use
2001:db8:1:: for the overlay network in the next iteration.

Thanks!

Paolo

