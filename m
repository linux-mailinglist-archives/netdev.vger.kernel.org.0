Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC6839712C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 06:32:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727592AbfHUEcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 00:32:25 -0400
Received: from ajax.cs.uga.edu ([128.192.4.6]:44158 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbfHUEcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 00:32:25 -0400
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id x7L4WMoe069266
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Aug 2019 00:32:23 -0400
Received: by mail-lj1-f171.google.com with SMTP id l1so795910lji.12;
        Tue, 20 Aug 2019 21:32:23 -0700 (PDT)
X-Gm-Message-State: APjAAAUL11Gw39KpL4NYef24UhbT582GgezPL+E++gdp13coDwblbYkw
        n40Psyg8TDmXil8gmZGOkJRWycFg3HeKMPxzbJM=
X-Google-Smtp-Source: APXvYqwJHnVp3pdE4Bg3YqrbSEYEU0E+uUeX0LYZnhept2ioLf2LEA9SBYVSnw5rPgmOuKsCzmsz5ZDPTJNOx9P70bM=
X-Received: by 2002:a2e:5c5:: with SMTP id 188mr2582725ljf.166.1566361942335;
 Tue, 20 Aug 2019 21:32:22 -0700 (PDT)
MIME-Version: 1.0
References: <1565690709-3186-1-git-send-email-wenwen@cs.uga.edu> <MN2PR18MB2528D8046DFC6BB880D8EFF6D3D20@MN2PR18MB2528.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB2528D8046DFC6BB880D8EFF6D3D20@MN2PR18MB2528.namprd18.prod.outlook.com>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Wed, 21 Aug 2019 00:31:46 -0400
X-Gmail-Original-Message-ID: <CAAa=b7dKCjCRU3gik3ZPVP7WWMfEYqEmq_4rd7vnSLoOiK5nOw@mail.gmail.com>
Message-ID: <CAAa=b7dKCjCRU3gik3ZPVP7WWMfEYqEmq_4rd7vnSLoOiK5nOw@mail.gmail.com>
Subject: Re: [EXT] [PATCH] qed: Add cleanup in qed_slowpath_start()
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:QLOGIC QL4xxx ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Wenwen Wang <wenwen@cs.uga.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 6:46 AM Sudarsana Reddy Kalluru
<skalluru@marvell.com> wrote:
>
> > -----Original Message-----
> > From: Wenwen Wang <wenwen@cs.uga.edu>
> > Sent: Tuesday, August 13, 2019 3:35 PM
> > To: Wenwen Wang <wenwen@cs.uga.edu>
> > Cc: Ariel Elior <aelior@marvell.com>; GR-everest-linux-l2 <GR-everest-linux-
> > l2@marvell.com>; David S. Miller <davem@davemloft.net>; open
> > list:QLOGIC QL4xxx ETHERNET DRIVER <netdev@vger.kernel.org>; open list
> > <linux-kernel@vger.kernel.org>
> > Subject: [EXT] [PATCH] qed: Add cleanup in qed_slowpath_start()
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > If qed_mcp_send_drv_version() fails, no cleanup is executed, leading to
> > memory leaks. To fix this issue, redirect the execution to the label 'err3'
> > before returning the error.
> >
> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_main.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c
> > b/drivers/net/ethernet/qlogic/qed/qed_main.c
> > index 829dd60..d16a251 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> > @@ -1325,7 +1325,7 @@ static int qed_slowpath_start(struct qed_dev
> > *cdev,
> >                                             &drv_version);
> >               if (rc) {
> >                       DP_NOTICE(cdev, "Failed sending drv version
> > command\n");
> > -                     return rc;
> > +                     goto err3;
>
> In this case, we might need to free the ll2-buf allocated at the below path (?),
> 1312         /* Allocate LL2 interface if needed */
> 1313         if (QED_LEADING_HWFN(cdev)->using_ll2) {
> 1314                 rc = qed_ll2_alloc_if(cdev);
> May be by adding a new goto label 'err4'.

Thanks for your suggestion! I will rework the patch.

Wenwen

>
> >               }
> >       }
> >
> > --
> > 2.7.4
>
