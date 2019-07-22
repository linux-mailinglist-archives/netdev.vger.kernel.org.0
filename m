Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760B36FD90
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 12:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbfGVKRJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 06:17:09 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45490 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728569AbfGVKRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 06:17:09 -0400
Received: by mail-qk1-f195.google.com with SMTP id s22so28165276qkj.12;
        Mon, 22 Jul 2019 03:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7CJkKA7SZFRonSxwlZKyw8W6pgs5EdX5dwdC50uPvBs=;
        b=IfyEGn1teOvseGqamLGm6eYMrp4kEADYmxLmuf3lwn47e7irJLZzzSadD5rA/AIBI9
         goH41xTw+8mHRl1BZvXsR//j0Bkx/qgpjDwxg+U0Sgv/xiZjg8KtvmyTZALR9IWcaIXV
         CkKHYuQh8zqpoaziifRWNQJj6IFlA4GCuNLjekCgFw/JORcJrYdvAW9z1V4W6KoM1wwm
         VULx2b8vVGz68sAMPswtsad+XUrTWq6NgpiZCM1ZVw4TMgy/CGbdJbHgWLP86SU1dGvd
         Z5pyX3CkxJbOlpaYN+NcMGuBrk11hsJl17wOl6wns3nwJxlMqgXlSlT1u12RZg1yhaEA
         FtQA==
X-Gm-Message-State: APjAAAXq6SoJbRtNpNdtsju6Iqd40f0IQCjpznLrKw1xRcgd1JB/roKO
        6vLan+lWSBG81Y9PJP7R6HGzDTE7JDS31A46Yqg=
X-Google-Smtp-Source: APXvYqy7ISax661sJxUrp3WbLhv5BC0kus4uGgZKznelHiJHcAGScOZIvY+BAP14dw/qwJzgUC+dnqfk8j1fG+ylzm4=
X-Received: by 2002:a37:4ac3:: with SMTP id x186mr44360140qka.138.1563790627957;
 Mon, 22 Jul 2019 03:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190628123819.2785504-1-arnd@arndb.de> <20190628123819.2785504-4-arnd@arndb.de>
 <alpine.LFD.2.21.1906302308280.3788@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.21.1906302308280.3788@ja.home.ssi.bg>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 22 Jul 2019 12:16:51 +0200
Message-ID: <CAK8P3a03wShPgL85K-0W3UUc3QJWLbbs+ZVAnkKLkqg00vVehw@mail.gmail.com>
Subject: Re: [PATCH 4/4] ipvs: reduce kernel stack usage
To:     Julian Anastasov <ja@ssi.bg>
Cc:     Kees Cook <keescook@chromium.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Networking <netdev@vger.kernel.org>, lvs-devel@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 10:37 PM Julian Anastasov <ja@ssi.bg> wrote:
> On Fri, 28 Jun 2019, Arnd Bergmann wrote:

> >       struct ip_vs_conn *ctl_cp = cp->control;
> >       if (!ctl_cp) {
> > -             IP_VS_ERR_BUF("request control DEL for uncontrolled: "
> > -                           "%s:%d to %s:%d\n",
> > -                           IP_VS_DBG_ADDR(cp->af, &cp->caddr),
> > -                           ntohs(cp->cport),
> > -                           IP_VS_DBG_ADDR(cp->af, &cp->vaddr),
> > -                           ntohs(cp->vport));
> > +             pr_err("request control DEL for uncontrolled: "
> > +                    "%pISp to %pISp\n",

(replying a bit late)

>         ip_vs_dbg_addr() used compact form (%pI6c), so it would be
> better to use %pISc and %pISpc everywhere in IPVS...

done

>         Also, note that before now port was printed with %d and
> ntohs() was used, now port should be in network order, so:
>
> - ntohs() should be removed

done

> - htons() should be added, if missing. At first look, this case
> is not present in IPVS, we have only ntohs() usage

I found one case in ip_vs_ftp_in() that needs it in order to subtract one:

                IP_VS_DBG(7, "protocol %s %pISpc %pISpc\n",
                          ip_vs_proto_name(ipvsh->protocol),
-                         IP_VS_DBG_SOCKADDR(cp->af, &to, ntohs(port)),
+                         IP_VS_DBG_SOCKADDR(cp->af, &to, port),
                          IP_VS_DBG_SOCKADDR(cp->af, &cp->vaddr,
-                                             ntohs(cp->vport)-1));
+                                            htons(ntohs(cp->vport)-1)));

Thanks for the review, I'll send a new patch after some more
build testing on the new version.

       Arnd
