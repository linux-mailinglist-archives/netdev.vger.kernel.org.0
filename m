Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2778497CF2
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbfHUO2w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 21 Aug 2019 10:28:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:39348 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727949AbfHUO2v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:28:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 89345AD94;
        Wed, 21 Aug 2019 14:28:49 +0000 (UTC)
Date:   Wed, 21 Aug 2019 16:28:47 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>,
        Evgeniy Polyakov <zbr@ioremap.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v5 10/17] net: sgi: ioc3-eth: rework skb rx handling
Message-Id: <20190821162847.479c9967d4dc8026fe65fa0e@suse.de>
In-Reply-To: <20190819165522.451f2ea2@cakuba.netronome.com>
References: <20190819163144.3478-1-tbogendoerfer@suse.de>
        <20190819163144.3478-11-tbogendoerfer@suse.de>
        <20190819165522.451f2ea2@cakuba.netronome.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Aug 2019 16:55:22 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Mon, 19 Aug 2019 18:31:33 +0200, Thomas Bogendoerfer wrote:
> > Buffers alloacted by alloc_skb() are already cache aligned so there
> > is no need for an extra align done by ioc3_alloc_skb. And instead
> > of skb_put/skb_trim simply use one skb_put after frame size is known
> > during receive.
> [...]  
> > -/* We use this to acquire receive skb's that we can DMA directly into. */
> > -
> > -#define IOC3_CACHELINE	128UL
> 
> Is the cache line on the platform this driver works on 128B?

right now yes, in theory IOC3 CAD DUO cards might work in SGI O2 systems,
but the current Linux PCI implementation for O2 will not detect that card.
On X86 usually the BIOS will choke up on that cards.

> This looks like a DMA engine alignment requirement, more than an
> optimization.

that true, there are two constraints for the rx buffers, start must be aligned
to 128 bytes and a buffer must not cross a 16kbyte boundary. I was already
thinking of allocating pages and chop them up. Is there a Linux API available,
which could help for implementing this ?

I'll probably drop this patch or only change the skb_put stuff plus RX_BUF_SIZE
define.

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
