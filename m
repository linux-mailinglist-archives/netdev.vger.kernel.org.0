Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D69248F43
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 22:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHRUAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 16:00:44 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55372 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726685AbgHRUAl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 16:00:41 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id B7B338EE183;
        Tue, 18 Aug 2020 13:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597780837;
        bh=E3x9MtKucMoLMHa3CyKwg7UhEGPq9DioLfkS9Z1+XGE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QbgQa4sNQ7ioYr+ZRo2Le/RZiJPH+/p5G4sH/hAcS9I4kzZ0sD06xHGNpxi7vpvsh
         vr2zHlcKt8Djvsye4cN/5REko80zNw1ws3Pi5/FhdhWLZr8xokhc8SqSwcUtY/N2RX
         WalGwB8lkK7LHfsBLLdTDYFy7s65x73pT2v0cjxQ=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id OhVM_virpzc7; Tue, 18 Aug 2020 13:00:37 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 49AB78EE17F;
        Tue, 18 Aug 2020 13:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597780837;
        bh=E3x9MtKucMoLMHa3CyKwg7UhEGPq9DioLfkS9Z1+XGE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QbgQa4sNQ7ioYr+ZRo2Le/RZiJPH+/p5G4sH/hAcS9I4kzZ0sD06xHGNpxi7vpvsh
         vr2zHlcKt8Djvsye4cN/5REko80zNw1ws3Pi5/FhdhWLZr8xokhc8SqSwcUtY/N2RX
         WalGwB8lkK7LHfsBLLdTDYFy7s65x73pT2v0cjxQ=
Message-ID: <1597780833.3978.3.camel@HansenPartnership.com>
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
Date:   Tue, 18 Aug 2020 13:00:33 -0700
In-Reply-To: <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
         <20200817091617.28119-2-allen.cryptic@gmail.com>
         <b5508ca4-0641-7265-2939-5f03cbfab2e2@kernel.dk>
         <202008171228.29E6B3BB@keescook>
         <161b75f1-4e88-dcdf-42e8-b22504d7525c@kernel.dk>
         <202008171246.80287CDCA@keescook>
         <df645c06-c30b-eafa-4d23-826b84f2ff48@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-08-17 at 13:02 -0700, Jens Axboe wrote:
> On 8/17/20 12:48 PM, Kees Cook wrote:
> > On Mon, Aug 17, 2020 at 12:44:34PM -0700, Jens Axboe wrote:
> > > On 8/17/20 12:29 PM, Kees Cook wrote:
> > > > On Mon, Aug 17, 2020 at 06:56:47AM -0700, Jens Axboe wrote:
> > > > > On 8/17/20 2:15 AM, Allen Pais wrote:
> > > > > > From: Allen Pais <allen.lkml@gmail.com>
> > > > > > 
> > > > > > In preparation for unconditionally passing the
> > > > > > struct tasklet_struct pointer to all tasklet
> > > > > > callbacks, switch to using the new tasklet_setup()
> > > > > > and from_tasklet() to pass the tasklet pointer explicitly.
> > > > > 
> > > > > Who came up with the idea to add a macro 'from_tasklet' that
> > > > > is just container_of? container_of in the code would be
> > > > > _much_ more readable, and not leave anyone guessing wtf
> > > > > from_tasklet is doing.
> > > > > 
> > > > > I'd fix that up now before everything else goes in...
> > > > 
> > > > As I mentioned in the other thread, I think this makes things
> > > > much more readable. It's the same thing that the timer_struct
> > > > conversion did (added a container_of wrapper) to avoid the
> > > > ever-repeating use of typeof(), long lines, etc.
> > > 
> > > But then it should use a generic name, instead of each sub-system 
> > > using some random name that makes people look up exactly what it
> > > does. I'm not huge fan of the container_of() redundancy, but
> > > adding private variants of this doesn't seem like the best way
> > > forward. Let's have a generic helper that does this, and use it
> > > everywhere.
> > 
> > I'm open to suggestions, but as things stand, these kinds of
> > treewide
> 
> On naming? Implementation is just as it stands, from_tasklet() is
> totally generic which is why I objected to it. from_member()? Not
> great with naming... But I can see this going further and then we'll
> suddenly have tons of these. It's not good for readability.

Since both threads seem to have petered out, let me suggest in
kernel.h:

#define cast_out(ptr, container, member) \
	container_of(ptr, typeof(*container), member)

It does what you want, the argument order is the same as container_of
with the only difference being you name the containing structure
instead of having to specify its type.

James

