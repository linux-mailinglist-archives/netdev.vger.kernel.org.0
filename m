Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB498114F9B
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfLFLIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:08:43 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36044 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbfLFLIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575630521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JXAVyRNO0S0J/Uz5OpV3pVoq+dH9wtbNSdffte/FzOU=;
        b=g+geD7oBVA3jUt6NCgI1bs0Wqp0aSPKsGZVJSyDWUf3/NNwIqv6puujQm3Ccttxzg3dMVl
        LqohSSaORRRnOK61ksDbZw77BxCUVqOYPnjI08Sxe2MeZZdFHT0xjoCf97vAUU5NJnMV4M
        /Dvej0yQoRzB2ja2aejBY8AezueYdIg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-dW2lIaHnOHmBmoLaQT24aw-1; Fri, 06 Dec 2019 06:08:40 -0500
Received: by mail-wm1-f72.google.com with SMTP id j203so1508536wma.2
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:08:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E6apc5q4Qh4+L9/n1LILraHjS08C+qKn0AccGYcl6ZU=;
        b=puea5/jZPcD16+3Q8+JtgYkkpEediIIpG0akpTCzo+S/hMgc6bODVyBYr9Q67aEpC4
         di5XpxtJU6LnHLgM9niehiXOTkpJmcwmv03TsYpg9lfR7BtKit2sMnf6AvBzWMwi3ioe
         51ADtNJ9I54EIdAmMpuxll6plVcvNedsqqdtI69h6mjeGoGUm/B8bgJZMQTyGT/oBOOP
         0CMF0xoDM1g/9eWyMx6MpaVKFX72FKKsx//lv3Yz2QQkg06KiljynzbbyTMdM8bB+x9j
         yYACGRnA2XjmZmF1TxGFi5N+mhgK4SOJnZYa3xGyB/oRp8RgdmICjpotNLjUR+eFoJ0H
         qdLg==
X-Gm-Message-State: APjAAAVomeOfk+o+jeCA2UY7QkbcdwTEVBrHa2a3DpZ/EHzxAfKaU7OJ
        NSJIyD6K66iYdAw695X35sRB8QTHaWTh99Qm1MWQOzLbd/FqU/Tx5k0Le8XvrYrizCD111/mOun
        gpiKJtvHAFTcXu4QD
X-Received: by 2002:adf:9427:: with SMTP id 36mr15299588wrq.166.1575630519146;
        Fri, 06 Dec 2019 03:08:39 -0800 (PST)
X-Google-Smtp-Source: APXvYqxKTMlfmon8jy6AoLdba0EKi703qy8alKRgngDu+kdtVUQnjzyn1zCUwP9ImboSnmpS34C5NA==
X-Received: by 2002:adf:9427:: with SMTP id 36mr15299570wrq.166.1575630519004;
        Fri, 06 Dec 2019 03:08:39 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id 2sm16405878wrq.31.2019.12.06.03.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Dec 2019 03:08:38 -0800 (PST)
Date:   Fri, 6 Dec 2019 12:08:36 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net v3 3/3] tcp: Protect accesses to .ts_recent_stamp
 with {READ,WRITE}_ONCE()
Message-ID: <20191206110836.GB31416@linux.home>
References: <cover.1575595670.git.gnault@redhat.com>
 <6473f122f953f6b0bf350ace584a721d0ae02ef6.1575595670.git.gnault@redhat.com>
 <27c9579d-634d-99c9-689c-65e3f4a2b296@gmail.com>
MIME-Version: 1.0
In-Reply-To: <27c9579d-634d-99c9-689c-65e3f4a2b296@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-MC-Unique: dW2lIaHnOHmBmoLaQT24aw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 05, 2019 at 07:50:39PM -0800, Eric Dumazet wrote:
>=20
>=20
> On 12/5/19 5:50 PM, Guillaume Nault wrote:
> > Syncookies borrow the ->rx_opt.ts_recent_stamp field to store the
> > timestamp of the last synflood. Protect them with READ_ONCE() and
> > WRITE_ONCE() since reads and writes aren't serialised.
> >=20
> > Fixes: 264ea103a747 ("tcp: syncookies: extend validity range")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>
>=20
> To be fair, bug was there before the patch mentioned in the Fixes: tag,
> but we probably do not care enough to backport this to very old kernels.
>=20
I used this commit because it introduced the conditional in
tcp_synq_overflow(), which I believe made the lockless accesses more
dangerous than they were. But yes, the problem has been there forever.

I have to post a v4 anyway, so I'll change this tag to reference the
first commit in the tree.

