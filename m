Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13D8EE44
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 03:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729822AbfD3BRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 21:17:41 -0400
Received: from au-smtp-delivery-110.mimecast.com ([180.189.28.110]:28242 "EHLO
        au-smtp-delivery-110.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729626AbfD3BRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 21:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sydney.edu.au; s=mimecast20161123; t=1556587057; h=from:from:sender:reply-to:subject:subject:date:date: message-id:message-id:to:to:cc:cc:mime-version:mime-version: content-type:content-type: content-transfer-encoding:content-transfer-encoding: in-reply-to:in-reply-to:references:references; bh=WypSgHS14WfdX1jhMM2B1Ue7AhXyzMGpfeUWhcLUdbY=; b=n9PnQr/MRmWHn5gb1q3Yf4sZQlGTZtj6QhuFfiS5/Eq5Nl5pPDDhR/ce73fXtVo5deMfd13TbuhDmK11GZsbt+Xp4eWsAcQDL0BgEQsKziCldYj0jowKZQ0ukqzaas/3/gWHJ2jt7QZI8QXFwL/s4fkubUsBkMh2vZOBgi3EnjE=
Received: from EX-TPR-PRO-04.mcs.usyd.edu.au (129.78.56.252 [129.78.56.252])
 (Using TLS) by relay.mimecast.com with ESMTP id
 au-mta-61-nzEr8szhNGussWCxZKiR4A-1; Tue, 30 Apr 2019 11:17:34 +1000
Received: from exchpa00450.mcs.usyd.edu.au (10.83.31.38) by
 EX-TPR-PRO-04.mcs.usyd.edu.au (172.17.63.53) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Tue, 30 Apr 2019 11:17:33 +1000
Received: from localhost (172.20.34.22) by exchpa00450.mcs.usyd.edu.au
 (10.83.31.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P256) id 15.1.1531.3; Tue, 30
 Apr 2019 11:17:33 +1000
Date:   Tue, 30 Apr 2019 11:17:32 +1000
From:   Stephen Mallon <stephen.mallon@sydney.edu.au>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        "Stephen Mallon" <stephen.mallon@sydney.edu.au>
Subject: Re: [PATCH net] ipv4: Fix updating SOF_TIMESTAMPING_OPT_ID when
 SKBTX_HW_TSTAMP is enabled
Message-ID: <20190430011732.GA20814@stephen-mallon>
References: <20190428054521.GA14504@stephen-mallon>
 <20190428151938.njy3ip5szwj3vkda@localhost>
 <CAF=yD-JLcmyoJ6tq1osgrQbXs6+As0R+J-ofU+XwQWcvaW+LBg@mail.gmail.com>
 <20190429150242.vckwna4bt4xynzjo@localhost>
 <CAF=yD-+EdbxnSa1SUqPamdxeDN_oPd4-kXAEF6yV1o_Zwj+LUw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAF=yD-+EdbxnSa1SUqPamdxeDN_oPd4-kXAEF6yV1o_Zwj+LUw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Originating-IP: [172.20.34.22]
X-ClientProxiedBy: exchpa00448.mcs.usyd.edu.au (10.83.31.36) To
 exchpa00450.mcs.usyd.edu.au (10.83.31.38)
X-MC-Unique: nzEr8szhNGussWCxZKiR4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:32:08AM -0400, Willem de Bruijn wrote:
> On Mon, Apr 29, 2019 at 11:02 AM Richard Cochran
> <richardcochran@gmail.com> wrote:
> >
> > On Sun, Apr 28, 2019 at 10:57:57PM -0400, Willem de Bruijn wrote:
> > > It is debatable whether this is a fix or a new feature. It extends
> > > SOF_TIMESTAMPING_OPT_ID to hardware timestamps. I don't think this
> > > would be a stable candidate.
> >
> > Was the original series advertised as SW timestamping only?
>=20
> I did not intend to cover hardware timestamps at the time.
>=20
> > If so, I missed that at the time.  After seeing it not work, I meant
> > to fix it, but never got around to it.  So to me this is a known
> > issue.
>=20
> Understood. I certainly understand that view. I never use hw
> timestamps, so it is a bit of a blind spot for me. If this is a safe
> and predictable change, I don't care strongly about net vs net-next. I
> don't think it meets the bar for stable, but that is not my call.

I've found that SOF_TIMESTAMPING_OPT_ID already works with hardware timesta=
mps
for TCP just not datagram sockets and so I though this was a fix.

> > > More importantly, note that __ip6_append_data has similar logic. For
> > > consistency the two should be updated at the same time.
> >
> > +1
> >
> > Thanks,
> > Richard

Thanks for the feedback, I'll update with __ip6_append_data.

