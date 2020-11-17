Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDD72B5643
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 02:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgKQB1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 20:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgKQB1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 20:27:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9004A2468F;
        Tue, 17 Nov 2020 01:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605576463;
        bh=47TEkotzt3F/LTmw1Gm/QSF0wkfHZUX07oPBgXjQUeg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AH8Z82mDw5vxnNF2Q0AHlhLi72YipYyuDpVL7fOcH1Rwp4kUJ5GzwmxJwcJLHbyh+
         ZlUB6pBO322shxSkmgEl3GkWk05bfH1/mnA+cOmcN06mn+Q0OWup9S2w/SrlBV/GGe
         i8Vdtc5bmjEKVbVQpkk/nnNwEBPSurIsN6sfGz0o=
Date:   Mon, 16 Nov 2020 17:27:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <min.li.xe@renesas.com>
Cc:     <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] ptp: clockmatrix: bug fix for
 idtcm_strverscmp
Message-ID: <20201116172742.5f86a49b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1605554850-14437-1-git-send-email-min.li.xe@renesas.com>
References: <1605554850-14437-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 14:27:26 -0500 min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
>=20
> Feed kstrtou8 with NULL terminated string.

Is this a fix? Does it need to be backported to stable?

Also please add a cover letter for the series describing the overall
goal of this work, what testing has been done etc.

>  drivers/ptp/ptp_clockmatrix.c | 52 +++++++++++++++++++++++++++++++------=
------
>  1 file changed, 38 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
> index e020faf..bf2be50 100644
> --- a/drivers/ptp/ptp_clockmatrix.c
> +++ b/drivers/ptp/ptp_clockmatrix.c
> @@ -103,42 +103,66 @@ static int timespec_to_char_array(struct timespec64=
 const *ts,
>  	return 0;
>  }
> =20
> -static int idtcm_strverscmp(const char *ver1, const char *ver2)
> +static int idtcm_strverscmp(const char *version1, const char *version2)
>  {
>  	u8 num1;
>  	u8 num2;
>  	int result =3D 0;
> +	char ver1[16];
> +	char ver2[16];
> +	char *cur1;
> +	char *cur2;
> +	char *next1;
> +	char *next2;
> +
> +	strncpy(ver1, version1, 16);
> +	strncpy(ver2, version2, 16);

This patch triggers the following warning on a 32bit build:

In file included from ../arch/x86/include/asm/page_32.h:35,
                 from ../arch/x86/include/asm/page.h:14,
                 from ../arch/x86/include/asm/thread_info.h:12,
                 from ../include/linux/thread_info.h:38,
                 from ../arch/x86/include/asm/preempt.h:7,
                 from ../include/linux/preempt.h:78,
                 from ../include/linux/spinlock.h:51,
                 from ../include/linux/mmzone.h:8,
                 from ../include/linux/gfp.h:6,
                 from ../include/linux/firmware.h:7,
                 from ../drivers/ptp/ptp_clockmatrix.c:8:
In function =E2=80=98strncpy=E2=80=99,
    inlined from =E2=80=98idtcm_strverscmp.constprop=E2=80=99 at ../drivers=
/ptp/ptp_clockmatrix.c:118:2:
../include/linux/string.h:290:30: warning: =E2=80=98__builtin_strncpy=E2=80=
=99 specified bound 16 equals destination size [-Wstringop-truncation]
  290 | #define __underlying_strncpy __builtin_strncpy
      |                              ^
../include/linux/string.h:300:9: note: in expansion of macro =E2=80=98__und=
erlying_strncpy=E2=80=99
  300 |  return __underlying_strncpy(p, q, size);
      |         ^~~~~~~~~~~~~~~~~~~~
