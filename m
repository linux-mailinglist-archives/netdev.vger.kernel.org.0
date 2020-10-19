Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5FE292763
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbgJSMfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbgJSMfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 08:35:53 -0400
X-Greylist: delayed 596 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 19 Oct 2020 05:35:53 PDT
Received: from mx.mylinuxtime.de (mx.mylinuxtime.de [IPv6:2a01:4f8:13a:16c2::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2BCC0613CE
        for <netdev@vger.kernel.org>; Mon, 19 Oct 2020 05:35:53 -0700 (PDT)
Received: from leda (p200300cf2f11e700625718fffe7f1598.dip0.t-ipconnect.de [IPv6:2003:cf:2f11:e700:6257:18ff:fe7f:1598])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.mylinuxtime.de (Postfix) with ESMTPSA id 1232812124F;
        Mon, 19 Oct 2020 14:25:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eworm.de; s=mail;
        t=1603110354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HbeAnW4c9Dm1n3xDUNmcoJFkwlht8FqAxioW4sSFnss=;
        b=vrBEDBWAYq288Avn9QNnyGLoVt2nS6RZYUCb76YN8NTGdjfVaVM6Rqe2p9UiNlTWcRbWgO
        D8AMFW59rc/qv9qeBcgy2iQOGUXLVQP9CxrdetvGnViLaNIgEOZ34XH1Og4mupOEfaptxZ
        dT2Jg9n2DzgKU2Ln4oMqK7I5Ygoe0xU=
Date:   Mon, 19 Oct 2020 14:25:50 +0200
From:   Christian Hesse <list@eworm.de>
To:     Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
Cc:     Thomas Deutschmann <whissi@gentoo.org>,
        <johannes@sipsolutions.net>,
        "davem@davemloft.net" <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <denkenz@gmail.com>
Subject: Re: [Regression 5.9][Bisected 1df2bdba528b] Wifi GTK rekeying
 fails: Sending of EAPol packages broken
Message-ID: <20201019142550.5fe02d7d@leda>
In-Reply-To: <20201017230818.04896494@mathy-work.localhost>
References: <4a7f92dc-13bb-697f-1730-ac288e74b730@gentoo.org>
        <20201017230818.04896494@mathy-work.localhost>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Face: %O:rCSk<c"<MpJ:yn<>HSKf7^4uF|FD$9$I0}g$nbnS1{DYPvs#:,~e`).mzj\$P9]V!WCveE/XdbL,L!{)6v%x4<jA|JaB-SKm74~Wa1m;|\QFlOg>\Bt!b#{;dS&h"7l=ow'^({02!2%XOugod|u*mYBVm-OS:VpZ"ZrRA4[Q&zye,^j;ftj!Hxx\1@;LM)Pz)|B%1#sfF;s;,N?*K*^)
Face:   iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAGFBMVEUZFRFENy6KVTKEd23CiGHeqofJvrX4+vdHgItOAAAACXBIWXMAAA3XAAAN1wFCKJt4AAACUklEQVQ4y2VUTZeqMAxNxXG2Io5uGd64L35unbF9ax0b3OLxgFs4PcLff0lBHeb1QIq5uelNCEJNq/TIFGyeC+iugH0WJr+B1MvzWASpuP4CYHOB0VfoDdddwA7OIFQIEHjXDiCtV5e9QX0WMu8AG0mB7g7WP4GqeqVdsi4vv/5kFBvaF/zD7zDquL4DxbrDGDyAsgNYOsJOYzth4Q9ZF6iLV+6TLAT1pi2kuvgAtZxSjoG8cL+8vIn251uoe1OOEWwbIPU04gHsmMsoxyyhYsD2FdIigF1yxaVbBuSOCAlCoX324I7wNMhrO1bhOLsRoA6DC6wQ5eQiSG5BiWQfM4gN+uItQTRDMaJUhVbGyKWCuaaUGSVFVKpl4PdoDn3yY8J+YxQxyhlHfoYOyPgyDcO+cSQK6Bvabjcy2nwRo3pxgA8jslnCuYw23ESOzHAPYwo4ITNQMaOO+RGPEGhSlPEZBh2jmBEjQ5cKbxmr0ruAe/WCriUxW76I8T3h7vqY5VR5wXLdERodg2rHEzdxxk5KpXTL4FwnarvndKM5/MWDY5CuBBdQ+3/0ivsUJHicuHd+Xh3jOdBL+FjSGq4SPCwco+orpWlERRTNo7BHCvbNXFVSIQMp+P5QsIL9upmr8kMTUOfxEHoanwzKRcNAe76WbjBwex/RkdHu48xT5YqP70DaMOhBcTHmAVDxLaBdle93oJy1QKFUh2GXT4am+YH/GGel1CeI98GdMXsytjCKIq/9cMrlgxFCROv+3/BU1fijNpcVD6DxE8VfLBaxUGr1D5usgDYdjwiPAAAAAElFTkSuQmCC
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/vNZ.r9uZ.9tb0u1RSbRqb2j";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Spam-Status: No, score=2.11
X-Spamd-Bar: ++
Authentication-Results: mx.mylinuxtime.de;
        auth=pass smtp.auth=mail@eworm.de smtp.mailfrom=list@eworm.de
X-Rspamd-Server: mx
X-Spam-Level: **
X-Stat-Signature: a4knrgg6w7u93idcbjoyp98uns7wyc1w
X-Rspamd-Queue-Id: 1232812124F
X-Spamd-Result: default: False [2.11 / 15.00];
         ARC_NA(0.00)[];
         TO_DN_EQ_ADDR_SOME(0.00)[];
         URIBL_BLOCKED(0.00)[kuleuven.be:email];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.20)[multipart/signed,text/plain];
         BAYES_SPAM(5.08)[99.96%];
         NEURAL_HAM_LONG(-2.70)[-0.901];
         DKIM_SIGNED(0.00)[];
         NEURAL_HAM_SHORT(-0.57)[-0.572];
         RCPT_COUNT_SEVEN(0.00)[9];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+,1:+,2:~];
         MID_RHS_NOT_FQDN(0.50)[];
         ASN(0.00)[asn:3320, ipnet:2003::/19, country:DE];
         FREEMAIL_CC(0.00)[gentoo.org,sipsolutions.net,davemloft.net,kernel.org,vger.kernel.org,gmail.com]
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/vNZ.r9uZ.9tb0u1RSbRqb2j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be> on Sat, 2020/10/17 23:08:
> I've managed to reproduce the issue, or at least a related issue. Can
> you try the draft patch below and see if that fixes it?

