Return-Path: <netdev+bounces-11664-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5D9733DAE
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 04:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25585281912
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 02:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE31627;
	Sat, 17 Jun 2023 02:54:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D07EA28
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 02:54:45 +0000 (UTC)
X-Greylist: delayed 318 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Jun 2023 19:54:44 PDT
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC11235BE
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 19:54:44 -0700 (PDT)
Received: from sparky.lan (unknown [159.196.93.152])
	by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 99BBB200E3;
	Sat, 17 Jun 2023 10:49:19 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=codeconstruct.com.au; s=2022a; t=1686970162;
	bh=TOsUrMI0pxVA6HMyMujrM6h9e+cR1G+X/IHqxavgziI=;
	h=Subject:From:To:Date:In-Reply-To:References;
	b=PFv3XZwBZTFHNijdzPJgx0BkPn8zVdgg79mN1745+Zqwn6foOT4r9nb9jZv58yerS
	 ygNybcCVi6ADJ0MmuoTa3uAXPOsmF4Hk+2nCNBxerw7QEmp/BJFRHfaFnPyFpc8Jvr
	 MWG+gy1lLQJZAViajxELV94thVclkjwn9pXILYTMXZnvbBtAqP9OXRiYPWt3GK97nj
	 l2H23Iv4OD/OQbCqcm4AxEcePIuVLIz97XsEbHGKpnWbL1PbXp0VRILM00GVLnXu+/
	 lZbP4OrQlAGKRpM8s+9Te8whvp1zze1twTT06/3/DxEvEpmZsbiQ+OYP1LZpdlsW7+
	 BKzg6+udTyIuA==
Message-ID: <89d47a83bb2203bc787573f2a5e62de268da72f8.camel@codeconstruct.com.au>
Subject: Re: [PATCH v1] net: mctp: remove redundant RTN_UNICAST check
From: Jeremy Kerr <jk@codeconstruct.com.au>
To: Lin Ma <linma@zju.edu.cn>, matt@codeconstruct.com.au,
 davem@davemloft.net,  edumazet@google.com, kuba@kernel.org,
 netdev@vger.kernel.org
Date: Sat, 17 Jun 2023 10:49:19 +0800
In-Reply-To: <20230615152240.1749428-1-linma@zju.edu.cn>
References: <20230615152240.1749428-1-linma@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Lin,

> Current mctp_newroute() contains two exactly same check against
> rtm->rtm_type
>=20
> static int mctp_newroute(...)
> {
> ...
> =C2=A0=C2=A0=C2=A0 if (rtm->rtm_type !=3D RTN_UNICAST) { // (1)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 NL_SET_ERR_MSG(extack, "rtm_ty=
pe must be RTN_UNICAST");
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> =C2=A0=C2=A0=C2=A0 }
> ...
> =C2=A0=C2=A0=C2=A0 if (rtm->rtm_type !=3D RTN_UNICAST) // (2)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return -EINVAL;
> ...
> }
>=20
> This commits removes the (2) check as it is redundant.

Looks good, thanks!

Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>

(but this probably doesn't need to go into the net fixes tree; net-next
would be fine.)

Cheers,


Jeremy

