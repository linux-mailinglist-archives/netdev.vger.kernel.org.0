Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE9A8F557
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbfHOUG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:06:26 -0400
Received: from ajax.cs.uga.edu ([128.192.4.6]:58570 "EHLO ajax.cs.uga.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731699AbfHOUG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 16:06:26 -0400
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
        (authenticated bits=0)
        by ajax.cs.uga.edu (8.14.4/8.14.4) with ESMTP id x7FK6N8I077486
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Aug 2019 16:06:24 -0400
Received: by mail-lj1-f182.google.com with SMTP id m24so3278585ljg.8;
        Thu, 15 Aug 2019 13:06:24 -0700 (PDT)
X-Gm-Message-State: APjAAAWLEIRuBR44EIC8J2y6T85AK92daYm6evPBeGGS/pAiZmefZnNa
        dh1eOY9cEfudS9z635hseN4UwWtONh6ZCR7Z4jg=
X-Google-Smtp-Source: APXvYqz4Iy/6XNX+MVvf4TD5dvd9KB0BX0Yc/8O9jSENtkExtdY3aoeqaJVHrgi3iel0+/IUUsE8rAlGqjuBfPn5ht0=
X-Received: by 2002:a2e:b4e6:: with SMTP id s6mr3498453ljm.169.1565899583386;
 Thu, 15 Aug 2019 13:06:23 -0700 (PDT)
MIME-Version: 1.0
References: <1565892301-2812-1-git-send-email-wenwen@cs.uga.edu> <20190815184505.o7o2ojt7ag4shh7u@oracle.com>
In-Reply-To: <20190815184505.o7o2ojt7ag4shh7u@oracle.com>
From:   Wenwen Wang <wenwen@cs.uga.edu>
Date:   Thu, 15 Aug 2019 16:05:47 -0400
X-Gmail-Original-Message-ID: <CAAa=b7ctf3pkoeN0+hjeK1ZXwaZpnniO4-ypMMcS3nKuVcjo_w@mail.gmail.com>
Message-ID: <CAAa=b7ctf3pkoeN0+hjeK1ZXwaZpnniO4-ypMMcS3nKuVcjo_w@mail.gmail.com>
Subject: Re: [PATCH] wimax/i2400m: fix a memory leak bug
To:     Wenwen Wang <wenwen@cs.uga.edu>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        "supporter:INTEL WIRELESS WIMAX CONNECTION 2400" 
        <linux-wimax@intel.com>, "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 15, 2019 at 2:45 PM Liam R. Howlett <Liam.Howlett@oracle.com> wrote:
>
> * Wenwen Wang <wenwen@cs.uga.edu> [190815 14:05]:
> > In i2400m_barker_db_init(), 'options_orig' is allocated through kstrdup()
> > to hold the original command line options. Then, the options are parsed.
> > However, if an error occurs during the parsing process, 'options_orig' is
> > not deallocated, leading to a memory leak bug. To fix this issue, free
> > 'options_orig' before returning the error.
> >
> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> > ---
> >  drivers/net/wimax/i2400m/fw.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
> > index e9fc168..6b36f6d 100644
> > --- a/drivers/net/wimax/i2400m/fw.c
> > +++ b/drivers/net/wimax/i2400m/fw.c
> > @@ -342,6 +342,7 @@ int i2400m_barker_db_init(const char *_options)
> >                                      "a 32-bit number\n",
> >                                      __func__, token);
> >                               result = -EINVAL;
> > +                             kfree(options_orig);
> >                               goto error_parse;
> >                       }
> >                       if (barker == 0) {
> > @@ -350,8 +351,10 @@ int i2400m_barker_db_init(const char *_options)
> >                               continue;
> >                       }
> >                       result = i2400m_barker_db_add(barker);
> > -                     if (result < 0)
> > +                     if (result < 0) {
> > +                             kfree(options_orig);
> >                               goto error_add;
>
> I know that you didn't add this error_add label, but it seems like the
> incorrect goto label.  Although looking at the caller indicates an add
> failed, this label is used prior to and after the memory leak you are
> trying to fix.  It might be better to change this label to something
> like error_parse_add and move the kfree to the unwinding.  If a new
> label is used, it becomes more clear as to what is being undone and
> there aren't two jumps into an unwind from two very different stages of
> the function.  Adding a new label also has the benefit of moving the
> kfree to the unwind of error_parse.

Thanks for your suggestion! I will rework the patch.

Wenwen