This patch fixes the regression for me. Thanks a lot!
--=20
main(a){char*c=3D/*    Schoene Gruesse                         */"B?IJj;MEH"
"CX:;",b;for(a/*    Best regards             my address:    */=3D0;b=3Dc[a+=
+];)
putchar(b-1/(/*    Chris            cc -ox -xc - && ./x    */b/42*2-3)*42);}

--Sig_/vNZ.r9uZ.9tb0u1RSbRqb2j
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEXHmveYAHrRp+prOviUUh18yA9HYFAl+Nhc4ACgkQiUUh18yA
9HZMWAgAj0Ppz0rYQxSPoYcQ8xdhh7kFdURLcEp8B7XkZzMhGxpXHssN5RCBoD1O
NcmbWFulSI8VfpmwVPjvk3E3e7ZfQUVR/RCmp9NNLvI0TYCI+BsHb9EsTADWQTPO
NaQum9kZWzZUF+oQN57n1bY+7Al7ifWzUBmblTr1BzgDmsrkR0fzGaS2QzPAgjij
0Kpu+IHr+NRqYAlxWotMULgvxY0N8OhcPW0vGA2E5YMDlXvI+0eDHN/R87xSMdLK
gWh4ydFCrtgu+sHSssy3EygMtaNuhlor3/7239pxLsoUs/vU4VD8UPJ9nf/JuexZ
ZIGEYRFL5YtdzvlTIdVOtgSndc6dyQ==
=WWxr
-----END PGP SIGNATURE-----

--Sig_/vNZ.r9uZ.9tb0u1RSbRqb2j--
