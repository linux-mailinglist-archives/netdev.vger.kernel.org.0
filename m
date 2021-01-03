Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29A82E8E46
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbhACVFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbhACVFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 16:05:42 -0500
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25BB1C061573;
        Sun,  3 Jan 2021 13:05:01 -0800 (PST)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 103L4hgK030212
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Sun, 3 Jan 2021 22:04:43 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1609707883; bh=tJ9Si7uwTlF1+m4XAh1P6KDZfGpLXIZq6AArp/iMmMY=;
        h=From:To:Cc:Subject:References:Date:Message-ID:From;
        b=Rl2CWHYNakjmQtPotlTxNDabtYe/RZV9ne96VqhvcWG+KI1AQTYyjwjQBTnhyWa+f
         q+E561rOh30bBnwDz7TtCNkOeaz3mL8xREV0KLAZNXDyNgPtaPF2wL5DqeSslq/YfL
         iYQb7Y9m8/SBsabqzdjOgVVMDl/da7KPW4lu3ZA8=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@mork.no>)
        id 1kwAYN-000Ecx-AR; Sun, 03 Jan 2021 22:04:43 +0100
From:   =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To:     Jouni =?utf-8?Q?Sepp=C3=A4nen?= <jks@iki.fi>
Cc:     Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Enrico Mioso <mrkiko.rs@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net,stable] net: cdc_ncm: correct overhead in
 delayed_ndp_size
Organization: m
References: <20210103143602.95343-1-jks@iki.fi>
Date:   Sun, 03 Jan 2021 22:04:43 +0100
In-Reply-To: <20210103143602.95343-1-jks@iki.fi> ("Jouni =?utf-8?Q?Sepp?=
 =?utf-8?Q?=C3=A4nen=22's?= message
        of "Sun, 3 Jan 2021 16:36:02 +0200")
Message-ID: <87ft3henpw.fsf@miraculix.mork.no>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.102.4 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jouni Sepp=C3=A4nen <jks@iki.fi> writes:

> +		delayed_ndp_size =3D ctx->max_ndp_size +
> +			max(ctx->tx_ndp_modulus,
> +			    ctx->tx_modulus + ctx->tx_remainder) - 1;

You'll probably have to use something like

  max_t(u32, ctx->tx_ndp_modulus, ctx->tx_modulus + ctx->tx_remainder)
=20=20
here as the test robot already said.  Sorry for not seeing that earlier.
Otherwise this looks very good to me. The bug is real and severe, and
your patch appears to be the proper fix for it.

Thanks a lot for figuring this out and taking the time to fixup this
rather messy piece of code.

Reviewed-by: Bj=C3=B8rn Mork <bjorn@mork.no>

