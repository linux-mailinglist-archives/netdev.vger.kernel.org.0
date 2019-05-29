Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 189952D772
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 10:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfE2INB convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 May 2019 04:13:01 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41614 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbfE2INB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 04:13:01 -0400
Received: by mail-lj1-f196.google.com with SMTP id q16so1494672ljj.8;
        Wed, 29 May 2019 01:12:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a0don3TTA7MOPbrbjinj58BbWNizus2TjnpcpEnZ6h0=;
        b=YydndqMa2LgSRtqs2BJ95rhwZbCBiP6jaMAdwNku5DJDbGeJfbxQQAxu1yUBvuQ7ow
         Ll/MGmFxN645qG93kNAx3juWILfc/+Ljw4hgHrYn8PM16kdE/hvVBP8k0+l1D4HJGOiP
         DA8oTPGS26Nlty4IRuaG9Mn+fr9U51f8tdjPsJX3b1XAttosGOPnMnlZYHCSO2mempXC
         qG1TVI+r82hkI/CYGlSxVsb7cqdsBprWYu3VpY2xLgd0rZIdueWvqUF9QfZj2Dx4sCQ8
         0lNZjAx09O57abcOy5f2FlpSHyy5RrJb10Wph9lJhs9mXHq4l4Rtec5k4zpOf378PsWQ
         ZuiA==
X-Gm-Message-State: APjAAAVjBdmCWt3SSYC7M693xjFdlNmxhqVjW949QN0UmvuMJErBvshY
        gOlnzEGqejADTdL/ummqt9tDnRczFO5dMDCUSbQ=
X-Google-Smtp-Source: APXvYqz+i9F0zk6NyMyWBavDhJq5T11k3LBK2MrgZ55YQ542TgvrWEs81N68J92wCzTKGRLDj79yXuvelmq9XTmatnU=
X-Received: by 2002:a05:651c:150:: with SMTP id c16mr67589499ljd.65.1559117578478;
 Wed, 29 May 2019 01:12:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190528142424.19626-1-geert@linux-m68k.org> <20190528142424.19626-2-geert@linux-m68k.org>
 <4b666e32-04b6-228a-691d-0745fa48a57f@lightnvm.io>
In-Reply-To: <4b666e32-04b6-228a-691d-0745fa48a57f@lightnvm.io>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 29 May 2019 10:12:45 +0200
Message-ID: <CAMuHMdVtM9NWSXbWE=XKOt3fiQdjWaDvLiYdXbbri-buDn7jpg@mail.gmail.com>
Subject: Re: [PATCH 1/5] lightnvm: Fix uninitialized pointer in nvm_remove_tgt()
To:     =?UTF-8?Q?Matias_Bj=C3=B8rling?= <mb@lightnvm.io>
Cc:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-afs@lists.infradead.org,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matias,

On Wed, May 29, 2019 at 10:08 AM Matias Bjørling <mb@lightnvm.io> wrote:
> On 5/28/19 4:24 PM, Geert Uytterhoeven wrote:
> > With gcc 4.1:
> >
> >      drivers/lightnvm/core.c: In function ‘nvm_remove_tgt’:
> >      drivers/lightnvm/core.c:510: warning: ‘t’ is used uninitialized in this function
> >
> > Indeed, if no NVM devices have been registered, t will be an
> > uninitialized pointer, and may be dereferenced later.  A call to
> > nvm_remove_tgt() can be triggered from userspace by issuing the
> > NVM_DEV_REMOVE ioctl on the lightnvm control device.
> >
> > Fix this by preinitializing t to NULL.
> >
> > Fixes: 843f2edbdde085b4 ("lightnvm: do not remove instance under global lock")
> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >   drivers/lightnvm/core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/lightnvm/core.c b/drivers/lightnvm/core.c
> > index 0df7454832efe082..aa017f48eb8c588c 100644
> > --- a/drivers/lightnvm/core.c
> > +++ b/drivers/lightnvm/core.c
> > @@ -492,7 +492,7 @@ static void __nvm_remove_target(struct nvm_target *t, bool graceful)
> >    */
> >   static int nvm_remove_tgt(struct nvm_ioctl_remove *remove)
> >   {
> > -     struct nvm_target *t;
> > +     struct nvm_target *t = NULL;
> >       struct nvm_dev *dev;
> >
> >       down_read(&nvm_lock);
> >
>
> Thanks Geert. Would you like me to carry the patch?

Yes please. Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
