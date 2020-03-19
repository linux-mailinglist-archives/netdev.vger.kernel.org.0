Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC46718C308
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 23:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbgCSWgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 18:36:33 -0400
Received: from script.cs.helsinki.fi ([128.214.11.1]:47624 "EHLO
        script.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727091AbgCSWgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 18:36:33 -0400
X-DKIM: Courier DKIM Filter v0.50+pk-2017-10-25 mail.cs.helsinki.fi Fri, 20 Mar 2020 00:36:30 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.helsinki.fi;
         h=date:from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type:content-id; s=dkim20130528; bh=msaeSY
        tqooVLpDUxurOgY9SaCqtpCsKgr4Ov6fOeSg4=; b=Vhme2jMyFmEMfVmYK0Fiu9
        uWPplXdZEwkQgpjzencv70gVa5umBtdE2ONswOSLHVQHzqJsefpX7LleIjDSTf40
        inRa05RZHnTfYufRziIzpUjWws2lg9uulk4JNGI5NJdcqXIcLhwkstWvra0u22pm
        QAPGIkFNj9n9GiZFeoKYc=
Received: from whs-18.cs.helsinki.fi (whs-18.cs.helsinki.fi [128.214.166.46])
  (TLS: TLSv1/SSLv3,256bits,AES256-GCM-SHA384)
  by mail.cs.helsinki.fi with ESMTPS; Fri, 20 Mar 2020 00:36:30 +0200
  id 00000000005A000D.000000005E73F3EE.00006638
Date:   Fri, 20 Mar 2020 00:36:30 +0200 (EET)
From:   "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@cs.helsinki.fi>
X-X-Sender: ijjarvin@whs-18.cs.helsinki.fi
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     Netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>
Subject: Re: [RFC PATCH 09/28] gso: AccECN support
In-Reply-To: <6940af98-7083-15c7-dcea-54eb9d040a3d@gmail.com>
Message-ID: <alpine.DEB.2.20.2003192233580.5256@whs-18.cs.helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi> <1584524612-24470-10-git-send-email-ilpo.jarvinen@helsinki.fi> <6940af98-7083-15c7-dcea-54eb9d040a3d@gmail.com>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=_script-26192-1584657390-0001-2"
Content-ID: <alpine.DEB.2.20.2003200029590.5256@whs-18.cs.helsinki.fi>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_script-26192-1584657390-0001-2
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-ID: <alpine.DEB.2.20.2003192343491.5256@whs-18.cs.helsinki.fi>

On Wed, 18 Mar 2020, Eric Dumazet wrote:
> On 3/18/20 2:43 AM, Ilpo J=E4rvinen wrote:
> > From: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> >=20
> > Handling the CWR flag differs between RFC 3168 ECN and AccECN.
> > Take it into account in GSO by not clearing the CWR bit.
> >=20
> > Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@cs.helsinki.fi>
> >
>=20
> Does it means TCP segmentation offload is disabled on all the NIC
> around ?

On general level, yes. HW TSO should be disabled with AccECN (or when CWR=20
flag is set for an incoming packet). The reason is how CWR flag is handle=
d=20
by RFC 3168 ECN-aware TSO. It splits the segment such that CWR is cleared=20
starting from the 2nd segment which is incompatible how AccECN handles th=
e=20
CWR flag. With AccECN, CWR flag (or more accurately, the ACE field that=20
also includes ECE & AE flags) changes only when new packet(s) with CE mar=
k=20
arrives so the flag should not be changed within a super-skb. The new
feature flag is necessary to prevent such TSO engines happily clearing=20
CWRs (if the CWR handling feature cannot be turned off).

If NIC is completely unaware of RFC3168 ECN (doesn't support=20
NETIF_F_TSO_ECN) or its TSO engine can be set to not touch CWR flag
despite supporting also NETIF_F_TSO_ECN, TSO could be safely used with=20
AccECN on such NIC. I've little expertise on TSO HW so I don't know if=20
some/what NICs can do it. Nonetheless, there's nothing fundamental=20
preventing TSO being enabled with AccECN by NICs (if either of those=20
conditions is met).

In the cases, where TSO would fail to keep its hands off CWR flag, it
should fallback to GSO which has always on AccECN support (similar to=20
always on ECN support). I think that the current GSO changes are capable=20
of handling AccECN skbs. For the other parts of the idea above I'm not=20
so sure. There is this NETIF_F_GSO_SOFTWARE with comment that seems to=20
indicate it's doing what I want but I'm not fully sure if adding a flag=20
there is enough to achieve the desired effect?

On the rx side, supporting both RFC3168 and AccECN style CWR handling
is slightly more complicated (and possibly not worth the effort given
CWRs should be relatively rare with RFC3168-style ECN).

> Why tun driver is changed and not others ?

I think I didn't really understand why tun.c plays with the TSO_ECN flag=20
until now (after finding a related comment from tap.c) and so that change=20
now doesn't make much sense for me now any more. So I'll just remove that=20
part.

> I believe you need to give much more details in changelog in general,
> because many changes are not that obvious.

I'll try to.

Thanks.

--=20
 i.
--=_script-26192-1584657390-0001-2--
