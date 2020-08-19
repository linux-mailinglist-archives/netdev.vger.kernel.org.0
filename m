Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F98D24A24B
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgHSO7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 10:59:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40860 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727087AbgHSO7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 10:59:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id D115F8EE17F;
        Wed, 19 Aug 2020 07:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597849189;
        bh=7PMu9izfvJP0Yqog7vxhcEQb9h62GDKPX1If4m+L8R0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OjUAwUTp/ItAZSlbV+f5fOCaWVzt9DqIN+w9yoJxaEE0gnHE6rZZVb54+Hz0c5ZZE
         Hb/3aibCu54t6gcW2aVqbWIIDHBKiOLbR/fOvAY90fW0SUrQP0QkX8+CeCZ+PSzzdQ
         ViQuLsoRKTFDhSIJnCWv76g7gqa9l4AuHedfCKt8=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XOU0COqUWmkB; Wed, 19 Aug 2020 07:59:49 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6C2C88EE0E9;
        Wed, 19 Aug 2020 07:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597849189;
        bh=7PMu9izfvJP0Yqog7vxhcEQb9h62GDKPX1If4m+L8R0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OjUAwUTp/ItAZSlbV+f5fOCaWVzt9DqIN+w9yoJxaEE0gnHE6rZZVb54+Hz0c5ZZE
         Hb/3aibCu54t6gcW2aVqbWIIDHBKiOLbR/fOvAY90fW0SUrQP0QkX8+CeCZ+PSzzdQ
         ViQuLsoRKTFDhSIJnCWv76g7gqa9l4AuHedfCKt8=
Message-ID: <1597849185.3875.7.camel@HansenPartnership.com>
Subject: Re: [PATCH] block: convert tasklets to use new tasklet_setup() API
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jens Axboe <axboe@kernel.dk>, Kees Cook <keescook@chromium.org>
Cc:     Allen Pais <allen.cryptic@gmail.com>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        stefanr@s5r6.in-berlin.de, airlied@linux.ie, daniel@ffwll.ch,
        sre@kernel.org, kys@microsoft.com, deller@gmx.de,
        dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, davem@davemloft.net, kuba@kernel.org,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Date:   Wed, 19 Aug 2020 07:59:45 -0700
In-Reply-To: <f3312928-430c-25f3-7112-76f2754df080@kernel.dk>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
         <20200817091617.28119-2-allen.cryptic@gmail.com>
         <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
         <202008171228.29E6B3BB@keescook>
         <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
         <202008171246.80287CDCA@keescook>
         <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
         <1597780833.3978.3.camel@HansenPartnership.com>
         <f3312928-430c-25f3-7112-76f2754df080@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-08-19 at 07:00 -0600, Jens Axboe wrote:
> On 8/18/20 1:00 PM, James Bottomley wrote:
[...]
> > Since both threads seem to have petered out, let me suggest in
> > kernel.h:
> > 
> > #define cast_out(ptr, container, member) \
> > 	container_of(ptr, typeof(*container), member)
> > 
> > It does what you want, the argument order is the same as
> > container_of with the only difference being you name the containing
> > structure instead of having to specify its type.
> 
> Not to incessantly bike shed on the naming, but I don't like
> cast_out, it's not very descriptive. And it has connotations of
> getting rid of something, which isn't really true.

Um, I thought it was exactly descriptive: you're casting to the outer
container.  I thought about following the C++ dynamic casting style, so
out_cast(), but that seemed a bit pejorative.  What about outer_cast()?

> FWIW, I like the from_ part of the original naming, as it has some
> clues as to what is being done here. Why not just from_container()?
> That should immediately tell people what it does without having to
> look up the implementation, even before this becomes a part of the
> accepted coding norm.

I'm not opposed to container_from() but it seems a little less
descriptive than outer_cast() but I don't really care.  I always have
to look up container_of() when I'm using it so this would just be
another macro of that type ...

James

