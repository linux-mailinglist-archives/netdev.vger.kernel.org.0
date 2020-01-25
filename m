Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6F5E149616
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 15:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgAYOex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 09:34:53 -0500
Received: from ajax.cs.uga.edu ([128.192.4.6]:56602 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725710AbgAYOex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jan 2020 09:34:53 -0500
X-Greylist: delayed 1323 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jan 2020 09:34:52 EST
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id 00PECmTu053411
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jan 2020 09:12:48 -0500
Received: by mail-ua1-f49.google.com with SMTP id x16so1853415uao.11;
        Sat, 25 Jan 2020 06:12:48 -0800 (PST)
X-Gm-Message-State: APjAAAUEYmRUA4Gd1zEye2vC/zDyq9hZNNtt1D5rGlhWhx7f9GCfhCKY
        GrJh5W4vlImCLGB4R+NSH/fLDz5ve93NKPWISk4=
X-Google-Smtp-Source: APXvYqykrqpdtaMXv3Osib4znOIoEMgisi9bX1hYNkAIFH214UGyWuAg4CWlRaGLrGtiwqz/j2tEvuggB3Fu2YzXF9w=
X-Received: by 2002:ab0:2150:: with SMTP id t16mr4683359ual.61.1579961567761;
 Sat, 25 Jan 2020 06:12:47 -0800 (PST)
MIME-Version: 1.0
References: <20200125051134.11557-1-wenwen@cs.uga.edu> <20200125.081107.914737890991760251.davem@davemloft.net>
In-Reply-To: <20200125.081107.914737890991760251.davem@davemloft.net>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Sat, 25 Jan 2020 09:12:11 -0500
X-Gmail-Original-Message-ID: <CAAa=b7ff6xDGFjosX+RVp0=LCD5GHtg_O2gAkcha3OJMD2uaoQ@mail.gmail.com>
Message-ID: <CAAa=b7ff6xDGFjosX+RVp0=LCD5GHtg_O2gAkcha3OJMD2uaoQ@mail.gmail.com>
Subject: Re: [PATCH] firestream: fix memory leaks
To:     David Miller <davem@davemloft.net>
Cc:     Chas Williams <3chas3@gmail.com>,
        "moderated list:ATM" <linux-atm-general@lists.sourceforge.net>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wenwen Wang <wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 25, 2020 at 2:11 AM David Miller <davem@davemloft.net> wrote:
>
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Date: Sat, 25 Jan 2020 05:11:34 +0000
>
> > @@ -922,6 +923,7 @@ static int fs_open(struct atm_vcc *atm_vcc)
> >                       if (((DO_DIRECTION(rxtp) && dev->atm_vccs[vcc->channo])) ||
> >                           ( DO_DIRECTION(txtp) && test_bit (vcc->channo, dev->tx_inuse))) {
> >                               printk ("Channel is in use for FS155.\n");
> > +                             kfree(vcc);
> >                               return -EBUSY;
> >                       }
> >               }
> > --
>
> There is another case just below this line:
>
>                             tc, sizeof (struct fs_transmit_config));
>                 if (!tc) {
>                         fs_dprintk (FS_DEBUG_OPEN, "fs: can't alloc transmit_config.\n");
>                         return -ENOMEM;
>                 }
>
> Please audit the entire function and make sure your patch fixes all of these
> missing vcc free cases.

Thanks for your comment! I was planning to submit another patch as
this case has different semantics. But, since you have pointed out, I
will revise this patch.

Wenwen

>
> Thank you.
