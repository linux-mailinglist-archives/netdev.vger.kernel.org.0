Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7358D652
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727989AbfHNOhg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Aug 2019 10:37:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:39532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfHNOhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 10:37:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7E29EAF98;
        Wed, 14 Aug 2019 14:37:34 +0000 (UTC)
Date:   Wed, 14 Aug 2019 16:37:33 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jonas Gorski <jonas.gorski@gmail.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
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
        Evgeniy Polyakov <zbr@ioremap.net>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 9/9] Input: add IOC3 serio driver
Message-Id: <20190814163733.82f624e342d061866ba8ff87@suse.de>
In-Reply-To: <CAOiHx=kuQtOuNfsJ+fDrps+hbrbp5cPujmQpi8Vfy+0qeP8dtA@mail.gmail.com>
References: <20190809103235.16338-1-tbogendoerfer@suse.de>
        <20190809103235.16338-10-tbogendoerfer@suse.de>
        <CAOiHx=kuQtOuNfsJ+fDrps+hbrbp5cPujmQpi8Vfy+0qeP8dtA@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Aug 2019 15:20:14 +0200
Jonas Gorski <jonas.gorski@gmail.com> wrote:

> > +       d = devm_kzalloc(&pdev->dev, sizeof(*d), GFP_KERNEL);
> 
> &pdev->dev => dev

will change.

> 
> > +       if (!d)
> > +               return -ENOMEM;
> > +
> > +       sk = kzalloc(sizeof(*sk), GFP_KERNEL);
> 
> any reason not to devm_kzalloc this as well? Then you won't need to
> manually free it in the error cases.

it has different life time than the device, so it may not allocated
via devm_kzalloc

> > +static int ioc3kbd_remove(struct platform_device *pdev)
> > +{
> > +       struct ioc3kbd_data *d = platform_get_drvdata(pdev);
> > +
> > +       devm_free_irq(&pdev->dev, d->irq, d);
> > +       serio_unregister_port(d->kbd);
> > +       serio_unregister_port(d->aux);
> > +       return 0;
> > +}
> 
> and on that topic, won't you need to kfree d->kbd and d->aux here?

that's done in serio_release_port() by the serio core.

Thomas.

-- 
SUSE Linux GmbH
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
